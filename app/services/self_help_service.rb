
require 'faraday/multipart'

class SelfHelpService
  include TelegramMarkupHelper

  # Передаем бота, пользователя и chat_id
  def initialize(bot_service, user, chat_id) # Изменил 'bot' на 'bot_service' для ясности
    @bot_service = bot_service # Теперь это экземпляр Telegram::TelegramBotService
    @user = user
    @chat_id = chat_id
  end

  # --- Инициализация программы самопомощи ---

  # Запускает первый шаг: предложение начать программу.
  def start_program_initiation
    Rails.logger.debug "User #{@user.telegram_id} initiating self-help program."
    @user.set_self_help_step('program_started') # Устанавливаем начальное состояние
    message_text = "Привет! Я твой бот для самопомощи. Начнем наше путешествие к улучшению самочувствия. " \
                   "Сейчас я попрошу тебя пройти несколько тестов, чтобы мы могли начать совместную работу! " \
                   "Спасибо, что присоединился. Все полностью анонимно и останется между нами."
    send_message(text: message_text, reply_markup: TelegramMarkupHelper.self_help_intro_markup)
  end

  # Обрабатывает ответы "Да" или "Нет" на начальные вопросы.
  def handle_response(response_type)
    current_step = @user.get_self_help_step

    case current_step
    when 'program_started'
      if response_type == 'yes'
        start_tests_sequence
      else # response_type == 'no'
        cancel_program_initiation
      end
    when 'day_2_intro_delivered' # Пользователь подтвердил начало Дня 2
      if response_type == 'yes'
        send_body_scan_audio # Отправляем аудио
      else # response_type == 'no'
        handle_day_2_skip
      end
    when 'day_4_exercise_consent' # Пользователь соглашается начать упражнение Дня 4
      if response_type == 'yes'
        start_day_4_exercise
      else # response_type == 'no'
        handle_day_4_skip
      end
    else
      Rails.logger.warn "Unexpected state '#{current_step}' for handling response '#{response_type}' by user #{@user.telegram_id}."
      send_message(text: "Что-то пошло не так. Напишите /start, чтобы вернуться в главное меню.")
    end
  end

  # Отменяет инициацию программы (если пользователь сказал "Нет").
  def cancel_program_initiation
    @user.clear_self_help_program
    send_message(text: "Хорошо, мы можем начать в любой другой момент. Просто нажмите кнопку '⭐️ Программа самопомощи ⭐️' в главном меню.", reply_markup: TelegramMarkupHelper.main_menu_markup)
  end

  # --- Запуск последовательности тестов ---

  def start_tests_sequence
    Rails.logger.debug "User #{@user.telegram_id} moving to start tests sequence."
    @user.set_self_help_step('taking_depression_test') # Более конкретный шаг
    send_message(text: "Отлично! Начнем с теста на депрессию.")
    QuizRunner.new(@bot_service, @user, @chat_id).start_quiz('depression') # Используем @bot_service
  end

  # Обработчик завершения теста на депрессию.
  def handle_test_completion(test_type)
    case test_type
    when 'depression'
      Rails.logger.debug "User #{@user.telegram_id} completed depression test. Current step: #{@user.get_self_help_step}."
      # Проверяем, что пользователь находится в нужном состоянии
      if @user.get_self_help_step == 'taking_depression_test'
        @user.set_self_help_step('awaiting_anxiety_test_completion') # Переходим к запросу на тест тревожности
        send_message(
          text: "Тест на депрессию завершен! Теперь пройдем тест на тревожность. Вы готовы?",
          reply_markup: TelegramMarkupHelper.yes_no_markup(callback_data_yes: 'start_anxiety_test_from_sequence', callback_data_no: 'no_anxiety_test_sequence')
        )
      else
        Rails.logger.warn "User #{@user.telegram_id} received depression test completion callback in unexpected state: #{@user.get_self_help_step}."
        send_message(text: "Произошла ошибка в последовательности тестов. Напишите /start для начала заново.")
        @user.clear_self_help_program
      end
    when 'anxiety'
      Rails.logger.debug "User #{@user.telegram_id} completed anxiety test. Current step: #{@user.get_self_help_step}."
      if @user.get_self_help_step == 'taking_anxiety_test'
        @user.set_self_help_step('tests_completed') # Все тесты пройдены
        # Теперь предлагаем начать первый день программы самопомощи
        deliver_day_1_intro_message
      else
        Rails.logger.warn "User #{@user.telegram_id} received anxiety test completion callback in unexpected state: #{@user.get_self_help_step}."
        send_message(text: "Произошла ошибка в последовательности тестов. Напишите /start для начала заново.")
        @user.clear_self_help_program
      end
    else
      Rails.logger.warn "Unknown test type '#{test_type}' completion handled by SelfHelpService for user #{@user.telegram_id}."
    end
  end

  # Инициирует запуск теста на тревожность из последовательности.
  def start_anxiety_test_sequence
    Rails.logger.debug "User #{@user.telegram_id} is starting anxiety test sequence."
    if @user.get_self_help_step == 'awaiting_anxiety_test_completion'
      @user.set_self_help_step('taking_anxiety_test') # Обновляем шаг пользователя
      send_message(text: "Запускаю тест на тревожность...")
      QuizRunner.new(@bot_service, @user, @chat_id).start_quiz('anxiety') # Используем @bot_service
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to start anxiety test from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Что-то пошло не так. Пожалуйста, начните программу заново. Напишите /start.")
      @user.clear_self_help_program
    end
  end

  # Обрабатывает отказ пользователя от теста на тревожность.
  def handle_no_anxiety_test_sequence
    Rails.logger.debug "User #{@user.telegram_id} declined anxiety test sequence. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'awaiting_anxiety_test_completion'
      @user.clear_self_help_program # Сбрасываем прогресс, если пользователь отказался
      send_message(text: "Хорошо, мы можем пройти тест позже. Возвращаемся в главное меню.", reply_markup: TelegramMarkupHelper.main_menu_markup)
    else
      Rails.logger.warn "User #{@user.telegram_id} declined anxiety test from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Пожалуйста, вернитесь в главное меню, нажав /start.")
    end
  end

  # --- ДЕНЬ 1: Осознанность ---

  # Предлагает начать первый день после завершения тестов.
  def deliver_day_1_intro_message
    Rails.logger.debug "User #{@user.telegram_id} starting Day 1 intro. Current step: #{@user.get_self_help_step}."
    # Этот метод вызывается после завершения всех тестов
    # Предполагается, что шаг пользователя уже 'tests_completed' или что-то подобное.
    # Если необходимо, установим шаг здесь.
    @user.set_self_help_step('day_1_intro') # Устанавливаем начальный шаг для Дня 1

    message_text = "Спасибо за прохождение тестов! Это важный шаг к пониманию своего состояния.\n\n" \
                   "Теперь давайте начнем программу самопомощи. Первый день посвящен осознанности."
    send_message(text: message_text, reply_markup: TelegramMarkupHelper.day_1_content_markup)
  end

  # Отправляет контент первого дня.
  def deliver_day_1_content
    Rails.logger.debug "User #{@user.telegram_id} delivering Day 1 content. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_1_intro'
      @user.set_self_help_step('day_1_content_delivered') # Устанавливаем шаг, что контент показан

      content_text = "Добро пожаловать в первый день программы!\n\n**Тема дня: Осознанность.**\n\n" \
                     "Осознанность — это способность быть полностью присутствующим в текущем моменте, " \
                     "без осуждения, просто наблюдая свои мысли, чувства и ощущения.\n\n" \
                     "Это мощный инструмент для снижения стресса, улучшения эмоционального регулирования " \
                     "и повышения общего благополучия."
      send_message(text: content_text, parse_mode: 'Markdown')
      send_message(
        text: "Нажмите 'Продолжить', когда будете готовы к упражнению первого дня.",
        reply_markup: TelegramMarkupHelper.day_1_continue_markup # Кнопка "Продолжить изучение дня 1"
      )
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to deliver Day 1 content from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Что-то пошло не так при попытке начать день 1. Напишите /start для начала заново.")
      @user.clear_self_help_program
    end
  end

  # Запускает упражнение первого дня.
  def continue_day_1_content
    Rails.logger.debug "User #{@user.telegram_id} continuing Day 1 content. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_1_content_delivered'
      send_day_1_exercise # Вызываем метод отправки упражнения
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to continue Day 1 from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Что-то пошло не так при продолжении дня 1. Напишите /start для начала заново.")
      @user.clear_self_help_program
    end
  end

  # Отправляет упражнение первого дня.
  def send_day_1_exercise
    @user.set_self_help_step('day_1_exercise_in_progress') # Устанавливаем шаг, что упражнение выполняется

    exercise_text = "Отлично! Наше первое упражнение - это простое упражнение на внимательное дыхание.\n\n" \
                    "Найдите тихое место, где вас никто не побеспокоит в течение 5-10 минут. " \
                    "Сядьте удобно или лягте. Закройте глаза, если вам комфортно.\n\n" \
                    "Просто сосредоточьтесь на своем дыхании. Ощущайте, как воздух входит и выходит. " \
                    "Не пытайтесь изменить дыхание, просто наблюдайте за ним.\n\n" \
                    "Если ваш ум отвлекается, просто мягко верните внимание к дыханию. " \
                    "Это нормально, что мысли приходят и уходят. Цель не в том, чтобы не думать, а в том, чтобы замечать, когда ум отвлекся, и возвращать его обратно.\n\n" \
                    "Вы можете использовать таймер на 5 минут."
    send_message(text: exercise_text, parse_mode: 'Markdown')

    send_message(
      text: "Когда закончите упражнение, нажмите 'Я выполнил упражнение'.",
      reply_markup: TelegramMarkupHelper.day_1_exercise_completed_markup # Кнопка для завершения
    )
  end

  # Обработчик завершения упражнения Дня 1.
  def handle_day_1_exercise_completion
    Rails.logger.debug "User #{@user.telegram_id} completing Day 1 exercise. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_1_exercise_in_progress'
      @user.set_self_help_step('day_1_completed') # Отмечаем день 1 как завершенный

      message = "Отличная работа! Поздравляю с выполнением первого упражнения на осознанность.\n\n" \
                "Практика внимательности — это навык, который развивается со временем. " \
                "Не расстраивайтесь, если сначала было трудно. Главное — продолжать!\n\n" \
                "На сегодня всё! Отдохните и возвращайтесь завтра для нового дня программы."
      send_message(text: message) # Отправляем только текст о завершении дня

      # НОВОЕ: Предлагаем начать День 2 через отдельное сообщение и кнопку
      @user.set_self_help_step('awaiting_day_2_start') # Устанавливаем шаг ожидания
      send_message(text: "Готовы начать второй день программы?", reply_markup: TelegramMarkupHelper.day_2_start_proposal_markup)
      Rails.logger.debug "SelfHelpService: Day 1 completed. Awaiting Day 2 start."
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to complete Day 1 exercise from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Что-то пошло не так при завершении упражнения дня 1. Напишите /start для начала заново.")
      @user.clear_self_help_program
    end
  end

  # --- ДЕНЬ 2: Медитация "Сканирование тела" ---

  def deliver_day_2_content
    Rails.logger.debug "User #{@user.telegram_id} delivering Day 2 content. Current step: #{@user.get_self_help_step}."
    # ИЗМЕНЕНО: Теперь проверяем состояние ожидания перед началом дня 2
    if @user.get_self_help_step == 'awaiting_day_2_start'
      @user.set_self_help_step('day_2_intro_delivered') # Устанавливаем шаг, что интро доставлено
      message_text = "Добро пожаловать во второй день программы!\n\n**Тема дня: Научиться лучше чувствовать свое тело.**\n\n" \
                     "Сегодня мы сосредоточимся на развитии самосознания через собственные ощущения. " \
                     "Это поможет вам лучше понимать свои чувства, их причины и реакции."
      send_message(text: message_text, parse_mode: 'Markdown')
      send_message(
        text: "Нажмите 'Начать медитацию', когда будете готовы к медитации 'Сканирование тела'.",
        reply_markup: TelegramMarkupHelper.day_2_start_exercise_markup
      )
      Rails.logger.debug "SelfHelpService: Day 2 intro delivered, waiting for user to start exercise."
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to deliver Day 2 content from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Вы еще не завершили предыдущий день или что-то пошло не так. Напишите /start для начала заново.")
      @user.clear_self_help_program
    end
  end

  def send_day_2_exercise_audio
    Rails.logger.debug "User #{@user.telegram_id} sending Day 2 exercise audio. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_2_intro_delivered' # Проверяем, что пользователь на правильном шаге

      audio_file_path = Rails.root.join('public', 'assets', 'audio', 'body_scan.mp3')
      caption = "Медитация 'Сканирование тела'"

      day2_audio_file_id = Setting.find_by(key: 'day2_exercise_audio_file_id')&.value

      if day2_audio_file_id.present?
        Rails.logger.info "Sending day_2_exercise audio using file_id: #{day2_audio_file_id}"
        @bot_service.bot.send_audio(chat_id: @chat_id, audio: day2_audio_file_id, caption: caption) # Используем @bot_service.bot
      else
        if File.exist?(audio_file_path)
          file_size_mb = File.size(audio_file_path).to_f / (1024 * 1024)
          Rails.logger.info "Uploading day_2_exercise audio. Path: #{audio_file_path}, Size: #{file_size_mb.round(2)} MB"

          if file_size_mb > 50
            Rails.logger.error "Audio file is too large (#{file_size_mb.round(2)} MB). Telegram limit is 50MB."
            send_message(text: "Произошла ошибка при отправке аудио: файл слишком большой.")
            return
          end

          begin
            @bot_service.bot.send_audio(chat_id: @chat_id, audio: File.open(audio_file_path), caption: caption) # Используем @bot_service.bot
            Rails.logger.info "Audio sent successfully."
          rescue Telegram::Bot::Error => e
            Rails.logger.error "Error while uploading audio: #{e.message}"
            send_message(text: "Произошла ошибка при отправке аудио: #{e.message}. Пожалуйста, попробуйте позже.")
          rescue StandardError => e
            Rails.logger.error "General Error while sending audio: #{e.message}"
            send_message(text: "Произошла внутренняя ошибка при отправке аудио.")
          end
        else
          Rails.logger.error "Audio file not found at specified path: #{audio_file_path}"
          send_message(text: "Произошла ошибка: аудиофайл не найден.")
        end
      end

      # Обновляем шаг пользователя, чтобы обозначить, что упражнение началось.
      @user.set_self_help_step('day_2_exercise_in_progress')
      send_message(text: "Нажмите 'Я завершил(а) упражнение', когда закончите медитацию.", # Убрал chat_id: @chat_id
                   reply_markup: TelegramMarkupHelper.day_2_exercise_completed_markup) # <-- ИЗМЕНЕНО: Используем разметку для ЗАВЕРШЕНИЯ
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to start Day 2 exercise from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Что-то пошло не так при запуске упражнения дня 2. Напишите /start для начала заново.")
      @user.clear_self_help_program
    end
  end

  def handle_day_2_exercise_completion
    Rails.logger.debug "User #{@user.telegram_id} completing Day 2 exercise. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_2_exercise_in_progress'
      @user.set_self_help_step('day_2_completed')
      message = "Отличная работа! Поздравляю с выполнением упражнения второго дня.\n\n" \
                "Сегодня мы поработали над связью с телом и осознанностью. " \
                "Вы можете практиковать это упражнение в любое время, когда почувствуете напряжение.\n\n" \
                "На сегодня всё! Отдохните и возвращайтесь завтра для нового дня программы."
      send_message(text: message) # Отправляем только текст

      # НОВОЕ: Предлагаем начать День 3 через отдельное сообщение и кнопку
      @user.set_self_help_step('awaiting_day_3_start') # Устанавливаем шаг ожидания
      send_message(text: "Готовы начать третий день программы?", reply_markup: TelegramMarkupHelper.day_3_start_proposal_markup)
      Rails.logger.debug "SelfHelpService: Day 2 completed. Awaiting Day 3 start."
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to complete Day 2 exercise from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Что-то пошло не так при завершении упражнения дня 2. Напишите /start для начала заново.")
      @user.clear_self_help_program
    end
  end

  # --- ДЕНЬ 3: Дневник благодарности ---

  def deliver_day_3_content
    Rails.logger.debug "User #{@user.telegram_id} delivering Day 3 content. Current step: #{@user.get_self_help_step}."
    # ИЗМЕНЕНО: Теперь проверяем состояние ожидания перед началом дня 3
    if @user.get_self_help_step == 'awaiting_day_3_start'
      @user.set_self_help_step('day_3_intro')
      message_text = "Добро пожаловать в третий день программы!\n\n**Тема дня: Дневник благодарности.**\n\n" \
                     "Практика благодарности — это один из самых эффективных способов переключить фокус внимания с негатива на позитив. " \
                     "Это не значит игнорировать проблемы, а значит замечать хорошее, что уже есть в вашей жизни.\n\n" \
                     "Сегодня мы начнем вести дневник благодарности. Выберите действие:"
      send_message(text: message_text, reply_markup: TelegramMarkupHelper.day_3_menu_markup)
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to deliver Day 3 content from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Произошла ошибка. Пожалуйста, начните программу заново.")
      @user.clear_self_help_program
    end
  end

  # Запуск ввода новой благодарности
  def start_gratitude_entry
    Rails.logger.debug "User #{@user.telegram_id} starting gratitude entry. Current step: #{@user.get_self_help_step}."
    # Проверка на то, что мы находимся в контексте Дня 3
    if @user.get_self_help_step.to_s.start_with?('day_3')
      @user.set_self_help_step('day_3_waiting_for_gratitude')
      send_message(text: "Отлично! Перечислите 3 вещи, за которые вы сегодня благодарны. Это может быть что угодно. Просто напишите их одним сообщением.") # Убрал chat_id: @chat_id
    else
      # Если пользователь находится на совсем левом шаге, выдаем ошибку
      Rails.logger.warn "User #{@user.telegram_id} tried to start gratitude entry from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Произошла ошибка. Пожалуйста, начните программу заново.")
      @user.clear_self_help_program
    end
  end

  # Обработка введенного текста благодарности
  def handle_gratitude_input(text)
    Rails.logger.debug "User #{@user.telegram_id} submitting gratitude entry. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_3_waiting_for_gratitude'
      begin
        GratitudeEntry.create!(
          user: @user,
          entry_date: Date.current,
          entry_text: text
        )
        @user.set_self_help_step('day_3_entry_saved') # Отмечаем, что запись сохранена
        send_message(text: "✅ Запись сохранена! Продолжайте вести дневник или завершите день.", reply_markup: TelegramMarkupHelper.day_3_menu_markup) # Убрал chat_id: @chat_id
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error "Error saving gratitude entry for user #{@user.telegram_id}: #{e.message}"
        send_message(text: "Произошла ошибка при сохранении записи. Пожалуйста, попробуйте еще раз.") # Убрал chat_id: @chat_id
      end
    else
      Rails.logger.warn "User #{@user.telegram_id} submitted gratitude input from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Я не знаю, как ответить на это. Пожалуйста, используйте кнопки.")
      # Не сбрасываем программу, чтобы не потерять ввод, если он не был сохранен.
    end
  end

  # Показ записей благодарности
  def show_gratitude_entries
    Rails.logger.debug "User #{@user.telegram_id} requesting to show gratitude entries. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step.to_s.start_with?('day_3')
      entries = @user.gratitude_entries.order(entry_date: :desc).limit(5) # Показываем последние 5

      if entries.empty?
        send_message(text: "У вас пока нет записей в дневнике благодарности.", reply_markup: TelegramMarkupHelper.day_3_menu_markup)
        return
      end

      message = "❤️ **Ваши последние записи благодарности** ❤️\n\n"
      entries.each_with_index do |entry, index|
        message += "*#{entry.entry_date.strftime('%d.%m.%Y')}*\n"
        message += "#{entry.entry_text}\n\n"
      end
      message += "Нажмите 'Ввести благодарности', чтобы добавить новую запись."

      send_message(text: message, parse_mode: 'Markdown', reply_markup: TelegramMarkupHelper.day_3_menu_markup)
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to show gratitude entries from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Произошла ошибка. Пожалуйста, начните программу заново.")
      @user.clear_self_help_program
    end
  end

  # Завершение Дня 3
  def complete_day_3
    Rails.logger.debug "User #{@user.telegram_id} completing Day 3. Current step: #{@user.get_self_help_step}."
    if ['day_3_entry_saved', 'day_3_intro', 'day_3_waiting_for_gratitude'].include?(@user.get_self_help_step)
      @user.set_self_help_step('day_3_completed')
      message = "Поздравляю! Вы завершили третий день программы. Отдохните и возвращайтесь для продолжения!"
      send_message(text: message) # Отправляем только текст

      # НОВОЕ: Предлагаем начать День 4
      @user.set_self_help_step('awaiting_day_4_start')
      send_message(text: "Готовы начать четвертый день программы?", reply_markup: TelegramMarkupHelper.day_4_start_proposal_markup)
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to complete Day 3 from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Произошла ошибка при завершении дня 3. Напишите /start для начала заново.")
      @user.clear_self_help_program
    end
  end

  # --- ДЕНЬ 4: Квадратное дыхание ---

  def deliver_day_4_content
    Rails.logger.debug "User #{@user.telegram_id} delivering Day 4 content. Current step: #{@user.get_self_help_step}."
    # ИЗМЕНЕНО: Теперь проверяем состояние ожидания перед началом дня 4
    if @user.get_self_help_step == 'awaiting_day_4_start'
      @user.set_self_help_step('day_4_intro')
      message_text = "Добро пожаловать в четвертый день программы!\n\n**Тема дня: Регуляция дыхания.**\n\n" \
                     "Давай попробуем дыхательное упражнение 'Квадратное дыхание'. Это поможет успокоить нервную систему и снизить тревожность. " \
                     "Готовы?"
      send_message(text: message_text, reply_markup: TelegramMarkupHelper.day_4_exercise_consent_markup)
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to deliver Day 4 content from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Произошла ошибка. Пожалуйста, начните программу заново.")
      @user.clear_self_help_program
    end
  end

  def start_day_4_exercise
    Rails.logger.debug "User #{@user.telegram_id} starting Day 4 exercise. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_4_intro'
      @user.set_self_help_step('day_4_exercise_in_progress')

      send_message(text: "Отлично! Найдите удобное положение сидя или лежа. Закройте глаза, если вам это комфортно.") # Убрал chat_id: @chat_id
      send_message(text: "Представьте себе квадрат. Каждая сторона квадрата – это фаза дыхания.") # Убрал chat_id: @chat_id

      exercise_text =
        "**Упражнение 'Квадратное дыхание' (4-4-4-4):**\n\n" \
        "1. **Вдох (4 секунды):** Медленно и глубоко вдохните через нос, считая до 4.\n" \
        "2. **Задержка (4 секунды):** Задержите дыхание на 4 секунды.\n" \
        "3. **Выдох (4 секунды):** Медленно и плавно выдохните через рот, считая до 4.\n" \
        "4. **Задержка (4 секунды):** Задержите дыхание на 4 секунды.\n\n" \
        "Продолжайте этот цикл в течение 4-5 минут. Сосредоточьтесь на счете и ощущениях."
      send_message(text: exercise_text, parse_mode: 'Markdown') # Убрал chat_id: @chat_id

      send_message(
        text: "Как только закончите, нажмите кнопку ниже.", # Убрал chat_id: @chat_id
        reply_markup: TelegramMarkupHelper.day_4_exercise_completed_markup
      )
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to start Day 4 exercise from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Произошла ошибка. Пожалуйста, начните программу заново.")
      @user.clear_self_help_program
    end
  end

  def handle_day_4_exercise_completion
    Rails.logger.debug "User #{@user.telegram_id} completing Day 4 exercise. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_4_exercise_in_progress'
      @user.set_self_help_step('day_4_completed')
      message = "Прекрасно! Вы завершили упражнение. Как вы себя чувствуете? Надеюсь, более спокойно и расслабленно. На сегодня всё!"
      send_message(text: message) # Отправляем только текст

      # НОВОЕ: Предлагаем День 5
      @user.set_self_help_step('awaiting_day_5_start')
      send_message(text: "Готовы начать пятый день программы?", reply_markup: TelegramMarkupHelper.day_5_start_proposal_markup)
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to complete Day 4 exercise from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Произошла ошибка. Пожалуйста, начните программу заново.")
      @user.clear_self_help_program
    end
  end

  # --- ДЕНЬ 5: Физическая активность ---

  def deliver_day_5_content
    Rails.logger.debug "User #{@user.telegram_id} delivering Day 5 content. Current step: #{@user.get_self_help_step}."
    # ИЗМЕНЕНО: Теперь проверяем состояние ожидания перед началом дня 5
    if @user.get_self_help_step == 'awaiting_day_5_start'
      @user.set_self_help_step('day_5_intro')
      message_text = "Добро пожаловать в пятый день программы!\n\n**Тема дня: Движение и настроение.**\n\n" \
                     "Сегодня предлагаю немного подвигаться. Физическая активность — отличный способ снизить уровень стресса и улучшить настроение.\n\n" \
                     "**Задание:** Выберите любую физическую активность, которая вам нравится (прогулка, танцы, йога, зарядка), и уделите ей 15-20 минут."
      send_message(
        text: message_text,
        reply_markup: TelegramMarkupHelper.start_day_5_exercise_markup
      )
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to deliver Day 5 content from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Произошла ошибка. Пожалуйста, начните программу заново.")
      @user.clear_self_help_program
    end
  end

  def start_day_5_exercise
    Rails.logger.debug "User #{@user.telegram_id} starting Day 5 exercise. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_5_intro' # Проверяем, что пользователь на шаге интро
      @user.set_self_help_step('day_5_exercise_in_progress') # Обновляем состояние

      message_text = "Отлично! Уделите **15-20 минут** любой физической активности, которая вам нравится: прогулка, танцы, йога, зарядка или что-то еще.\n\n" \
                     "Сосредоточьтесь на ощущениях в теле и на том, как движение влияет на ваше настроение."
      send_message(text: message_text, parse_mode: 'Markdown')

      send_message(
        text: "Когда закончите, нажмите кнопку ниже.",
        reply_markup: TelegramMarkupHelper.day_5_exercise_completed_markup # Теперь используем разметку для завершения
      )
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to start Day 5 exercise from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Произошла ошибка. Пожалуйста, начните программу заново.")
      @user.clear_self_help_program
    end
  end

  def handle_day_5_exercise_completion
    Rails.logger.debug "User #{@user.telegram_id} completing Day 5 exercise. Current step: #{@user.get_self_help_step}."
    # ИЗМЕНЕНО: теперь проверяем состояние day_5_exercise_in_progress
    if @user.get_self_help_step == 'day_5_exercise_in_progress'
      @user.set_self_help_step('day_5_completed')
      message = "Отлично! Вы позаботились о своем теле. Это очень важный шаг к улучшению самочувствия. На сегодня всё!"
      send_message(text: message) # Отправляем только текст

      # НОВОЕ: Предлагаем День 6
      @user.set_self_help_step('awaiting_day_6_start')
      send_message(text: "Готовы начать шестой день программы?", reply_markup: TelegramMarkupHelper.day_6_start_proposal_markup)
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to complete Day 5 exercise from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Произошла ошибка. Пожалуйста, начните программу заново.")
      @user.clear_self_help_program
    end
  end

  # --- ДЕНЬ 6: Отдых и удовольствие ---

  def deliver_day_6_content
    Rails.logger.debug "User #{@user.telegram_id} delivering Day 6 content. Current step: #{@user.get_self_help_step}."
    # ИЗМЕНЕНО: Теперь проверяем состояние ожидания перед началом дня 6
    if @user.get_self_help_step == 'awaiting_day_6_start'
      @user.set_self_help_step('day_6_intro')
      message_text = "Добро пожаловать в шестой день программы!\n\n**Тема дня: Забота о себе.**\n\n" \
                     "Сегодня просто отдохни и сделай что-то приятное для себя. Посмотри фильм, почитай книгу, послушай музыку, прими ванну. " \
                     "Цель — дать себе время восстановиться и насладиться моментом, не испытывая чувства вины."
      send_message(
        text: message_text,
        reply_markup: TelegramMarkupHelper.day_6_exercise_completed_markup
      )
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to deliver Day 6 content from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Произошла ошибка. Пожалуйста, начните программу заново.")
      @user.clear_self_help_program
    end
  end

  def handle_day_6_exercise_completion
    Rails.logger.debug "User #{@user.telegram_id} completing Day 6 exercise. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_6_intro'
      @user.set_self_help_step('day_6_completed')
      message = "Надеюсь, вы хорошо отдохнули! Забота о себе — это не роскошь, а необходимость. Завтра последний день первой недели программы."
      send_message(text: message) # Отправляем только текст

      # НОВОЕ: Предлагаем День 7
      @user.set_self_help_step('awaiting_day_7_start')
      send_message(text: "Готовы начать седьмой день программы?", reply_markup: TelegramMarkupHelper.day_7_start_proposal_markup)
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to complete Day 6 exercise from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Произошла ошибка. Пожалуйста, начните программу заново.")
      @user.clear_self_help_program
    end
  end

  # --- ДЕНЬ 7: Рефлексия недели ---

  def deliver_day_7_content
    Rails.logger.debug "User #{@user.telegram_id} delivering Day 7 content. Current step: #{@user.get_self_help_step}."
    # ИЗМЕНЕНО: Теперь проверяем состояние ожидания перед началом дня 7
    if @user.get_self_help_step == 'awaiting_day_7_start'
      @user.set_self_help_step('day_7_waiting_for_reflection') # Устанавливаем шаг, что ожидаем рефлексию
      message_text = "Добро пожаловать в седьмой день программы!\n\n**Тема дня: Рефлексия недели.**\n\n" \
                     "Как прошла первая неделя? Что было самым сложным? Что помогло тебе почувствовать себя лучше? " \
                     "Напиши пару слов о своих впечатлениях в ответном сообщении. Это поможет тебе закрепить прогресс."
      send_message(text: message_text)
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to deliver Day 7 content from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Произошла ошибка. Пожалуйста, начните программу заново.")
      @user.clear_self_help_program
    end
  end

  # Обработка введенной рефлексии (вызывается из MessageProcessor)
  # Принимает текст от пользователя.
  def handle_reflection_input(text)
    Rails.logger.debug "User #{@user.telegram_id} submitting reflection. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_7_waiting_for_reflection'
      begin
        ReflectionEntry.create!(
          user: @user,
          entry_date: Date.current,
          entry_text: text
        )
        @user.set_self_help_step('day_7_completed')
        message = "Спасибо за твою искренность! Ты успешно завершил первую неделю программы самопомощи. Поздравляю!"
        send_message(text: message, reply_markup: TelegramMarkupHelper.complete_program_markup) # Кнопка для завершения
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error "Error saving reflection entry for user #{@user.telegram_id}: #{e.message}"
        send_message(text: "Произошла ошибка при сохранении записи. Пожалуйста, попробуйте еще раз.")
      end
    else
      Rails.logger.warn "User #{@user.telegram_id} submitted reflection input from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Я не знаю, как ответить на это. Пожалуйста, используйте кнопки.")
    end
  end

  # Обработчик для кнопки "Завершить неделю" (callback_data: 'complete_day_7')
  def complete_day_7_and_propose_next
    Rails.logger.debug "User #{@user.telegram_id} completing Day 7. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_7_completed'
      # НОВОЕ: Предлагаем начать День 8
      @user.set_self_help_step('awaiting_day_8_start')
      send_message(text: "Поздравляю с завершением первой недели! Готовы начать вторую?", reply_markup: TelegramMarkupHelper.day_8_start_proposal_markup)
      Rails.logger.debug "SelfHelpService: Day 7 completed. Awaiting Day 8 start."
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to complete Day 7 from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Ошибка состояния для завершения Дня 7. Начните /start.")
      @user.clear_self_help_program
    end
  end

  # --- ДЕНЬ 8: Техника "Остановка мыслей" ---

  def deliver_day_8_content
    Rails.logger.debug "User #{@user.telegram_id} delivering Day 8 content. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'awaiting_day_8_start'
      @user.set_self_help_step('day_8_waiting_for_consent') # <--- ИЗМЕНЕНО ЗДЕСЬ
      message_text = "Добро пожаловать в восьмой день программы!\n\n**Тема дня: Техника 'Остановка мыслей'.**\n\n" \
                     "Сегодня попробуем очень полезную технику, которая поможет вам взять под контроль навязчивые, " \
                     "негативные или тревожные мысли. Она требует практики, но со временем может стать очень эффективной.\n\n" \
                     "**Готовы попробовать?**"
      send_message(
        text: message_text,
        parse_mode: 'Markdown',
        reply_markup: TelegramMarkupHelper.day_8_consent_markup
      )
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to deliver Day 8 content from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Вы пытаетесь начать День 8 из неправильного состояния. Напишите /start, чтобы вернуться в главное меню и начать заново.")
      @user.clear_self_help_program
    end
  end

  # Обрабатывает согласие/отказ пользователя начать упражнение Дня 8.
  def handle_day_8_consent(choice)
    Rails.logger.debug "User #{@user.telegram_id} handled Day 8 consent: #{choice}. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_8_waiting_for_consent'
      if choice == 'confirm'
        start_day_8_exercise_instructions
      else # choice == 'decline'
        handle_day_8_skip
      end
    else
      Rails.logger.warn "User #{@user.telegram_id} handled Day 8 consent from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Ошибка состояния. Начните /start.")
    end
  end

  def start_day_8_exercise_instructions
    Rails.logger.debug "User #{@user.telegram_id} starting Day 8 exercise instructions. Current step: #{@user.get_self_help_step}."
    @user.set_self_help_step('day_8_thought_stopping_instructions')

        send_message(text: "Отлично! Давай начнем.\n\n" \
                                        "1. Представьте, что у вас есть **пульт дистанционного управления** для вашего мозга. " \
                                        "С помощью этого пульта вы можете 'включать' и 'выключать' различные мысли.\n\n" \
                                        "2. Сейчас я попрошу вас вспомнить мысль, которая часто вызывает у вас беспокойство или дискомфорт. " \
                                        "Это может быть что угодно: страх, сомнение, негативное воспоминание. " \
                                        "**Не погружайтесь в эту мысль слишком глубоко, просто осознайте ее.**")

    # Отправляем второе сообщение сразу, Telegram API отправляет их последовательно.
    send_message(text: "3. Как только вы осознали эту мысль, представьте, что вы нажимаете большую красную кнопку 'Стоп' на вашем воображаемом пульте дистанционного управления. " \
                                        "В этот момент вы должны сказать себе (мысленно или вслух) слово **'СТОП!'**.\n\n" \
                                        "**Сделайте это сейчас: Вспомните свою мысль... СТОП!**")


    @user.set_self_help_step('day_8_first_try') # Устанавливаем шаг, что пользователь сделал первую попытку
    send_message(
      text: "Когда будете готовы продолжить, нажмите кнопку:", # Убрал chat_id: @chat_id
      reply_markup: TelegramMarkupHelper.day_8_stopped_thought_first_try_markup # Кнопка для продолжения
    )
  end

  def handle_day_8_stopped_thought_first_try
    Rails.logger.debug "User #{@user.telegram_id} finished first try of thought stopping. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_8_first_try'
      @user.set_self_help_step('day_8_second_try')
            send_message(text: "Что произошло? Получилось ли у вас остановить мысль? Если нет, попробуйте еще раз. " \
                                          "**Вспомните свою мысль... СТОП!**\n\n" \
                                          "После того, как вы остановили мысль, важно переключить свое внимание на что-то другое. " \
                                          "Это ключевой момент техники.")

      send_message(
        text: "Когда будете готовы выбрать отвлечение, нажмите кнопку:", # Убрал chat_id: @chat_id
        reply_markup: TelegramMarkupHelper.day_8_ready_for_distraction_markup # Кнопка для выбора отвлечения
      )
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to proceed after first try from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Ошибка состояния. Начните /start.")
    end
  end

  def handle_day_8_ready_for_distraction
    Rails.logger.debug "User #{@user.telegram_id} is ready for distraction. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_8_second_try'
      @user.set_self_help_step('day_8_choosing_distraction')
      message_text = "Выберите что-то, что вам нравится и что может вас отвлечь на 5-10 минут:"
      send_message(
        text: message_text, # Убрал chat_id: @chat_id
        reply_markup: TelegramMarkupHelper.day_8_distraction_options_markup # Кнопки с вариантами отвлечения
      )
    else
      Rails.logger.warn "User #{@user.telegram_id} is ready for distraction from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Ошибка состояния. Начните /start.")
    end
  end

  def guide_distraction(distraction_type)
    Rails.logger.debug "User #{@user.telegram_id} chose distraction: #{distraction_type}. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_8_choosing_distraction'
      @user.set_self_help_step('day_8_distraction_in_progress')

      distraction_message = case distraction_type
                            when 'music' then "Отличный выбор! Включите любимую музыку."
                            when 'video' then "Хорошо! Посмотрите короткое интересное видео."
                            when 'friend' then "Прекрасно! Поговорите с другом или близким человеком."
                            when 'exercise' then "Отлично! Сделайте несколько легких физических упражнений или разомнитесь."
                            when 'book' then "Замечательно! Почитайте интересную книгу или статью."
                            else "Вы выбрали отличное занятие!"
                            end

            send_message(text: "#{distraction_message}\n\n" \
                                          "Сосредоточьтесь на выбранном занятии в течение **5-10 минут**. " \
                                          "Позвольте себе полностью погрузиться в этот процесс и отвлечься от негативных мыслей.")

      send_message(
        text: "Как только закончите выбранное занятие, нажмите кнопку ниже:", # Убрал chat_id: @chat_id
        reply_markup: TelegramMarkupHelper.day_8_exercise_completed_markup # Кнопка для завершения упражнения
      )
    else
      Rails.logger.warn "User #{@user.telegram_id} guided distraction from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Ошибка состояния. Начните /start.")
    end
  end

  def handle_day_8_exercise_completion
    Rails.logger.debug "User #{@user.telegram_id} completing Day 8 exercise. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_8_distraction_in_progress'
      @user.set_self_help_step('day_8_completed')

      message = "Отличная работа! Вы успешно попрактиковались в технике 'Остановка мыслей'.\n\n" \
                "**Важные напоминания:**\n" \
                "• После того, как вы остановили мысль, вернитесь к своим обычным делам. Если тревожные мысли снова возникнут, повторите упражнение.\n" \
                "• Если вам сложно сказать 'Стоп!' вслух, вы можете заменить это слово другим, которое имеет для вас сильное значение (например, 'Хватит!', 'Достаточно!').\n" \
                "• Вместо воображаемого пульта вы можете представить красный стоп-сигнал, стену, которая блокирует мысль, или любой другой образ.\n" \
                "• Не расстраивайтесь, если у вас не получится остановить мысль с первого раза. Эта техника требует практики. Продолжайте тренироваться, и со временем вы станете более успешными."
      send_message(text: message) # Убрал chat_id: @chat_id

      final_message = "Поздравляю с завершением восьмого дня программы! Продолжайте практиковать эту технику. До новых встреч!"
      send_message(text: final_message, reply_markup: TelegramMarkupHelper.final_program_completion_markup) # Убрал chat_id: @chat_id
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to complete Day 8 exercise from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Произошла ошибка. Пожалуйста, начните программу заново.")
      @user.clear_self_help_program
    end
  end

  def handle_day_8_skip
    Rails.logger.debug "User #{@user.telegram_id} declined Day 8 exercise. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_8_waiting_for_consent'
      @user.clear_self_help_program
      send_message(text: "Хорошо, мы можем попробовать эту технику позже. Возвращайтесь в главное меню.", reply_markup: TelegramMarkupHelper.main_menu_markup)
    else
      Rails.logger.warn "User #{@user.telegram_id} declined Day 8 from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Ошибка состояния. Начните /start.")
    end
  end

  def handle_day_4_skip
    Rails.logger.debug "User #{@user.telegram_id} declined Day 4 exercise. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_4_intro'
      @user.clear_self_help_program
      send_message(text: "Хорошо, мы можем вернуться к упражнению позже. Нажмите /start, чтобы вернуться в главное меню.")
    else
      Rails.logger.warn "User #{@user.telegram_id} declined Day 4 from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Пожалуйста, вернитесь в главное меню, нажав /start.")
    end
  end

  def handle_complete_program_final
    Rails.logger.debug "User #{@user.telegram_id} is completing the entire program. Current step: #{@user.get_self_help_step}."
    # Предполагается, что это финальное действие после Дня 8.
    @user.clear_self_help_program # Очищаем состояние программы
    send_message(
      text: "Программа полностью завершена! Вы молодец! Вы можете вернуться к материалам в любое время. Продолжайте использовать дневник благодарности и другие инструменты.", # Убрал chat_id: @chat_id
      reply_markup: TelegramMarkupHelper.main_menu_markup # Возвращаем в главное меню
    )
  end

  private

  # --- Вспомогательные методы ---

  # Этот метод принимает только text, reply_markup, parse_mode
  # и использует @chat_id, который уже известен из инициализатора класса.
  def send_message(text:, reply_markup: nil, parse_mode: nil)
    # Здесь @bot_service - это экземпляр Telegram::TelegramBotService.
    # Поэтому вызываем его метод send_message, который уже принимает chat_id:
    @bot_service.send_message(chat_id: @chat_id, text: text, reply_markup: reply_markup, parse_mode: parse_mode)
  rescue Telegram::Bot::Error => e
    Rails.logger.error "Telegram API Error sending message to #{@user.telegram_id}: #{e.message}"
    # Можно добавить логику для уведомления пользователя об ошибке, но часто просто логирования достаточно.
  end
end
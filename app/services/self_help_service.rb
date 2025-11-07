
# app/services/self_help_service.rb

require 'faraday/multipart'

class SelfHelpService
  include TelegramMarkupHelper

  def initialize(bot, user, chat_id)
    @bot = bot
    @user = user
    @chat_id = chat_id
  end

  # Запускает последовательность тестов (Депрессия, Тревожность)
  def start_tests_sequence
        @user.set_self_help_step('taking_depression_test') # <-- Более конкретный шаг
        @bot.send_message(chat_id: @chat_id, text: "Запускаю тест на депрессию...")
        QuizRunner.new(@bot, @user, @chat_id).start_quiz('depression')
      end

  # Метод, который будет вызван после завершения теста на депрессию
  def handle_depression_test_completion
    # Проверяем, что пользователь находится в нужном состоянии
    if @user.get_self_help_step == 'awaiting_depression_test_completion'
      @user.set_self_help_step('awaiting_anxiety_test_completion')
      @bot.send_message(chat_id: @chat_id, text: "Тест на депрессию завершен. Теперь пройдем тест на тревожность.")
      TestManager.new(@bot, @user, @chat_id).prepare_test('anxiety')
    else
      @bot.send_message(chat_id: @chat_id, text: "Произошла ошибка. Пожалуйста, начните программу заново.")
    end
  end

  def deliver_day_1_content
        # Шаг пользователя уже должен быть 'day_1_content_delivered'
        # @user.set_self_help_step('day_1_content_delivered') # Это теперь делается в CallbackQueryProcessor

        @bot.send_message(
          chat_id: @chat_id,
          text: "Добро пожаловать в первый день программы!\n\nТема дня: осознанность.\n\n" \
                "Осознанность — это способность быть полностью присутствующим в текущем моменте, " \
                "без осуждения, просто наблюдая свои мысли, чувства и ощущения.\n\n" \
                "Это мощный инструмент для снижения стресса, улучшения эмоционального регулирования " \
                "и повышения общего благополучия.",
          parse_mode: 'HTML'
        )

        @bot.send_message(
          chat_id: @chat_id,
          text: "Нажмите 'Продолжить', когда будете готовы к упражнению первого дня.",
          reply_markup: day_1_continue_markup # Кнопка "Продолжить изучение дня 1"
        )
      end

      # --- НОВЫЙ МЕТОД: отправка упражнения дня 1 ---
      def send_day_1_exercise
    # Проверка шага нужна только если вы вызываете этот метод напрямую без предварительного хэндлера
    # Если вызывается через handle_continue_day_1_content, то там уже есть проверка.
    # Для ясности, можем ее оставить:
    # return unless @user.get_self_help_step == 'day_1_content_delivered'

    @bot.send_message(
      chat_id: @chat_id,
      text: "Отлично! Наше первое упражнение - это простое упражнение на внимательное дыхание.\n\n" \
            "Найдите тихое место, где вас никто не побеспокоит в течение 5-10 минут. " \
            "Сядьте удобно или лягте. Закройте глаза, если вам комфортно.\n\n" \
            "Просто сосредоточьтесь на своем дыхании. Ощущайте, как воздух входит и выходит. " \
            "Не пытайтесь изменить дыхание, просто наблюдайте за ним.\n\n" \
            "Если ваш ум отвлекается, просто мягко верните внимание к дыханию. " \
            "Это нормально, что мысли приходят и уходят. Цель не в том, чтобы не думать, а в том, чтобы замечать, когда ум отвлекся, и возвращать его обратно.\n\n" \
            "Вы можете использовать таймер на 5 минут.",
      parse_mode: 'HTML'
    )
    @bot.send_message(
      chat_id: @chat_id,
      text: "Когда закончите упражнение, нажмите 'Я выполнил упражнение'.",
      reply_markup: { inline_keyboard: [[{ text: "Я выполнил упражнение", callback_data: 'day_1_exercise_completed' }]] }.to_json
    )
    @user.set_self_help_step('day_1_exercise_in_progress') # <--- Устанавливаем правильный шаг
  end

  # --- НОВЫЙ МЕТОД: handle_day_1_exercise_completion ---
  def handle_day_1_exercise_completion
    # Проверка шага уже происходит в CallbackQueryProcessor, но можно добавить для надежности.
    # return unless @user.get_self_help_step == 'day_1_exercise_in_progress'

    @user.set_self_help_step('day_1_completed') # Отмечаем, что день 1 завершен

    @bot.send_message(
      chat_id: @chat_id,
      text: "Отличная работа! Поздравляю с выполнением первого упражнения на осознанность.\n\n" \
            "Практика внимательности — это навык, который развивается со временем. " \
            "Не расстраивайтесь, если сначала было трудно. Главное — продолжать!\n\n" \
            "На сегодня всё! Отдохните и возвращайтесь завтра для нового дня программы.",
      # --- ИЗМЕНЕНИЕ ЗДЕСЬ: ПРЕДЛАГАЕМ НАЧАТЬ ДЕНЬ 2 ---
      reply_markup: day_2_intro_markup # <--- Новый markup для перехода ко Дню 2
    )
    Rails.logger.debug "SelfHelpService: Day 1 completed. Proposing Day 2."
  end

  def deliver_day_1_intro_message
        @bot.send_message(
          chat_id: @chat_id,
          text: "Спасибо за прохождение тестов! Это важный шаг к пониманию своего состояния.\n\n" \
                "Теперь давайте начнем программу самопомощи. Первый день посвящен осознанности.",
          reply_markup: { inline_keyboard: [[{ text: "Начать первый день", callback_data: 'start_day_1_content' }]] }.to_json
        )
  end

  def deliver_day_2_content
        # Шаг пользователя уже должен быть 'day_2_content_intro'
        # @user.set_self_help_step('day_2_content_delivered') # Это действие не нужно здесь

        @bot.send_message(
          chat_id: @chat_id,
          text: "Добро пожаловать во второй день программы!\n\nТема дня: Рефлексия и дневник эмоций.\n\n" \
                "Сегодня мы сосредоточимся на развитии самосознания через рефлексию и ведение дневника эмоций. " \
                "Это поможет вам лучше понимать свои чувства, их причины и реакции.",
          parse_mode: 'HTML'
        )

        @bot.send_message(
          chat_id: @chat_id,
          text: "Нажмите 'Начать упражнение', когда будете готовы к медитации 'Сканирование тела'.",
          reply_markup: { inline_keyboard: [[{ text: "Начать упражнение", callback_data: 'start_day_2_exercise_audio' }]] }.to_json
          # Используем новую callback_data для запуска аудио
        )
        @user.set_self_help_step('day_2_intro_delivered') # Устанавливаем шаг, чтобы знать, что интро доставлено
        Rails.logger.debug "SelfHelpService: Day 2 intro delivered."
      end

  def send_day_2_exercise_audio
  audio_file_path = Rails.root.join('public', 'assets', 'audio', 'body_scan.mp3')
  caption = "Медитация 'Сканирование тела'"

  day2_audio_file_id = Setting.find_by(key: 'day2_exercise_audio_file_id')&.value

  if day2_audio_file_id.present?
    Rails.logger.info "Sending day_2_exercise audio using file_id: #{day2_audio_file_id}"
    @bot.send_audio(chat_id: @chat_id, audio: day2_audio_file_id, caption: caption)
  else
    if File.exist?(audio_file_path)
      file_size_mb = File.size(audio_file_path).to_f / (1024 * 1024)
      Rails.logger.info "Uploading day_2_exercise audio. Path: #{audio_file_path}, Size: #{file_size_mb.round(2)} MB"

      if file_size_mb > 50
        Rails.logger.error "Audio file is too large (#{file_size_mb.round(2)} MB). Telegram limit is 50MB."
        @bot.send_message(chat_id: @chat_id, text: "Произошла ошибка при отправке аудио: файл слишком большой.")
        return
      end

      begin
        # Попробуйте отправить файл напрямую
        @bot.send_audio(chat_id: @chat_id, audio: File.open(audio_file_path), caption: caption)
        Rails.logger.info "Audio sent successfully."
      rescue Telegram::Bot::Error => e
        Rails.logger.error "Error while uploading audio: #{e.message}"
        @bot.send_message(chat_id: @chat_id, text: "Произошла ошибка при отправке аудио: #{e.message}. Пожалуйста, попробуйте позже.")
      rescue StandardError => e
        Rails.logger.error "General Error while sending audio: #{e.message}"
        @bot.send_message(chat_id: @chat_id, text: "Произошла внутренняя ошибка при отправке аудио.")
      end
    else
      Rails.logger.error "Audio file not found at specified path: #{audio_file_path}"
      @bot.send_message(chat_id: @chat_id, text: "Произошла ошибка: аудиофайл не найден.")
    end
  end

  @bot.send_message(chat_id: @chat_id, text: "Нажмите 'Я завершил упражнение', когда закончите медитацию.",
                    reply_markup: { inline_keyboard: [[{ text: "Я завершил упражнение", callback_data: 'day_2_exercise_completed' }]] }.to_json)

  @user.set_self_help_step('day_2_exercise_in_progress')
end

      def handle_day_2_exercise_completion
        Rails.logger.debug "Current self help step: #{@user.get_self_help_step}"
        if @user.get_self_help_step == 'day_2_exercise_in_progress'
          @user.set_self_help_step('day_2_completed')
          @bot.send_message(
            chat_id: @chat_id,
            text: "Отличная работа! Поздравляю с выполнением упражнения второго дня.\n\n" \
                  "Сегодня мы поработали над связью с телом и осознанностью. " \
                  "Вы можете практиковать это упражнение в любое время, когда почувствуете напряжение.\n\n" \
                  "На сегодня всё! Отдохните и возвращайтесь завтра для нового дня программы.",
            reply_markup: { inline_keyboard: [[{ text: "Начать День 3", callback_data: 'start_day_3_content' }]] }.to_json
            # Или main_menu_markup
          )
          Rails.logger.debug "SelfHelpService: Day 2 completed. Proposing Day 3."
        else
          @bot.send_message(chat_id: @chat_id, text: "Что-то пошло не так при завершении дня 2. Напишите /start для начала заново.")
        end
      end

  # Переход к следующему дню (день 3)
  # 
  def deliver_day_3_content
    @user.set_self_help_step('day_3_content_intro')
    message_text = "Добро пожаловать в третий день программы!\n\nТема дня: Дневник благодарности.\n\n" \
                   "Практика благодарности — это один из самых эффективных способов переключить фокус внимания с негатива на позитив. " \
                   "Это не значит игнорировать проблемы, а значит замечать хорошее, что уже есть в вашей жизни.\n\n" \
                   "Сегодня мы начнем вести дневник благодарности. Выберите действие:"

    @bot.send_message(chat_id: @chat_id, text: message_text, reply_markup: day_3_menu_markup)
  end

  def start_gratitude_entry
    # Проверка на то, что мы находимся в контексте Дня 3
    if @user.get_self_help_step.start_with?('day_3')
      @user.set_self_help_step('day_3_waiting_for_gratitude')
      @bot.send_message(chat_id: @chat_id, text: "Отлично! Перечислите 3 вещи, за которые вы сегодня благодарны. Это может быть что угодно. Просто напишите их одним сообщением.")
    else
      @bot.send_message(chat_id: @chat_id, text: "Произошла ошибка. Пожалуйста, начните программу заново.")
    end
  end

  # --- НОВЫЙ МЕТОД: Обработка текстового ввода и сохранение ---
  # Этот метод будет вызываться из MessageProcessor
  def handle_gratitude_input(text)
    # 1. Сохраняем запись в новую модель
    GratitudeEntry.create!(
      user: @user,
      entry_date: Date.current,
      entry_text: text
    )

    # 2. Обновляем шаг пользователя
    @user.set_self_help_step('day_3_entry_saved')

    # 3. Отправляем подтверждение
    @bot.send_message(chat_id: @chat_id, text: "✅ Запись сохранена! Продолжайте вести дневник или завершите день.", reply_markup: day_3_menu_markup)
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Ошибка при сохранении благодарности: #{e.message}"
    @bot.send_message(chat_id: @chat_id, text: "Произошла ошибка при сохранении записи. Пожалуйста, попробуйте еще раз.")
  end

  # --- НОВЫЙ МЕТОД: Показ записей ---
  def show_gratitude_entries
    entries = @user.gratitude_entries.order(entry_date: :desc).limit(5) # Показываем последние 5

    if entries.empty?
      @bot.send_message(chat_id: @chat_id, text: "У вас пока нет записей в дневнике благодарности.", reply_markup: day_3_menu_markup)
      return
    end

    message = "❤️ **Ваши последние записи благодарности** ❤️\n\n"
    entries.each_with_index do |entry, index|
      message += "*#{entry.entry_date.strftime('%d.%m.%Y')}*\n"
      message += "#{entry.entry_text}\n\n"
    end
    message += "Нажмите 'Ввести благодарности', чтобы добавить новую запись."

    @bot.send_message(chat_id: @chat_id, text: message, parse_mode: 'Markdown', reply_markup: day_3_menu_markup)
  end

  # --- НОВЫЙ МЕТОД: Завершение Дня 3 ---
  def complete_day_3
    @user.set_self_help_step('day_3_completed')
    @bot.send_message(chat_id: @chat_id, text: "Поздравляю! Вы завершили третий день программы. Возвращайтесь завтра для продолжения!", reply_markup: back_to_main_menu_markup)
  end

  def prepare_day_3
    if @user.get_self_help_step == 'day_2_completed'
      @user.set_self_help_step('day_3_intro')
      message_text = "Сегодня поговорим о благодарности. Вспомни 3 вещи, за которые ты благодарен сегодня. Это может быть что угодно, даже мелочи."
      @bot.send_message(chat_id: @chat_id, text: message_text, reply_markup: TelegramMarkupHelper.day_3_menu_markup)
    else
      @bot.send_message(chat_id: @chat_id, text: "Произошла ошибка. Пожалуйста, начните программу заново.")
    end
  end

  # Метод для запуска ввода благодарностей (вызывается после нажатия кнопки)
  def start_gratitude_entry
    # Проверка должна быть мягкой, чтобы позволить пользователю вернуться к вводу
    # после просмотра записей (когда шаг все еще 'day_3_content_intro' или 'day_3_entry_saved')
    if @user.get_self_help_step.to_s.start_with?('day_3')
      @user.set_self_help_step('day_3_waiting_for_gratitude')
      @bot.send_message(chat_id: @chat_id, text: "Отлично! Перечислите 3 вещи, за которые вы сегодня благодарны. Это может быть что угодно. Просто напишите их одним сообщением.")
    else
      # Если пользователь находится на совсем левом шаге, выдаем ошибку
      @bot.send_message(chat_id: @chat_id, text: "Произошла ошибка. Пожалуйста, начните программу заново.")
    end
  end

  # Завершение программы
  def complete_program
    if @user.get_self_help_step == 'day_3_completed' || @user.get_self_help_step == 'program_completed'
      @user.set_self_help_step('program_completed')
      @bot.send_message(chat_id: @chat_id, text: "Поздравляю! Ты завершил первый этап программы самопомощи. Мы можем вернуться к нему позже, или ты можешь продолжить использовать другие функции бота.", reply_markup: TelegramMarkupHelper.back_to_main_menu_markup)
    else
      @bot.send_message(chat_id: @chat_id, text: "Произошла ошибка. Пожалуйста, начните программу заново.")
    end
  end

  # Обновленный метод `TestResultCalculator.calculate_and_send_results`
  # чтобы он мог возвращать интерпретацию без отправки сообщения
  class TestResultCalculator
    # ... (ваш существующий код)

    def calculate_and_send_results(silent: false)
      # ... (ваш код для расчета и получения интерпретации)

      # Вместо отправки сообщения, возвращаем интерпретацию
      interpretation = get_interpretation(total_score)
      @test_result.update(score: total_score, completed_at: Time.now)

      message = "Ваш балл: #{total_score}\n" # Добавим балл для наглядности
      message += "Интерпретация: #{interpretation}"

      if !silent
        @bot.send_message(
          chat_id: @chat_id,
          text: message,
          reply_markup: back_to_main_menu_markup # Используем новую клавиатуру
        )
      else
        return message # Возвращаем текст интерпретации
      end
    end
  end
end
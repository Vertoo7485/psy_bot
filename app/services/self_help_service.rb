
require 'faraday/multipart'

class SelfHelpService
  include TelegramMarkupHelper

  # Передаем бота, пользователя и chat_id
  def initialize(bot_service, user, chat_id) # Изменил 'bot' на 'bot_service' для ясности
    @bot_service = bot_service # Теперь это экземпляр Telegram::TelegramBotService
    @user = user
    @chat_id = chat_id
    @message_sender = Telegram::RobustMessageSender.new(bot_service, user, chat_id)
    
    # Автоматически создаем/восстанавливаем сессию
    @session = @user.get_or_create_session('self_help', @user.get_self_help_step || 'start')
  end

  # --- Инициализация программы самопомощи ---

  # Запускает первый шаг: предложение начать программу.
  def start_program_initiation
    Rails.logger.debug "User #{@user.telegram_id} initiating self-help program."
    save_current_progress
    # Если пользователь уже находится в программе, возобновляем ее
    if @user.get_self_help_step.present?
      return resume_program
    end

    @user.set_self_help_step('program_started') # Устанавливаем начальное состояние
    message_text = "Привет! Я твой бот для самопомощи. Начнем наше путешествие к улучшению самочувствия. " \
                   "Сейчас я попрошу тебя пройти несколько тестов, чтобы мы могли начать совместную работу! " \
                   "Спасибо, что присоединился. Все полностью анонимно и останется между нами."
    send_message(text: message_text, reply_markup: TelegramMarkupHelper.self_help_intro_markup)
  end

  def resume_program
    save_current_progress
  current_step = @user.get_self_help_step
  Rails.logger.info "Resuming program for user #{@user.telegram_id} at step: #{current_step}"

  case current_step
  # --- Этап тестов ---
  when 'program_started', 'taking_depression_test', 'awaiting_anxiety_test_completion', 'taking_anxiety_test'
    send_message(
      text: "Вы остановились на этапе прохождения тестов. Хотите продолжить?",
      reply_markup: TelegramMarkupHelper.self_help_intro_markup # Используем markup, который ведет на start_self_help_program_tests
    )

  # --- День 1 ---
  when 'day_1_intro', 'day_1_content_delivered', 'day_1_exercise_in_progress'
    deliver_day_1_content # Метод теперь сам определит, что показать

  when 'day_1_completed', 'awaiting_day_2_start'
    send_message(text: "Вы завершили День 1. Готовы начать второй день программы?", reply_markup: TelegramMarkupHelper.day_2_start_proposal_markup)

  # --- День 2 ---
  when 'day_2_intro_delivered', 'day_2_exercise_in_progress'
    deliver_day_2_content # Метод теперь сам определит, что показать

  when 'day_2_completed', 'awaiting_day_3_start'
    send_message(text: "Вы завершили День 2. Готовы начать третий день программы?", reply_markup: TelegramMarkupHelper.day_3_start_proposal_markup)

  # --- День 3 ---
  when 'day_3_intro', 'day_3_waiting_for_gratitude', 'day_3_entry_saved'
    deliver_day_3_content # Метод теперь сам определит, что показать

  when 'day_3_completed', 'awaiting_day_4_start'
    send_message(text: "Вы завершили День 3. Готовы начать четвертый день программы?", reply_markup: TelegramMarkupHelper.day_4_start_proposal_markup)

  # --- День 4 ---
  when 'day_4_intro', 'day_4_exercise_in_progress'
    deliver_day_4_content # Метод теперь сам определит, что показать

  when 'day_4_completed', 'awaiting_day_5_start'
    send_message(text: "Вы завершили День 4. Готовы начать пятый день программы?", reply_markup: TelegramMarkupHelper.day_5_start_proposal_markup)

  # --- День 5 ---
  when 'day_5_intro', 'day_5_exercise_in_progress'
    deliver_day_5_content # Метод теперь сам определит, что показать

  when 'day_5_completed', 'awaiting_day_6_start'
    send_message(text: "Вы завершили День 5. Готовы начать шестой день программы?", reply_markup: TelegramMarkupHelper.day_6_start_proposal_markup)

  # --- День 6 ---
  when 'day_6_intro'
    deliver_day_6_content # Метод теперь сам определит, что показать

  when 'day_6_completed', 'awaiting_day_7_start'
    send_message(text: "Вы завершили День 6. Готовы начать седьмой день программы?", reply_markup: TelegramMarkupHelper.day_7_start_proposal_markup)

  # --- День 7 ---
  when 'day_7_waiting_for_reflection'
    deliver_day_7_content # Метод теперь сам определит, что показать (попросит ввести рефлексию)

  when 'day_7_completed', 'awaiting_day_8_start'
    send_message(text: "Вы завершили День 7. Готовы начать восьмой день программы?", reply_markup: TelegramMarkupHelper.day_8_start_proposal_markup)

  # --- День 8 (Самый сложный, требует детального возобновления) ---
  when 'day_8_waiting_for_consent'
    deliver_day_8_content # Отправляет интро и кнопки согласия

  when 'day_8_first_try'
    # Пользователь нажал "согласен", но не нажал "Я попробовал(а) остановить мысль"
    send_message(text: "Вы остановились после получения инструкций. Сделайте свою попытку 'СТОП!' и нажмите кнопку.",
                 reply_markup: TelegramMarkupHelper.day_8_stopped_thought_first_try_markup)

  when 'day_8_second_try', 'day_8_choosing_distraction'
    # Пользователь остановился после первой попытки, но до выбора отвлечения
    handle_day_8_ready_for_distraction # Повторно отправляет меню выбора отвлечения

  when 'day_8_distraction_in_progress'
    # Пользователь выбрал отвлечение, но не нажал "Я выполнил(а) упражнение"
    send_message(text: "Вы сейчас выполняете упражнение на отвлечение. Как только закончите, нажмите кнопку ниже:",
                 reply_markup: TelegramMarkupHelper.day_8_exercise_completed_markup)
  when 'day_10_intro', 'day_10_exercise_in_progress'
  deliver_day_10_content

when 'day_10_completed', 'awaiting_day_11_start' # или program_completed
  send_message(text: "Вы завершили День 10. Готовы завершить программу?", reply_markup: TelegramMarkupHelper.final_program_completion_markup)

  when 'day_8_completed'
    send_message(text: "Вы завершили всю программу! Продолжайте практиковать полученные навыки.", reply_markup: TelegramMarkupHelper.final_program_completion_markup)

  else
    # Если состояние не определено, но не nil, предлагаем начать заново (на всякий случай)
    @user.clear_self_help_program
    send_message(text: "Произошла ошибка в вашем прогрессе. Начните программу заново.")
  end
end

  # Обрабатывает ответы "Да" или "Нет" на начальные вопросы.
  def handle_response(response_type)
    save_current_progress
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

  def deliver_day_10_content
  save_current_progress
  Rails.logger.debug "User #{@user.telegram_id} delivering Day 10 content. Current step: #{@user.get_self_help_step}"
  current_step = @user.get_self_help_step

  if current_step == 'awaiting_day_10_start'
    @user.set_self_help_step('day_10_intro')
    message_text = "🎉 **Добро пожаловать в десятый день программы!** 🎉\n\n" \
                   "**Тема дня: Работа с эмоциональными реакциями**\n\n" \
                   "За эти 9 дней вы научились:\n" \
                   "• Осознанности и внимательности\n" \
                   "• Техникам дыхания и релаксации\n" \
                   "• Работе с тревожными мыслями\n\n" \
                   "Сегодня мы закрепим эти навыки с помощью **Дневника эмоций** - мощного инструмента для анализа своих эмоциональных реакций."
    send_message(text: message_text, parse_mode: 'Markdown')
  end

  if ['day_10_intro', 'awaiting_day_10_start'].include?(@user.get_self_help_step)
    send_message(
      text: "**Задание на сегодня:**\n\n" \
            "1. Вспомните недавнюю ситуацию, которая вызвала у вас сильную эмоциональную реакцию\n" \
            "2. Заполните Дневник эмоций, используя все шаги\n" \
            "3. Проанализируйте результат\n\n" \
            "Это поможет вам лучше понимать связь между мыслями, эмоциями и поведением.",
      parse_mode: 'Markdown',
      reply_markup: TelegramMarkupHelper.day_10_start_exercise_markup
    )
  elsif current_step == 'day_10_exercise_in_progress'
    send_message(text: "Вы сейчас заполняете Дневник эмоций. Нажмите 'Я завершил(а) упражнение', когда закончите.",
                 reply_markup: TelegramMarkupHelper.day_10_exercise_completed_markup)
  else
    Rails.logger.warn "User #{@user.telegram_id} tried to deliver Day 10 content from unexpected state: #{current_step}."
    send_message(text: "Что-то пошло не так. Начните программу заново.")
    @user.clear_self_help_program
  end
end

def start_day_10_exercise
  save_current_progress
  Rails.logger.debug "User #{@user.telegram_id} starting Day 10 exercise. Current step: #{@user.get_self_help_step}"
  
  if @user.get_self_help_step == 'day_10_intro'
    @user.set_self_help_step('day_10_exercise_in_progress')
    
    # Запускаем Дневник эмоций через существующий сервис
    EmotionDiaryService.new(@bot_service, @user, @chat_id).start_new_entry
    
    # УБИРАЕМ сообщение с советом здесь - оно будет показано ПОСЛЕ заполнения
  else
    Rails.logger.warn "User #{@user.telegram_id} tried to start Day 10 exercise from unexpected state: #{@user.get_self_help_step}."
    send_message(text: "Что-то пошло не так. Начните программу заново.")
    @user.clear_self_help_program
  end
end

def handle_day_10_exercise_completion
  save_current_progress
  Rails.logger.debug "User #{@user.telegram_id} completing Day 10 exercise. Current step: #{@user.get_self_help_step}"
  
  if @user.get_self_help_step == 'day_10_exercise_in_progress'
    # Показываем записи пользователя
    show_day_10_diary_entries
    
    # Затем показываем совет и завершаем
    show_day_10_advice_and_complete
  else
    Rails.logger.warn "User #{@user.telegram_id} tried to complete Day 10 exercise from unexpected state: #{@user.get_self_help_step}."
    send_message(text: "Что-то пошло не так. Начните программу заново.")
    @user.clear_self_help_program
  end
end

def show_day_10_diary_entries
  # Используем существующий метод из EmotionDiaryService
  diary_service = EmotionDiaryService.new(@bot_service, @user, @chat_id)
  
  # Добавляем заголовок для контекста программы
  send_message(
    text: "📖 **Ваши записи в Дневнике эмоций:**\n\n" \
          "Вот все ваши сохраненные записи. Вы можете вернуться к ним в любое время для анализа.",
    parse_mode: 'Markdown'
  )
  
  # Вызываем метод показа записей (он сам проверит, есть ли записи)
  diary_service.show_entries
end

def show_day_10_advice_and_complete
  # Совет после заполнения
  send_message(
    text: "💡 **Совет по использованию Дневника эмоций:**\n\n" \
          "1. **Будьте честны с собой** - цель не оценивать, а понимать\n" \
          "2. **Заполняйте регулярно** - хотя бы раз в неделю\n" \
          "3. **Анализируйте паттерны** - что чаще всего вызывает негативные эмоции?\n" \
          "4. **Отмечайте прогресс** - как меняются ваши реакции со временем?\n\n" \
          "Этот инструмент поможет вам лучше понимать связь между мыслями, эмоциями и поведением.",
    parse_mode: 'Markdown'
  )
  
  # Предложение посмотреть конкретную запись
  latest_entry = @user.emotion_diary_entries.order(created_at: :desc).first
  if latest_entry
    send_message(
      text: "🔍 **Только что заполненная запись:**\n\n" \
            "*Ситуация:* #{latest_entry.situation.truncate(100)}\n" \
            "*Мысли:* #{latest_entry.thoughts.truncate(100)}\n" \
            "*Эмоции:* #{latest_entry.emotions}\n\n" \
            "Запись сохранена ✅",
      parse_mode: 'Markdown'
    )
  end
  
  # Завершаем день
  @user.set_self_help_step('day_10_completed')
  
  message = "🌟 **Отличная работа! День 10 завершен.** 🌟\n\n" \
            "Вы успешно:\n" \
            "✅ Заполнили Дневник эмоций\n" \
            "✅ Проанализировали свои записи\n" \
            "✅ Получили практические советы\n\n" \
            "Теперь у вас есть полный набор инструментов для работы с эмоциями!"
  send_message(text: message, parse_mode: 'Markdown')
  
  # Предлагаем завершить программу
  send_message(
    text: "🎊 **Поздравляем! Вы завершили 10-дневную программу самопомощи!** 🎊\n\n" \
          "Вы проделали огромную работу над собой. Что бы вы хотели сделать дальше?",
    reply_markup: TelegramMarkupHelper.day_10_completion_options_markup
  )
end

def complete_day_10
  save_current_progress
  @user.set_self_help_step('program_completed')
  @user.clear_self_help_program
  
  send_message(
    text: "🎉 **Программа полностью завершена!** 🎉\n\n" \
          "Вы прошли 10-дневный путь самопомощи. Все инструменты теперь в вашем распоряжении:\n\n" \
          "• Дневник эмоций\n" \
          "• Дневник благодарности\n" \
          "• Техники релаксации\n" \
          "• Работа с тревожными мыслями\n\n" \
          "Продолжайте практиковать и заботиться о себе!",
    reply_markup: TelegramMarkupHelper.main_menu_markup
  )
end

  # Отменяет инициацию программы (если пользователь сказал "Нет").
  def cancel_program_initiation
    save_current_progress
  @user.clear_self_help_program
  send_message(text: "Хорошо, мы можем начать в любой другой момент. Просто нажмите кнопку '⭐️ Программа самопомощи ⭐️' в главном меню.", reply_markup: TelegramMarkupHelper.main_menu_markup)
end

  # --- Запуск последовательности тестов ---

  def start_tests_sequence
    save_current_progress
    Rails.logger.debug "User #{@user.telegram_id} moving to start tests sequence."
    @user.set_self_help_step('taking_depression_test') # Более конкретный шаг
    send_message(text: "Отлично! Начнем с теста на депрессию.")
    QuizRunner.new(@bot_service, @user, @chat_id).start_quiz('depression') # Используем @bot_service
  end

  # Обработчик завершения теста на депрессию.
  def handle_test_completion(test_type)
    save_current_progress
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
    save_current_progress
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
    save_current_progress
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
    save_current_progress
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
    save_current_progress
  Rails.logger.debug "User #{@user.telegram_id} delivering Day 1 content. Current step: #{@user.get_self_help_step}."
  current_step = @user.get_self_help_step

  if current_step == 'day_1_intro'
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
  elsif current_step == 'day_1_content_delivered'
    send_message(
      text: "Вы остановились после прочтения вводного текста. Нажмите 'Продолжить', чтобы перейти к упражнению.",
      reply_markup: TelegramMarkupHelper.day_1_continue_markup
    )
  elsif current_step == 'day_1_exercise_in_progress'
    # Если упражнение уже начато, просто отправляем кнопку завершения
    send_message(
      text: "Вы сейчас выполняете упражнение на внимательное дыхание. Когда закончите, нажмите 'Я выполнил упражнение'.",
      reply_markup: TelegramMarkupHelper.day_1_exercise_completed_markup
    )
  else
    Rails.logger.warn "User #{@user.telegram_id} tried to deliver Day 1 content from unexpected state: #{current_step}."
    send_message(text: "Что-то пошло не так при попытке начать день 1. Напишите /start для начала заново.")
    @user.clear_self_help_program
  end
end

  # Запускает упражнение первого дня.
  def continue_day_1_content
    save_current_progress
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
    save_current_progress
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
    save_current_progress
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
    save_current_progress
  Rails.logger.debug "User #{@user.telegram_id} delivering Day 2 content. Current step: #{@user.get_self_help_step}."
  current_step = @user.get_self_help_step

  if current_step == 'awaiting_day_2_start'
    @user.set_self_help_step('day_2_intro_delivered') # Устанавливаем шаг, что интро доставлено
    message_text = "Добро пожаловать во второй день программы!\n\n**Тема дня: Научиться лучше чувствовать свое тело.**\n\n" \
                   "Сегодня мы сосредоточимся на развитии самосознания через собственные ощущения. " \
                   "Это поможет вам лучше понимать свои чувства, их причины и реакции."
    send_message(text: message_text, parse_mode: 'Markdown')
  end

  if ['day_2_intro_delivered', 'awaiting_day_2_start'].include?(@user.get_self_help_step)
    send_message(
      text: "Нажмите 'Начать медитацию', когда будете готовы к медитации 'Сканирование тела'.",
      reply_markup: TelegramMarkupHelper.day_2_start_exercise_markup
    )
  elsif current_step == 'day_2_exercise_in_progress'
    send_message(text: "Вы сейчас выполняете упражнение. Нажмите 'Я завершил(а) упражнение', когда закончите медитацию.",
                 reply_markup: TelegramMarkupHelper.day_2_exercise_completed_markup)
  else
    Rails.logger.warn "User #{@user.telegram_id} tried to deliver Day 2 content from unexpected state: #{current_step}."
    send_message(text: "Вы еще не завершили предыдущий день или что-то пошло не так. Напишите /start для начала заново.")
    @user.clear_self_help_program
  end
end

  def send_day_2_exercise_audio
    # Сохраняем прогресс перед началом отправки
    save_current_progress
    
    Rails.logger.debug "User #{@user.telegram_id} sending Day 2 exercise audio. Current step: #{@user.get_self_help_step}."
    
    # Проверяем, что пользователь на правильном шаге
    if @user.get_self_help_step != 'day_2_intro_delivered'
      Rails.logger.warn "User #{@user.telegram_id} tried to start Day 2 exercise from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Что-то пошло не так при запуске упражнения дня 2. Напишите /start для начала заново.")
      @user.clear_self_help_program
      return
    end

    # Определяем путь к аудиофайлу
    audio_file_path = Rails.root.join('public', 'assets', 'audio', 'body_scan.mp3')
    caption = "Медитация 'Сканирование тела'"

    # Пытаемся получить file_id из настроек (если уже загружали раньше)
    day2_audio_file_id = Setting.find_by(key: 'day2_exercise_audio_file_id')&.value

    success = false
    audio_to_send = nil

    # Определяем что отправлять: file_id или файл
    if day2_audio_file_id.present?
      Rails.logger.info "Sending day_2_exercise audio using file_id: #{day2_audio_file_id}"
      audio_to_send = day2_audio_file_id
    elsif File.exist?(audio_file_path)
      # Проверяем размер файла
      file_size_mb = File.size(audio_file_path).to_f / (1024 * 1024)
      Rails.logger.info "Uploading day_2_exercise audio. Path: #{audio_file_path}, Size: #{file_size_mb.round(2)} MB"

      if file_size_mb > 50
        Rails.logger.error "Audio file is too large (#{file_size_mb.round(2)} MB). Telegram limit is 50MB."
        send_message(text: "Произошла ошибка при отправке аудио: файл слишком большой.")
        # Предлагаем альтернативу
        offer_audio_alternative
        return
      end
      
      audio_to_send = File.open(audio_file_path)
    else
      Rails.logger.error "Audio file not found at specified path: #{audio_file_path}"
      # Файл не найден, предлагаем альтернативу
      offer_audio_alternative
      return
    end

    # Используем надежную отправку через RobustMessageSender
    if @message_sender && @message_sender.respond_to?(:send_audio_with_retry)
      success = @message_sender.send_audio_with_retry(
        audio: audio_to_send,
        caption: caption
      )
    else
      # Если RobustMessageSender еще не реализован, используем старый способ
      success = send_audio_directly(audio_to_send, caption)
    end

    if success
      # Обновляем шаг пользователя
      @user.set_self_help_step('day_2_exercise_in_progress')
      
      # Сохраняем file_id в настройки для будущего использования
      unless day2_audio_file_id.present?
        save_audio_file_id(audio_to_send)
      end
      
      # Отправляем инструкцию после аудио
      send_message(
        text: "Нажмите 'Я завершил(а) упражнение', когда закончите медитацию.",
        reply_markup: TelegramMarkupHelper.day_2_exercise_completed_markup
      )
    else
      # Если не удалось отправить аудио, предлагаем альтернативу
      offer_audio_alternative
    end
  end

  # Вспомогательный метод для прямой отправки аудио
  def send_audio_directly(audio, caption)
    begin
      @bot_service.bot.send_audio(
        chat_id: @chat_id,
        audio: audio,
        caption: caption
      )
      true
    rescue Telegram::Bot::Error => e
      Rails.logger.error "Error while uploading audio: #{e.message}"
      false
    rescue StandardError => e
      Rails.logger.error "General Error while sending audio: #{e.message}"
      false
    ensure
      # Закрываем файл если это был File.open
      audio.close if audio.is_a?(File)
    end
  end

  # Метод для предложения альтернативы если аудио не доступно
  def offer_audio_alternative
    send_message(
      text: "Не удалось загрузить аудио. Вы можете сделать упражнение без аудио:",
      save_progress: false
    )
    
    send_message(
      text: "**Медитация 'Сканирование тела' (альтернатива):**\n\n" \
            "1. Сядьте или лягте удобно\n" \
            "2. Закройте глаза, сделайте несколько глубоких вдохов\n" \
            "3. Мысленно пройдитесь по всем частям тела:\n" \
            "   - Начните с макушки головы\n" \
            "   - Лицо, шея, плечи\n" \
            "   - Руки, кисти, пальцы\n" \
            "   - Грудь, живот, спина\n" \
            "   - Ноги, стопы, пальцы ног\n" \
            "4. В каждой части замечайте ощущения (тепло, холод, напряжение, расслабление)\n" \
            "5. Не пытайтесь что-то изменить, просто наблюдайте\n" \
            "6. Уделите 10-15 минут\n\n" \
            "Когда закончите, нажмите кнопку ниже.",
      reply_markup: TelegramMarkupHelper.day_2_exercise_completed_markup,
      parse_mode: 'Markdown'
    )
    
    # Обновляем шаг пользователя даже без аудио
    @user.set_self_help_step('day_2_exercise_in_progress')
  end

  # Метод для сохранения file_id аудио (чтобы не загружать каждый раз)
  def save_audio_file_id(audio_file)
    # Этот метод можно реализовать позже
    # Для этого нужно получить file_id из ответа Telegram API
    Rails.logger.info "Audio file_id saving not implemented yet"
  end

  def handle_day_2_exercise_completion
    save_current_progress
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
    save_current_progress
  Rails.logger.debug "User #{@user.telegram_id} delivering Day 3 content. Current step: #{@user.get_self_help_step}."
  current_step = @user.get_self_help_step

  if current_step == 'awaiting_day_3_start'
    @user.set_self_help_step('day_3_intro')
    message_text = "Добро пожаловать в третий день программы!\n\n**Тема дня: Дневник благодарности.**\n\n" \
                   "Практика благодарности — это один из самых эффективных способов переключить фокус внимания с негатива на позитив. " \
                   "Это не значит игнорировать проблемы, а значит замечать хорошее, что уже есть в вашей жизни.\n\n" \
                   "Сегодня мы начнем вести дневник благодарности. Выберите действие:"
    send_message(text: message_text, reply_markup: TelegramMarkupHelper.day_3_menu_markup)
  elsif ['day_3_intro', 'day_3_waiting_for_gratitude', 'day_3_entry_saved'].include?(current_step)
    # Если пользователь уже в процессе, просто возвращаем его в меню дня 3
    send_message(text: "Вы вернулись в меню Дня 3. Выберите действие:", reply_markup: TelegramMarkupHelper.day_3_menu_markup)
  else
    Rails.logger.warn "User #{@user.telegram_id} tried to deliver Day 3 content from unexpected state: #{current_step}."
    send_message(text: "Произошла ошибка. Пожалуйста, начните программу заново.")
    @user.clear_self_help_program
  end
end

  # Запуск ввода новой благодарности
  def start_gratitude_entry
    save_current_progress
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
    save_current_progress
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
    save_current_progress
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
    save_current_progress
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
    save_current_progress
  Rails.logger.debug "User #{@user.telegram_id} delivering Day 4 content. Current step: #{@user.get_self_help_step}."
  current_step = @user.get_self_help_step

  if current_step == 'awaiting_day_4_start'
    @user.set_self_help_step('day_4_intro')
    message_text = "Добро пожаловать в четвертый день программы!\n\n**Тема дня: Регуляция дыхания.**\n\n" \
                   "Давай попробуем дыхательное упражнение 'Квадратное дыхание'. Это поможет успокоить нервную систему и снизить тревожность. " \
                   "Готовы?"
    send_message(text: message_text, reply_markup: TelegramMarkupHelper.day_4_exercise_consent_markup)
  elsif current_step == 'day_4_intro'
    send_message(text: "Вы вернулись в меню Дня 4. Готовы начать упражнение?", reply_markup: TelegramMarkupHelper.day_4_exercise_consent_markup)
  elsif current_step == 'day_4_exercise_in_progress'
    send_message(text: "Вы сейчас выполняете упражнение 'Квадратное дыхание'. Как только закончите, нажмите кнопку ниже.",
                 reply_markup: TelegramMarkupHelper.day_4_exercise_completed_markup)
  else
    Rails.logger.warn "User #{@user.telegram_id} tried to deliver Day 4 content from unexpected state: #{current_step}."
    send_message(text: "Произошла ошибка. Пожалуйста, начните программу заново.")
    @user.clear_self_help_program
  end
end

  def start_day_4_exercise
    save_current_progress
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
    save_current_progress
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
    save_current_progress
  Rails.logger.debug "User #{@user.telegram_id} delivering Day 5 content. Current step: #{@user.get_self_help_step}."
  current_step = @user.get_self_help_step

  if current_step == 'awaiting_day_5_start'
    @user.set_self_help_step('day_5_intro')
    message_text = "Добро пожаловать в пятый день программы!\n\n**Тема дня: Движение и настроение.**\n\n" \
                   "Сегодня предлагаю немного подвигаться. Физическая активность — отличный способ снизить уровень стресса и улучшить настроение.\n\n" \
                   "**Задание:** Выберите любую физическую активность, которая вам нравится (прогулка, танцы, йога, зарядка), и уделите ей 15-20 минут."
    send_message(text: message_text, parse_mode: 'Markdown')
  end

  if ['day_5_intro', 'awaiting_day_5_start'].include?(@user.get_self_help_step)
    send_message(
      text: "Нажмите 'Начать упражнение', чтобы получить инструкции по завершению дня.",
      reply_markup: TelegramMarkupHelper.start_day_5_exercise_markup
    )
  elsif current_step == 'day_5_exercise_in_progress'
    send_message(text: "Вы сейчас выполняете физическое упражнение. Когда закончите, нажмите кнопку ниже.",
                 reply_markup: TelegramMarkupHelper.day_5_exercise_completed_markup)
  else
    Rails.logger.warn "User #{@user.telegram_id} tried to deliver Day 5 content from unexpected state: #{current_step}."
    send_message(text: "Произошла ошибка. Пожалуйста, начните программу заново.")
    @user.clear_self_help_program
  end
end

  def start_day_5_exercise
    save_current_progress
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
    save_current_progress
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
    save_current_progress
  Rails.logger.debug "User #{@user.telegram_id} delivering Day 6 content. Current step: #{@user.get_self_help_step}."
  current_step = @user.get_self_help_step

  if current_step == 'awaiting_day_6_start'
    @user.set_self_help_step('day_6_intro')
    message_text = "Добро пожаловать в шестой день программы!\n\n**Тема дня: Забота о себе.**\n\n" \
                   "Сегодня просто отдохни и сделай что-то приятное для себя. Посмотри фильм, почитай книгу, послушай музыку, прими ванну. " \
                   "Цель — дать себе время восстановиться и насладиться моментом, не испытывая чувства вины."
    send_message(text: message_text, parse_mode: 'Markdown')
  end

  if current_step == 'day_6_intro' || current_step == 'awaiting_day_6_start'
    send_message(
      text: "Как только вы уделите себе время на отдых, нажмите 'Продолжить'.",
      reply_markup: TelegramMarkupHelper.day_6_exercise_completed_markup
    )
  else
    Rails.logger.warn "User #{@user.telegram_id} tried to deliver Day 6 content from unexpected state: #{current_step}."
    send_message(text: "Произошла ошибка. Пожалуйста, начните программу заново.")
    @user.clear_self_help_program
  end
end

  def handle_day_6_exercise_completion
    save_current_progress
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
    save_current_progress
  Rails.logger.debug "User #{@user.telegram_id} delivering Day 7 content. Current step: #{@user.get_self_help_step}."
  current_step = @user.get_self_help_step

  if current_step == 'awaiting_day_7_start'
    @user.set_self_help_step('day_7_waiting_for_reflection') # Устанавливаем шаг, что ожидаем рефлексию
  end

  if current_step == 'day_7_waiting_for_reflection' || current_step == 'awaiting_day_7_start'
    message_text = "Добро пожаловать в седьмой день программы!\n\n**Тема дня: Рефлексия недели.**\n\n" \
                   "Как прошла первая неделя? Что было самым сложным? Что помогло тебе почувствовать себя лучше? " \
                   "Напиши пару слов о своих впечатлениях в ответном сообщении. Это поможет тебе закрепить прогресс."
    send_message(text: message_text)
  elsif current_step == 'day_7_completed'
    send_message(text: "Вы уже завершили рефлексию. Готовы перейти к следующему дню?", reply_markup: TelegramMarkupHelper.complete_program_markup)
  else
    Rails.logger.warn "User #{@user.telegram_id} tried to deliver Day 7 content from unexpected state: #{current_step}."
    send_message(text: "Произошла ошибка. Пожалуйста, начните программу заново.")
    @user.clear_self_help_program
  end
end

  # Обработка введенной рефлексии (вызывается из MessageProcessor)
  # Принимает текст от пользователя.
  def handle_reflection_input(text)
    save_current_progress
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
    save_current_progress
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
    save_current_progress
  Rails.logger.debug "User #{@user.telegram_id} delivering Day 8 content. Current step: #{@user.get_self_help_step}."
  if @user.get_self_help_step == 'awaiting_day_8_start'
    @user.set_self_help_step('day_8_waiting_for_consent')
    message_text = "Добро пожаловать в восьмой день программы!\n\n**Тема дня: Техника 'Остановка мыслей'.**\n\n" \
                   "Сегодня попробуем очень полезную технику, которая поможет вам взять под контроль навязчивые, " \
                   "негативные или тревожные мысли. Она требует практики, но со временем может стать очень эффективной.\n\n" \
                   "**Готовы попробовать?**"
    send_message(
      text: message_text,
      parse_mode: 'Markdown',
      reply_markup: TelegramMarkupHelper.day_8_consent_markup
    )
  elsif @user.get_self_help_step == 'day_8_waiting_for_consent'
    send_message(text: "Вы вернулись в меню Дня 8. Готовы попробовать упражнение?", reply_markup: TelegramMarkupHelper.day_8_consent_markup)
  else
    Rails.logger.warn "User #{@user.telegram_id} tried to deliver Day 8 content from unexpected state: #{@user.get_self_help_step}."
    send_message(text: "Вы пытаетесь начать День 8 из неправильного состояния. Напишите /start, чтобы вернуться в главное меню и начать заново.")
    @user.clear_self_help_program
  end
end

  # Обрабатывает согласие/отказ пользователя начать упражнение Дня 8.
  def handle_day_8_consent(choice)
    save_current_progress
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
    save_current_progress
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
    save_current_progress
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
    save_current_progress
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
    save_current_progress
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
    save_current_progress
    Rails.logger.debug "User #{@user.telegram_id} completing Day 8 exercise. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_8_distraction_in_progress'
      @user.set_self_help_step('awaiting_day_9_start')

      message = "Отличная работа! Вы успешно попрактиковались в технике 'Остановка мыслей'.\n\n" \
                "**Важные напоминания:**\n" \
                "• После того, как вы остановили мысль, вернитесь к своим обычным делам. Если тревожные мысли снова возникнут, повторите упражнение.\n" \
                "• Если вам сложно сказать 'Стоп!' вслух, вы можете заменить это слово другим, которое имеет для вас сильное значение (например, 'Хватит!', 'Достаточно!').\n" \
                "• Вместо воображаемого пульта вы можете представить красный стоп-сигнал, стену, которая блокирует мысль, или любой другой образ.\n" \
                "• Не расстраивайтесь, если у вас не получится остановить мысль с первого раза. Эта техника требует практики. Продолжайте тренироваться, и со временем вы станете более успешными."
      send_message(text: message) # Убрал chat_id: @chat_id

      final_message = "Поздравляю с завершением восьмого дня программы! Продолжайте практиковать эту технику. До новых встреч!"
      send_message(text: "Хотите продолжить и поработать с тревожными мыслями (День 9)?", reply_markup: TelegramMarkupHelper.day_9_start_proposal_markup)
    else
      Rails.logger.warn "User #{@user.telegram_id} tried to complete Day 8 exercise from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Произошла ошибка. Пожалуйста, начните программу заново.")
      @user.clear_self_help_program
    end
  end

# --- ДЕНЬ 9: Работа с тревожной мыслью ---

  def deliver_day_9_content
    save_current_progress
    Rails.logger.debug "User #{@user.telegram_id} delivering Day 9 content. Current step: #{@user.get_self_help_step}."
    @user.set_self_help_step('day_9_intro')
    message_text = "Добро пожаловать в девятый день программы!\n\n" \
                  "**Тема дня: Работа с тревожной (тревожащей) мыслью.**\n\n" \
                  "Мы пройдем простой процесс анализа: определим мысль, оценим вероятность, посмотрим факты 'за' и 'против' и попробуем переформулировать мысль на более реалистичную."
    send_message(text: message_text, reply_markup: TelegramMarkupHelper.day_9_menu_markup)
  end

  # Запуск ввода тревожной мысли (вызывается из callback 'day_9_enter_thought')
  def start_day_9_thought_entry
    save_current_progress
    @user.set_self_help_step('day_9_waiting_for_thought')
    # очищаем предыдущие временные данные для дня 9
    @user.store_self_help_data('day_9_thought', nil)
    @user.store_self_help_data('day_9_probability', nil)
    @user.store_self_help_data('day_9_facts_pro', nil)
    @user.store_self_help_data('day_9_facts_con', nil)
    @user.store_self_help_data('day_9_reframe', nil)

    send_message(text: "Шаг 1: Определи свою тревожную мысль.\n\nПожалуйста, напиши мысль, которая вызывает у тебя тревогу. Просто отправь её одним сообщением.")
  end

  # Обработка введённой тревожной мысли (текст)
  def handle_day_9_thought_input(text)
  save_current_progress
  return send_message(text: "Пожалуйста, напиши мысль (не пустое сообщение).") if text.blank?
  
  # Проверяем, что это текст, а не только цифры
  if text =~ /\A\d+\z/  # Если строка состоит только из цифр
    send_message(text: "Пожалуйста, опиши мысль словами, а не только цифрами.")
    return true
  end
  
  # Проверяем минимальную длину
  if text.strip.length < 3
    send_message(text: "Мысль должна содержать хотя бы 3 символа. Попробуй описать подробнее.")
    return true
  end
  
  @user.store_self_help_data('day_9_thought', text)
  @user.set_self_help_step('day_9_waiting_for_probability')
  send_message(text: "Спасибо, что поделился(лась). Теперь давай оценим вероятность.\n\nШаг 2: Насколько вероятно, что это произойдет? Оцени по шкале от 1 до 10.")
  true
end

  # Обработка вероятности (ожидаем число 1..10)
  def handle_day_9_probability_input(text)
    save_current_progress
    # пытаемся спарсить число
    num = text.to_s.strip.to_i
    if num < 1 || num > 10
      send_message(text: "Пожалуйста, введи число от 1 до 10, где 1 — совсем не вероятно, а 10 — очень вероятно.")
      return true
    end

    @user.store_self_help_data('day_9_probability', num)
    @user.set_self_help_step('day_9_waiting_for_facts_pro')

    send_message(text: "Хорошо, ты оценил(а) вероятность как #{num}.\n\nШаг 3: Факты. Ответь на два вопроса по очереди.\n\n1) Какие факты подтверждают эту мысль? Напиши в одном сообщении.")
    true
  end

  # Обработка фактов, которые подтверждают мысль
  def handle_day_9_facts_pro_input(text)
  save_current_progress
  return send_message(text: "Пожалуйста, опиши факты, которые подтверждают мысль. Если их нет — просто напиши 'нет'.") if text.blank?
  
  # Проверяем, что это не только цифры
  if text =~ /\A\d+\z/  # Если строка состоит только из цифр
    send_message(text: "Пожалуйста, опиши факты словами. Например: 'Я уже сталкивался с подобной ситуацией раньше'.")
    return true
  end
  
  @user.store_self_help_data('day_9_facts_pro', text)
  @user.set_self_help_step('day_9_waiting_for_facts_con')
  send_message(text: "2) Есть ли факты, которые опровергают эту мысль? Напиши их (или 'нет', если таких фактов нет).")
  true
end

  # Обработка фактов, которые опровергают мысль
  def handle_day_9_facts_con_input(text)
  save_current_progress
  return send_message(text: "Пожалуйста, опиши факты, которые опровергают мысль, или напиши 'нет'.") if text.blank?
  
  # Проверяем, что это не только цифры
  if text =~ /\A\d+\z/  # Если строка состоит только из цифр
    send_message(text: "Пожалуйста, опиши факты словами. Например: 'У меня есть друзья, которые мне помогут'.")
    return true
  end
  
  @user.store_self_help_data('day_9_facts_con', text)
  @user.set_self_help_step('day_9_waiting_for_reframe')
  
  # Получаем все данные для промежуточного отчета
  thought = @user.get_self_help_data('day_9_thought')
  probability = @user.get_self_help_data('day_9_probability')
  facts_pro = @user.get_self_help_data('day_9_facts_pro')
  facts_con = @user.get_self_help_data('day_9_facts_con')
  
  send_message(text: "Отлично! У нас теперь есть:\n\n" \
                    "— Твоя мысль: #{thought}\n" \
                    "— Оценка вероятности: #{probability}\n" \
                    "— Факты, подтверждающие: #{facts_pro}\n" \
                    "— Факты, опровергающие: #{facts_con}\n\n" \
                    "Шаг 4: Переосмысление.\n" \
                    "Как бы ты мог(ла) переформулировать свою тревожную мысль так, чтобы она звучала менее пугающе и более реалистично?\n\n" \
                    "Например: 'Это сложно, но я могу справляться по шагам.'")
  true
end

  def handle_day_9_reframe_input(text)
  save_current_progress
  return send_message(text: "Пожалуйста, попробуй написать переформулировку в одно-два предложения.") if text.blank?
  
  # Проверяем, что это текст, а не только цифры
  if text =~ /\A\d+\z/  # Если строка состоит только из цифр
    send_message(text: "Переформулировка должна быть в виде предложения. Например: 'Я справлюсь с этим шаг за шагом'.")
    return true
  end
  
  # Проверяем минимальную длину
  if text.strip.length < 3
    send_message(text: "Переформулировка должна содержать хотя бы 3 символа. Попробуй сформулировать полнее.")
    return true
  end
  
  # Получаем данные
  thought = @user.get_self_help_data('day_9_thought')
  probability = @user.get_self_help_data('day_9_probability')
  facts_pro = @user.get_self_help_data('day_9_facts_pro')
  facts_con = @user.get_self_help_data('day_9_facts_con')
  
  # Дополнительная проверка на случай, если где-то данные потерялись
  if thought.blank?
    send_message(text: "Кажется, данные о твоей мысли потерялись. Давай начнем день 9 заново.")
    return start_day_9_thought_entry
  end
  
  begin
    entry = AnxiousThoughtEntry.create!(
      user: @user,
      entry_date: Date.current,
      thought: thought,
      probability: probability.to_i,
      facts_pro: facts_pro,
      facts_con: facts_con,
      reframe: text
    )
    
    # Очищаем временные данные
    ['day_9_thought', 'day_9_probability', 'day_9_facts_pro', 'day_9_facts_con', 'day_9_reframe'].each do |key|
      @user.store_self_help_data(key, nil)
    end
    
    @user.set_self_help_step('day_9_completed')
    
    summary = "🎉 **Отличная работа! Ты проделал(а) важный анализ.**\n\n"
    summary += "**Сводка твоего анализа:**\n"
    summary += "• **Тревожная мысль:** #{thought.truncate(100)}\n"
    summary += "• **Вероятность (от 1 до 10):** #{probability}\n"
    summary += "• **Факты 'за':** #{facts_pro.truncate(80)}\n"
    summary += "• **Факты 'против':** #{facts_con.truncate(80)}\n"
    summary += "• **Переформулировка:** #{text.truncate(150)}\n\n"
    summary += "Эта запись сохранена в твоем дневнике. Ты можешь вернуться к ней в любой момент!"
    
    send_message(text: summary, parse_mode: 'Markdown')
    send_message(text: "Что дальше?", reply_markup: TelegramMarkupHelper.day_9_menu_markup)
    
    true
    
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to save AnxiousThoughtEntry: #{e.message}"
    send_message(text: "Произошла ошибка при сохранении: #{e.record.errors.full_messages.join(', ')}. Попробуй еще раз.")
    false
  end
end

  # Показать текущий прогресс дня 9 (если пользователь хочет посмотреть промежуточные ответы)
  def show_day_9_current_progress
    save_current_progress
    # Показываем текущие НЕСОХРАНЕННЫЕ данные из self_help_program_data
    thought = @user.get_self_help_data('day_9_thought')
    prob = @user.get_self_help_data('day_9_probability')
    pro = @user.get_self_help_data('day_9_facts_pro')
    con = @user.get_self_help_data('day_9_facts_con')
    reframe = @user.get_self_help_data('day_9_reframe')
    
    message = "📝 **Текущий прогресс по Дню 9:**\n\n"
    
    if thought.present?
      message += "• **Мысль:** #{thought.truncate(100)}\n"
      message += "• **Вероятность:** #{prob || '—'}\n"
      message += "• **Факты 'за':** #{pro || '—'}\n"
      message += "• **Факты 'против':** #{con || '—'}\n"
      message += "• **Переформулировка:** #{reframe || '—'}\n\n"
      
      if reframe.blank?
        message += "Ты почти закончил(а)! Осталось только сделать переформулировку.\n"
      else
        message += "Все готово! Нажми 'Завершить День 9', чтобы сохранить запись.\n"
      end
    else
      message += "Ты еще не начал(а) работу над тревожной мыслью.\n"
    end
    
    # Показываем последние СОХРАНЕННЫЕ записи
    saved_entries = @user.anxious_thought_entries.recent.limit(3)
    
    if saved_entries.any?
      message += "\n---\n"
      message += "📚 **Твои последние сохраненные записи:**\n"
      saved_entries.each_with_index do |entry, index|
        message += "#{index + 1}. *#{entry.entry_date.strftime('%d.%m.%Y')}*: "
        message += "#{entry.thought.truncate(50)}\n"
      end
    end
    
    send_message(text: message, parse_mode: 'Markdown', reply_markup: TelegramMarkupHelper.day_9_menu_markup)
  end

  def show_all_anxious_thought_entries
    save_current_progress
    entries = @user.anxious_thought_entries.recent
    
    if entries.empty?
      send_message(text: "У тебя пока нет сохраненных записей о тревожных мыслях.")
      return
    end
    
    # Показываем по 3 записи за раз
    entries.each_slice(3).with_index do |batch, batch_index|
      message = "📖 **Твои записи (часть #{batch_index + 1}):**\n\n"
      
      batch.each_with_index do |entry, index|
        message += "**#{batch_index * 3 + index + 1}. #{entry.entry_date.strftime('%d.%m.%Y')}**\n"
        message += "💭 *Мысль:* #{entry.thought.truncate(80)}\n"
        message += "📊 *Вероятность:* #{entry.probability}/10\n"
        message += "✅ *Факты 'за':* #{entry.facts_pro.truncate(60)}\n"
        message += "❌ *Факты 'против':* #{entry.facts_con.truncate(60)}\n"
        message += "🔄 *Переформулировка:* #{entry.reframe.truncate(80)}\n"
        message += "---\n"
      end
      
      send_message(text: message, parse_mode: 'Markdown')
    end
    
    send_message(text: "Всего записей: #{entries.count}", reply_markup: TelegramMarkupHelper.day_9_menu_markup)
  end

  # Завершение дня, если пользователь нажал кнопку "Завершить"
  def complete_day_9
  save_current_progress
  if @user.get_self_help_step == 'day_9_completed'
    # НОВОЕ: Предлагаем День 10
    @user.set_self_help_step('awaiting_day_10_start')
    send_message(
      text: "Отлично! День 9 завершен. Хотите перейти к последнему, 10-му дню программы?",
      reply_markup: TelegramMarkupHelper.day_10_start_proposal_markup
    )
  else
    send_message(text: "Похоже, вы еще не завершили шаги Дня 9.")
  end
end


  def handle_day_8_skip
    save_current_progress
    Rails.logger.debug "User #{@user.telegram_id} declined Day 8 exercise. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_8_waiting_for_consent'
      deliver_day_8_content
      send_message(text: "Хорошо, мы можем попробовать эту технику позже. Возвращайтесь в главное меню.", reply_markup: TelegramMarkupHelper.main_menu_markup)
    else
      Rails.logger.warn "User #{@user.telegram_id} declined Day 8 from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Ошибка состояния. Начните /start.")
    end
  end

  def handle_day_4_skip
    save_current_progress
    Rails.logger.debug "User #{@user.telegram_id} declined Day 4 exercise. Current step: #{@user.get_self_help_step}."
    if @user.get_self_help_step == 'day_4_intro'
      deliver_day_4_content
      send_message(text: "Хорошо, мы можем вернуться к упражнению позже. Нажмите /start, чтобы вернуться в главное меню.")
    else
      Rails.logger.warn "User #{@user.telegram_id} declined Day 4 from unexpected state: #{@user.get_self_help_step}."
      send_message(text: "Пожалуйста, вернитесь в главное меню, нажав /start.")
    end
  end

  def clear_and_restart_program
    save_current_progress
    @user.clear_self_help_program
    
    # Отправляем подтверждение сброса
    send_message(text: "Ваш прогресс в программе самопомощи был сброшен. Начинаем заново!")
    
    # Запускаем обычную инициацию, которая теперь увидит, что шаг пуст
    start_program_initiation
  end

  def handle_complete_program_final
    save_current_progress
    Rails.logger.debug "User #{@user.telegram_id} is completing the entire program. Current step: #{@user.get_self_help_step}."
    # Предполагается, что это финальное действие после Дня 8.
    @user.clear_self_help_program # Очищаем состояние программы
    send_message(
      text: "Программа полностью завершена! Вы молодец! Вы можете вернуться к материалам в любое время. Продолжайте использовать дневник благодарности и другие инструменты.", # Убрал chat_id: @chat_id
      reply_markup: TelegramMarkupHelper.main_menu_markup # Возвращаем в главное меню
    )
  end

    # Метод восстановления сессии
  def resume_from_last_step
    progress = @user.current_progress
    
    return unless progress[:step]
    
    Rails.logger.info "Resuming user #{@user.id} from step: #{progress[:step]}"
    
    case progress[:step]
    when 'day_1_intro', 'day_1_content_delivered', 'day_1_exercise_in_progress'
      deliver_day_1_content
    when 'day_2_intro_delivered', 'day_2_exercise_in_progress'
      deliver_day_2_content
    when 'day_3_intro', 'day_3_waiting_for_gratitude', 'day_3_entry_saved'
      deliver_day_3_content
    when 'day_4_intro', 'day_4_exercise_in_progress'
      deliver_day_4_content
    when 'day_5_intro', 'day_5_exercise_in_progress'
      deliver_day_5_content
    when 'day_6_intro'
      deliver_day_6_content
    when 'day_7_waiting_for_reflection'
      deliver_day_7_content
    when 'day_8_waiting_for_consent', 'day_8_first_try', 'day_8_second_try', 
        'day_8_choosing_distraction', 'day_8_distraction_in_progress'
      deliver_day_8_content
    when 'day_9_intro', 'day_9_waiting_for_thought', 'day_9_waiting_for_probability',
        'day_9_waiting_for_facts_pro', 'day_9_waiting_for_facts_con', 'day_9_waiting_for_reframe'
      deliver_day_9_content
      
      # Восстанавливаем конкретный шаг дня 9
      if @user.get_self_help_data('day_9_thought').present?
        thought = @user.get_self_help_data('day_9_thought')
        send_message(text: "Восстанавливаю вашу работу...")
        send_message(text: "Ваша тревожная мысль: #{thought}")
        
        if @user.get_self_help_step == 'day_9_waiting_for_probability'
          send_message(text: "Пожалуйста, оцените вероятность от 1 до 10:")
        elsif @user.get_self_help_step == 'day_9_waiting_for_facts_pro'
          send_message(text: "Какие факты подтверждают эту мысль?")
        # ... и так далее для всех шагов
        end
      end
      
    else
      # Если непонятное состояние, возвращаем в главное меню
      send_message(text: "Добро пожаловать обратно! Что бы вы хотели сделать?", 
                  reply_markup: TelegramMarkupHelper.main_menu_markup)
    end
    
    # Обрабатываем очередь неотправленных сообщений
    @message_sender.process_message_queue
  end

  private

  # --- Вспомогательные методы ---

  # Этот метод принимает только text, reply_markup, parse_mode
  # и использует @chat_id, который уже известен из инициализатора класса.
  def send_message(text:, reply_markup: nil, parse_mode: nil, save_progress: true)
    # Отправляем с повторными попытками
    success = @message_sender.send_with_retry(
      text: text,
      reply_markup: reply_markup,
      parse_mode: parse_mode
    )
    
    # Сохраняем прогресс если нужно
    if success && save_progress
      save_current_progress
    end
    
    success
  end
  
  # Метод для сохранения прогресса
  def save_current_progress
    current_step = @user.get_self_help_step
    
    # Сохраняем в сессию
    @user.update_session_progress(
      current_step,
      {
        day_9_thought: @user.get_self_help_data('day_9_thought'),
        day_9_probability: @user.get_self_help_data('day_9_probability'),
        # ... другие важные данные
      }
    )
    
    # Также обрабатываем очередь сообщений
    @message_sender.process_message_queue
  end
end
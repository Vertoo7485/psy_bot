
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
    @bot.send_message(
      chat_id: @chat_id, 
      text: "Поздравляю! Вы завершили третий день программы. Отдохните и возвращайтесь для продолжения!", 
      reply_markup: day_4_intro_markup # <-- Предлагаем День 4
    )
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

  def deliver_day_4_content
    @user.set_self_help_step('day_4_intro')
    message_text = "Добро пожаловать в четвертый день программы!\n\nТема дня: Регуляция дыхания.\n\n" \
                   "Давай попробуем дыхательное упражнение 'Квадратное дыхание'. Это поможет успокоить нервную систему и снизить тревожность. " \
                   "Готовы?"

    @bot.send_message(
      chat_id: @chat_id, 
      text: message_text, 
      reply_markup: day_4_exercise_consent_markup
    )
  end

  def start_day_4_exercise
    @user.set_self_help_step('day_4_exercise_in_progress')
    
    # Отправляем инструкции по частям
    @bot.send_message(chat_id: @chat_id, text: "Отлично! Найдите удобное положение сидя или лежа. Закройте глаза, если вам это комфортно.")
    @bot.send_message(chat_id: @chat_id, text: "Представьте себе квадрат. Каждая сторона квадрата – это фаза дыхания.")
    
    # Полное описание упражнения
    exercise_text = 
      "**Упражнение 'Квадратное дыхание' (4-4-4-4):**\n\n" \
      "1. **Вдох (4 секунды):** Медленно и глубоко вдохните через нос, считая до 4.\n" \
      "2. **Задержка (4 секунды):** Задержите дыхание на 4 секунды.\n" \
      "3. **Выдох (4 секунды):** Медленно и плавно выдохните через рот, считая до 4.\n" \
      "4. **Задержка (4 секунды):** Задержите дыхание на 4 секунды.\n\n" \
      "Продолжайте этот цикл в течение 4-5 минут. Сосредоточьтесь на счете и ощущениях."
      
    @bot.send_message(chat_id: @chat_id, text: exercise_text, parse_mode: 'Markdown')
    
    @bot.send_message(
      chat_id: @chat_id, 
      text: "Как только закончите, нажмите кнопку ниже.",
      reply_markup: day_4_exercise_completed_markup
    )
  end

  def handle_day_4_exercise_completion
    @user.set_self_help_step('day_4_completed')
    @bot.send_message(
      chat_id: @chat_id,
      text: "Прекрасно! Вы завершили упражнение. Как вы себя чувствуете? Надеюсь, более спокойно и расслабленно. На сегодня всё!",
      reply_markup: day_5_intro_markup # <-- Предлагаем День 5
    )
  end

  # --- ДЕНЬ 5: Физическая активность ---

  def deliver_day_5_content
    @user.set_self_help_step('day_5_intro')
    message_text = "Добро пожаловать в пятый день программы!\n\nТема дня: Движение и настроение.\n\n" \
                   "Сегодня предлагаю немного подвигаться. Физическая активность — отличный способ снизить уровень стресса и улучшить настроение.\n\n" \
                   "**Задание:** Выберите любую физическую активность, которая вам нравится (прогулка, танцы, йога, зарядка), и уделите ей 15-20 минут."

    @bot.send_message(
      chat_id: @chat_id,
      text: message_text,
      reply_markup: { inline_keyboard: [[{ text: "Я выполнил(а) задание", callback_data: 'day_5_exercise_completed' }]] }.to_json
    )
  end

  def handle_day_5_exercise_completion
    @user.set_self_help_step('day_5_completed')
    @bot.send_message(
      chat_id: @chat_id,
      text: "Отлично! Вы позаботились о своем теле. Это очень важный шаг к улучшению самочувствия. На сегодня всё!",
      reply_markup: day_6_intro_markup # <-- Предлагаем День 6
    )
  end

  # --- ДЕНЬ 6: Отдых и удовольствие ---

  def deliver_day_6_content
    @user.set_self_help_step('day_6_intro')
    message_text = "Добро пожаловать в шестой день программы!\n\nТема дня: Забота о себе.\n\n" \
                   "Сегодня просто отдохни и сделай что-то приятное для себя. Посмотри фильм, почитай книгу, послушай музыку, прими ванну. " \
                   "Цель — дать себе время восстановиться и насладиться моментом, не испытывая чувства вины."

    @bot.send_message(
      chat_id: @chat_id,
      text: message_text,
      reply_markup: { inline_keyboard: [[{ text: "Я уделил(а) время себе", callback_data: 'day_6_exercise_completed' }]] }.to_json
    )
  end

  def handle_day_6_exercise_completion
    @user.set_self_help_step('day_6_completed')
    @bot.send_message(
      chat_id: @chat_id,
      text: "Надеюсь, вы хорошо отдохнули! Забота о себе — это не роскошь, а необходимость. Завтра последний день первой недели программы.",
      reply_markup: day_7_intro_markup # <-- Предлагаем День 7
    )
  end

  # --- ДЕНЬ 7: Рефлексия и завершение недели ---

  def deliver_day_7_content
    @user.set_self_help_step('day_7_waiting_for_reflection')
    message_text = "Добро пожаловать в седьмой день программы!\n\nТема дня: Рефлексия недели.\n\n" \
                   "Как прошла первая неделя? Что было самым сложным? Что помогло тебе почувствовать себя лучше? " \
                   "Напиши пару слов о своих впечатлениях в ответном сообщении. Это поможет тебе закрепить прогресс."

    @bot.send_message(chat_id: @chat_id, text: message_text)
  end

 def handle_reflection_input(text)
    # 1. Сохраняем запись
    ReflectionEntry.create!(
      user: @user,
      entry_date: Date.current,
      entry_text: text
    )

    # 2. Обновляем шаг пользователя
    @user.set_self_help_step('day_7_completed')

    # 3. Отправляем подтверждение и предложение завершить неделю
    @bot.send_message(
      chat_id: @chat_id,
      text: "Спасибо за твою искренность! Ты успешно завершил первую неделю программы самопомощи. Поздравляю!",
      reply_markup: complete_program_markup # <-- Используем эту разметку
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Ошибка при сохранении рефлексии: #{e.message}"
    @bot.send_message(chat_id: @chat_id, text: "Произошла ошибка при сохранении записи. Пожалуйста, попробуйте еще раз.")
  end

  # НОВЫЙ МЕТОД: предложение Дня 8 (вызывается из CallbackQueryProcessor#handle_complete_day_7)
  def propose_day_8
    @user.set_self_help_step('day_8_intro') # Устанавливаем шаг для начала Дня 8
    @bot.send_message(
      chat_id: @chat_id,
      text: "Поздравляю с завершением первой недели! Готовы начать вторую? Сегодня мы освоим новую технику.",
      reply_markup: day_8_intro_markup # <-- Предлагаем кнопку для начала Дня 8
    )
  end

  # МЕТОД complete_program теперь будет вызываться в самом конце программы
  # или может быть удален, если у вас всего 8 дней.
  # Если это *последний* день в программе, то handle_day_8_exercise_completion
  # должен будет вызывать этот complete_program или final_program_completion_markup.
  def complete_program
    @user.set_self_help_step('program_completed')
    @bot.send_message(
      chat_id: @chat_id,
      text: "Программа полностью завершена! Вы можете вернуться к ней в любое время. Продолжайте использовать дневник благодарности и другие инструменты.",
      reply_markup: back_to_main_menu_markup
    )
    # Здесь можно добавить логику очистки clear_self_help_program
    # @user.clear_self_help_program
  end

  # --- НЕДЕЛЯ 2 ---

  # --- ДЕНЬ 8: Техника 'Остановка мыслей' ---

  def deliver_day_8_intro
    @user.set_self_help_step('day_8_waiting_for_consent')
    message_text = "Добро пожаловать в восьмой день программы!\n\nТема дня: **Техника 'Остановка мыслей'**.\n\n" \
                   "Сегодня попробуем очень полезную технику, которая поможет вам взять под контроль навязчивые, " \
                   "негативные или тревожные мысли. Она требует практики, но со временем может стать очень эффективной.\n\n" \
                   "**Готовы попробовать?**"

    @bot.send_message(
      chat_id: @chat_id,
      text: message_text,
      parse_mode: 'Markdown',
      reply_markup: day_8_consent_markup # Кнопки "Да/Нет" для согласия
    )
  end

  def start_day_8_exercise_instructions
    @user.set_self_help_step('day_8_thought_stopping_instructions')

    @bot.send_message(chat_id: @chat_id, text: "Отлично! Давай начнем.\n\n" \
                                                "1. Представьте, что у вас есть **пульт дистанционного управления** для вашего мозга. " \
                                                "С помощью этого пульта вы можете 'включать' и 'выключать' различные мысли.\n\n" \
                                                "2. Сейчас я попрошу вас вспомнить мысль, которая часто вызывает у вас беспокойство или дискомфорт. " \
                                                "Это может быть что угодно: страх, сомнение, негативное воспоминание. " \
                                                "**Не погружайтесь в эту мысль слишком глубоко, просто осознайте ее.**")

    # Небольшая пауза перед следующим сообщением, чтобы пользователь успел прочитать
    sleep(1) # Это пауза в выполнении кода, а не задержка в отправке сообщения Telegram. Telegram не ждет.
             # Для симуляции паузы мы используем последовательные сообщения с кнопками.

    @bot.send_message(chat_id: @chat_id, text: "3. Как только вы осознали эту мысль, представьте, что вы нажимаете большую красную кнопку 'Стоп' на вашем воображаемом пульте дистанционного управления. " \
                                                "В этот момент вы должны сказать себе (мысленно или вслух) слово **'СТОП!'**.\n\n" \
                                                "**Сделайте это сейчас: Вспомните свою мысль... СТОП!**")

    @user.set_self_help_step('day_8_first_try')
    @bot.send_message(
      chat_id: @chat_id,
      text: "Когда будете готовы продолжить, нажмите кнопку:",
      reply_markup: day_8_stopped_thought_first_try_markup # Кнопка для продолжения
    )
  end

  def continue_day_8_second_try
    @user.set_self_help_step('day_8_second_try')
    @bot.send_message(chat_id: @chat_id, text: "Что произошло? Получилось ли у вас остановить мысль? Если нет, попробуйте еще раз. " \
                                                "**Вспомните свою мысль... СТОП!**\n\n" \
                                                "После того, как вы остановили мысль, важно переключить свое внимание на что-то другое. " \
                                                "Это ключевой момент техники.")

    @bot.send_message(
      chat_id: @chat_id,
      text: "Когда будете готовы выбрать отвлечение, нажмите кнопку:",
      reply_markup: day_8_ready_for_distraction_markup # Кнопка для выбора отвлечения
    )
  end

  def ask_for_distraction_choice
    @user.set_self_help_step('day_8_choosing_distraction')
    message_text = "Выберите что-то, что вам нравится и что может вас отвлечь на 5-10 минут:"

    @bot.send_message(
      chat_id: @chat_id,
      text: message_text,
      reply_markup: day_8_distraction_options_markup # Кнопки с вариантами отвлечения
    )
  end

  def guide_distraction(distraction_type)
    @user.set_self_help_step('day_8_distraction_in_progress')

    distraction_message = case distraction_type
                          when 'music' then "Отличный выбор! Включите любимую музыку."
                          when 'video' then "Хорошо! Посмотрите короткое интересное видео."
                          when 'friend' then "Прекрасно! Поговорите с другом или близким человеком."
                          when 'exercise' then "Отлично! Сделайте несколько легких физических упражнений или разомнитесь."
                          when 'book' then "Замечательно! Почитайте интересную книгу или статью."
                          else "Вы выбрали отличное занятие!"
                          end

    @bot.send_message(chat_id: @chat_id, text: "#{distraction_message}\n\n" \
                                                "Сосредоточьтесь на выбранном занятии в течение **5-10 минут**. " \
                                                "Позвольте себе полностью погрузиться в этот процесс и отвлечься от негативных мыслей.")

    @bot.send_message(
      chat_id: @chat_id,
      text: "Как только закончите выбранное занятие, нажмите кнопку ниже:",
      reply_markup: day_8_exercise_completed_markup # Кнопка для завершения упражнения
    )
  end

  def handle_day_8_exercise_completion
    @user.set_self_help_step('day_8_completed')

    @bot.send_message(chat_id: @chat_id, text: "Отличная работа! Вы успешно попрактиковались в технике 'Остановка мыслей'.\n\n" \
                                                "**Важные напоминания:**\n" \
                                                "• После того, как вы остановили мысль, вернитесь к своим обычным делам. Если тревожные мысли снова возникнут, повторите упражнение.\n" \
                                                "• Если вам сложно сказать 'Стоп!' вслух, вы можете заменить это слово другим, которое имеет для вас сильное значение (например, 'Хватит!', 'Достаточно!').\n" \
                                                "• Вместо воображаемого пульта вы можете представить красный стоп-сигнал, стену, которая блокирует мысль, или любой другой образ.\n" \
                                                "• Не расстраивайтесь, если у вас не получится остановить мысль с первого раза. Эта техника требует практики. Продолжайте тренироваться, и со временем вы станете более успешными.")

    @bot.send_message(
      chat_id: @chat_id,
      text: "Поздравляю с завершением восьмого дня программы! Продолжайте практиковать эту технику. До новых встреч!",
      reply_markup: back_to_main_menu_markup # Возвращаемся в главное меню после завершения
    )
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
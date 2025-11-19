
# app/services/telegram/callback_query_processor.rb
module Telegram
  class CallbackQueryProcessor
    include TelegramMarkupHelper # Для генерации клавиатур

    def initialize(bot_service, user, callback_query_data) # Добавил bot_service как аргумент
      @bot_service = bot_service # Сохраняем TelegramBotService
      @bot = bot_service.bot # Получаем сам объект бота
      @user = user
      @callback_query_data = callback_query_data
      @chat_id = callback_query_data.dig(:message, :chat, :id)
      @message_id = callback_query_data.dig(:message, :message_id)
      @callback_data = callback_query_data[:data]
    end

    def process
      Rails.logger.info "Received callback_query: #{@callback_data} for user #{ @user.telegram_id }"
      case @callback_data
      when 'show_test_categories' then handle_show_test_categories
      when /^prepare_(anxiety|depression|eq|luscher)_test$/ then handle_prepare_test($1)
      when /^start_(anxiety|depression|eq)_test$/ then handle_start_standard_test($1)
      when 'start_luscher_test' then handle_start_luscher_test
      when 'show_luscher_interpretation' then handle_show_luscher_interpretation
      when /^luscher_color_([a-z_]+)_(\d+)$/ # <-- ИЗМЕНЕНО: [a-z_]+ вместо \w+ для учета подчеркиваний
        color_code = $1
        test_result_id = $2.to_i
        # Теперь вызываем LuscherTestService с полным @callback_data
        LuscherTestService.new(@bot_service, @user, @chat_id).process_choice(@callback_data)
      when /^answer_(\d+)_(\d+)_(\d+)$/ then handle_quiz_answer($1.to_i, $2.to_i, $3.to_i)
      when 'start_emotion_diary' then handle_start_emotion_diary
      when 'new_emotion_diary_entry' then handle_new_emotion_diary_entry
      when 'show_emotion_diary_entries' then handle_show_emotion_diary_entries
      when 'back_to_main_menu' then handle_back_to_main_menu
      when /^answer_(\d+)_(\d+)_(\d+)$/ then handle_quiz_answer($1.to_i, $2.to_i, $3.to_i)

      # --- Обработка программы самопомощи ---
      # Логика программы самопомощи делегируется SelfHelpService.
      # Все callback_data, связанные с программой, будут обрабатываться там.
      when 'start_self_help_program' then handle_start_self_help_program_intro
      when 'start_self_help_program_tests' then handle_start_self_help_program_tests
      when 'yes' then handle_yes_response
      when 'no' then handle_no_response
      when 'test_completed_depression' then handle_test_completed_depression
      when 'start_anxiety_test_from_sequence' then handle_start_anxiety_test_from_sequence
      when 'test_completed_anxiety' then handle_test_completed_anxiety
      when 'no_anxiety_test_sequence' then handle_no_anxiety_test_sequence
      when 'start_day_1_content' then handle_start_day_1_content
      when 'start_day_2_from_proposal' then handle_start_day_2_from_proposal
      when 'start_day_3_from_proposal' then handle_start_day_3_from_proposal
      when 'start_day_4_from_proposal' then handle_start_day_4_from_proposal
      when 'start_day_5_from_proposal' then handle_start_day_5_from_proposal
      when 'start_day_5_exercise' then handle_start_day_5_exercise # <--- Эту строку ДОБАВИТЬ
      when 'day_5_exercise_completed' then handle_day_5_exercise_completed
      when 'start_day_6_from_proposal' then handle_start_day_6_from_proposal
      when 'day_6_exercise_completed' then handle_day_6_exercise_completed
      when 'start_day_7_from_proposal' then handle_start_day_7_from_proposal
      when 'complete_day_7' then handle_complete_day_7
      when 'start_day_8_from_proposal' then handle_start_day_8_from_proposal
      when 'continue_day_1_content' then handle_continue_day_1_content
      when 'complete_day_1' then handle_complete_day_1
      when 'day_1_exercise_completed' then handle_day_1_exercise_completed
      when 'start_day_2_content' then handle_start_day_2_content
      when 'start_day_2_exercise_audio' then handle_start_day_2_exercise_audio
      when 'day_2_exercise_completed' then handle_day_2_exercise_completion
      when 'start_day_3_content' then handle_start_day_3_content
      when 'day_3_enter_gratitude' then handle_start_gratitude_entry # Новый callback_data
      when 'show_gratitude_entries' then handle_show_gratitude_entries # Новый callback_data
      when 'complete_day_3' then handle_complete_day_3
      when 'start_day_4_content' then handle_start_day_4_content
      when 'start_day_4_exercise' then handle_start_day_4_exercise
      when 'day_4_exercise_completed' then handle_day_4_exercise_completed
      when 'start_day_5_content' then handle_start_day_5_content
      when 'day_5_exercise_completed' then handle_day_5_exercise_completion
      when 'start_day_6_content' then handle_start_day_6_content
      when 'day_6_exercise_completed' then handle_day_6_exercise_completed
      when 'start_day_7_content' then handle_start_day_7_content
      when 'complete_day_7' then handle_complete_day_7 # Перенаправляем на метод, который вызовет SelfHelpService
      when 'start_day_8_content' then handle_start_day_8_content
      when 'day_8_confirm_exercise' then handle_day_8_confirm_exercise
      when 'day_8_decline_exercise' then handle_day_8_decline_exercise
      when 'day_8_stopped_thought_first_try' then handle_day_8_stopped_thought_first_try
      when 'day_8_ready_for_distraction' then handle_day_8_ready_for_distraction
      when /^day_8_distraction_(music|video|friend|exercise|book)$/ then handle_day_8_distraction_choice($1)
      when 'day_8_exercise_completed' then handle_day_8_exercise_completion
      when 'complete_program_final' then handle_complete_program_final # Предполагаем, что это финальное завершение

      else
        Rails.logger.warn "Unknown callback_data received: #{@callback_data} from user #{ @user.telegram_id }"
        send_message_to_user("Извините, я не понял эту команду. Пожалуйста, используйте кнопки.")
      end
    end

    private

    # --- Обработчики общих функций ---

    def handle_back_to_main_menu
      send_main_menu("Выберите действие:")
    end

    # --- Обработчики тестов ---

    def handle_show_test_categories
      TestManager.new(@bot_service, @user, @chat_id).show_categories
    end

    def handle_prepare_test(test_type)
      TestManager.new(@bot_service, @user, @chat_id).prepare_test(test_type)
    end

    def handle_start_standard_test(test_type)
      QuizRunner.new(@bot_service, @user, @chat_id).start_quiz(test_type)
    end

    def handle_start_luscher_test
      LuscherTestService.new(@bot_service, @user, @chat_id).start_test
    end

    def handle_show_luscher_interpretation
      LuscherTestService.new(@bot_service, @user, @chat_id).show_interpretation
    end

    def handle_quiz_answer(question_id, answer_option_id, test_result_id)
      QuizRunner.new(@bot_service, @user, @chat_id).process_answer(question_id, answer_option_id, test_result_id)
    end
    
    # --- Обработчики дневника эмоций ---

    def handle_start_emotion_diary
      EmotionDiaryService.new(@bot_service, @user, @chat_id).start_diary_menu
    end

    def handle_new_emotion_diary_entry
      EmotionDiaryService.new(@bot_service, @user, @chat_id).start_new_entry
    end

    def handle_show_emotion_diary_entries
      EmotionDiaryService.new(@bot_service, @user, @chat_id).show_entries
    end

    # --- Обработчики программы самопомощи ---
    # Все методы, связанные с программой самопомощи, теперь делегируются SelfHelpService

    def handle_start_self_help_program_intro
      self_help_service = SelfHelpService.new(@bot_service, @user, @chat_id)
      self_help_service.start_program_initiation # Теперь вызываем start_program_initiation
      # ИСПРАВЛЕННАЯ СТРОКА:
      @bot.answer_callback_query(callback_query_id: @callback_query_data["id"], text: "Запускаем программу!")
    end

    def handle_start_self_help_program_tests # Вызывается по 'start_self_help_program_tests' (кнопка "Начать программу")
      # Теперь вызываем метод, который непосредственно начинает последовательность тестов
      SelfHelpService.new(@bot_service, @user, @chat_id).start_tests_sequence
    end

    def handle_yes_response
      # Передаем управление сервису, который знает, что делать с 'yes' в зависимости от текущего состояния.
      SelfHelpService.new(@bot_service, @user, @chat_id).handle_response('yes')
    end

    def handle_no_response
    # Передаем управление сервису, который знает, что делать с 'no' в зависимости от текущего состояния.
      SelfHelpService.new(@bot_service, @user, @chat_id).handle_response('no')
    end

    # --- Обработчики завершения тестов (для программы самопомощи) ---

    def handle_test_completed_depression
      SelfHelpService.new(@bot_service, @user, @chat_id).handle_test_completion('depression')
    end

    def handle_start_anxiety_test_from_sequence
      SelfHelpService.new(@bot_service, @user, @chat_id).start_anxiety_test_sequence
    end

    def handle_test_completed_anxiety
      SelfHelpService.new(@bot_service, @user, @chat_id).handle_test_completion('anxiety')
    end

    def handle_no_anxiety_test_sequence
      SelfHelpService.new(@bot_service, @user, @chat_id).handle_no_anxiety_test_sequence
    end

    # --- Обработчики шагов программы самопомощи ---
    # Все эти методы делегируют исполнение SelfHelpService

    def handle_start_day_1_content
      SelfHelpService.new(@bot_service, @user, @chat_id).deliver_day_1_content
    end

    def handle_continue_day_1_content
      SelfHelpService.new(@bot_service, @user, @chat_id).continue_day_1_content
    end

    def handle_complete_day_1
      SelfHelpService.new(@bot_service, @user, @chat_id).complete_day_1
    end

    def handle_day_1_exercise_completed
      SelfHelpService.new(@bot_service, @user, @chat_id).handle_day_1_exercise_completion
    end

    def handle_start_day_2_from_proposal
      if ['awaiting_day_2_start', 'day_1_completed'].include?(@user.get_self_help_step)
        # Устанавливаем шаг, прежде чем вызвать deliver_day_2_content, которое его тоже устанавливает.
        # Это для большей надежности в случае перехода из разных состояний.
        @user.set_self_help_step('awaiting_day_2_start')
        self_help_service = SelfHelpService.new(@bot_service, @user, @chat_id)
        self_help_service.deliver_day_2_content
        answer_callback_query("Начинаем День 2!")
      else
        Rails.logger.warn "User #{@user.telegram_id} tried to start Day 2 from unexpected state: #{@user.get_self_help_step}."
        answer_callback_query("Ошибка. Попробуйте еще раз или начните /start.")
      end
    end

    # НОВОЕ: Обработка callback_data 'start_day_3_from_proposal'
    def handle_start_day_3_from_proposal
      if ['awaiting_day_3_start', 'day_2_completed'].include?(@user.get_self_help_step)
        @user.set_self_help_step('awaiting_day_3_start')
        self_help_service = SelfHelpService.new(@bot_service, @user, @chat_id)
        self_help_service.deliver_day_3_content
        answer_callback_query("Начинаем День 3!")
      else
        Rails.logger.warn "User #{@user.telegram_id} tried to start Day 3 from unexpected state: #{@user.get_self_help_step}."
        answer_callback_query("Ошибка. Попробуйте еще раз или начните /start.")
      end
    end

    # НОВОЕ: Обработка callback_data 'start_day_4_from_proposal'
    def handle_start_day_4_from_proposal
      if ['awaiting_day_4_start', 'day_3_completed'].include?(@user.get_self_help_step)
        @user.set_self_help_step('awaiting_day_4_start')
        self_help_service = SelfHelpService.new(@bot_service, @user, @chat_id)
        self_help_service.deliver_day_4_content
        answer_callback_query("Начинаем День 4!")
      else
        Rails.logger.warn "User #{@user.telegram_id} tried to start Day 4 from unexpected state: #{@user.get_self_help_step}."
        answer_callback_query("Ошибка. Попробуйте еще раз или начните /start.")
      end
    end

    # НОВОЕ: Обработка callback_data 'start_day_5_from_proposal'
    def handle_start_day_5_from_proposal
      if ['awaiting_day_5_start', 'day_4_completed'].include?(@user.get_self_help_step)
        @user.set_self_help_step('awaiting_day_5_start')
        self_help_service = SelfHelpService.new(@bot_service, @user, @chat_id)
        self_help_service.deliver_day_5_content
        answer_callback_query("Начинаем День 5!")
      else
        Rails.logger.warn "User #{@user.telegram_id} tried to start Day 5 from unexpected state: #{@user.get_self_help_step}."
        answer_callback_query("Ошибка. Попробуйте еще раз или начните /start.")
      end
    end

    def handle_start_day_5_exercise
      self_help_service = SelfHelpService.new(@bot_service, @user, @chat_id)
      self_help_service.start_day_5_exercise # Делегируем SelfHelpService
      answer_callback_query("Начинаем упражнение Дня 5!")
    end

    def handle_day_5_exercise_completed
      self_help_service = SelfHelpService.new(@bot_service, @user, @chat_id)
      self_help_service.handle_day_5_exercise_completion # Делегируем SelfHelpService
      answer_callback_query("Упражнение Дня 5 завершено!")
    end

    # НОВОЕ: Обработка callback_data 'start_day_6_from_proposal'
    def handle_start_day_6_from_proposal
      if ['awaiting_day_6_start', 'day_5_completed'].include?(@user.get_self_help_step)
        @user.set_self_help_step('awaiting_day_6_start')
        self_help_service = SelfHelpService.new(@bot_service, @user, @chat_id)
        self_help_service.deliver_day_6_content
        answer_callback_query("Начинаем День 6!")
      else
        Rails.logger.warn "User #{@user.telegram_id} tried to start Day 6 from unexpected state: #{@user.get_self_help_step}."
        answer_callback_query("Ошибка. Попробуйте еще раз или начните /start.")
      end
    end

    # НОВОЕ: Обработка callback_data 'start_day_7_from_proposal'
    def handle_start_day_7_from_proposal
      if ['awaiting_day_7_start', 'day_6_completed'].include?(@user.get_self_help_step)
        @user.set_self_help_step('awaiting_day_7_start')
        self_help_service = SelfHelpService.new(@bot_service, @user, @chat_id)
        self_help_service.deliver_day_7_content
        answer_callback_query("Начинаем День 7!")
      else
        Rails.logger.warn "User #{@user.telegram_id} tried to start Day 7 from unexpected state: #{@user.get_self_help_step}."
        answer_callback_query("Ошибка. Попробуйте еще раз или начните /start.")
      end
    end

    # НОВОЕ: Обработка callback_data 'start_day_8_from_proposal'
    def handle_start_day_8_from_proposal
      if ['awaiting_day_8_start', 'day_7_completed'].include?(@user.get_self_help_step)
        @user.set_self_help_step('awaiting_day_8_start')
        self_help_service = SelfHelpService.new(@bot_service, @user, @chat_id)
        self_help_service.deliver_day_8_content # Вызываем переименованный метод
        answer_callback_query("Начинаем День 8!")
      else
        Rails.logger.warn "User #{@user.telegram_id} tried to start Day 8 from unexpected state: #{@user.get_self_help_step}."
        answer_callback_query("Ошибка. Попробуйте еще раз или начните /start.")
      end
    end

    def handle_start_day_2_content
      SelfHelpService.new(@bot_service, @user, @chat_id).deliver_day_2_content
    end

    def handle_start_day_2_exercise_audio
      SelfHelpService.new(@bot_service, @user, @chat_id).send_day_2_exercise_audio
    end

    def handle_day_2_exercise_completion
      SelfHelpService.new(@bot_service, @user, @chat_id).handle_day_2_exercise_completion
    end

    def handle_start_day_3_content
      SelfHelpService.new(@bot_service, @user, @chat_id).deliver_day_3_content
    end

    # Новый callback_data для начала ввода благодарностей
    def handle_start_gratitude_entry
      SelfHelpService.new(@bot_service, @user, @chat_id).start_gratitude_entry
    end

    # Новый callback_data для просмотра записей благодарностей
    def handle_show_gratitude_entries
      SelfHelpService.new(@bot_service, @user, @chat_id).show_gratitude_entries
    end

    def handle_complete_day_3
      SelfHelpService.new(@bot_service, @user, @chat_id).complete_day_3
    end

    def handle_start_day_4_content
      SelfHelpService.new(@bot_service, @user, @chat_id).deliver_day_4_content
    end

    def handle_start_day_4_exercise
      SelfHelpService.new(@bot_service, @user, @chat_id).start_day_4_exercise
    end

    def handle_day_4_exercise_completed
      SelfHelpService.new(@bot_service, @user, @chat_id).handle_day_4_exercise_completion
    end

    def handle_start_day_5_content
      SelfHelpService.new(@bot_service, @user, @chat_id).deliver_day_5_content
    end

    def handle_day_5_exercise_completed
      SelfHelpService.new(@bot_service, @user, @chat_id).handle_day_5_exercise_completion
    end

    def handle_start_day_6_content
      SelfHelpService.new(@bot_service, @user, @chat_id).deliver_day_6_content
    end

    def handle_day_6_exercise_completed
      SelfHelpService.new(@bot_service, @user, @chat_id).handle_day_6_exercise_completion
    end

    def handle_start_day_7_content
      SelfHelpService.new(@bot_service, @user, @chat_id).deliver_day_7_content
    end

    def handle_complete_day_7 # Этот метод теперь просто вызывает сервис
      SelfHelpService.new(@bot_service, @user, @chat_id).complete_day_7_and_propose_next
    end

    def handle_start_day_8_content
      SelfHelpService.new(@bot_service, @user, @chat_id).deliver_day_8_intro
    end

    def handle_day_8_confirm_exercise
      SelfHelpService.new(@bot_service, @user, @chat_id).handle_day_8_consent('confirm')
    end

    def handle_day_8_decline_exercise
      SelfHelpService.new(@bot_service, @user, @chat_id).handle_day_8_consent('decline')
    end

    def handle_day_8_stopped_thought_first_try
      self_help_service = SelfHelpService.new(@bot_service, @user, @chat_id)
      self_help_service.handle_day_8_stopped_thought_first_try # <-- ИЗМЕНЕНО: Вызываем существующий метод
      answer_callback_query("Продолжаем упражнение!") # Добавьте это, чтобы пользователь получил обратную связь
    end

    def handle_day_8_ready_for_distraction
      self_help_service = SelfHelpService.new(@bot_service, @user, @chat_id)
      self_help_service.handle_day_8_ready_for_distraction # <-- ИЗМЕНЕНО: Вызываем существующий метод
      answer_callback_query("Выбираем способ отвлечения!") # Добавьте это
    end

    def handle_day_8_distraction_choice(distraction_type)
      SelfHelpService.new(@bot_service, @user, @chat_id).guide_distraction(distraction_type)
    end

    def handle_day_8_exercise_completion
      SelfHelpService.new(@bot_service, @user, @chat_id).handle_day_8_exercise_completion
    end

    def handle_complete_program_final
      # Если это реальное завершение программы, вызываем соответствующий метод.
      SelfHelpService.new(@bot_service, @user, @chat_id).complete_program_final
    end

    # --- Вспомогательные методы ---

    def send_message_to_user(text, markup = nil)
      @bot.send_message(chat_id: @chat_id, text: text, reply_markup: markup)
    rescue Telegram::Bot::Error => e
      Rails.logger.error "Failed to send message to user #{@user.telegram_id}: #{e.message}"
    end

    def send_main_menu(text)
      send_message_to_user(text, TelegramMarkupHelper.main_menu_markup)
    end

    def answer_callback_query(text, show_alert: false)
      @bot.answer_callback_query(
        callback_query_id: @callback_query_data["id"],
        text: text,
        show_alert: show_alert # Установите true, если хотите показать всплывающее уведомление
      )
    rescue Telegram::Bot::Error => e
      Rails.logger.error "Failed to answer callback query for user #{@user.telegram_id}: #{e.message}"
    end

    def handle_day_8_confirm_exercise
      self_help_service = SelfHelpService.new(@bot_service, @user, @chat_id)
      self_help_service.handle_day_8_consent('confirm')
      answer_callback_query("Начинаем упражнение!")
    end

    def handle_day_8_decline_exercise
      self_help_service = SelfHelpService.new(@bot_service, @user, @chat_id)
      self_help_service.handle_day_8_consent('decline')
      answer_callback_query("Хорошо, возможно, позже.")
    end

    # --- Метод для упрощенной отправки сообщений ---
    # Этот метод будет использоваться во всех сервисах для отправки сообщений.
    # Он также будет обрабатывать ошибки отправки.
    # def send_message(chat_id:, text:, reply_markup: nil, parse_mode: nil)
    #   @bot.send_message(chat_id: chat_id, text: text, reply_markup: reply_markup, parse_mode: parse_mode)
    # rescue Telegram::Bot::Error => e
    #   Rails.logger.error "Telegram API Error: #{e.message}"
      # Возможно, стоит добавить какую-то логику для оповещения пользователя об ошибке,
      # но часто просто игнорирование ошибки отправки (и логирование) является достаточным,
      # чтобы бот не падал.
    # end
  end
end
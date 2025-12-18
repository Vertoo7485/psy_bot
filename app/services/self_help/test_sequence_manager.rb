# app/services/self_help/test_sequence_manager.rb
module SelfHelp
  class TestSequenceManager
    include TelegramMarkupHelper
    
    attr_reader :bot_service, :user, :chat_id
    
    # Порядок прохождения тестов
    TEST_SEQUENCE = [:depression, :anxiety].freeze
    
    def initialize(bot_service, user, chat_id)
      @bot_service = bot_service
      @user = user
      @chat_id = chat_id
    end
    
    # Запуск последовательности тестов
    def start
      log_info("Starting test sequence")
      
      @user.set_self_help_step('taking_depression_test')
      
      message = <<~MARKDOWN
        📋 *Начнем с тестирования* 📋

        Сначала пройдем тест на депрессию (PHQ-9).
        Это поможет нам оценить ваше текущее состояние.
      MARKDOWN
      
      @bot_service.send_message(
        chat_id: @chat_id,
        text: message,
        parse_mode: 'Markdown'
      )
      
      # Запускаем первый тест
      start_test(:depression)
    end
    
    # Обработка завершения теста
    def handle_completion(test_type)
      log_info("Handling test completion: #{test_type}")
      
      case test_type.to_sym
      when :depression
        handle_depression_test_completion
      when :anxiety
        handle_anxiety_test_completion
      else
        log_warn("Unknown test type: #{test_type}")
        handle_unknown_test_completion
      end
    end
    
    # Запуск теста на тревожность
    def start_anxiety_test
      if @user.self_help_state == 'awaiting_anxiety_test_completion'
        @user.set_self_help_step('taking_anxiety_test')
        start_test(:anxiety)
      else
        log_warn("Cannot start anxiety test from state: #{@user.self_help_state}")
        false
      end
    end
    
    # Пропуск теста на тревожность
    def skip_anxiety_test
      if @user.self_help_state == 'awaiting_anxiety_test_completion'
        @user.clear_self_help_program
        
        message = <<~TEXT
          Хорошо, мы можем пройти тест позже.
          Возвращаемся в главное меню.
        TEXT
        
        @bot_service.send_message(
          chat_id: @chat_id,
          text: message,
          reply_markup: TelegramMarkupHelper.main_menu_markup
        )
      else
        log_warn("Cannot skip anxiety test from state: #{@user.self_help_state}")
        false
      end
    end
    
    private
    
    # Запуск конкретного теста
    def start_test(test_type)
      log_info("Starting test: #{test_type}")
      
      runner = QuizRunner.new(@bot_service, @user, @chat_id)
      runner.start_quiz(test_type)
      
      true
    rescue => e
      log_error("Failed to start test #{test_type}", e)
      send_error_message("Ошибка при запуске теста. Пожалуйста, попробуйте позже.")
      false
    end
    
    # Обработка завершения теста на депрессию
    def handle_depression_test_completion
      if @user.self_help_state == 'taking_depression_test'
        @user.set_self_help_step('awaiting_anxiety_test_completion')
        
        message = <<~MARKDOWN
          ✅ *Тест на депрессию завершен!*

          Теперь пройдем тест на тревожность.
          Это поможет получить более полную картину.
        MARKDOWN
        
        markup = TelegramMarkupHelper.yes_no_markup(
          callback_data_yes: 'start_anxiety_test_from_sequence',
          callback_data_no: 'no_anxiety_test_sequence'
        )
        
        @bot_service.send_message(
          chat_id: @chat_id,
          text: message,
          parse_mode: 'Markdown',
          reply_markup: markup
        )
      else
        log_warn("Unexpected state for depression test completion: #{@user.self_help_state}")
        handle_unexpected_state
      end
    end
    
    # Обработка завершения теста на тревожность
    def handle_anxiety_test_completion
      if @user.self_help_state == 'taking_anxiety_test'
        @user.set_self_help_step('tests_completed')
        
        message = <<~MARKDOWN
          🎉 *Все тесты пройдены!* 🎉

          Спасибо за ваши ответы. Теперь мы можем начать программу самопомощи.

          Нажмите кнопку, чтобы перейти к первому дню программы.
        MARKDOWN
        
        markup = {
          inline_keyboard: [
            [{ text: 'Начать День 1', callback_data: 'start_day_1_content' }]
          ]
        }.to_json
        
        @bot_service.send_message(
          chat_id: @chat_id,
          text: message,
          parse_mode: 'Markdown',
          reply_markup: markup
        )
      else
        log_warn("Unexpected state for anxiety test completion: #{@user.self_help_state}")
        handle_unexpected_state
      end
    end
    
    # Обработка неизвестного теста
    def handle_unknown_test_completion
      send_error_message("Неизвестный тип теста. Пожалуйста, начните заново.")
    end
    
    # Обработка неожиданного состояния
    def handle_unexpected_state
      @user.clear_self_help_program
      send_error_message("Произошла ошибка в последовательности тестов. Начнем заново.")
    end
    
    # Отправка сообщения об ошибке
    def send_error_message(text)
      @bot_service.send_message(
        chat_id: @chat_id,
        text: text,
        reply_markup: TelegramMarkupHelper.main_menu_markup
      )
    end
    
    # Логирование
    def log_info(message)
      Rails.logger.info "[TestSequenceManager] #{message} - User: #{@user.telegram_id}"
    end
    
    def log_warn(message)
      Rails.logger.warn "[TestSequenceManager] #{message} - User: #{@user.telegram_id}"
    end
    
    def log_error(message, error = nil)
      Rails.logger.error "[TestSequenceManager] #{message} - User: #{@user.telegram_id}"
      Rails.logger.error error.message if error
    end
  end
end
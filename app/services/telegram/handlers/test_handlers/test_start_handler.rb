module Telegram
  module Handlers
    module TestHandlers
      class TestStartHandler < BaseHandler
        def initialize(bot_service, user, chat_id, callback_query_data)
          super(bot_service, user, chat_id, callback_query_data)
          log_info("Starting test from tests list", test_type: extract_test_type, user_id: @user&.id, self_help_state: @user&.self_help_state, telegram_id: @user&.telegram_id)
        end

        def process
          test_type = extract_test_type
          
          unless test_type
            log_error("Could not extract test type", callback_data: @callback_data)
            answer_callback_query("Ошибка: не удалось определить тест")
            return
          end

          # Сохраняем информацию о текущем тесте
          @user.store_self_help_data('current_test_type', nil) # Сбрасываем предыдущий

          # Запускаем тест через QuizRunner
          quiz_runner = QuizRunner.new(@bot_service, @user, @chat_id)
          quiz_runner.start_quiz(test_type)

          answer_callback_query("Запускаю тест...")
        end

        private

        def extract_test_type
          # Извлекаем тип теста из callback_data
          match = @callback_data.match(/^start_(.+)_test$/)
          match ? match[1] : nil
        end

        def log_info(message, data = {})
          Rails.logger.info "[TestStartHandler] #{message} - #{data}"
        end

        def log_error(message, data = {})
          Rails.logger.error "[TestStartHandler] #{message} - #{data}"
        end
      end
    end
  end
end
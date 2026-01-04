module Telegram
  module Handlers
    module SelfHelpHandlers
      class SelfHelpTestHandler < BaseHandler
        def initialize(bot_service, user, chat_id, callback_query_data)
          super(bot_service, user, chat_id, callback_query_data)
          log_info("SelfHelpTestHandler initialized", user_id: @user&.id, callback_data: @callback_data)
        end

        def process
          log_info("Processing self help test", callback_data: @callback_data)
          
          # Извлекаем тип теста из callback_data
          match = @callback_data.match(/^self_help_(.+)_test$/)
          
          unless match
            log_error("Could not extract test type", callback_data: @callback_data)
            send_message(text: "Ошибка: не удалось определить тест")
            return
          end
          
          test_type = match[1]
          log_info("Extracted test type", test_type: test_type)
          
          # Запускаем тест через QuizRunner
          quiz_runner = QuizRunner.new(@bot_service, @user, @chat_id)
          quiz_runner.start_quiz(test_type)
          
          answer_callback_query("Запускаю тест...")
        end

        private

        def log_info(message, data = {})
          Rails.logger.info "[SelfHelpTestHandler] #{message} - #{data}"
        end

        def log_error(message, data = {})
          Rails.logger.error "[SelfHelpTestHandler] #{message} - #{data}"
        end
      end
    end
  end
end
# app/services/telegram/handlers/test_handlers/test_preparation_handler.rb
module Telegram
  module Handlers
    module TestHandlers
      class TestPreparationHandler < BaseHandler
        def initialize(bot_service, user, chat_id, callback_query_data)
          super(bot_service, user, chat_id, callback_query_data)
          log_info("Preparing test - User: #{@user.telegram_id}, Chat: #{@chat_id}")
        end
        
        def process
          test_type = extract_test_type
          
          unless test_type
            log_error("Could not extract test type", callback_data: @callback_data)
            answer_callback_query("Ошибка: не удалось определить тест")
            return
          end
          
          log_info("Preparing test: #{test_type} - User: #{@user.telegram_id}, Chat: #{@chat_id}")
          
          # Используем TestManager для подготовки теста
          test_manager = TestManager.new(@bot_service, @user, @chat_id)
          
          if test_manager.prepare_test(test_type)
            answer_callback_query("Подготавливаем тест...")
          else
            log_error("Failed to prepare test: #{test_type}")
            answer_callback_query("Ошибка при подготовке теста")
          end
        end
        
        private
        
        def extract_test_type
          # Извлекаем тип теста из callback_data
          match = @callback_data.match(/prepare_(\w+)_test/)
          match ? match[1] : nil
        end
        
        def log_info(message)
          Rails.logger.info "[TestPreparationHandler] #{message}"
        end
        
        def log_error(message, error = nil)
          Rails.logger.error "[TestPreparationHandler] #{message}"
          Rails.logger.error error.message if error
        end
      end
    end
  end
end
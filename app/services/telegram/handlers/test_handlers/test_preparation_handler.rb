# app/services/telegram/handlers/test_handlers/test_preparation_handler.rb

module Telegram
  module Handlers
    class TestPreparationHandler
      attr_accessor :matches
      
      def initialize(bot_service, user, chat_id, callback_query_data = nil)
        @bot_service = bot_service
        @user = user
        @chat_id = chat_id
        @callback_query_data = callback_query_data
        @callback_data = callback_query_data[:data] if callback_query_data
      end
      
      def process
        log_info("Preparing test")
        
        # Извлекаем тип теста из matches
        test_type = extract_test_type
        
        unless test_type
          log_error("Could not extract test type", callback_data: @callback_data)
          answer_callback_query("Ошибка: не удалось определить тест")
          return
        end
        
        log_info("Preparing test: #{test_type}")
        
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
        return @matches[1] if @matches && @matches[1]
        
        # Пробуем извлечь из callback_data
        match = @callback_data.match(/prepare_(\w+)_test/)
        match ? match[1] : nil
      end
      
      def answer_callback_query(text = nil, show_alert: false)
        return unless @callback_query_data && @callback_query_data["id"]
        
        @bot_service.answer_callback_query(
          callback_query_id: @callback_query_data["id"],
          text: text,
          show_alert: show_alert
        )
      rescue Telegram::Bot::Error => e
        log_error("Failed to answer callback query", e)
      end
      
      def log_info(message)
        Rails.logger.info "[TestPreparationHandler] #{message} - User: #{@user.telegram_id}, Chat: #{@chat_id}"
      end
      
      def log_error(message, error = nil)
        Rails.logger.error "[TestPreparationHandler] #{message} - User: #{@user.telegram_id}, Chat: #{@chat_id}"
        Rails.logger.error error.message if error
      end
    end
  end
end
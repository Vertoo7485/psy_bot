# app/services/telegram/callback_query_processor.rb
module Telegram
  class CallbackQueryProcessor
    # Константы
    ERROR_MESSAGE = "Произошла ошибка при обработке вашего запроса. Пожалуйста, попробуйте еще раз или начните заново с /start."
    
    attr_reader :bot_service, :user, :callback_query_data, :chat_id, :message_id, :callback_data
    
    def initialize(bot_service, user, callback_query_data)
      @bot_service = bot_service
      @user = user
      @callback_query_data = callback_query_data
      @chat_id = extract_chat_id
      @message_id = extract_message_id
      @callback_data = callback_query_data[:data]
    end
    
    def process
      log_info("Processing callback: #{@callback_data}")
      
      # Находим обработчик через фабрику
      handler = Handlers::CallbackHandlerFactory.handler_for(
        @callback_data,
        [@bot_service, @user, @chat_id, @callback_query_data]
      )
      
      # Выполняем обработчик
      handler.process
      
      log_success("Callback processed successfully")
      
    rescue StandardError => e
      log_error("Error processing callback", e)
      send_error_message
    end
    
    private
    
    # Извлечение chat_id из callback query
    def extract_chat_id
      @callback_query_data.dig(:message, :chat, :id)
    end
    
    # Извлечение message_id из callback query
    def extract_message_id
      @callback_query_data.dig(:message, :message_id)
    end
    
    # Отправка сообщения об ошибке
    def send_error_message
      @bot_service.send_message(
        chat_id: @chat_id,
        text: ERROR_MESSAGE
      )
    rescue => e
      log_error("Failed to send error message", e)
    end
    
    # Логирование
    def log_info(message)
      Rails.logger.info "[CallbackQueryProcessor] #{message} - User: #{@user.telegram_id}, Chat: #{@chat_id}"
    end
    
    def log_success(message)
      Rails.logger.debug "[CallbackQueryProcessor] #{message} - User: #{@user.telegram_id}, Chat: #{@chat_id}"
    end
    
    def log_error(message, error = nil)
      Rails.logger.error "[CallbackQueryProcessor] #{message} - User: #{@user.telegram_id}, Chat: #{@chat_id}, Callback: #{@callback_data}"
      if error
        Rails.logger.error "Error: #{error.message}"
        Rails.logger.error "Backtrace:\n#{error.backtrace.join("\n")}" if error.respond_to?(:backtrace)
      end
    end
  end
end
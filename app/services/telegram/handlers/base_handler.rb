# app/services/telegram/handlers/base_handler.rb

module Telegram
  module Handlers
    class BaseHandler
      # Атрибуты
      attr_reader :bot_service, :user, :chat_id, :callback_query_data
      attr_accessor :matches
      
      def initialize(bot_service, user, chat_id, callback_query_data = nil)
        @bot_service = bot_service
        @user = user
        @chat_id = chat_id
        @callback_query_data = callback_query_data
        @callback_data = callback_query_data[:data] if callback_query_data
      end
      
      # Основной метод обработки (должен быть переопределен в наследниках)
      def process
        raise NotImplementedError, "#{self.class} must implement #process"
      end
      
      protected
      
      # Отправка сообщения пользователю
      def send_message(text:, reply_markup: nil, parse_mode: nil, disable_notification: false)
        @bot_service.send_message(
          chat_id: @chat_id,
          text: text,
          reply_markup: reply_markup,
          parse_mode: parse_mode,
          disable_notification: disable_notification
        )
      rescue Telegram::Bot::Error => e
        log_error("Failed to send message", e)
        false
      end
      
      # Ответ на callback query
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
      
      # Редактирование сообщения
      def edit_message(text:, reply_markup: nil, parse_mode: nil)
        return unless @callback_query_data && @message_id
        
        message_id = @callback_query_data.dig(:message, :message_id) || @message_id
        
        @bot_service.edit_message_text(
          chat_id: @chat_id,
          message_id: message_id,
          text: text,
          reply_markup: reply_markup,
          parse_mode: parse_mode
        )
      rescue Telegram::Bot::Error => e
        log_error("Failed to edit message", e)
        false
      end
      
      # Удаление сообщения
      def delete_message(message_id = nil)
        message_id ||= @callback_query_data.dig(:message, :message_id)
        return unless message_id
        
        @bot_service.delete_message(
          chat_id: @chat_id,
          message_id: message_id
        )
      rescue Telegram::Bot::Error => e
        log_error("Failed to delete message", e)
        false
      end
      
      # Проверка наличия совпадений из регулярного выражения
      def has_matches?
        !matches.nil?
      end
      
      # Получение группы совпадения
      def match_group(index)
        matches[index] if matches
      end
      
      # Логирование
      def log_info(message, extra = {})
        Rails.logger.info "[#{self.class}] #{message} - User: #{@user.telegram_id}, Chat: #{@chat_id}"
        Rails.logger.info "Extra: #{extra.to_json}" unless extra.empty?
      end
      
      def log_error(message, error = nil)
        Rails.logger.error "[#{self.class}] #{message} - User: #{@user.telegram_id}, Chat: #{@chat_id}"
        Rails.logger.error error.message if error
        Rails.logger.error error.backtrace.join("\n") if error.respond_to?(:backtrace)
      end
      
      def log_warn(message)
        Rails.logger.warn "[#{self.class}] #{message} - User: #{@user.telegram_id}, Chat: #{@chat_id}"
      end
      
      def log_debug(message)
        Rails.logger.debug "[#{self.class}] #{message} - User: #{@user.telegram_id}, Chat: #{@chat_id}"
      end
    end
  end
end
# app/services/telegram/context_handlers/base_context_handler.rb
module Telegram
  module ContextHandlers
    class BaseContextHandler
      # Атрибуты
      attr_reader :bot, :user, :chat_id, :text
      
      def initialize(bot, user, chat_id, text)
        @bot = bot
        @user = user
        @chat_id = chat_id
        @text = text.to_s.strip
      end
      
      # Основной метод обработки (должен быть переопределен)
      def process
        raise NotImplementedError, "#{self.class} must implement #process"
      end
      
      protected
      
      # Отправка сообщения
      def send_message(text:, reply_markup: nil, parse_mode: nil)
        @bot.send_message(
          chat_id: @chat_id,
          text: text,
          reply_markup: reply_markup,
          parse_mode: parse_mode
        )
      rescue Telegram::Bot::Error => e
        log_error("Failed to send message", e)
        false
      end
      
      # Логирование
      def log_info(message)
        Rails.logger.info "[#{self.class}] #{message} - User: #{@user.telegram_id}"
      end
      
      def log_error(message, error = nil)
        Rails.logger.error "[#{self.class}] #{message} - User: #{@user.telegram_id}"
        Rails.logger.error error.message if error
        Rails.logger.error error.backtrace.join("\n") if error.respond_to?(:backtrace)
      end
      
      def log_debug(message)
        Rails.logger.debug "[#{self.class}] #{message} - User: #{@user.telegram_id}"
      end
    end
  end
end
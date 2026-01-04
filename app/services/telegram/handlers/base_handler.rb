module Telegram
  module Handlers
    class BaseHandler
      attr_reader :bot_service, :user, :chat_id, :callback_query_data, :callback_data, :callback_query_id
      attr_accessor :matches  # ← ДОБАВЛЯЕМ сеттер для matches
      
      def initialize(bot_service, user, chat_id, callback_query_data = nil)
        @bot_service = bot_service
        @user = user
        @chat_id = chat_id
        @callback_query_data = callback_query_data
        
        if callback_query_data
          @callback_data = callback_query_data[:data] || callback_query_data["data"]
          
          # Извлекаем ID разными способами
          @callback_query_id = callback_query_data[:id] || 
                              callback_query_data["id"] ||
                              (callback_query_data[:callback_query] && callback_query_data[:callback_query][:id]) ||
                              (callback_query_data["callback_query"] && callback_query_data["callback_query"]["id"])
        end
        
        # Инициализируем matches если есть callback_data и паттерн
        init_matches if @callback_data
      end
      
      # Основной метод обработки (должен быть переопределен в наследниках)
      def process
        raise NotImplementedError, "#{self.class} must implement #process"
      end
      
      protected
      
      # Инициализация matches на основе CALLBACK_PATTERN
      def init_matches
        return unless @callback_data
        
        if self.class.const_defined?(:CALLBACK_PATTERN)
          pattern = self.class::CALLBACK_PATTERN
          @matches = @callback_data.match(pattern)
        else
          @matches = nil
        end
      end
      
      # Безопасная проверка наличия совпадений
      def has_matches?
        return false unless @callback_data
        
        if defined?(@matches)
          !@matches.nil?
        elsif self.class.const_defined?(:CALLBACK_PATTERN)
          !@callback_data.match(self.class::CALLBACK_PATTERN).nil?
        else
          false
        end
      end
      
      # Безопасное получение группы совпадения
      def match_group(index)
        return nil unless has_matches?
        
        if defined?(@matches) && @matches
          @matches[index]
        elsif self.class.const_defined?(:CALLBACK_PATTERN)
          match = @callback_data.match(self.class::CALLBACK_PATTERN)
          match[index] if match
        end
      end
      
      # === УТИЛИТНЫЕ МЕТОДЫ ===
      
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
        return unless @callback_query_id
        
        @bot_service.answer_callback_query(
          callback_query_id: @callback_query_id,
          text: text,
          show_alert: show_alert
        )
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
      
      # === ЛОГИРОВАНИЕ ===
      
      def log_info(message, data = {})
        Rails.logger.info "[#{self.class.name}] #{message} - #{data}"
      end
      
      def log_error(message, error = nil)
        Rails.logger.error "[#{self.class.name}] #{message}"
        if error
          Rails.logger.error "Error: #{error.message}"
          Rails.logger.error "Backtrace: #{error.backtrace.first(5).join(', ')}" if error.backtrace
        end
      end
      
      # ====== ИСПРАВЛЕННЫЕ МЕТОДЫ ЛОГИРОВАНИЯ ======
    end
  end
end
      def log_warn(message, data = {})
        Rails.logger.warn "[#{self.class.name}] #{message} - #{data}"
      end

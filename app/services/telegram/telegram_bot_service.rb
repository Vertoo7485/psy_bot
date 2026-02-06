# app/services/telegram/telegram_bot_service.rb
require 'telegram/bot'
require 'faraday/multipart'

module Telegram
  class TelegramBotService
    # Константы
    DEFAULT_TIMEOUT = 10
    MAX_RETRIES = 3
    
    attr_reader :bot
    
    def initialize(token)
      @bot = create_bot_client(token)
    end
    
    # Установка вебхука
    def set_webhook(url)
      Rails.logger.info "[TelegramBotService] Setting webhook to: #{url}"
      
      begin
        @bot.set_webhook(url: url)
        Rails.logger.info "[TelegramBotService] Webhook set successfully"
        true
      rescue Telegram::Bot::Error => e
        Rails.logger.error "[TelegramBotService] Failed to set webhook: #{e.message}"
        false
      rescue => e
        Rails.logger.error "[TelegramBotService] Unexpected error setting webhook: #{e.message}"
        false
      end
    end
    
    # Удаление вебхука
    def delete_webhook
      Rails.logger.info "[TelegramBotService] Deleting webhook"
      
      begin
        @bot.delete_webhook
        Rails.logger.info "[TelegramBotService] Webhook deleted successfully"
        true
      rescue Telegram::Bot::Error => e
        Rails.logger.error "[TelegramBotService] Failed to delete webhook: #{e.message}"
        false
      end
    end
    
    # Отправка сообщения
    def send_message(chat_id:, text:, reply_markup: nil, parse_mode: nil, disable_notification: false)
      log_debug("Sending message to #{chat_id}", text)
      
      with_retry do
        @bot.send_message(
          chat_id: chat_id,
          text: text,
          reply_markup: reply_markup,
          parse_mode: parse_mode,
          disable_notification: disable_notification
        )
      end
    rescue Telegram::Bot::Error => e
      handle_telegram_error("sending message", e, chat_id)
    rescue => e
      handle_unexpected_error("sending message", e, chat_id)
    end
    
    # Отправка аудио
    def send_audio(chat_id:, audio:, caption: nil)
      log_debug("Sending audio to #{chat_id}", caption)
      
      with_retry do
        @bot.send_audio(
          chat_id: chat_id,
          audio: audio,
          caption: caption
        )
      end
    rescue Telegram::Bot::Error => e
      handle_telegram_error("sending audio", e, chat_id)
    rescue => e
      handle_unexpected_error("sending audio", e, chat_id)
    end
    
    # Отправка фото
    def send_photo(chat_id:, photo:, caption: nil)
      log_debug("Sending photo to #{chat_id}", caption)
      
      with_retry do
        @bot.send_photo(
          chat_id: chat_id,
          photo: photo,
          caption: caption
        )
      end
    rescue Telegram::Bot::Error => e
      handle_telegram_error("sending photo", e, chat_id)
    rescue => e
      handle_unexpected_error("sending photo", e, chat_id)
    end
    
    # Ответ на callback query
    def answer_callback_query(callback_query_id:, text: nil, show_alert: false)
      log_debug("Answering callback query #{callback_query_id}", text)
      
      with_retry do
        @bot.answer_callback_query(
          callback_query_id: callback_query_id,
          text: text,
          show_alert: show_alert
        )
      end
    rescue Telegram::Bot::Error => e
      handle_telegram_error("answering callback query", e, callback_query_id)
    rescue => e
      handle_unexpected_error("answering callback query", e, callback_query_id)
    end
    
    # Редактирование сообщения
    def edit_message_text(chat_id:, message_id:, text:, reply_markup: nil, parse_mode: nil)
      log_debug("Editing message #{message_id} for #{chat_id}", text)
      
      with_retry do
        @bot.edit_message_text(
          chat_id: chat_id,
          message_id: message_id,
          text: text,
          reply_markup: reply_markup,
          parse_mode: parse_mode
        )
      end
    rescue Telegram::Bot::Error => e
      handle_telegram_error("editing message", e, chat_id)
    rescue => e
      handle_unexpected_error("editing message", e, chat_id)
    end
    
    # Удаление сообщения
    def delete_message(chat_id:, message_id:)
      log_debug("Deleting message #{message_id} for #{chat_id}")
      
      with_retry do
        @bot.delete_message(
          chat_id: chat_id,
          message_id: message_id
        )
      end
    rescue Telegram::Bot::Error => e
      handle_telegram_error("deleting message", e, chat_id)
    rescue => e
      handle_unexpected_error("deleting message", e, chat_id)
    end
    
    # Получение информации о боте
    def get_me
      log_debug("Getting bot info")
      
      with_retry do
        @bot.get_me
      end
    rescue Telegram::Bot::Error => e
      handle_telegram_error("getting bot info", e)
    rescue => e
      handle_unexpected_error("getting bot info", e)
    end
    
    private
    
    # Создание клиента бота
    def create_bot_client(token)
      Telegram::Bot::Client.new(token) do |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
        faraday.options.timeout = DEFAULT_TIMEOUT
        faraday.options.open_timeout = DEFAULT_TIMEOUT
      end
    end
    
    # Метод с повторными попытками
    def with_retry(attempts = MAX_RETRIES)
      attempts.times do |attempt|
        begin
          return yield
        rescue Telegram::Bot::Error => e
          if attempt == attempts - 1
            raise
          else
            sleep_time = 2 ** attempt
            Rails.logger.warn "[TelegramBotService] Retry #{attempt + 1}/#{attempts} after #{sleep_time}s: #{e.message}"
            sleep(sleep_time)
          end
        end
      end
    end
    
    # Обработка ошибок Telegram API
    def handle_telegram_error(action, error, context = nil)
      error_message = "[TelegramBotService] Telegram API Error #{action}"
      error_message += " for #{context}" if context
      error_message += ": #{error.message}"
      
      Rails.logger.error error_message
      nil
    end
    
    # Обработка неожиданных ошибок
    def handle_unexpected_error(action, error, context = nil)
      error_message = "[TelegramBotService] Unexpected error #{action}"
      error_message += " for #{context}" if context
      error_message += ": #{error.message}"
      
      Rails.logger.error error_message
      Rails.logger.error error.backtrace.join("\n") if error.respond_to?(:backtrace)
      nil
    end
    
    # Логирование отладки
    def log_debug(action, content = nil)
      return unless Rails.env.development?
      
      message = "[TelegramBotService] #{action}"
      message += ": #{content.truncate(100)}" if content
      Rails.logger.debug message
    end
  end
end
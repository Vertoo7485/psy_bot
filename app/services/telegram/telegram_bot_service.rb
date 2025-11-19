# app/services/telegram/telegram_bot_service.rb
require 'telegram/bot'
require 'faraday/multipart'

module Telegram
  class TelegramBotService # <--- Обрати внимание на `class` здесь, это важно
    attr_reader :bot # Предоставляем публичный доступ к объекту бота

    def initialize(token)
      @bot = Telegram::Bot::Client.new(token) do |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      end
    end

    # Метод для установки вебхука.
    def set_webhook(url)
      Rails.logger.info "Setting webhook to: #{url}"
      @bot.set_webhook(url: url)
    rescue Telegram::Bot::Error => e
      Rails.logger.error "Failed to set webhook: #{e.message}"
      raise # Перебрасываем исключение, чтобы обработать его на уровне приложения
    end

    # Универсальный метод для отправки сообщений, инкапсулирующий обработку ошибок.
    def send_message(chat_id:, text:, reply_markup: nil, parse_mode: nil)
      Rails.logger.debug "Sending message to #{chat_id}: '#{text.truncate(100)}'"
      @bot.send_message(chat_id: chat_id, text: text, reply_markup: reply_markup, parse_mode: parse_mode)
    rescue Telegram::Bot::Error => e
      Rails.logger.error "Telegram API Error sending message to #{chat_id}: #{e.message}"
    rescue StandardError => e
      Rails.logger.error "Unexpected error sending message to #{chat_id}: #{e.message}"
    end
  end
end

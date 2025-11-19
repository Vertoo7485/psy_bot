# app/controllers/telegram_webhooks_controller.rb
require 'telegram/bot'
require 'json'
require 'faraday/multipart'

class TelegramWebhooksController < ApplicationController
  # Этот before_action инициализирует @bot_service
  before_action :initialize_bot_service

  def message
    process_telegram_update(params)
    render plain: 'OK'
  end

  private

  # Инициализация TelegramBotService
  def initialize_bot_service
    # Здесь вызывается TelegramBotService, который должен быть найден Zeitwerk'ом
    @bot_service = Telegram::TelegramBotService.new(ENV['TELEGRAM_BOT_TOKEN'])
  end

  # Централизованная обработка входящих обновлений от Telegram.
  def process_telegram_update(update_params)
    if update_params[:message]
      handle_message(update_params[:message])
    elsif update_params[:callback_query]
      handle_callback_query(update_params[:callback_query])
    end
  end

  # Обработка обычных текстовых сообщений.
  def handle_message(message_data)
    user = User.find_or_create_from_telegram_message(message_data[:from])
    # Делегируем обработку сообщений MessageProcessor.
    Telegram::MessageProcessor.new(@bot_service.bot, user, message_data).process
  end

  # Обработка нажатий на кнопки (callback queries).
  def handle_callback_query(callback_query_data)
    user = User.find_by(telegram_id: callback_query_data[:from][:id])
    return render plain: 'OK' unless user

    # Передаем @bot_service в CallbackQueryProcessor
    Telegram::CallbackQueryProcessor.new(@bot_service, user, callback_query_data).process
  end
end

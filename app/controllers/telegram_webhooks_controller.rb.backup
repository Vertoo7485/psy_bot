# app/controllers/telegram_webhooks_controller.rb

# ЯВНАЯ ЗАГРУЗКА всех необходимых файлов Telegram
require Rails.root.join('app/services/telegram/telegram_bot_service')
require Rails.root.join('app/services/telegram/callback_query_processor')
require Rails.root.join('app/services/telegram/message_processor')

# Загружаем ВСЕ handlers
Dir.glob(Rails.root.join('app/services/telegram/handlers/**/*.rb')).each do |file|
  require file
end

class TelegramWebhooksController < ApplicationController
  # Для API контроллера CSRF токен не проверяется по умолчанию
  
  before_action :initialize_bot_service

  def message
    process_telegram_update(params)
    render plain: 'OK'
  rescue => e
    Rails.logger.error "Error in Telegram webhook: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    render plain: 'OK' # Всегда возвращаем OK для Telegram
  end

  private

  def initialize_bot_service
    @bot_service = Telegram::TelegramBotService.new(ENV['TELEGRAM_BOT_TOKEN'])
  end

  def process_telegram_update(update_params)
    Rails.logger.info "Processing update: #{update_params.keys}"
    
    if update_params[:message]
      handle_message(update_params[:message])
    elsif update_params[:callback_query]
      handle_callback_query(update_params[:callback_query])
    else
      Rails.logger.warn "Unknown update type: #{update_params.keys}"
    end
  end

  def handle_message(message_data)
    Rails.logger.info "Processing message from: #{message_data[:from][:id]}"
    
    user = User.find_or_create_from_telegram_message(message_data[:from])
    Telegram::MessageProcessor.new(@bot_service.bot, user, message_data).process
  rescue => e
    Rails.logger.error "Failed to handle message: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
  end

  def handle_callback_query(callback_query_data)
    Rails.logger.info "Processing callback query: #{callback_query_data[:data]}"
    
    user = find_user_from_callback(callback_query_data)
    return unless user

    Telegram::CallbackQueryProcessor.new(@bot_service, user, callback_query_data).process
  rescue => e
    Rails.logger.error "Error processing callback query: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
  end

  def find_user_from_callback(callback_query_data)
    telegram_id = callback_query_data.dig(:from, :id)
    return nil unless telegram_id

    User.find_by(telegram_id: telegram_id)
  end
end
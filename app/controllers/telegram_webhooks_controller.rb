# app/controllers/telegram_webhooks_controller.rb
require 'telegram/bot'
require 'json' # Можно убрать, если не используется напрямую в контроллере

class TelegramWebhooksController < ApplicationController
  # Эти хелперы вам не нужны в контроллере, если вы будете использовать
  # прямой путь к файлам или CDN для изображений.
  # Если очень нужно, то их можно инклюдить в сервисный объект,
  # но это усложнит его тестирование.
  # include ActionView::Helpers::AssetUrlHelper
  # include Rails.application.routes.url_helpers

  before_action :set_bot

  def message
    if params[:message]
      user = User.find_or_create_from_telegram_message(params[:message][:from])
      Telegram::MessageProcessor.new(@bot, user, params[:message]).process
    elsif params[:callback_query]
      user = User.find_by(telegram_id: params[:callback_query][:from][:id])
      Telegram::CallbackQueryProcessor.new(@bot, user, params[:callback_query]).process
    end

    render plain: 'OK'
  end

  private

  def set_bot
    @bot = Telegram::Bot::Client.new(ENV['TELEGRAM_BOT_TOKEN'])
  end
end

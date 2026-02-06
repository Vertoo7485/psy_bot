class TelegramWebhooksController < ApplicationController
  before_action :initialize_bot_service
  
  def message
    # Логируем в файл
    log_message("📱 Received: #{params.dig(:message, :text)} from #{params.dig(:message, :from, :id)}")
    
    process_telegram_update(params)
    render plain: 'OK'
  rescue => e
    log_message("🔥 ERROR: #{e.message}\n#{e.backtrace.first}")
    render plain: 'OK'
  end
  
  def callback_query
    log_message("🔘 Callback: #{params.dig(:callback_query, :data)}")
    render plain: 'OK'
  end
  
  private
  
  def initialize_bot_service
    @bot_service = Telegram::TelegramBotService.new(ENV['TELEGRAM_BOT_TOKEN'])
    log_message("🤖 Bot service initialized")
  rescue => e
    log_message("🔥 Bot init ERROR: #{e.message}")
  end
  
  def process_telegram_update(update_params)
    if update_params[:message]
      handle_message(update_params[:message])
    elsif update_params[:callback_query]
      handle_callback_query(update_params[:callback_query])
    end
  end
  
  def handle_message(message_data)
    chat_id = message_data.dig(:chat, :id)
    text = message_data[:text]
    
    log_message("💬 Processing: '#{text}' for chat #{chat_id}")
    
    # Находим или создаем пользователя
    user = User.find_or_create_from_telegram_message(message_data[:from])
    log_message("👤 User: #{user.telegram_id} (#{user.first_name})")
    
    # Обрабатываем сообщение
    Telegram::MessageProcessor.new(@bot_service.bot, user, message_data).process
    log_message("✅ Message processed successfully")
    
  rescue => e
    log_message("🔥 Message processing ERROR: #{e.message}\n#{e.backtrace.first(3).join('\n')}")
  end
  
  def handle_callback_query(callback_query_data)
    log_message("🔘 Processing callback")
    user = find_user_from_callback(callback_query_data)
    return unless user
    
    Telegram::CallbackQueryProcessor.new(@bot_service, user, callback_query_data).process
    log_message("✅ Callback processed")
  rescue => e
    log_message("🔥 Callback ERROR: #{e.message}")
  end
  
  def find_user_from_callback(callback_query_data)
    telegram_id = callback_query_data.dig(:from, :id)
    return nil unless telegram_id
    User.find_by(telegram_id: telegram_id)
  end
  
  def log_message(msg)
    # Пишем в файл
    File.open("/home/deploy/bot_activity.log", "a") do |f|
      f.puts "[#{Time.now.strftime('%H:%M:%S')}] #{msg}"
    end
    # И в STDOUT на всякий случай
    puts "[BOT] #{msg}"
  end
end

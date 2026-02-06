require_relative "../../app/services/telegram_markup_helper"


class TelegramWebhooksController < ApplicationController
  before_action :initialize_bot_service
  
  
  def message
    # ЛОГИРОВАНИЕ ДЛЯ ОТЛАДКИ
    user_id = params.dig(:message, :from, :id) || params.dig(:callback_query, :from, :id) || 'unknown'
    message_text = params.dig(:message, :text) || 'callback'
    
    log_entry = "[#{Time.now}] 👤 User: #{user_id} | Команда: #{message_text}"
    File.write('/home/deploy/bot_requests.log', log_entry + "\n", mode: 'a')
    puts log_entry  # В systemd логи
    
    # Логируем в файл
    log_message("📱 Received: #{message_text} from #{user_id}")
    
    process_telegram_update(params)
    render plain: 'OK'
  rescue => e
    log_message("🔥 ERROR: #{e.message}\n#{e.backtrace.first}")
    render plain: 'OK'
  end
  
    def callback_query
    # ЛОГИРОВАНИЕ CALLBACK ДЛЯ ОТЛАДКИ
    callback_data = params.dig(:callback_query, :data)
    user_id = params.dig(:callback_query, :from, :id)
    callback_id = params.dig(:callback_query, :id)
    
    log_entry = "[#{Time.now}] 🔘 CALLBACK User: #{user_id} | Data: #{callback_data} | ID: #{callback_id}"
    File.write('/home/deploy/bot_requests.log', log_entry + "\n", mode: 'a')
    puts log_entry
    
    begin
      # ИНИЦИАЛИЗИРУЕМ БОТ СЕРВИС
      log_message("1. Инициализация бот сервиса...")
      initialize_bot_service
      log_message("2. Бот сервис инициализирован")
      
      if @bot_service
        log_message("3. Бот сервис доступен")
        # Отвечаем на callback (чтобы кнопка перестала "светиться")
        log_message("4. Отвечаем на callback: #{callback_id}")
        @bot_service.answer_callback_query(callback_query_id: callback_id, text: "Обрабатываю...")
        log_message("5. Ответ отправлен")
        
        # Обрабатываем данные callback
        log_message("6. Обрабатываем данные: #{callback_data}")
        process_callback_data(user_id, callback_data)
        log_message("7. Данные обработаны")
        
        render json: { status: 'ok' }
      else
        log_message("🔥 Bot service not initialized")
        render json: { status: 'error', message: 'Bot service not available' }, status: 500
      end
    rescue => e
      log_message("🔥 Callback processing error: #{e.message}")
      log_message("🔥 Backtrace: #{e.backtrace.first(5).join(' | ')}")
      # Все равно отвечаем Telegram чтобы избежать 502 если можем
      if @bot_service && callback_id
        begin
          @bot_service.answer_callback_query(callback_query_id: callback_id, text: "Произошла ошибка")
        rescue => e2
          log_message("🔥 Не удалось ответить на callback: #{e2.message}")
        end
      end
      render json: { status: 'error', message: e.message }, status: 500
    end
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
    
    # Сначала отвечаем Telegram чтобы кнопка перестала светиться
    callback_id = callback_query_data[:id]
    if callback_id && @bot_service
      begin
        @bot_service.answer_callback_query(callback_query_id: callback_id, text: "Обрабатываю...")
        log_message("✅ Answered callback query: #{callback_id}")
      rescue => e
        log_message("⚠️  Failed to answer callback: #{e.message}")
      end
    end
    
    # Затем обрабатываем callback
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
  
  private
  
  

  def process_callback_data(user_id, data)
    log_message("🔧 Processing callback data: #{data} for user #{user_id}")
    
    case data
    when 'show_test_categories'
      # Используем хелпер для создания меню тестов
      markup_helper = TelegramMarkupHelper
      keyboard = markup_helper.test_categories_markup
      
      @bot_service.send_message(
        chat_id: user_id,
        text: "#{markup_helper::EMOJI[:tests]} *Список тестов:*\n\nВыберите тест для прохождения:",
        reply_markup: keyboard.to_json,
        parse_mode: 'Markdown'
      )
    when 'start_emotion_diary'
      @bot_service.send_message(
        chat_id: user_id, 
        text: "#{TelegramMarkupHelper::EMOJI[:diary]} *Дневник эмоций запущен!*\n\nОпишите ваше текущее состояние или эмоцию:",
        parse_mode: 'Markdown'
      )
    when 'start_self_help_program'
      @bot_service.send_message(
        chat_id: user_id,
        text: "#{TelegramMarkupHelper::EMOJI[:self_help]} *Программа самопомощи*\n\nЭта функция в разработке.",
        parse_mode: 'Markdown'
      )
    when 'help'
      @bot_service.send_message(
        chat_id: user_id,
        text: "#{TelegramMarkupHelper::EMOJI[:help]} *Помощь*\n\nДоступные команды:\n/start - Начать\n/menu - Главное меню\n/tests - Список тестов\n\nИспользуйте кнопки для навигации.",
        parse_mode: 'Markdown'
      )
    when 'back_to_main_menu'
      send_menu(user_id)
    when 'prepare_anxiety_test', 'prepare_depression_test', 'prepare_eq_test', 'prepare_luscher_test'
      test_name = case data
        when 'prepare_anxiety_test' then "Тест Тревожности"
        when 'prepare_depression_test' then "Тест Депрессии (PHQ-9)"
        when 'prepare_eq_test' then "Тест EQ (Эмоциональный Интеллект)"
        when 'prepare_luscher_test' then "Тест Люшера (8 цветов)"
        else "Неизвестный тест"
      end
      emoji = case data
        when 'prepare_anxiety_test' then TelegramMarkupHelper::EMOJI[:brain]
        when 'prepare_depression_test' then TelegramMarkupHelper::EMOJI[:heart]
        when 'prepare_eq_test' then TelegramMarkupHelper::EMOJI[:brain]
        when 'prepare_luscher_test' then TelegramMarkupHelper::EMOJI[:yoga]
        else "🧪"
      end
      @bot_service.send_message(
        chat_id: user_id,
        text: "#{emoji} *Начинаем: #{test_name}*\n\nТест будет запущен в следующем сообщении.",
        parse_mode: 'Markdown'
      )
    else
      @bot_service.send_message(chat_id: user_id, text: "Команда: #{data}")
    end
  end
  def send_menu(user_id)
    # Используем хелпер для создания меню
    markup_helper = TelegramMarkupHelper
    keyboard = markup_helper.main_menu_markup
    
    @bot_service.send_message(
      chat_id: user_id,
      text: "#{markup_helper::EMOJI[:home]} *Главное меню*\n\nВыберите опцию:",
      reply_markup: keyboard.to_json,
      parse_mode: 'Markdown'
    )
  end
  
  private
  
end

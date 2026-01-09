# app/services/telegram/message_processor.rb
module Telegram
  class MessageProcessor
    # Константы
    COMMANDS = {
      '/start' => :handle_start,
      '/menu' => :handle_menu,
      '/help' => :handle_help,
      '/tests' => :handle_tests,
      '/diary' => :handle_diary,
      '/program' => :handle_program,
      '/progress' => :handle_progress
    }.freeze
    
    attr_reader :bot, :user, :message_data
    
    def initialize(bot, user, message_data)
      @bot = bot
      @user = user
      @message_data = message_data
      @chat_id = message_data[:chat][:id]
      @text = message_data[:text].to_s.strip
      
      # Создаем временный bot_service для совместимости
      @bot_service = create_temp_bot_service(@bot)
    end
    
    def process
      log_info("Processing message: #{@text} - User: #{@user.telegram_id}, Chat: #{@chat_id}")
      
      # Проверяем команды
      if command?
        return process_command
      end
      
      # Получаем текущее состояние
      state = @user.self_help_state
      log_info("User state: #{state}")
      
      # Если есть активное состояние, обрабатываем его
      if state.present?
        # Проверяем дневник эмоций
        if @user.current_diary_step.present?
          return handle_emotion_diary_input
        end
        
        # Проверяем программу самопомощи
        if state.include?('day_')
          return handle_self_help_input(state)
        end
      end
      
      # Если ничего не подошло
      log_info("No handler found for message")
      send_message(
        text: "Не понял вашего сообщения. Используйте меню или команды."
      )
      
      false
    end
    
    private
    
    def create_temp_bot_service(bot)
      Class.new do
        def initialize(bot)
          @bot = bot
        end
        
        attr_reader :bot
        
        def send_message(chat_id:, text:, reply_markup: nil, parse_mode: nil, disable_notification: false)
          @bot.send_message(
            chat_id: chat_id,
            text: text,
            reply_markup: reply_markup,
            parse_mode: parse_mode,
            disable_notification: disable_notification
          )
        end
        
        def answer_callback_query(callback_query_id:, text: nil, show_alert: false)
          @bot.answer_callback_query(
            callback_query_id: callback_query_id,
            text: text,
            show_alert: show_alert
          )
        end
        
        def edit_message_text(chat_id:, message_id:, text:, reply_markup: nil, parse_mode: nil)
          @bot.edit_message_text(
            chat_id: chat_id,
            message_id: message_id,
            text: text,
            reply_markup: reply_markup,
            parse_mode: parse_mode
          )
        end
      end.new(bot)
    end
    
    # Проверка, является ли сообщение командой
    def command?
      @text.start_with?('/')
    end
    
    # Обработка команд
    def process_command
      command_key = @text.split(' ').first.downcase
      handler_method = COMMANDS[command_key]
      
      if handler_method
        send(handler_method)
      else
        handle_unknown_command
      end
    end
    
    # Обработка текстовых сообщений
    def process_text_message
      # Проверяем активные сессии пользователя
      if handle_active_sessions
        return
      end
      
      # Обработка по контексту
      handle_context_message
    end
    
    # Обработка активных сессий
    def handle_active_sessions
      # Проверяем дневник эмоций
      if @user.current_diary_step.present?
        handle_emotion_diary_input
        return true
      end
      
      # Проверяем программу самопомощи
      if @user.self_help_state.present?
        # Передаем состояние как параметр
        handle_self_help_input(@user.self_help_state)
        return true
      end
      
      false
    end
    
    # Обработка ввода для дневника эмоций
    def handle_emotion_diary_input
      EmotionDiaryService.new(@bot_service, @user, @chat_id).handle_answer(@text)
    end
    
    # Обработка ввода для программы самопомощи
    def handle_self_help_input(state)
      log_info("Handling self-help input for state: #{state}")
      
      # ВАЖНО: Убираем все специальные проверки для отдельных дней
      # Все обрабатываем через фасад
      
      # Создаем фасад
      facade = SelfHelp::Facade::SelfHelpFacade.new(@bot_service, @user, @chat_id)
      
      # Обрабатываем ввод через фасад
      result = facade.handle_day_input(@text, state)
      
      # Если фасад не смог обработать, показываем сообщение
      unless result
        log_info("Facade couldn't handle input for state: #{state}")
        send_message(
          text: "Пожалуйста, используйте кнопки для навигации или завершите текущий шаг."
        )
      end
      
      result
    end
    
    # Обработка контекстных сообщений
    def handle_context_message
      send_message(
        text: "Не совсем понял ваше сообщение. Пожалуйста, используйте команды меню."
      )
    end
    
    # Обработчики команд
    
    def handle_start
      send_welcome_message
      handle_menu
    end
    
    def handle_menu
      show_main_menu
    end
    
    def handle_help
      send_help_message
    end
    
    def handle_tests
      TestManager.new(@bot, @user, @chat_id).show_categories
    end
    
    def handle_diary
      EmotionDiaryService.new(@bot, @user, @chat_id).start_diary_menu
    end
    
    def handle_program
      facade = SelfHelp::Facade::SelfHelpFacade.new(@bot, @user, @chat_id)
      facade.start_program
    end

    def handle_progress
      log_info("Handling /progress command")
      
      # Используем уже созданный bot_service, а не создаем новый
      handler = Telegram::Handlers::GeneralHandlers::ProgressHandler.new(
        @bot_service,  # ← Используем существующий
        @user, 
        @chat_id, 
        {}  
      )
      
      handler.process
    rescue => e
      log_error("Failed to handle /progress", e)
      send_message(
        text: "Произошла ошибка при получении прогресса. Попробуйте позже."
      )
    end
    
    def handle_unknown_command
      send_message(
        text: "Неизвестная команда. Используйте /help для списка доступных команд."
      )
    end
    
    # Вспомогательные методы
    
    def send_welcome_message
      message = <<~MARKDOWN
        👋 *Добро пожаловать!*

        Я — бот для психологической поддержки и самопомощи.

        Я помогу вам:
        • Пройти психологические тесты
        • Вести дневник эмоций
        • Пройти программу самопомощи
        • Освоить техники управления эмоциями

        Используйте команду /menu для навигации.
      MARKDOWN
      
      send_message(text: message, parse_mode: 'Markdown')
    end
    
    def show_main_menu
      send_message(
        text: "Главное меню. Выберите действие:",
        reply_markup: TelegramMarkupHelper.main_menu_markup
      )
    end
    
    def send_help_message
      message = <<~MARKDOWN
        🆘 *Справка*

        Доступные команды:

        *Основные команды:*
        /start — начать работу с ботом
        /menu — показать главное меню
        /help — показать эту справку

        *Основные функции:*
        /tests — список психологических тестов
        /diary — дневник эмоций
        /program — программа самопомощи

        *Как использовать:*
        1. Выберите нужный раздел из меню
        2. Следуйте инструкциям на экране
        3. Используйте кнопки для навигации

        Если возникли проблемы, попробуйте перезапустить бот командой /start.
      MARKDOWN
      
      send_message(text: message, parse_mode: 'Markdown')
    end
    
    def send_error_message
      send_message(
        text: "Произошла ошибка при обработке вашего сообщения. Пожалуйста, попробуйте еще раз или используйте команду /menu."
      )
    end
    
    # Отправка сообщения через бота
    def send_message(text:, reply_markup: nil, parse_mode: nil, disable_notification: false)
      @bot.send_message(
        chat_id: @chat_id,
        text: text,
        reply_markup: reply_markup,
        parse_mode: parse_mode,
        disable_notification: disable_notification
      )
    rescue Telegram::Bot::Error => e
      log_error("Failed to send message", e)
    end
    
    # Логирование
    def log_info(message)
      Rails.logger.info "[MessageProcessor] #{message} - User: #{@user.telegram_id}, Chat: #{@chat_id}"
    end
    
    def log_error(message, error = nil)
      Rails.logger.error "[MessageProcessor] #{message} - User: #{@user.telegram_id}, Chat: #{@chat_id}"
      Rails.logger.error error.message if error
      Rails.logger.error error.backtrace.join("\n") if error.respond_to?(:backtrace)
    end
  end
end
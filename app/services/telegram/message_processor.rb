# app/services/telegram/message_processor.rb
require Rails.root.join('app/services/telegram/admin_service')

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
      '/progress' => :handle_progress,
      '/admin' => :handle_admin,          # ← ДОБАВЛЯЕМ
      '/access' => :handle_access,
      '/my_subscription' => :handle_my_subscription
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
    
    def handle_admin
  log_info("Processing /admin command")
  
  # Проверяем, является ли пользователь админом
  unless @user.admin?
    send_message(text: "❌ У вас нет прав администратора.")  # ← ИСПРАВЛЕНО
    return
  end
  
  # Используем AdminService для обработки команды
  # Передаем @bot и @message_data (хэш), а не объект Message
  admin_service = Telegram::AdminService.new(@bot, @message_data, @user)
  admin_service.process
  
rescue => e
  log_error("Error in admin command", e)
  send_message(text: "❌ Ошибка при обработке команды администратора: #{e.message}")  # ← ИСПРАВЛЕНО
end
    
    def handle_access
      log_info("Processing /access command")
      
      access_text = "🔐 *Информация о вашем доступе*\n\n"
      access_text += "#{@user.access_info}\n\n"
      
      if @user.admin?
        access_text += "👑 Вы администратор системы\n"
        access_text += "Используйте `/admin help` для управления пользователями\n"
        
      elsif @user.premium?
        if @user.trial_active?
          days_left = @user.days_until_trial_ends
          access_text += "🎁 *Пробный период активен*\n"
          access_text += "Осталось дней: #{days_left}\n"
          access_text += "Завершается: #{@user.trial_ends_at.strftime('%d.%m.%Y')}\n\n"
          
          if days_left <= 1
            access_text += "⚠️ Пробный период заканчивается скоро!\n"
            access_text += "Для продолжения программы самопомощи обратитесь к администратору после истечения trial.\n"
          end
          
        elsif @user.subscription_active?
          days_left = @user.days_until_subscription_ends
          access_text += "⭐️ *Премиум подписка активна*\n"
          access_text += "Осталось дней: #{days_left}\n"
          access_text += "Завершается: #{@user.subscription_ends_at.strftime('%d.%m.%Y')}\n\n"
          
          if days_left <= 3
            access_text += "⚠️ Подписка заканчивается скоро!\n"
            access_text += "Для продления обратитесь к администратору.\n"
          end
          
        else
          access_text += "❌ Премиум доступ не активен\n"
          access_text += "Обратитесь к администратору для активации.\n"
        end
        
        access_text += "\n✅ Вам доступна вся программа самопомощи (28 дней)"
        
      else
        access_text += "🆓 *Бесплатный доступ*\n\n"
        access_text += "Вам доступны:\n"
        access_text += "• 📋 Все психологические тесты\n"
        access_text += "• 📔 Дневник эмоций\n\n"
        access_text += "Для доступа к программе самопомощи (28 дней) необходим премиум доступ.\n"
        access_text += "Новые пользователи получают 3 дня пробного периода автоматически.\n"
      end
      
      # Кнопки действий
      markup = if @user.admin?
        {
          inline_keyboard: [
            [{ text: "👑 Админ-панель", callback_data: "admin:help" }],
            [{ text: "📊 Статистика", callback_data: "admin:stats" }],
            [{ text: "🏠 Главное меню", callback_data: "back_to_main_menu" }]
          ]
        }
      elsif @user.can_access_self_help_program?
        {
          inline_keyboard: [
            [{ text: "⭐️ Начать программу", callback_data: "start_self_help_program" }],
            [{ text: "📋 Тесты", callback_data: "show_test_categories" }],
            [{ text: "🏠 Главное меню", callback_data: "back_to_main_menu" }]
          ]
        }
      else
        {
          inline_keyboard: [
            [{ text: "📋 Тесты", callback_data: "show_test_categories" }],
            [{ text: "📔 Дневник", callback_data: "start_emotion_diary" }],
            [{ text: "🏠 Главное меню", callback_data: "back_to_main_menu" }]
          ]
        }
      end.to_json
      
      send_message(text: access_text, parse_mode: 'Markdown', reply_markup: markup)
    end
    
    def show_admin_help
  help_text = "👑 *Админ-панель*\n\n" \
              "Используйте команды:\n" \
              "`/admin help` - эта справка\n" \
              "`/admin users` - список пользователей\n" \
              "`/admin user @username` - информация о пользователе\n" \
              "`/admin activate @username` - активировать премиум\n" \
              "`/admin deactivate @username` - деактивировать\n" \
              "`/admin trial @username` - установить trial\n" \
              "`/admin stats` - статистика\n" \
              "`/admin search имя` - поиск\n\n" \
              "Или используйте кнопки ниже:"
  
  markup = {
    inline_keyboard: [
      [
        { text: "👥 Пользователи", callback_data: "admin:users" },
        { text: "📊 Статистика", callback_data: "admin:stats" }
      ],
      [
        { text: "🔍 Поиск", callback_data: "admin:search" },
        { text: "🆘 Справка", callback_data: "admin:help" }
      ],
      [
        { text: "🏠 Главное меню", callback_data: "back_to_main_menu" }
      ]
    ]
  }.to_json
  
  send_message(text: help_text, parse_mode: 'Markdown', reply_markup: markup)
end


    def handle_my_subscription
      user.reload
      
      if user.has_active_premium?
        days_left = (user.subscription_ends_at.to_date - Date.today).to_i
        send_message(
          text: "🌟 У вас активна премиум-подписка!\n" \
                "📅 Действует до: #{user.subscription_ends_at.strftime('%d.%m.%Y')}\n" \
                "⏳ Осталось дней: #{days_left}\n\n" \
                "Спасибо, что с нами! 🚀"
        )
      else
        send_message(
          text: "У вас нет активной премиум-подписки.\n\n" \
                "🚀 Премиум-подписка дает:\n" \
                "• Безлимитные запросы к GPT-4\n" \
                "• Расширенную историю диалогов\n" \
                "• Приоритетная обработку\n\n" \
                "Нажмите /premium для оформления!"
        )
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
  if @user.can_access_self_help_program?
    message = <<~MARKDOWN
      🎊 *С возвращением в пространство осознанного развития, #{@user.first_name}!* 🎊

      **Рад снова видеть вас на пути психологической трансформации!** 🧭

      📊 *Научные основания вашего прогресса:*
      
      🧠 **Нейропластичность в действии:**
      • 🔬 Каждая практика осознанности укрепляет нейронные связи префронтальной коры
      • 🧩 Регулярные упражнения увеличивают объем серого вещества в гиппокампе
      • 🌉 Формируются новые нейронные пути для эмоциональной регуляции
      
      📈 **Ваши достижения отражаются в мозге:**
      1. ✅ Снижение активности миндалины (центра страха) на 15-20%
      2. ✅ Усиление связи между префронтальной корой и лимбической системой
      3. ✅ Улучшение когнитивного контроля над эмоциональными реакциями
      4. ✅ Увеличение плотности серого вещества уже через 8 недель практики

      🎯 *ПОЛНЫЙ ДОСТУП АКТИВИРОВАН:*
      • ⭐️ Программа самопомощи (28 дней научно-обоснованных практик)
      • 📋 Все психометрические тесты с клинической валидностью
      • 📔 Дневник эмоций с аналитикой и отслеживанием динамики
      
      📊 *ВАШ СТАТУС:* #{@user.access_info}

      🚀 *РЕКОМЕНДУЕМЫЕ ДЕЙСТВИЯ:*
      1. Нажмите /program — продолжить трансформацию по дням
      2. Нажмите /tests — углубить самопознание через валидированные методики
      3. Нажмите /diary — зафиксировать текущее эмоциональное состояние
      4. Нажмите /progress — увидеть вашу динамику и достижения

      *Каждая осознанная практика — это инвестиция в архитектуру вашего мозга!* 💎
    MARKDOWN
    
  elsif @user.free?
    message = <<~MARKDOWN
      🌈 *ДОБРО ПОЖАЛОВАТЬ В ЭМПИРИЧЕСКО ОБОСНОВАННУЮ ПСИХОЛОГИЧЕСКУЮ ПРАКТИКУ!* 🌈

      **#{@user.first_name}, я — ваш научно-обоснованный компаньон в исследовании внутреннего мира!** 🔬

      🎯 *ЧТО ГОВОРИТ НАУКА О ПСИХОЛОГИЧЕСКОМ РОСТЕ:*
      
      🧬 **Нейробиологические основы:**
      • 🧠 Мозг сохраняет способность к изменениям в любом возрасте (нейропластичность)
      • 🔄 Регулярная практика формирует устойчивые нейронные паттерны
      • 💡 Осознанность изменяет структуру и функцию мозга уже через 8 недель
      
      📚 **Эмпирически подтвержденные методы:**
      1. 🧘 Когнитивно-поведенческие техники (КПТ) — золотой стандарт в психотерапии
      2. 📝 Экспрессивное письмо — снижение стресса на 23-47% (исследования Пеннебейкера)
      3. 🌬️ Дыхательные практики — активация парасимпатической нервной системы
      4. 🤔 Метакогнитивная терапия — работа с отношениями к мыслям

      🎁 *СПЕЦИАЛЬНОЕ ПРЕДЛОЖЕНИЕ ДЛЯ НОВЫХ УЧАСТНИКОВ:*
      **3 ДНЯ ПОЛНОГО ДОСТУПА К ПРОГРАММЕ САМОПОМОЩИ — БЕСПЛАТНО!** 🎉

      📊 *ВАШ ТЕКУЩИЙ СТАТУС:* #{@user.access_info}

      🔬 *ДОСТУПНЫЕ ИНСТРУМЕНТЫ ПРЯМО СЕЙЧАС:*
      
      📋 *ПСИХОМЕТРИЧЕСКИЕ ТЕСТЫ* (клинически валидизированы):
      • 🧪 Шкала тревожности (GAD-7) — чувствительность 89%, специфичность 82%
      • 🧪 Шкала депрессии (PHQ-9) — AUC 0.95, стандарт в клинической практике
      • 🧪 Тест эмоционального интеллекта (на основе MSCEIT)
      • 🎨 Цветовой тест Люшера — проективная методика
      
      📔 *ДНЕВНИК ЭМОЦИЙ* (с научным подходом):
      • 📊 Треккинг эмоций по шкале от 1 до 10
      • 🧩 Анализ паттернов и триггеров
      • 📈 Визуализация динамики состояния
      • 🔍 Связь с физиологическими симптомами

      ⭐️ *ПРОГРАММА САМОПОМОЩИ* (28 дней эмпирически обоснованных практик):
      • 🧬 День 1-7: Основы нейропластичности и внимательности
      • 🧠 День 8-14: Когнитивная реструктуризация (методы КПТ)
      • 💖 День 15-21: Эмоциональная регуляция и resilience
      • 🏆 День 22-28: Интеграция и поддержание изменений

      🚀 *ОПТИМАЛЬНЫЙ СТАРТ ДЛЯ МАКСИМАЛЬНОЙ ЭФФЕКТИВНОСТИ:*
      1. Нажмите /menu — системная навигация по всем инструментам
      2. Пройдите /tests — получите базовые метрики для отслеживания прогресса
      3. Начните /diary — создайте baseline вашего эмоционального состояния
      4. Активируйте пробный период через /access — получите полный доступ к трансформации

      *Ваш мозг ждет новых нейронных связей — начните строить их сегодня!* 🧩
    MARKDOWN
    
  else
    message = <<~MARKDOWN
      🧪 *ДОБРО ПОЖАЛОВАТЬ В ЛАБОРАТОРИЮ САМОПОЗНАНИЯ!* 🧪

      **Я — ваш научный ассистент в исследовании внутренней вселенной.** 🔭

      🎯 *ОСНОВАН НА ДОКАЗАТЕЛЬНОЙ ПСИХОЛОГИИ:*
      
      📊 **Эмпирическая база:**
      • 🔬 Все методики имеют научное обоснование и клиническую валидность
      • 📈 Подход основан на когнитивно-поведенческой терапии (КПТ) — золотом стандарте
      • 🧪 Интеграция методов третьей волны КПТ: Mindfulness, ACT, DBT
      
      🧬 **Нейробиологический механизм:**
      1. 🧠 Префронтальная кора — сознательный контроль и планирование
      2. 🧠 Лимбическая система — эмоциональные реакции и память
      3. 🧠 Миндалевидное тело — обработка страха и угроз
      4. 🔄 Нейропластичность — основа для устойчивых изменений

      🛠️ *ИНСТРУМЕНТАРИЙ ДЛЯ СИСТЕМНОЙ РАБОТЫ:*

      1. 📋 *ПСИХОМЕТРИЧЕСКИЕ ИЗМЕРЕНИЯ*
         • Валидизированные шкалы с известной чувствительностью и специфичностью
         • Точная оценка текущего состояния
         • Бенчмарки для отслеживания прогресса

      2. 📔 *ЭМОЦИОНАЛЬНЫЙ МОНИТОРИНГ*
         • Систематическое отслеживание аффективных состояний
         • Выявление паттернов и триггеров
         • Научный подход к самопознанию

      3. ⭐️ *СТРУКТУРИРОВАННАЯ ТРАНСФОРМАЦИЯ*
         • 28-дневная программа с поэтапным развитием навыков
         • Основана на принципах доказательной психологии
         • Интеграция знаний в повседневную жизнь

      🧭 *НАЧАЛО ИССЛЕДОВАНИЯ:*
      1. /menu — карта лаборатории с навигацией
      2. /access — информация о доступных инструментах и возможностях
      3. /help — методологическое руководство по использованию
      4. /start — перезагрузка исследовательской сессии

      *Каждое взаимодействие — это эксперимент по познанию себя. Давайте начнем!* 🧫
    MARKDOWN
  end
  
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

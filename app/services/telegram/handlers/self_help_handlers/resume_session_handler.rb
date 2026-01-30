# app/services/telegram/handlers/resume_session_handler.rb

module Telegram
  module Handlers
    class ResumeSessionHandler < BaseHandler
      def process
        log_info("Resuming self-help program session")
        
        # 🔒 ШАГ 1: ПРОВЕРКА ДОСТУПА (главная защита)
        check_user_access!
        return if @access_denied  # Если доступ запрещен - выходим
        
        # ШАГ 2: Получаем текущее состояние пользователя
        current_state = @user.self_help_state
        
        if current_state.blank? || current_state == 'program_started'
          handle_no_active_state
          return
        end
        
        log_info("Resuming from state: #{current_state}")
        
        # ШАГ 3: Определяем тип состояния и обрабатываем
        handle_state_based_on_type(current_state)
        
      rescue => e
        log_error("Error resuming session", e)
        handle_resume_error
      end
      
      private
      
      # 🔒 МЕТОД ПРОВЕРКИ ДОСТУПА
      def check_user_access!
        begin
          access_service = AccessControlService.new(@user)
          access_service.check_self_help_access!
          @access_denied = false
        rescue AccessControlService::AccessDeniedError => e
          @access_denied = true
          send_access_denied_message(e)
          answer_callback_query("❌ Доступ ограничен")
        end
      end
      
      # 📋 ОБРАБОТКА РАЗНЫХ ТИПОВ СОСТОЯНИЙ
      def handle_state_based_on_type(state)
        case
        when state.match?(/^day_\d+_/)
          handle_day_state(state)
        when state.match?(/^awaiting_day_\d+_start$/)
          handle_awaiting_day_state(state)
        when state.in?(%w[awaiting_anxiety_test_completion taking_anxiety_test])
          handle_anxiety_test_state
        else
          handle_unknown_state(state)
        end
      end
      
      # 📅 ОБРАБОТКА СОСТОЯНИЙ ДНЕЙ
      def handle_day_state(state)
        day_number = extract_day_number(state)
        
        unless day_number
          log_warn("Cannot extract day number from state: #{state}")
          handle_unknown_state(state)
          return
        end
        
        # Создаем сервис дня
        service = create_day_service(day_number)
        
        # Определяем какой метод вызвать
        action_method = determine_action_method(state)
        
        # Вызываем соответствующий метод
        case action_method
        when :deliver_content
          service.deliver_content
        when :continue_content
          service.continue_content
        when :handle_exercise_completion
          service.handle_exercise_completion
        else
          # По умолчанию начинаем день заново
          service.deliver_content
        end
        
        answer_callback_query("🔄 Восстанавливаем сессию...")
      end
      
      # 🎯 ОПРЕДЕЛЕНИЕ МЕТОДА ДЛЯ ВЫЗОВА
      def determine_action_method(state)
        case state
        when /_intro$/
          :deliver_content
        when /_exercise_in_progress$/
          :continue_content
        when /_waiting_for_input$/
          :continue_content  # Просто продолжаем упражнение
        when /_completed$/
          :handle_exercise_completion
        else
          :deliver_content  # По умолчанию
        end
      end
      
      # 🔧 ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ
      def extract_day_number(state)
        match = state.match(/day_(\d+)_/)
        match ? match[1].to_i : nil
      end
      
      def create_day_service(day_number)
        service_class = "SelfHelp::Days::Day#{day_number}Service".constantize
        service_class.new(@bot_service, @user, @chat_id)
      end
      
      # 📝 СОСТОЯНИЕ "ОЖИДАНИЕ ДНЯ"
      def handle_awaiting_day_state(state)
        day_number = state.match(/awaiting_day_(\d+)_start$/)[1].to_i
        
        message = <<~MARKDOWN
          📅 *День #{day_number}*
          
          Вы остановились перед началом этого дня.
          Готовы начать?
        MARKDOWN
        
        send_message(
          text: message,
          parse_mode: 'Markdown',
          reply_markup: TelegramMarkupHelper.day_start_proposal_markup(day_number)
        )
      end
      
      # 🧪 СОСТОЯНИЕ ТЕСТА ТРЕВОЖНОСТИ
      def handle_anxiety_test_state
        message = <<~MARKDOWN
          🔄 *Восстанавливаю сессию*
          
          Вы остановились на этапе теста на тревожность.
          
          Хотите продолжить тест?
        MARKDOWN
        
        markup = {
          inline_keyboard: [
            [{ text: "✅ Продолжить тест", callback_data: 'start_anxiety_test_from_sequence' }],
            [{ text: "➡️ Пропустить тест", callback_data: 'no_anxiety_test_sequence' }]
          ]
        }.to_json
        
        send_message(
          text: message,
          parse_mode: 'Markdown',
          reply_markup: markup
        )
      end
      
      # ❌ СООБЩЕНИЯ ОБ ОШИБКАХ
      def handle_no_active_state
        send_message(
          text: "Не найдено активное состояние для продолжения. Начните программу.",
          reply_markup: TelegramMarkupHelper.self_help_program_markup
        )
      end
      
      def handle_unknown_state(state)
        log_warn("Unknown state for resumption: #{state}")
        send_message(
          text: "Не удалось восстановить сессию. Начните день заново.",
          reply_markup: TelegramMarkupHelper.main_menu_markup
        )
      end
      
      def handle_resume_error
        send_message(
          text: "Ошибка восстановления сессии. Начните день заново.",
          reply_markup: TelegramMarkupHelper.main_menu_markup
        )
      end
      
      # 🔒 СООБЩЕНИЯ О ЗАПРЕТЕ ДОСТУПА
      def send_access_denied_message(error)
        text = case error
        when AccessControlService::NotPremiumError
          "🔒 *Доступ к программе самопомощи*\n\n#{error.message}"
        when AccessControlService::TrialExpiredError
          "⏰ *Пробный период завершен*\n\n#{error.message}"
        when AccessControlService::SubscriptionExpiredError
          "📅 *Подписка истекла*\n\n#{error.message}"
        else
          "❌ *Доступ ограничен*\n\n#{error.message}"
        end
        
        markup = {
          inline_keyboard: [
            [
              { text: "📋 Тесты", callback_data: 'show_test_categories' },
              { text: "📔 Дневник", callback_data: 'start_emotion_diary' }
            ],
            [
              { text: "ℹ️ О программе", callback_data: 'self_help_info' },
              { text: "👑 Админ", callback_data: 'contact_admin' }
            ],
            [
              { text: "🏠 Главное меню", callback_data: 'back_to_main_menu' }
            ]
          ]
        }.to_json
        
        send_message(
          text: text,
          parse_mode: 'Markdown',
          reply_markup: markup,
          save_progress: false
        )
      end
    end
  end
end
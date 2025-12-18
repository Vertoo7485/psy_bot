module Telegram
  module Handlers
    class ResumeSessionHandler < BaseHandler
      def process
        log_info("Resuming self-help program session")
        
        # Получаем текущее состояние пользователя
        current_state = @user.self_help_state
        
        if current_state.blank? || current_state == 'program_started'
          log_warn("No active state to resume", state: current_state)
          send_message(
            text: "Не найдено активное состояние для продолжения. Начинаем программу.",
            reply_markup: TelegramMarkupHelper.main_menu_markup
          )
          return
        end
        
        log_info("Resuming from state: #{current_state}")
        
        # Обрабатываем разные состояния напрямую
        handle_state_resumption(current_state)
        
        answer_callback_query("Продолжаем с того места, где остановились...")
        
      rescue => e
        log_error("Error resuming session", e)
        send_message(
          text: "Не удалось восстановить сессию. Начинаем программу заново.",
          reply_markup: TelegramMarkupHelper.main_menu_markup
        )
      end
      
      private
      
      def handle_state_resumption(state)
        case state
        when 'awaiting_anxiety_test_completion', 'taking_anxiety_test'
          handle_anxiety_test_resumption
        when /^awaiting_day_(\d+)_start$/
          # ДОБАВЛЯЕМ ЭТОТ КЕЙС!
          handle_awaiting_day_start($1.to_i)
        when /^day_(\d+)_.*/
          day_number = state.match(/day_(\d+)_/)[1].to_i
          handle_day_resumption(day_number)
        else
          log_warn("Unknown state for resumption: #{state}")
          # Вместо start_program_fresh, просто предлагаем начать день 1
          handle_day_resumption(1)
        end
      end

      def handle_awaiting_day_start(day_number)
        log_info("User is awaiting day #{day_number} start")
        
        # Просто предлагаем начать день
        send_message(
          text: "📅 *День #{day_number}*\n\nГотовы начать следующий день?",
          parse_mode: 'Markdown',
          reply_markup: TelegramMarkupHelper.day_start_proposal_markup(day_number)
        )
        
        log_info("Successfully handled awaiting_day_#{day_number}_start")
      end
      
      def handle_anxiety_test_resumption
        log_info("Resuming anxiety test")
        
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
      
      def handle_day_resumption(day_number)
        log_info("Resuming day #{day_number}")
        
        # Пытаемся использовать фасад
        begin
          require Rails.root.join('app/services/self_help/facade/self_help_facade') unless defined?(SelfHelp::Facade::SelfHelpFacade)
          
          facade = SelfHelp::Facade::SelfHelpFacade.new(@bot_service, @user, @chat_id)
          
          if facade.respond_to?(:deliver_day) && facade.deliver_day(day_number)
            log_info("Successfully resumed day #{day_number} via facade")
            return
          end
        rescue => e
          log_error("Failed to use facade for day #{day_number}", e)
        end
        
        # Если фасад не сработал, используем прямой подход
        send_message(
          text: "📅 *День #{day_number}*\n\nПродолжаем с того места, где остановились...",
          parse_mode: 'Markdown',
          reply_markup: TelegramMarkupHelper.day_start_proposal_markup(day_number)
        )
      end
      
      def start_program_fresh
        log_info("Starting program fresh after failed resumption")
        
        # Просто предлагаем начать программу с тестов
        begin
          require Rails.root.join('app/services/self_help/program_starter') unless defined?(SelfHelp::ProgramStarter)
          
          starter = SelfHelp::ProgramStarter.new(@bot_service, @user, @chat_id)
          starter.start
          
          log_info("Successfully started fresh program via ProgramStarter")
        rescue => e
          log_error("Failed to start program via ProgramStarter", e)
          
          # Простой fallback
          send_message(
            text: "🏁 *Начинаем программу самопомощи* 🏁\n\nДля начала пройдем небольшие тесты.",
            parse_mode: 'Markdown',
            reply_markup: {
              inline_keyboard: [
                [{ text: "✅ Начать тестирование", callback_data: 'start_self_help_program_tests' }]
              ]
            }.to_json
          )
        end
      end
    end
  end
end
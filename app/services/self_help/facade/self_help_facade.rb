# app/services/self_help/facade/self_help_facade.rb
module SelfHelp
  module Facade
    class SelfHelpFacade
      # Карта соответствия номеров дней и классов сервисов
      DAY_SERVICES = {
        1 => Days::Day1Service,
        2 => Days::Day2Service,
        3 => Days::Day3Service,
        4 => Days::Day4Service,
        5 => Days::Day5Service,
        6 => Days::Day6Service,
        7 => Days::Day7Service,
        8 => Days::Day8Service,
        9 => Days::Day9Service,
        10 => Days::Day10Service,
        11 => Days::Day11Service,
        12 => Days::Day12Service,
        13 => Days::Day13Service
      }.freeze
      
      # Максимальное количество дней в программе
      MAX_DAYS = 13
      
      attr_reader :bot_service, :bot, :user, :chat_id
      
      def initialize(bot_or_service, user, chat_id)
        @user = user
        @chat_id = chat_id
        
        # Определяем тип объекта
        if bot_or_service.respond_to?(:bot)
          # Это bot_service (TelegramBotService)
          @bot_service = bot_or_service
          @bot = @bot_service.bot
        elsif bot_or_service.respond_to?(:send_message)
          # Это сам bot (Telegram::Bot::Client)
          @bot = bot_or_service
          @bot_service = create_bot_service_wrapper(@bot)
        else
          raise ArgumentError, "Expected TelegramBotService or Telegram::Bot::Client, got #{bot_or_service.class}"
        end
      end
      
      # Основные публичные методы
      
      # Запуск программы самопомощи
      def start_program
        ProgramStarter.new(@bot_service, @user, @chat_id).start
      end
      
      # Запуск последовательности тестов
      def start_tests_sequence
        TestSequenceManager.new(@bot_service, @user, @chat_id).start
      end
      
      # Доставка контента дня
      def deliver_day(day_number)
        service = day_service_for(day_number)
        return false unless service
        
        service.deliver_content
        true
      rescue => e
        log_error("Failed to deliver day #{day_number}", e)
        false
      end
      
      # Продолжение дня
      def continue_day(day_number)
        service = day_service_for(day_number)
        return false unless service
        
        service.continue_content
        true
      rescue => e
        log_error("Failed to continue day #{day_number}", e)
        false
      end
      
      # Завершение упражнения дня
      def complete_day_exercise(day_number)
        service = day_service_for(day_number)
        return false unless service
        
        service.handle_exercise_completion
        true
      rescue => e
        log_error("Failed to complete day #{day_number} exercise", e)
        false
      end
      
      # Завершение дня полностью
      def complete_day(day_number)
        service = day_service_for(day_number)
        return false unless service
        
        service.complete_day
        true
      rescue => e
        log_error("Failed to complete day #{day_number}", e)
        false
      end
      
      # Восстановление сессии из состояния
      def resume_from_state(state)
        # Извлекаем номер дня из состояния
        day_number = extract_day_number_from_state(state)
        return false unless day_number
        
        service = day_service_for(day_number)
        return false unless service
        
        service.resume_session
        true
      rescue => e
        log_error("Failed to resume from state #{state}", e)
        false
      end
      
      # Обработка специальных ответов
      def handle_response(response_type)
        ResponseHandler.new(@bot_service, @user, @chat_id).handle(response_type)
      end
      
      # Обработка завершения теста
      def handle_test_completion(test_type)
        case test_type.to_sym
        when :depression
          # После теста на депрессию спрашиваем про тест на тревожность
          offer_anxiety_test
        when :anxiety
          # После теста на тревожность переходим к дню 1
          @user.set_self_help_step('awaiting_day_1_start')
          deliver_day(1)
        else
          log_error("Unknown test type for completion: #{test_type}")
          false
        end
      end

      def offer_anxiety_test
        log_info("Offering anxiety test to user")
        
        message = <<~MARKDOWN
          ✅ *Тест на депрессию завершен!*

          Теперь пройдем тест на тревожность.
          Это поможет получить более полную картину.
        MARKDOWN
        
        markup = {
          inline_keyboard: [
            [{ text: "✅ Пройти тест на тревожность", callback_data: 'start_anxiety_test_from_sequence' }],
            [{ text: "➡️ Пропустить тест", callback_data: 'no_anxiety_test_sequence' }]
          ]
        }.to_json
        
        @bot_service.send_message(
          chat_id: @chat_id,
          text: message,
          parse_mode: 'Markdown',
          reply_markup: markup
        )
        
        # Устанавливаем состояние ожидания теста на тревожность
        @user.set_self_help_step('awaiting_anxiety_test_completion')
        
        true
      end

      def skip_anxiety_test
        log_info("Skipping anxiety test, moving to day 1")
        
        # Устанавливаем состояние перехода к дню 1
        @user.set_self_help_step('awaiting_day_1_start')
        
        # Запускаем день 1
        deliver_day(1)
        
        true
      end
      
      # Обработка ввода для активного дня
      def handle_day_input(text, state)
        day_number = extract_day_number_from_state(state)
        return false unless day_number
        
        service = day_service_for(day_number)
        return false unless service
        
        # Делегируем обработку ввода соответствующему сервису
        handle_day_specific_input(service, text, state)
      end
      
      # Очистка и перезапуск программы
      def clear_and_restart
        # Очищаем все данные программы
        @user.clear_self_help_program_data
        
        # Очищаем активную сессию
        @user.active_session&.destroy
        
        # Очищаем незавершенные тесты
        TestResult.where(user: @user, completed_at: nil).destroy_all
        
        # Сбрасываем состояние пользователя
        @user.update(
          self_help_program_step: nil,
          current_diary_step: nil,
          diary_data: {}
        )
        
        log_info("Cleared all program data for restart")
        
        # Запускаем программу заново
        start_program
      end
      
      # Завершение программы
      def complete_program
        @user.clear_self_help_program_data
        @user.active_session&.destroy
        
        message = <<~MARKDOWN
          🎊 *Программа самопомощи завершена!* 🎊

          Вы прошли 13-дневный путь развития. Все инструменты остаются в вашем распоряжении!
        MARKDOWN
        
        @bot_service.send_message(
          chat_id: @chat_id,
          text: message,
          parse_mode: 'Markdown',
          reply_markup: TelegramMarkupHelper.main_menu_markup
        )
      end
      
      # Проверка, может ли пользователь начать день
      def can_start_day?(day_number)
        return false unless valid_day_number?(day_number)
        
        DayStateChecker.new(@user).can_start_day?(day_number)
      end
      
      # Получение текущего номера дня
      def current_day_number
        @user.current_day_number
      end
      
      private

      def create_bot_service_wrapper(bot)
        # Создаем обертку вокруг bot
        Class.new do
          def initialize(bot)
            @bot = bot
          end
          
          attr_reader :bot
          
          def send_message(chat_id:, text:, reply_markup: nil, parse_mode: nil)
            @bot.send_message(
              chat_id: chat_id,
              text: text,
              reply_markup: reply_markup,
              parse_mode: parse_mode
            )
          end
          
          def answer_callback_query(callback_query_id:, text: nil, show_alert: false)
            @bot.answer_callback_query(
              callback_query_id: callback_query_id,
              text: text,
              show_alert: show_alert
            )
          end
          
          # Добавьте другие методы по мере необходимости
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
      
      # Создание сервиса дня
      def day_service_for(day_number)
        return nil unless valid_day_number?(day_number)
        
        service_class = DAY_SERVICES[day_number]
        return nil unless service_class
        
        service_class.new(@bot_service, @user, @chat_id)
      end
      
      # Обработка ввода для конкретного дня
      def handle_day_specific_input(service, text, state)
        case state
        when 'day_3_waiting_for_gratitude'
          service.handle_gratitude_input(text)
        when 'day_7_waiting_for_reflection'
          service.handle_reflection_input(text)
        when 'day_9_waiting_for_thought'
          service.handle_thought_input(text)
        when 'day_9_waiting_for_probability'
          service.handle_probability_input(text)
        when 'day_9_waiting_for_facts_pro'
          service.handle_facts_pro_input(text)
        when 'day_9_waiting_for_facts_con'
          service.handle_facts_con_input(text)
        when 'day_9_waiting_for_reframe'
          service.handle_reframe_input(text)
        when 'day_11_exercise_in_progress'
          service.handle_grounding_input(text)
        when 'day_12_exercise_in_progress'
          service.handle_self_compassion_input(text)
        when 'day_13_exercise_in_progress'
          service.handle_procrastination_input(text)
        
        # ИЗМЕНЕНИЕ 1: Добавляем обработку для дня 10
        when 'day_10_exercise_in_progress'
          handle_day_10_emotion_diary_input(text, service)
        else
          # Проверяем, не находится ли пользователь в процессе заполнения дневника для дня 10
          if @user.get_self_help_data('is_filling_emotion_diary') == true
            handle_day_10_emotion_diary_input(text, service)
          else
            false
          end
        end
      end

      # ИЗМЕНЕНИЕ 2: Новый метод для обработки ввода дневника эмоций в день 10
      def handle_day_10_emotion_diary_input(text, day_service)
        # Проверяем, есть ли последовательный сервис для дня 10
        if defined?(Days::EmotionDiarySequenceService)
          sequence_service = Days::EmotionDiarySequenceService.new(@bot_service, @user, @chat_id)
          sequence_service.handle_answer(text)
          true
        else
          # Если нет последовательного сервиса, используем стандартный
          if day_service.respond_to?(:handle_text_input)
            day_service.handle_text_input(text)
          else
            log_error("Day10Service doesn't have handle_text_input method")
            false
          end
        end
      rescue => e
        log_error("Failed to handle day 10 emotion diary input", e)
        false
      end
      
      # Извлечение номера дня из состояния
      def extract_day_number_from_state(state)
        return nil unless state
        
        match = state.match(/day_(\d+)_/)
        return nil unless match
        
        day_number = match[1].to_i
        valid_day_number?(day_number) ? day_number : nil
      end
      
      # Проверка валидности номера дня
      def valid_day_number?(day_number)
        day_number.is_a?(Integer) && day_number >= 1 && day_number <= MAX_DAYS
      end
      
      # Логирование
      def log_info(message)
        Rails.logger.info "[SelfHelpFacade] #{message} - User: #{@user.telegram_id}"
      end
      
      def log_error(message, error = nil)
        Rails.logger.error "[SelfHelpFacade] #{message} - User: #{@user.telegram_id}"
        Rails.logger.error error.message if error
        Rails.logger.error error.backtrace.join("\n") if error
      end
    end
  end
end
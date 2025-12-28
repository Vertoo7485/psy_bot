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
        13 => Days::Day13Service,
        14 => Days::Day14Service,
        15 => Days::Day15Service,
        16 => Days::Day16Service,
        17 => Days::Day17Service,
        18 => Days::Day18Service,
        19 => Days::Day19Service,
        20 => Days::Day20Service,
        21 => Days::Day21Service,
        22 => Days::Day22Service
      }.freeze
      
      # Максимальное количество дней в программе
      MAX_DAYS = 28
      
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
      # app/services/self_help/facade/self_help_facade.rb

def handle_day_specific_input(service, text, state)
  log_info("Handling day specific input - State: #{state}, Text: #{text.truncate(50)}")
  log_info("=== START handle_day_specific_input ===")
  log_info("State: #{state}")
  log_info("Text: #{text}")
  log_info("Service class: #{service.class}")
  log_info("Day 19 step: #{@user.get_self_help_data('day_19_current_step')}")
  log_info("User self_help_state: #{@user.self_help_state}")
  
  # ВРЕМЕННЫЙ ФИКС: Если пользователь в дне 22, обрабатываем только день 22
  if state == 'day_22_exercise_in_progress'
    log_info("Processing day 22 input specifically")
    if service.respond_to?(:handle_text_input)
      return service.handle_text_input(text)
    elsif service.respond_to?(:handle_smart_input)
      return service.handle_smart_input(text)
    else
      log_error("Day 22 service doesn't have handle_text_input method")
      return false
    end
  end
  
  # Основная логика обработки по состоянию
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
  when 'day_14_exercise_in_progress'
    if service.respond_to?(:handle_reflection_input)
      service.handle_reflection_input(text)
    else
      log_error("Day 14 service doesn't have handle_reflection_input method")
      false
    end
  when 'day_15_exercise_in_progress'
    if service.respond_to?(:handle_kindness_input)
      service.handle_kindness_input(text)
    else
      log_error("Day 15 service doesn't have handle_kindness_input method")
      false
    end
  when 'day_16_exercise_in_progress'
    if service.respond_to?(:handle_connection_input)
      service.handle_connection_input(text)
    else
      log_error("Day 16 service doesn't have handle_connection_input method")
      false
    end
  when 'day_17_exercise_in_progress'
    current_step = @user.get_self_help_data('day_17_current_step')
    if service.respond_to?(:handle_compassion_input)
      service.handle_compassion_input(text, current_step)
    else
      log_error("Day 17 service doesn't have handle_compassion_input method")
      false
    end
  when 'day_18_exercise_in_progress'
    handle_day_18_input(text, service)
  when 'day_19_exercise_in_progress'
    handle_day_19_input(text, service)
  when 'day_20_exercise_in_progress'
    if service.respond_to?(:handle_text_input)
      service.handle_text_input(text)
    elsif service.respond_to?(:handle_fear_input)
      service.handle_fear_input(text)
    else
      log_error("Day 20 service doesn't have handle_text_input or handle_fear_input method")
      false
    end
  when 'day_21_exercise_in_progress'
    if service.respond_to?(:handle_reflection_input)
      service.handle_reflection_input(text)
    elsif service.respond_to?(:handle_text_input)
      service.handle_text_input(text)
    else
      log_error("Day 21 service doesn't have handle_reflection_input or handle_text_input method")
      false
    end
  when 'day_22_exercise_in_progress'
  if service.respond_to?(:handle_text_input)
    service.handle_text_input(text)
  elsif service.respond_to?(:handle_smart_input)
    service.handle_smart_input(text)
  else
    log_error("Day 22 service doesn't have handle_text_input method")
    false
  end
  when 'day_10_exercise_in_progress'
    handle_day_10_emotion_diary_input(text, service)
  else
    # Сначала проверяем, не в процессе ли пользователь какого-то дня
    current_day_number = extract_day_number_from_state(state)
    
    if current_day_number
      # Пользователь находится в процессе какого-то дня
      # Нужно обработать именно этот день, а не проверять другие
      log_warn("No specific handler for day #{current_day_number} state: #{state}")
      
      # Пробуем использовать общий обработчик, если есть
      if service.respond_to?(:handle_text_input)
        return service.handle_text_input(text)
      else
        log_error("Day #{current_day_number} service doesn't have handle_text_input method")
        return false
      end
    else
      # Только если пользователь не в процессе какого-либо дня
      # проверяем другие незавершенные задачи
      
      # Проверяем, находится ли пользователь в процессе заполнения дневника для дня 10
      if @user.get_self_help_data('is_filling_emotion_diary') == true
        handle_day_10_emotion_diary_input(text, service)
      # Проверяем, не день ли 18 по префиксу состояния
      elsif state&.start_with?('day_18_')
        handle_day_18_input(text, service)
      # ВАЖНО: НЕ проверяем день 19 здесь, если пользователь в другом дне!
      # Только если нет активного состояния дня
      elsif @user.self_help_state.nil? && @user.get_self_help_data('day_19_current_step') == 'waiting_feedback'
        # Если нет активного дня, но день 19 ожидает фидбек
        handle_day_19_input(text, service)
      else
        log_info("No handler for state: #{state}")
        false
      end
    end
  end
  log_info("=== END handle_day_specific_input ===")
end
      

      def handle_day_19_input(text, day_service)
  log_info("Handling day 19 input: #{text}")
  
  # Проверяем на пустой ввод
  if text.strip.empty?
    log_warn("Empty input received for day 19")
    @bot_service.send_message(
      chat_id: @chat_id,
      text: "Пожалуйста, напишите ваш ответ."
    )
    return true
  end
  
  # Получаем текущий шаг
  current_step = @user.get_self_help_data('day_19_current_step')
  log_info("Day 19 current step: #{current_step}")
  
  # Обрабатываем в зависимости от шага
  if current_step == 'waiting_feedback' && day_service.respond_to?(:handle_feedback_input)
    day_service.handle_feedback_input(text)
    return true
  end
  
  log_warn("Unknown day 19 step for text input: #{current_step}")
  false
rescue => e
  log_error("Failed to handle day 19 input", e)
  false
end

      # Новый метод для обработки ввода дня 18
      # app/services/self_help/facade/self_help_facade.rb

def handle_day_18_input(text, day_service)
  log_info("=== HANDLING DAY 18 INPUT ===")
  log_info("Input text: #{text}")
  log_info("User state BEFORE: #{@user.self_help_state}")
  log_info("User self_help_program_step: #{@user.self_help_program_step}")
  log_info("Day 18 current step from data: #{@user.get_self_help_data('day_18_current_step')}")
  
  # Проверяем на пустой ввод
  if text.strip.empty?
    log_warn("Empty input received for day 18")
    @bot_service.send_message(
      chat_id: @chat_id,
      text: "Пожалуйста, напишите ваш ответ. Если не знаете что написать, просто опишите ваши мысли."
    )
    return true
  end
  
  # Получаем текущий шаг из данных пользователя
  current_step = @user.get_self_help_data('day_18_current_step')
  log_info("Current step from data: #{current_step}")
  
  # Также проверяем состояние пользователя
  user_state = @user.self_help_state
  log_info("User state: #{user_state}")
  
  # Определяем, какой шаг сейчас активен
  if user_state == 'day_18_planning_activity' || current_step == 'planning_details'
    log_info("Processing as activity plan input")
    if day_service.respond_to?(:handle_activity_plan_input)
      result = day_service.handle_activity_plan_input(text)
      log_info("handle_activity_plan_input returned: #{result}")
      log_info("User state AFTER: #{@user.self_help_state}")
      return result
    else
      log_error("Day 18 service doesn't have handle_activity_plan_input method")
      return false
    end
    
  elsif user_state == 'day_18_planning_time' || current_step == 'planning_time'
    log_info("Processing as time plan input")
    if day_service.respond_to?(:handle_time_plan_input)
      result = day_service.handle_time_plan_input(text)
      log_info("handle_time_plan_input returned: #{result}")
      log_info("User state AFTER: #{@user.self_help_state}")
      return result
    else
      log_error("Day 18 service doesn't have handle_time_plan_input method")
      return false
    end
    
  elsif user_state == 'day_18_activity_planned' || current_step == 'reflection'
    log_info("Processing as reflection input")
    if day_service.respond_to?(:handle_reflection_input)
      result = day_service.handle_reflection_input(text)
      log_info("handle_reflection_input returned: #{result}")
      return result
    else
      log_error("Day 18 service doesn't have handle_reflection_input method")
      return false
    end
    
  else
    log_warn("Unknown state for day 18 input: user_state=#{user_state}, current_step=#{current_step}")
    log_info("Available user data: #{@user.self_help_program_data.inspect}")
    
    # Пробуем определить состояние по данным
    if @user.get_self_help_data('day_18_activity_plan').present? && @user.get_self_help_data('day_18_planned_time').blank?
      log_info("Detected: has activity plan but no time, so should be planning_time")
      @user.set_self_help_step("day_18_planning_time")
      store_day_data('current_step', 'planning_time')
      return handle_day_18_input(text, day_service) # Рекурсивно обработаем с новым состоянием
    end
    
    return false
  end
  
rescue => e
  log_error("Failed to handle day 18 input", e)
  false
end

      # ИЗМЕНЕНИЕ 2: Новый метод для обработки ввода дневника эмоций в день 10
      def handle_day_10_emotion_diary_input(text, day_service)
        # Проверяем, есть ли последовательный сервис для дня 10
        sequence_service = SelfHelp::Days::EmotionDiarySequenceService.new(@bot_service, @user, @chat_id)
        sequence_service.handle_answer(text)
        true
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
      
      def log_warn(message)
        Rails.logger.warn "[SelfHelpFacade] #{message} - User: #{@user.telegram_id}"
      end
    end
  end
end
module Telegram
  module Handlers
    class DayStartHandler < BaseHandler
      def process
        # Сначала проверяем специальные callbacks
        case @callback_data
        when 'start_grounding_exercise'
          handle_grounding_exercise_start
        when 'start_self_compassion_exercise'
          handle_self_compassion_exercise_start
        when 'start_procrastination_exercise'
          handle_procrastination_exercise_start
        else
          # Пробуем извлечь номер дня
          day_number = extract_day_number
          
          unless day_number
            log_error("Could not extract day number", callback_data: @callback_data)
            answer_callback_query("Ошибка: не удалось определить день")
            return
          end
          
          log_info("Starting day #{day_number}")
          handle_day_or_exercise_start(day_number)
        end
      end
      
      private

      def day_service_for(day_number)
  # Определяем класс сервиса для дня
  service_class = "SelfHelp::Days::Day#{day_number}Service".constantize
  service_class.new(@bot_service, @user, @chat_id)
rescue NameError => e
  log_error("Failed to find service for day #{day_number}", e)
  nil
end
      
      def handle_grounding_exercise_start
        log_info("Starting grounding exercise (day 11)")
        
        # Проверяем, что пользователь находится в правильном состоянии
        valid_states = ["day_11_intro", "day_11_exercise_in_progress"]
        
        if valid_states.include?(@user.self_help_state)
          day_service_class = "SelfHelp::Days::Day11Service".constantize
          day_service = day_service_class.new(@bot_service, @user, @chat_id)
          
          if day_service.respond_to?(:handle_exercise_consent)
            day_service.handle_exercise_consent
          else
            day_service.deliver_exercise
          end
          
          answer_callback_query("Начинаем упражнение заземления!")
        else
          log_warn("User cannot start grounding exercise", state: @user.self_help_state)
          answer_callback_query("Сначала начните день 11")
        end
      end
      
      def handle_self_compassion_exercise_start
        # Аналогично для дня 12
        log_info("Starting self-compassion exercise (day 12)")
        
        valid_states = ["day_12_intro", "day_12_exercise_in_progress"]
        
        if valid_states.include?(@user.self_help_state)
          day_service_class = "SelfHelp::Days::Day12Service".constantize
          day_service = day_service_class.new(@bot_service, @user, @chat_id)
          
          if day_service.respond_to?(:handle_exercise_consent)
            day_service.handle_exercise_consent
          else
            day_service.deliver_exercise
          end
          
          answer_callback_query("Начинаем медитацию на самосострадание!")
        else
          log_warn("User cannot start self-compassion exercise", state: @user.self_help_state)
          answer_callback_query("Сначала начните день 12")
        end
      end
      
      def handle_procrastination_exercise_start
        # Аналогично для дня 13
        log_info("Starting procrastination exercise (day 13)")
        
        valid_states = ["day_13_intro", "day_13_exercise_in_progress"]
        
        if valid_states.include?(@user.self_help_state)
          day_service_class = "SelfHelp::Days::Day13Service".constantize
          day_service = day_service_class.new(@bot_service, @user, @chat_id)
          
          if day_service.respond_to?(:handle_exercise_consent)
            day_service.handle_exercise_consent
          else
            day_service.deliver_exercise
          end
          
          answer_callback_query("Начинаем работу с прокрастинацией!")
        else
          log_warn("User cannot start procrastination exercise", state: @user.self_help_state)
          answer_callback_query("Сначала начните день 13")
        end
      end
      
      def handle_day_or_exercise_start(day_number)
        # Используем фасад для запуска дня
        facade = SelfHelp::Facade::SelfHelpFacade.new(@bot_service, @user, @chat_id)
        
        # Если это уже запуск упражнения (пользователь ответил "Да" на вопрос)
        if @callback_data.include?("_exercise")
          handle_exercise_start(day_number, facade)
        else
          handle_day_start(day_number, facade)
        end
      end
      
      def handle_day_start(day_number, facade)
  # Проверяем, находится ли пользователь уже в этом дне
  if @user.self_help_state&.include?("day_#{day_number}")
    # Пользователь уже находится в этом дне, продолжаем
    log_info("Continuing day #{day_number} from state: #{@user.self_help_state}")
    
    # Восстанавливаем сессию
    service = day_service_for(day_number)
    if service
      service.resume_session
      answer_callback_query("Продолжаем день #{day_number}!")
    else
      log_error("Failed to create service for day #{day_number}")
      answer_callback_query("Ошибка при продолжении дня")
    end
  elsif facade.can_start_day?(day_number)
    # Новый день - можем начать
    if facade.deliver_day(day_number)
      answer_callback_query("Начинаем День #{day_number}!")
    else
      log_error("Failed to deliver day #{day_number}")
      answer_callback_query("Ошибка при запуске дня")
    end
  else
    log_warn("User cannot start day #{day_number}", state: @user.self_help_state)
    answer_callback_query("Сначала завершите предыдущие этапы")
  end
end
      
      def handle_exercise_start(day_number, facade)
        # Проверяем, что пользователь находится на правильном шаге
        if @user.self_help_state == "day_#{day_number}_intro"
          # Создаем сервис дня и запускаем упражнение
          day_service_class = "SelfHelp::Days::Day#{day_number}Service".constantize
          day_service = day_service_class.new(@bot_service, @user, @chat_id)
          
          # Вызываем метод handle_exercise_consent если он есть, иначе deliver_exercise
          if day_service.respond_to?(:handle_exercise_consent)
            day_service.handle_exercise_consent
          else
            day_service.deliver_exercise
          end
          
          answer_callback_query("Начинаем упражнение!")
        else
          log_warn("User cannot start exercise for day #{day_number}", state: @user.self_help_state)
          answer_callback_query("Сначала начните день #{day_number}")
        end
      end
      
      def extract_day_number
        # Пробуем извлечь из callback_data
        patterns = [
          /start_day_(\d+)_from_proposal/,
          /start_day_(\d+)_exercise/,
          /start_day_(\d+)_content/
        ]
        
        patterns.each do |pattern|
          match = @callback_data.match(pattern)
          return match[1].to_i if match
        end
        
        nil
      end
    end
  end
end
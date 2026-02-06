module Telegram
  module Handlers
    class DayStartHandler < BaseHandler
      def process
        log_info("DayStartHandler processing: #{@callback_data}")
        
        # Сначала проверяем специальные упражнения
        case @callback_data
        when 'start_grounding_exercise'
          handle_grounding_exercise_start
        when 'start_self_compassion_exercise'
          handle_self_compassion_exercise_start
        when 'start_procrastination_exercise'
          handle_procrastination_exercise_start
        else
          # Обрабатываем начало дней
          handle_day_callback
        end
      end
      
      private
      
      def handle_day_callback
        day_number = extract_day_number
        
        unless day_number
          log_error("Could not extract day number", callback_data: @callback_data)
          answer_callback_query("Ошибка: не удалось определить день")
          return # КРИТИЧЕСКИ ВАЖНО: return после ошибки
        end
        
        # ПЕРВОЕ И ГЛАВНОЕ: проверка ограничений
        can_start_result = @user.can_start_day?(day_number)
        
        unless can_start_result == true
          # Не может начать - показываем причину и ПРЕРЫВАЕМ выполнение
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          log_warn("User cannot start day #{day_number}", reason: error_message)
          answer_callback_query(error_message, show_alert: true)  # show_alert чтобы пользователь увидел
          return # КРИТИЧЕСКИ ВАЖНО: return после ошибки
        end
        
        # Динамически проверяем, есть ли у этого дня свой хендлер
        if day_has_own_handler?(day_number)
          log_info("Day #{day_number} has its own handler, skipping", callback_data: @callback_data)
          answer_callback_query("День #{day_number} обрабатывается отдельным хендлером")
          return # КРИТИЧЕСКИ ВАЖНО: return после перенаправления
        end
        
        # ЕСЛИ ДОШЛИ СЮДА: пользователь может начать день
        log_info("User can start day #{day_number}, proceeding with old logic")
        
        # НАЧИНАЕМ ДЕНЬ - только один раз в одном месте
        start_day_safely(day_number)
      end

      def start_day_safely(day_number)
        # Защита от двойного вызова start_day_program
        unless @user.can_start_day?(day_number) == true
          log_error("Day #{day_number} cannot be started - validation failed in start_day_safely")
          answer_callback_query("Ошибка при запуске дня")
          return
        end
        
        # Обновляем состояние пользователя
        @user.start_day_program(day_number)
        
        # Проверяем, сохранился ли пользователь
        if @user.save
          log_info("Successfully started day #{day_number} for user")
          handle_day_using_old_logic(day_number)
        else
          log_error("Failed to save user after starting day #{day_number}", errors: @user.errors.full_messages)
          answer_callback_query("Ошибка при сохранении состояния")
        end
      end
      
      # Динамически проверяем, существует ли хендлер для этого дня
      def day_has_own_handler?(day_number)
        # Проверяем существование класса DayXHandler в правильной папке
        handler_class_name = "Telegram::Handlers::SelfHelpHandlers::DayHandlers::Day#{day_number}Handler"
        
        begin
          handler_class_name.constantize
          true
        rescue NameError
          false
        end
      end
      
      # Старая логика обработки дней (для дней без своих хендлеров)
      def handle_day_using_old_logic(day_number)
        log_info("Using old logic for day #{day_number}")
        
        # Используем существующую логику из старого метода handle_day_or_exercise_start
        facade = SelfHelp::Facade::SelfHelpFacade.new(@bot_service, @user, @chat_id)
        
        if @callback_data.include?("_exercise")
          handle_exercise_start_old(day_number, facade)
        else
          handle_day_start_old(day_number, facade)
        end
      end
      
      def handle_day_start_old(day_number, facade)
        log_info("Starting day #{day_number} using old facade logic")
        
        # Проверяем, находится ли пользователь уже в этом дне
        if @user.self_help_state&.include?("day_#{day_number}")
          log_info("Continuing day #{day_number} from state: #{@user.self_help_state}")
          
          # Восстанавливаем сессию через сервис
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
      
      def handle_exercise_start_old(day_number, facade)
        log_info("Starting exercise for day #{day_number} using old logic")
        
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
      
      def extract_day_number
        # Извлекаем номер дня из callback_data
        patterns = [
          /start_day_(\d+)_from_proposal/,
          /start_day_(\d+)_exercise/,
          /start_day_(\d+)_content/,
          /day_(\d+)_exercise_completed/,
          /continue_day_(\d+)_content/
        ]
        
        patterns.each do |pattern|
          match = @callback_data.match(pattern)
          return match[1].to_i if match
        end
        
        nil
      end
      
      def log_info(message, data = {})
        Rails.logger.info "[DayStartHandler] #{message} - #{data}"
      end
      
      def log_error(message, error = nil)
        Rails.logger.error "[DayStartHandler] #{message}"
        if error
          Rails.logger.error "Error: #{error.message}"
          Rails.logger.error "Backtrace: #{error.backtrace.first(5).join(', ')}" if error.backtrace
        end
      end
      
      def log_warn(message, data = {})
        Rails.logger.warn "[DayStartHandler] #{message} - #{data}"
      end
    end
  end
end
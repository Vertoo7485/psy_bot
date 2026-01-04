module Telegram
  module Handlers
    class DayExerciseCompleteHandler < BaseHandler
      def process
        log_info("Completing exercise for day - callback: #{@callback_data}")
        
        # ИСПРАВЛЕНИЕ: Сначала проверяем специальные callbacks без номера дня
        case @callback_data
        when 'grounding_exercise_completed'
          handle_grounding_exercise_completed
        when 'self_compassion_exercise_completed'
          handle_self_compassion_exercise_completed
        when 'procrastination_exercise_completed'
          handle_procrastination_exercise_completed
        when 'day_10_exercise_completed'
          handle_day_10_exercise_completed
        when 'day_8_stopped_thought_first_try'
          handle_day_8_stopped_thought
        when 'reflection_exercise_completed'
          handle_reflection_exercise_completed
        else
          # Пробуем извлечь номер дня для других callbacks
          day_number = extract_day_number
        
          unless day_number
            log_error("Could not extract day number", callback_data: @callback_data)
            answer_callback_query( "Ошибка: не удалось определить день")
            return
          end
        
          log_info("Completing exercise for day #{day_number}")
          handle_other_day_exercise(day_number)
        end
        
      rescue => e
        log_error("Error in DayExerciseCompleteHandler", e)
        answer_callback_query( "Ошибка при завершении упражнения")
      end
      
      private

      def handle_reflection_exercise_completed
        log_info("Completing reflection exercise (day 14)")
        
        if @user.self_help_state == "day_14_exercise_in_progress"
          service = SelfHelp::Days::Day14Service.new(@bot_service, @user, @chat_id)
          service.complete_exercise
          answer_callback_query( "Рефлексия завершена!")
        else
          answer_callback_query( "Сначала начните рефлексию")
        end
      end
      
      # ИСПРАВЛЕНИЕ: Добавляем метод для grounding_exercise_completed
      def handle_grounding_exercise_completed
        log_info("Completing grounding exercise (day 11)")
        
        # Проверяем, что пользователь в правильном состоянии
        if @user.self_help_state == "day_11_exercise_in_progress"
          begin
            service = SelfHelp::Days::Day11Service.new(@bot_service, @user, @chat_id)
            service.complete_exercise
            answer_callback_query( "Упражнение заземления завершено!")
          rescue => e
            log_error("Failed to complete grounding exercise", e)
            fallback_grounding_completion
          end
        else
          log_warn("User not in correct state for grounding exercise", state: @user.self_help_state)
          answer_callback_query( "Сначала начните упражнение заземления")
        end
      end
      
      def fallback_grounding_completion
        @user.set_self_help_step("day_11_completed")
        
        send_message(
          text: "✅ *Техника заземления освоена!*\n\nТеперь у вас есть инструмент для экстренной самопомощи.",
          parse_mode: 'Markdown'
        )
        
        # Предлагаем следующий день
        if @user.completed_days < 12
          send_message(
            text: "Готовы начать День 12?",
            reply_markup: TelegramMarkupHelper.day_12_start_proposal_markup
          )
        end
        
        answer_callback_query( "Упражнение завершено")
      end
      
      # ИСПРАВЛЕНИЕ: Добавляем метод для self_compassion_exercise_completed
      def handle_self_compassion_exercise_completed
        log_info("Completing self-compassion exercise (day 12)")
        
        if @user.self_help_state == "day_12_exercise_in_progress"
          begin
            service = SelfHelp::Days::Day12Service.new(@bot_service, @user, @chat_id)
            service.complete_exercise
            answer_callback_query( "Медитация на самосострадание завершена!")
          rescue => e
            log_error("Failed to complete self-compassion exercise", e)
            fallback_self_compassion_completion
          end
        else
          log_warn("User not in correct state for self-compassion exercise", state: @user.self_help_state)
          answer_callback_query( "Сначала начните медитацию")
        end
      end
      
      # ИСПРАВЛЕНИЕ: Добавляем метод для procrastination_exercise_completed
      def handle_procrastination_exercise_completed
        log_info("Completing procrastination exercise (day 13)")
        
        if @user.self_help_state == "day_13_exercise_in_progress"
          begin
            service = SelfHelp::Days::Day13Service.new(@bot_service, @user, @chat_id)
            service.complete_exercise
            answer_callback_query( "Работа с прокрастинацией завершена!")
          rescue => e
            log_error("Failed to complete procrastination exercise", e)
            fallback_procrastination_completion
          end
        else
          log_warn("User not in correct state for procrastination exercise", state: @user.self_help_state)
          answer_callback_query( "Сначала начните работу с прокрастинацией")
        end
      end
      
      # ИСПРАВЛЕНИЕ: Добавляем метод для day_10_exercise_completed
      def handle_day_10_exercise_completed
        log_info("Completing day 10 exercise")
        
        if @user.self_help_state == "day_10_exercise_in_progress"
          begin
            service = SelfHelp::Days::Day10Service.new(@bot_service, @user, @chat_id)
            service.complete_exercise
            answer_callback_query( "Упражнение дня 10 завершено!")
          rescue => e
            log_error("Failed to complete day 10 exercise", e)
            fallback_day_10_completion
          end
        else
          log_warn("User not in correct state for day 10", state: @user.self_help_state)
          answer_callback_query( "Сначала начните упражнение дня 10")
        end
      end
      
      # Остальной код без изменений
      def extract_day_number
        # Пробуем извлечь из различных форматов
        patterns = [
          /day_(\d+)_exercise_completed/,
          /day_(\d+)_stopped_thought_first_try/,
          /day_(\d+)_/  # Общий паттерн
        ]
        
        patterns.each do |pattern|
          match = @callback_data.match(pattern)
          return match[1].to_i if match
        end
        
        nil
      end
      
      def handle_day_8_stopped_thought
        log_info("Handling day 8 stopped thought")
        
        # Создаем сервис дня 8
        begin
          service = SelfHelp::Days::Day8Service.new(@bot_service, @user, @chat_id)
          
          # Вызываем complete_exercise для дня 8
          service.complete_exercise
          
          answer_callback_query( "Отлично! Продолжаем...")
        rescue => e
          log_error("Failed to handle day 8 exercise", e)
          
          # Fallback: просто отвечаем
          send_message(
            text: "🌟 *Техника освоена!* 🌟\n\nВы научились останавливать навязчивые мысли.",
            parse_mode: 'Markdown'
          )
          
          send_message(
            text: "Что делать, если мысль возвращается? Используйте отвлечение:",
            reply_markup: TelegramMarkupHelper.day_8_distraction_options_markup
          )
          
          answer_callback_query( "Упражнение завершено")
        end
      end
      
      def handle_other_day_exercise(day_number)
        log_info("Completing exercise for day #{day_number}")
        
        begin
          # Пробуем создать сервис дня
          service_class = "SelfHelp::Days::Day#{day_number}Service".constantize
          service = service_class.new(@bot_service, @user, @chat_id)
          
          # Вызываем complete_exercise если метод существует
          if service.respond_to?(:complete_exercise)
            service.complete_exercise
          else
            # Fallback
            @user.set_self_help_step("day_#{day_number}_completed")
            send_message(
              text: "✅ Упражнение дня #{day_number} завершено!",
              reply_markup: TelegramMarkupHelper.day_start_proposal_markup(day_number + 1)
            )
          end
          
          answer_callback_query( "Упражнение завершено!")
          
        rescue NameError
          # Если сервис не найден, используем fallback
          log_warn("Day service not found for day #{day_number}, using fallback")
          
          @user.set_self_help_step("day_#{day_number}_completed")
          send_message(
            text: "✅ Упражнение дня #{day_number} завершено!",
            reply_markup: TelegramMarkupHelper.day_start_proposal_markup(day_number + 1)
          )
          
          answer_callback_query( "Упражнение завершено")
        end
      end
      
      def log_info(message)
        Rails.logger.info "[DayExerciseCompleteHandler] #{message} - User: #{@user.telegram_id}, Callback: #{@callback_data}"
      end
      
      def log_warn(message)
        Rails.logger.warn "[DayExerciseCompleteHandler] #{message} - User: #{@user.telegram_id}"
      end
      
      def log_error(message, error = nil)
        Rails.logger.error "[DayExerciseCompleteHandler] #{message} - User: #{@user.telegram_id}, Callback: #{@callback_data}"
        Rails.logger.error "Error: #{error.message}\n#{error.backtrace.join("\n")}" if error
      end
      
      # Fallback методы
      def fallback_self_compassion_completion
        @user.set_self_help_step("day_12_completed")
        
        send_message(
          text: "✅ *Медитация на самосострадание завершена!*\n\nВы научились быть добрее к себе.",
          parse_mode: 'Markdown'
        )
        
        if @user.completed_days < 13
          send_message(
            text: "Готовы начать День 13?",
            reply_markup: TelegramMarkupHelper.day_13_start_proposal_markup
          )
        end
      end
      
      def fallback_procrastination_completion
        @user.set_self_help_step("day_13_completed")
        
        send_message(
          text: "✅ *Работа с прокрастинацией завершена!*\n\nВы освоили техники преодоления откладывания.",
          parse_mode: 'Markdown'
        )
        
        send_message(
          text: "🎊 *Программа самопомощи завершена!* 🎊",
          parse_mode: 'Markdown',
          reply_markup: TelegramMarkupHelper.final_program_completion_markup
        )
      end
      
      def fallback_day_10_completion
        @user.set_self_help_step("day_10_completed")
        
        send_message(
          text: "✅ *День 10 завершен!*\n\nВы освоили дневник эмоций.",
          parse_mode: 'Markdown'
        )
        
        if @user.completed_days < 11
          send_message(
            text: "Готовы начать День 11?",
            reply_markup: TelegramMarkupHelper.day_11_start_proposal_markup
          )
        end
      end
    end
  end
end
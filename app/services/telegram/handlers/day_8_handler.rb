# app/services/telegram/handlers/day_8_handler.rb
module Telegram
  module Handlers
    class Day8Handler < BaseHandler
      def process
        log_info("Processing day 8 callback: #{@callback_data}")
        
        case @callback_data
        when 'day_8_stopped_thought_first_try'
          handle_stopped_thought
        when /^day_8_distraction_(\w+)$/
          handle_distraction($1)
        when 'day_8_exercise_completed'
          handle_exercise_completed
        else
          log_error("Unknown callback for day 8")
          answer_callback_query("Неизвестная команда дня 8")
        end
      end
      
      private
      
      def handle_stopped_thought
        # ИЗМЕНЕНИЕ 1: Разрешаем обработку в двух состояниях
        valid_states = ["day_8_exercise_in_progress", "day_8_intro"]
        
        if valid_states.include?(@user.self_help_state)
          service = SelfHelp::Days::Day8Service.new(@bot_service, @user, @chat_id)
          
          # ИЗМЕНЕНИЕ 2: Вместо complete_exercise вызываем handle_stopped_thought
          if service.respond_to?(:handle_stopped_thought)
            service.handle_stopped_thought
          else
            # Для обратной совместимости
            service.complete_exercise
          end
          
          answer_callback_query("Отлично! Теперь выберите способ отвлечения...")
        else
          log_warn("User not in correct state for stopped thought", state: @user.self_help_state)
          answer_callback_query("Сначала начните упражнение дня 8")
        end
      end
      
      def handle_distraction(distraction_type)
        # ИЗМЕНЕНИЕ 3: Разрешаем обработку после остановки мысли
        valid_states = ["day_8_exercise_done", "day_8_exercise_completed"]
        
        if valid_states.include?(@user.self_help_state)
          service = SelfHelp::Days::Day8Service.new(@bot_service, @user, @chat_id)
          
          if service.respond_to?(:handle_distraction_choice)
            service.handle_distraction_choice(distraction_type)
          end
          
          answer_callback_query("Хороший выбор!")
        else
          log_warn("User not in correct state for distraction", state: @user.self_help_state)
          answer_callback_query("Сначала завершите упражнение остановки мыслей")
        end
      end
      
      def handle_exercise_completed
        # ИЗМЕНЕНИЕ 4: Этот callback приходит ПОСЛЕ отвлечения
        service = SelfHelp::Days::Day8Service.new(@bot_service, @user, @chat_id)
        
        if service.respond_to?(:complete_day_after_distraction)
          service.complete_day_after_distraction
        else
          # Для обратной совместимости
          service.complete_exercise
        end
        
        answer_callback_query("Упражнение завершено!")
      end
    end
  end
end
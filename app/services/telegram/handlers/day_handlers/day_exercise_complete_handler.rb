module Telegram
  module Handlers
    class DayExerciseCompleteHandler < BaseHandler
      def process
        day_number = extract_day_number
        
        unless day_number
          log_error("Could not extract day number", callback_data: @callback_data)
          answer_callback_query("Ошибка: не удалось определить день")
          return
        end
        
        log_info("Completing exercise for day #{day_number}")
        
        facade = SelfHelp::Facade::SelfHelpFacade.new(@bot_service, @user, @chat_id)
        
        if facade.complete_day_exercise(day_number)
          answer_callback_query("Упражнение завершено!")
        else
          log_error("Failed to complete exercise for day #{day_number}")
          answer_callback_query("Ошибка при завершении упражнения")
        end
      end
      
      private
      
      def extract_day_number
        return match_group(1).to_i if has_matches?
        
        # Пробуем извлечь из callback_data
        match = @callback_data.match(/day_(\d+)_exercise_completed/)
        match ? match[1].to_i : nil
      end
    end
  end
end
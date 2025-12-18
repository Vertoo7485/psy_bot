# app/services/telegram/handlers/day_9_handler.rb
module Telegram
  module Handlers
    class Day9Handler < BaseHandler
      def process
        case @callback_data
        when 'day_9_enter_thought'
          handle_enter_thought
        when 'day_9_show_current'
          handle_show_current
        when 'show_all_anxious_thoughts'
          handle_show_all
        when 'complete_day_9'
          handle_complete_day
        else
          log_error("Unknown day 9 callback: #{@callback_data}")
          answer_callback_query("Неизвестная команда")
        end
      end
      
      private
      
      def handle_enter_thought
        log_info("Starting thought analysis")
        
        service = SelfHelp::Days::Day9Service.new(@bot_service, @user, @chat_id)
        service.deliver_exercise
        
        answer_callback_query("Начинаем анализ мысли...")
      end
      
      def handle_show_current
        log_info("Showing current progress")
        
        service = SelfHelp::Days::Day9Service.new(@bot_service, @user, @chat_id)
        service.show_current_progress
        
        answer_callback_query("Показываю текущий прогресс...")
      end
      
      def handle_show_all
        log_info("Showing all anxious thoughts")
        
        service = SelfHelp::Days::Day9Service.new(@bot_service, @user, @chat_id)
        service.show_all_entries
        
        answer_callback_query("Показываю все анализы...")
      end
      
      def handle_complete_day
        log_info("Completing day 9")
        
        service = SelfHelp::Days::Day9Service.new(@bot_service, @user, @chat_id)
        service.complete_day
        
        answer_callback_query("День 9 завершен!")
      end
    end
  end
end
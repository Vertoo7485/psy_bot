# app/services/telegram/handlers/day_18_text_handler.rb

module Telegram
  module Handlers
    class Day18TextHandler < BaseHandler
      def process
        log_info("Processing day 18 text input: #{@text}")
        
        # Получаем сервис дня 18
        service_class = "SelfHelp::Days::Day18Service".constantize
        service = service_class.new(@bot_service, @user, @chat_id)
        
        # Получаем текущий шаг
        current_step = @user.get_self_help_data('day_18_current_step')
        log_info("Day 18 current step: #{current_step}")
        
        case current_step
        when 'planning_details'
          service.handle_activity_plan_input(@text)
        when 'planning_time'
          service.handle_time_plan_input(@text)
        when 'reflection'
          service.handle_reflection_input(@text)
        else
          log_warn("Day 18: Unknown step for text: #{current_step}")
          @bot_service.send_message(
            chat_id: @chat_id,
            text: "Пожалуйста, используйте кнопки для навигации."
          )
        end
      end
    end
  end
end
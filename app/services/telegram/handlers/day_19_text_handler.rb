# app/services/telegram/handlers/day_19_text_handler.rb

module Telegram
  module Handlers
    class Day19TextHandler < BaseHandler
      def process
        log_info("Processing day 19 text input: #{@text}")
        
        # Получаем сервис дня 19
        service_class = "SelfHelp::Days::Day19Service".constantize
        service = service_class.new(@bot_service, @user, @chat_id)
        
        # Получаем текущий шаг
        current_step = @user.get_self_help_data('day_19_current_step')
        log_info("Day 19 current step: #{current_step}")
        
        # Проверяем, ожидает ли сервис текстового ввода
        if service.respond_to?(:handle_text_input)
          service.handle_text_input(@text)
        else
          log_warn("Day 19 service doesn't have handle_text_input method")
          @bot_service.send_message(
            chat_id: @chat_id,
            text: "Пожалуйста, используйте кнопки для навигации."
          )
        end
      end
    end
  end
end
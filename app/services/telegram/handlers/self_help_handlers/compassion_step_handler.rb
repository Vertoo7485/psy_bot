module Telegram
  module Handlers
    class CompassionStepHandler < BaseHandler
      def process
        log_info("Processing compassion step: #{@callback_data}")
        
        # Получаем текущий день пользователя
        day_number = @user.current_day_number
        
        if day_number != 17 && !@user.self_help_state&.include?('day_17')
          log_warn("User not in day 17 for compassion step", state: @user.self_help_state)
          answer_callback_query( "Сначала начните день 17")
          return
        end
        
        # Получаем сервис дня 17
        service_class = "SelfHelp::Days::Day17Service".constantize
        service = service_class.new(@bot_service, @user, @chat_id)
        
        # Обрабатываем нажатие кнопки
        service.handle_compassion_button(@callback_data)
        
        answer_callback_query( "Продолжаем...")
        
      rescue => e
        log_error("Error processing compassion step", e)
        answer_callback_query( "Ошибка при обработке шага")
      end
    end
  end
end
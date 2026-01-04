# app/services/telegram/handlers/day_18_handler.rb

module Telegram
  module Handlers
    class Day18Handler < BaseHandler
      def process
        log_info("Processing day 18 callback: #{@callback_data}")
        
        # Получаем сервис дня 18
        service_class = "SelfHelp::Days::Day18Service".constantize
        service = service_class.new(@bot_service, @user, @chat_id)
        
        # Обрабатываем кнопку
        service.handle_button(@callback_data)
        
        answer_callback_query( "Обрабатываю...")
        
      rescue => e
        log_error("Error processing day 18 callback", e)
        answer_callback_query( "Ошибка при обработке")
      end
    end
  end
end
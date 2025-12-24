# app/services/telegram/handlers/meditation_menu_handler.rb

module Telegram
  module Handlers
    class MeditationMenuHandler < BaseHandler
      def process
        log_info("Processing meditation menu callback")
        
        service_class = "SelfHelp::Days::Day19Service".constantize
        service = service_class.new(@bot_service, @user, @chat_id)
        
        service.show_meditation_menu
        
        answer_callback_query("Показываю меню...")
        
      rescue => e
        log_error("Error in MeditationMenuHandler", e)
        answer_callback_query("Ошибка")
      end
    end
  end
end
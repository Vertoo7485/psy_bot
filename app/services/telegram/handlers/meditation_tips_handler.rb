# app/services/telegram/handlers/meditation_tips_handler.rb

module Telegram
  module Handlers
    class MeditationTipsHandler < BaseHandler
      def process
        log_info("Processing meditation tips callback")
        
        service_class = "SelfHelp::Days::Day19Service".constantize
        service = service_class.new(@bot_service, @user, @chat_id)
        
        service.show_meditation_tips
        
        answer_callback_query("Показываю советы...")
        
      rescue => e
        log_error("Error in MeditationTipsHandler", e)
        answer_callback_query("Ошибка")
      end
    end
  end
end
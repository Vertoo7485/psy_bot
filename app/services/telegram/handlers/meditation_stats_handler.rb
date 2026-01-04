# app/services/telegram/handlers/meditation_stats_handler.rb

module Telegram
  module Handlers
    class MeditationStatsHandler < BaseHandler
      def process
        log_info("Processing meditation stats callback")
        
        service_class = "SelfHelp::Days::Day19Service".constantize
        service = service_class.new(@bot_service, @user, @chat_id)
        
        service.show_meditation_stats
        
        answer_callback_query( "Показываю статистику...")
        
      rescue => e
        log_error("Error in MeditationStatsHandler", e)
        answer_callback_query( "Ошибка")
      end
    end
  end
end
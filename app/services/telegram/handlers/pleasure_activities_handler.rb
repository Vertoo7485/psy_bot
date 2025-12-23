# app/services/telegram/handlers/pleasure_activities_handler.rb

module Telegram
  module Handlers
    class PleasureActivitiesHandler < BaseHandler
      def process
        log_info("Processing pleasure activities callback: #{@callback_data}")
        
        service_class = "SelfHelp::Days::Day18Service".constantize
        service = service_class.new(@bot_service, @user, @chat_id)
        
        case @callback_data
        when 'view_pleasure_activities'
          service.show_previous_activities
        when 'view_activity_ideas'
          service.show_activity_ideas
        when 'pleasure_stats'
          service.show_pleasure_stats
        when 'back_to_day_18_menu'
          service.show_pleasure_activities_menu
        end
        
        answer_callback_query("Показываю...")
        
      rescue => e
        log_error("Error in PleasureActivitiesHandler", e)
        answer_callback_query("Ошибка")
      end
    end
  end
end
# app/services/telegram/handlers/day_20_handler.rb

module Telegram
  module Handlers
    class Day20Handler < BaseHandler
      def process
        log_info("Processing day 20 callback: #{@callback_data}")
        
        begin
          service_class = "SelfHelp::Days::Day20Service".constantize
          service = service_class.new(@bot_service, @user, @chat_id)
          
          case @callback_data
          when 'start_day_20_exercise'
            service.deliver_exercise
          when /^day_20_category_(.+)$/
            category_key = $1
            service.handle_category_selection(category_key)
          when 'day_20_back_to_categories'
            service.choose_fear_category
          when 'day_20_start_planning'
            service.start_planning
          when /^day_20_skip_(.+)$/
            step_name = $1
            service.handle_skipped_step(step_name)
          when 'day_20_action_completed'
            service.handle_action_completed
          when 'day_20_need_help'
            service.provide_first_step_help
          when 'day_20_skip_reflection'
            service.show_success_summary
          when 'view_fear_tips'
            service.show_fear_tips
          when 'view_fear_victories'
            service.show_fear_victories
          when 'back_to_day_20_menu'
            service.show_fear_overcoming_menu
          else
            # Если это неизвестный callback, пробуем вызвать handle_button
            if service.respond_to?(:handle_button)
              service.handle_button(@callback_data)
            else
              log_error("Unknown callback data for day 20: #{@callback_data}")
            end
          end
          
          answer_callback_query( "Обрабатываю...")
          
        rescue => e
          log_error("Error in Day20Handler", e)
          answer_callback_query( "Ошибка")
        end
      end
    end
  end
end
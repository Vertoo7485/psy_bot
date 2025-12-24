# app/services/telegram/handlers/day_19_handler.rb

module Telegram
  module Handlers
    class Day19Handler < BaseHandler
      def process
        log_info("Processing day 19 callback: #{@callback_data}")
        
        begin
          service_class = "SelfHelp::Days::Day19Service".constantize
          service = service_class.new(@bot_service, @user, @chat_id)
          
          case @callback_data
          when 'day_19_start_meditation'
            service.start_meditation
          when 'day_19_prepare_again'
            service.prepare_for_meditation
          when /^day_19_meditation_rating_(\d+)$/
            rating = $1.to_i
            service.handle_meditation_rating(rating)
          when 'day_19_share_feedback'
            # Теперь метод публичный, должен работать
            service.store_day_data('current_step', 'waiting_feedback')
            @bot_service.send_message(
              chat_id: @chat_id, 
              text: "Напишите ваши впечатления от медитации:"
            )
          when 'day_19_skip_feedback'
            service.handle_feedback_input("")
          when 'view_meditation_history'
            service.show_previous_meditations
          when 'view_meditation_tips'
            service.show_meditation_tips
          when 'meditation_stats'
            service.show_meditation_stats
          when 'back_to_day_19_menu'
            service.show_meditation_menu
          else
            # Если это неизвестный callback, пробуем вызвать handle_button
            if service.respond_to?(:handle_button)
              service.handle_button(@callback_data)
            else
              log_error("Unknown callback data for day 19: #{@callback_data}")
            end
          end
          
          answer_callback_query("Обрабатываю...")
          
        rescue => e
          log_error("Error in Day19Handler", e)
          answer_callback_query("Ошибка")
        end
      end
    end
  end
end
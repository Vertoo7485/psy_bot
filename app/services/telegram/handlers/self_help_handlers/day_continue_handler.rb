# app/services/telegram/handlers/self_help_handlers/day_continue_handler.rb
module Telegram
  module Handlers
    class DayContinueHandler < BaseHandler
      def process
        day_number = extract_day_number
        
        unless day_number
          log_error("Could not extract day number", callback_data: @callback_data)
          answer_callback_query("Ошибка: не удалось определить день")
          return
        end
        
        log_info("Continuing day #{day_number}")
        
        # Прямой вызов сервиса дня
        handle_day_continuation(day_number)
        
        answer_callback_query("Продолжаем день #{day_number}...")
      end
      
      private
      
      def extract_day_number
        return match_group(1).to_i if has_matches?
        
        # Пробуем извлечь из callback_data
        match = @callback_data.match(/continue_day_(\d+)_content/)
        match ? match[1].to_i : nil
      end
      
      def handle_day_continuation(day_number)
        case day_number
        when 1
          handle_day_1_continuation
        when 2
          handle_day_2_continuation
        # ... добавьте обработку для других дней по мере необходимости
        else
          log_error("Day #{day_number} continuation not implemented")
          send_message(
            text: "Продолжение дня #{day_number} еще не реализовано.",
            reply_markup: TelegramMarkupHelper.main_menu_markup
          )
        end
      end
      
      def handle_day_1_continuation
        begin
          require Rails.root.join('app/services/self_help/days/day_1_service')
          
          service = SelfHelp::Days::Day1Service.new(@bot_service, @user, @chat_id)
          service.deliver_exercise
          
          log_info("Successfully delivered day 1 exercise")
        rescue => e
          log_error("Failed to deliver day 1 exercise", e)
          send_message(
            text: "Ошибка при загрузке упражнения дня 1. Попробуйте позже.",
            reply_markup: TelegramMarkupHelper.main_menu_markup
          )
        end
      end
      
      def handle_day_2_continuation
        # Аналогично для дня 2
        send_message(
          text: "День 2 будет доступен позже.",
          reply_markup: TelegramMarkupHelper.main_menu_markup
        )
      end
    end
  end
end
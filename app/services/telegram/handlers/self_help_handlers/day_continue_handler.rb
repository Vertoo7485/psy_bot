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
        
        # Вместо прямой обработки здесь, делегируем соответствующим DayHandler'ам
        delegate_to_day_handler(day_number)
        
        answer_callback_query("Продолжаем день #{day_number}...")
      end
      
      private
      
      def extract_day_number
        return match_group(1).to_i if has_matches?
        
        # Пробуем извлечь из callback_data
        match = @callback_data.match(/continue_day_(\d+)_content/)
        match ? match[1].to_i : nil
      end
      
      def delegate_to_day_handler(day_number)
        case day_number
        when 1
          delegate_to_day1_handler
        when 2
          delegate_to_day2_handler
        else
          log_error("Day #{day_number} continuation not implemented")
          send_message(
            text: "День #{day_number} будет доступен позже.",
            reply_markup: TelegramMarkupHelper.main_menu_markup
          )
        end
      end
      
      def delegate_to_day1_handler
        require Rails.root.join('app/services/telegram/handlers/self_help_handlers/day_handlers/day1_handler')
        
        handler = Telegram::Handlers::SelfHelpHandlers::DayHandlers::Day1Handler.new(
          @bot,
          @message,
          @user,
          @chat_id,
          @callback_data,
          @callback_query_id
        )
        handler.process
      end
      
      def delegate_to_day2_handler
        require Rails.root.join('app/services/telegram/handlers/self_help_handlers/day_handlers/day2_handler')
        
        handler = Telegram::Handlers::SelfHelpHandlers::DayHandlers::Day2Handler.new(
          @bot,
          @message,
          @user,
          @chat_id,
          @callback_data,
          @callback_query_id
        )
        handler.process
      end
    end
  end
end
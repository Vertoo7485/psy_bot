# app/services/telegram/handlers/self_help_handlers/day_gratitude_handler.rb
module Telegram
  module Handlers
    class DayGratitudeHandler < BaseHandler
      def process
        day_number = extract_day_number
        
        unless day_number
          log_error("Could not extract day number", callback_data: @callback_data)
          answer_callback_query("Ошибка: не удалось определить день")
          return
        end
        
        log_info("Handling gratitude input for day #{day_number}")
        
        # Для дня 3 вызываем Day3Service
        if day_number == 3
          handle_day_3_gratitude
        else
          # Для других дней можно добавить обработку позже
          handle_other_day_gratitude(day_number)
        end
      end
      
      private
      
      def extract_day_number
        return match_group(1).to_i if has_matches?
        
        # Пробуем извлечь из callback_data
        match = @callback_data.match(/day_(\d+)_enter_gratitude/)
        match ? match[1].to_i : nil
      end
      
      def handle_day_3_gratitude
        # Загружаем Day3Service
        require Rails.root.join('app/services/self_help/days/day_3_service') unless defined?(SelfHelp::Days::Day3Service)
        
        # Создаем сервис
        service = SelfHelp::Days::Day3Service.new(@bot_service, @user, @chat_id)
        
        # Вызываем метод для ввода благодарностей
        service.deliver_exercise
        
        # Ответ на callback query
        answer_callback_query("Начинаем практику благодарности...")
      end
      
      def handle_other_day_gratitude(day_number)
        log_warn("Gratitude handler for day #{day_number} not implemented")
        
        send_message(
          text: "Практика благодарности для дня #{day_number} еще не реализована.",
          reply_markup: TelegramMarkupHelper.main_menu_markup
        )
        
        answer_callback_query("Функция временно недоступна")
      end
    end
  end
end
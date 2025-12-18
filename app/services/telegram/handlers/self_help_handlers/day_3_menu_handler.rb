# app/services/telegram/handlers/self_help_handlers/day_3_menu_handler.rb
module Telegram
  module Handlers
    class Day3MenuHandler < BaseHandler
      def process
        log_info("Showing day 3 menu")
        
        # Показываем меню дня 3
        send_message(
          text: "📋 *Меню Дня 3: Практика благодарности* 📋\n\nВыберите действие:",
          parse_mode: 'Markdown',
          reply_markup: TelegramMarkupHelper.day_3_menu_markup
        )
        
        answer_callback_query("Возвращаемся к меню дня 3...")
      end
    end
  end
end
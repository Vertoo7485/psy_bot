module Telegram
  module Handlers
    class TestManagerHandler < BaseHandler
      def process
        log_info("TestManagerHandler: Processing show_test_categories")
        
        # Используем TelegramMarkupHelper
        require_relative '../../../services/telegram_markup_helper'
        markup_helper = TelegramMarkupHelper
        
        # Получаем клавиатуру с тестами
        keyboard = JSON.parse(markup_helper.test_categories_markup)
        
        # Отправляем сообщение с тестами
        send_message(
          text: "#{markup_helper::EMOJI[:tests]} *Список тестов:*\n\nВыберите тест для прохождения:",
          reply_markup: keyboard,
          parse_mode: 'Markdown'
        )
        
        # Отвечаем на callback
        answer_callback_query("Показываю список тестов")
        
        log_info("TestManagerHandler: Completed successfully")
      end
    end
  end
end

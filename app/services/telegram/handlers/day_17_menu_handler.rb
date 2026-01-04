# app/services/telegram/handlers/day_17_menu_handler.rb

module Telegram
  module Handlers
    class Day17MenuHandler < BaseHandler
      def process
        log_info("Showing day 17 menu")
        
        # Получаем сервис дня 17
        service_class = "SelfHelp::Days::Day17Service".constantize
        service = service_class.new(@bot_service, @user, @chat_id)
        
        # Показываем меню дня 17
        menu_text = <<~MARKDOWN
          ✨ *Меню дня 17 - Письма самосострадания* ✨

          Здесь вы можете:
          1. 📚 *Просмотреть все ваши письма* - перечитывайте в трудные моменты
          2. ✍️ *Написать новое письмо* - создавайте новые письма поддержки
          3. 📅 *Смотреть по дате* - находите письма за конкретные дни
          4. ⭐ *Лучшие письма* - самые поддерживающие и добрые слова

          Письма самосострадания — это мощный инструмент самоподдержки!
        MARKDOWN
        
        @bot_service.send_message(
          chat_id: @chat_id,
          text: menu_text,
          parse_mode: 'Markdown',
          reply_markup: TelegramMarkupHelper.day_17_full_menu_markup
        )
        
        answer_callback_query( "Меню дня 17")
        
      rescue => e
        log_error("Error showing day 17 menu", e)
        answer_callback_query( "Ошибка при показе меню")
      end
    end
  end
end
# app/services/telegram/handlers/continue_after_day_17_handler.rb

module Telegram
  module Handlers
    class ContinueAfterDay17Handler < BaseHandler
      def process
        log_info("Continuing after day 17")
        
        # Показываем меню выбора
        message = <<~MARKDOWN
          🌟 *Что вы хотите сделать дальше?* 🌟

          1. *Перейти к Дню 18* - продолжить программу самопомощи
          2. *Вернуться к письмам* - просмотреть или создать новые письма самосострадания
          3. *Отдохнуть* - вернуться в главное меню

          Письма самосострадания останутся доступными в любое время через главное меню.
        MARKDOWN
        
        @bot_service.send_message(
          chat_id: @chat_id,
          text: message,
          parse_mode: 'Markdown',
          reply_markup: TelegramMarkupHelper.continue_after_day_17_markup
        )
        
        answer_callback_query("Выберите дальнейшее действие")
        
      rescue => e
        log_error("Error continuing after day 17", e)
        answer_callback_query("Ошибка при выборе действия")
      end
    end
  end
end
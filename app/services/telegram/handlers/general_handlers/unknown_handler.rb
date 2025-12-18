# app/services/telegram/handlers/general_handlers/unknown_handler.rb
module Telegram
  module Handlers
    class UnknownHandler < BaseHandler
      def process
        log_warn("Unknown callback data: #{@callback_data}")
        
        message = <<~TEXT
          ❓ Извините, я не понял эту команду.

          Пожалуйста, используйте кнопки меню или команды:
          /start - начало работы
          /menu - главное меню
          /help - справка
        TEXT
        
        send_message(text: message)
        answer_callback_query("Неизвестная команда")
      end
    end
  end
end
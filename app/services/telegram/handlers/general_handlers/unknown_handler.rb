module Telegram
  module Handlers
    class UnknownHandler < BaseHandler
      def process
        log_info("Unknown callback data: #{@callback_data}")
        
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
# app/services/telegram/handlers/self_help_handlers/day22_handler.rb

module Telegram
  module Handlers
    module SelfHelpHandlers
      class Day22Handler < BaseHandler
        def process
          log_info("Processing day 22 callback: #{@callback_data} - User: #{@user.telegram_id}, Chat: #{@chat_id}")
          
          begin
            # Получаем сервис дня 22
            day_service = SelfHelp::Days::Day22Service.new(bot_service, user, chat_id)
            
            # Вызываем обработку кнопки
            day_service.handle_button(@callback_data)
            
          rescue => e
            log_error("Error in Day22Service processing", e)
            # Отправляем сообщение пользователю об ошибке
            send_message(
              text: "Произошла ошибка при обработке. Пожалуйста, попробуйте еще раз."
            )
            # Отвечаем Telegram об ошибке
            answer_callback_query( "❌ Ошибка обработки")
            return
          end
          
          # Успешное завершение
          answer_callback_query( "✅")
        end
        
        # Метод для отправки сообщения
        def send_message(text:, reply_markup: nil, parse_mode: nil)
          @bot_service.send_message(
            chat_id: @chat_id,
            text: text,
            reply_markup: reply_markup,
            parse_mode: parse_mode
          )
        rescue => e
          log_error("Failed to send message", e)
        end
      end
    end
  end
end
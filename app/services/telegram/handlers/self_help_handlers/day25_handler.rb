module Telegram
  module Handlers
    module SelfHelpHandlers
      class Day25Handler < BaseHandler
        def process
          log_info("Processing day 25 callback: #{@callback_data} - User: #{@user.telegram_id}, Chat: #{@chat_id}")
          
          begin
            day_service = SelfHelp::Days::Day25Service.new(bot_service, user, chat_id)
            day_service.handle_button(@callback_data)
            
          rescue => e
            log_error("Error in Day25Service processing", e)
            send_message(
              text: "Произошла ошибка при выполнении упражнения 'Вид сверху'. Пожалуйста, попробуйте еще раз."
            )
            answer_callback_query( "❌ Ошибка")
            return
          end
          
          answer_callback_query( "✅")
        end
        
        private
        
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
# app/services/telegram/handlers/self_help_handlers/day21_handler.rb
module Telegram
  module Handlers
    module SelfHelpHandlers
      class Day21Handler < BaseHandler
        def process
          log_info("Processing day 21 callback: #{@callback_data} - User: #{@user.telegram_id}, Chat: #{@chat_id}")
          
          # Получаем сервис дня 21
          day_service = SelfHelp::Days::Day21Service.new(bot_service, user, chat_id)
          
          # Вызываем обработку кнопки
          day_service.handle_button(@callback_data)
          
          # ВАЖНО: Отвечаем на callback_query, чтобы Telegram знал, что запрос обработан
          # и убрал "часики" с кнопки
          answer_callback_query("✅")  # Это вызовет метод из BaseHandler
          
        rescue => e
          log_error("Error processing day 21 callback", e)
          
          # Даже при ошибке отвечаем Telegram
          answer_callback_query("❌ Ошибка")
          
          # Пересылаем ошибку выше
          raise
        end
      end
    end
  end
end
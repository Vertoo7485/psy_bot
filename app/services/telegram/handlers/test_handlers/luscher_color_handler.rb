# app/services/telegram/handlers/test_handlers/luscher_color_handler.rb
module Telegram
  module Handlers
    class LuscherColorHandler < BaseHandler
      def process
        unless has_matches? && matches.length >= 2
          log_error("Invalid callback data format: #{@callback_data}")
          answer_callback_query("Ошибка: неверный формат данных")
          return
        end
        
        color_code = match_group(1)
        test_result_id = match_group(2).to_i
        
        log_info("Processing color choice", color_code: color_code, test_result_id: test_result_id)
        
        # Обрабатываем выбор цвета
        service = LuscherTestService.new(@bot_service, @user, @chat_id)
        success = service.process_choice(@callback_data)
        
        if success
          answer_callback_query("Цвет выбран")
        else
          answer_callback_query("Ошибка при выборе цвета")
        end
      end
    end
  end
end
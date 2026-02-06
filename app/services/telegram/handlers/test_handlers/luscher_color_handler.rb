module Telegram
  module Handlers
    class LuscherColorHandler < BaseHandler
      # Паттерн для callback_data: luscher_color_<color_code>_<test_result_id>
      # Пример: luscher_color_dark_blue_123
      CALLBACK_PATTERN = /^luscher_color_([a-z_]+)_(\d+)$/
      
      def process
        unless has_matches?
          log_error("Invalid callback data format: #{@callback_data}")
          answer_callback_query("Ошибка: неверный формат данных")
          return
        end
        
        color_code = match_group(1)  # Получаем код цвета
        test_result_id = match_group(2).to_i  # Получаем ID результата теста
        
        log_info("Processing color choice", 
                color_code: color_code, 
                test_result_id: test_result_id,
                matches_size: @matches&.size)
        
        # Обрабатываем выбор цвета через сервис
        service = LuscherTestService.new(@bot_service, @user, @chat_id)
        success = service.process_choice(@callback_data)
        
        if success
          answer_callback_query("Цвет выбран")
        else
          answer_callback_query("Ошибка при выборе цвета")
        end
      rescue => e
        log_error("Error processing Luscher color choice", e)
        answer_callback_query("Произошла ошибка")
      end
    end
  end
end
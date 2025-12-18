module Telegram
  module Handlers
    class TestStartHandler < BaseHandler
      def process
        test_type = extract_test_type
        
        unless test_type
          log_error("Could not extract test type", callback_data: @callback_data)
          answer_callback_query("Ошибка: не удалось определить тест")
          return
        end
        
        log_info("Starting test: #{test_type}")
        
        case test_type.to_sym
        when :luscher
          start_luscher_test
        else
          start_standard_test(test_type)
        end
        
        answer_callback_query("Запускаю тест...")
      end
      
      private
      
      def extract_test_type
        return match_group(1) if has_matches?
        
        # Пробуем извлечь из callback_data
        match = @callback_data.match(/start_(\w+)_test/)
        match ? match[1] : nil
      end
      
      def start_standard_test(test_type)
        runner = QuizRunner.new(@bot_service, @user, @chat_id)
        runner.start_quiz(test_type)
      end
      
      def start_luscher_test
        service = LuscherTestService.new(@bot_service, @user, @chat_id)
        service.start_test
      end
    end
  end
end
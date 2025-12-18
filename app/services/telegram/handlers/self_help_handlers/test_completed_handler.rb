# app/services/telegram/handlers/self_help_handlers/test_completed_handler.rb

module Telegram
  module Handlers
    class TestCompletedHandler < BaseHandler
      def process
        log_info("Processing test completion")
        
        # Определяем, какой тест завершен
        test_type = extract_test_type
        
        unless test_type
          log_error("Could not extract test type from callback", callback_data: @callback_data)
          answer_callback_query("Ошибка: не удалось определить тест")
          return
        end
        
        log_info("Test completed: #{test_type}")
        
        # Загружаем фасад программы самопомощи
        require Rails.root.join('app/services/self_help/facade/self_help_facade') unless defined?(SelfHelp::Facade::SelfHelpFacade)
        
        facade = SelfHelp::Facade::SelfHelpFacade.new(@bot_service, @user, @chat_id)
        
        case test_type
        when :depression
          # После теста на депрессию спрашиваем про тест на тревожность
          facade.handle_test_completion(:depression)
        when :anxiety
          # После теста на тревожность переходим к дню 1
          facade.handle_test_completion(:anxiety)
        else
          log_error("Unknown test type: #{test_type}")
          answer_callback_query("Неизвестный тип теста")
          return
        end
        
        answer_callback_query("Продолжаем программу...")
      end
      
      private
      
      def extract_test_type
        case @callback_data
        when 'test_completed_depression'
          :depression
        when 'test_completed_anxiety'
          :anxiety
        else
          nil
        end
      end
    end
  end
end
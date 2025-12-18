# app/services/telegram/handlers/test_handlers/luscher_test_start_handler.rb

module Telegram
  module Handlers
    class LuscherTestStartHandler < BaseHandler
      def process
        log_info("Starting Luscher test")
        
        # Загружаем сервис
        require Rails.root.join('app/services/luscher_test_service') unless defined?(LuscherTestService)
        
        # Инициализируем сервис теста Люшера
        service = LuscherTestService.new(@bot_service, @user, @chat_id)
        
        if service.start_test
          answer_callback_query("Запускаю тест Люшера...")
        else
          log_error("Failed to start Luscher test")
          answer_callback_query("Ошибка при запуске теста")
        end
      end
    end
  end
end
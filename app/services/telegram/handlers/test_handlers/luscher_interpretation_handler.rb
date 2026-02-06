# app/services/telegram/handlers/test_handlers/luscher_interpretation_handler.rb

module Telegram
  module Handlers
    class LuscherInterpretationHandler < BaseHandler
      def process
        log_info("Showing Luscher interpretation")
        
        # Загружаем сервис
        require Rails.root.join('app/services/luscher_test_service') unless defined?(LuscherTestService)
        
        # Инициализируем сервис теста Люшера
        service = LuscherTestService.new(@bot_service, @user, @chat_id)
        
        if service.show_interpretation
          answer_callback_query( "Показываю интерпретацию...")
        else
          log_error("Failed to show Luscher interpretation")
          answer_callback_query( "Ошибка при получении интерпретации")
        end
      end
    end
  end
end
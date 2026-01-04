# app/services/telegram/handlers/test_handlers/test_manager_handler.rb
module Telegram
  module Handlers
    class TestManagerHandler < BaseHandler
      def process
        log_info("Showing test categories")
        
        TestManager.new(@bot_service, @user, @chat_id).show_categories
        answer_callback_query( "Выберите тест")
      end
    end
  end
end
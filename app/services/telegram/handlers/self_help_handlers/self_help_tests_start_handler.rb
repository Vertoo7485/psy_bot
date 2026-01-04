# app/services/telegram/handlers/self_help_handlers/self_help_tests_start_handler.rb
module Telegram
  module Handlers
    class SelfHelpTestsStartHandler < BaseHandler
      def process
        log_info("Starting self-help program tests")
        
        facade = SelfHelp::Facade::SelfHelpFacade.new(@bot_service, @user, @chat_id)
        facade.start_tests_sequence
        
        answer_callback_query( "Начинаем тестирование")
      end
    end
  end
end
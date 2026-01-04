# app/services/telegram/handlers/self_help_handlers/self_help_program_start_handler.rb
module Telegram
  module Handlers
    class SelfHelpProgramStartHandler < BaseHandler
      def process
        log_info("Starting self-help program")
        
        facade = SelfHelp::Facade::SelfHelpFacade.new(@bot_service, @user, @chat_id)
        facade.start_program
        
        answer_callback_query( "Начинаем программу самопомощи")
      end
    end
  end
end
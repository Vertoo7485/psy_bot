module Telegram
  module Handlers
    class RestartProgramHandler < BaseHandler
      def process
        log_info("Restarting self-help program")
        
        # Загружаем фасад
        require Rails.root.join('app/services/self_help/facade/self_help_facade') unless defined?(SelfHelp::Facade::SelfHelpFacade)
        
        facade = SelfHelp::Facade::SelfHelpFacade.new(@bot_service, @user, @chat_id)
        
        # Очищаем и перезапускаем программу
        facade.clear_and_restart
        
        answer_callback_query("Начинаем заново")
      end
    end
  end
end
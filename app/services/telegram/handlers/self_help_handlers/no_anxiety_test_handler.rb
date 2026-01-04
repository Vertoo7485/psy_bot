module Telegram
  module Handlers
    class NoAnxietyTestHandler < BaseHandler
      def process
        log_info("User declined anxiety test")
        
        # Загружаем фасад
        require Rails.root.join('app/services/self_help/facade/self_help_facade') unless defined?(SelfHelp::Facade::SelfHelpFacade)
        
        facade = SelfHelp::Facade::SelfHelpFacade.new(@bot_service, @user, @chat_id)
        
        # Пропускаем тест на тревожность и переходим к дню 1
        facade.skip_anxiety_test
        
        answer_callback_query( "Пропускаем тест на тревожность, переходим к программе...")
      end
    end
  end
end
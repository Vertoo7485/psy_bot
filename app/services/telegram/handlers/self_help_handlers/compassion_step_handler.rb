module Telegram
  module Handlers
    class CompassionStepHandler < BaseHandler
      def process
        log_info("Processing compassion step: #{@callback_data}")
        
        # Просто передаем в сервис
        service = SelfHelp::Days::Day17Service.new(@bot_service, @user, @chat_id)
        service.handle_button(@callback_data)
        
        answer_callback_query("Продолжаем...")
      end
    end
  end
end
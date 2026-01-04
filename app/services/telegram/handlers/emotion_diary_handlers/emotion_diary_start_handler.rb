# app/services/telegram/handlers/emotion_diary_handlers/emotion_diary_start_handler.rb

module Telegram
  module Handlers
    class EmotionDiaryStartHandler < BaseHandler
      def process
        log_info("Starting emotion diary")
        
        # Загружаем сервис
        require Rails.root.join('app/services/emotion_diary_service') unless defined?(EmotionDiaryService)
        
        service = EmotionDiaryService.new(@bot_service, @user, @chat_id)
        service.start_diary_menu
        
        answer_callback_query( "Открываю дневник эмоций")
      end
    end
  end
end
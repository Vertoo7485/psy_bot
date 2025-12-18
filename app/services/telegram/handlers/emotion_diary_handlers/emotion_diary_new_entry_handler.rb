# app/services/telegram/handlers/emotion_diary_handlers/emotion_diary_new_entry_handler.rb

module Telegram
  module Handlers
    class EmotionDiaryNewEntryHandler < BaseHandler
      def process
        log_info("Starting new emotion diary entry")
        
        # Загружаем сервис
        require Rails.root.join('app/services/emotion_diary_service') unless defined?(EmotionDiaryService)
        
        # Инициализируем сервис дневника эмоций
        service = EmotionDiaryService.new(@bot_service, @user, @chat_id)
        
        # Начинаем новую запись
        service.start_new_entry
        
        answer_callback_query("Начинаем новую запись...")
      end
    end
  end
end
# app/services/telegram/handlers/emotion_diary_handlers/emotion_diary_show_handler.rb

module Telegram
  module Handlers
    class EmotionDiaryShowHandler < BaseHandler
      def process
        log_info("Showing emotion diary entries")
        
        # Загружаем сервис
        require Rails.root.join('app/services/emotion_diary_service') unless defined?(EmotionDiaryService)
        
        # Инициализируем сервис дневника эмоций
        service = EmotionDiaryService.new(@bot_service, @user, @chat_id)
        
        # Показываем записи (например, последние 10)
        service.show_entries(10)
        
        answer_callback_query("Показываю записи дневника...")
      end
    end
  end
end
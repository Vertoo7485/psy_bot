# app/services/telegram/handlers/emotion_diary_handlers/emotion_diary_show_all_handler.rb

module Telegram
  module Handlers
    class EmotionDiaryShowAllHandler < BaseHandler
      def process
        log_info("Showing all emotion diary entries")
        
        # Загружаем сервис
        require Rails.root.join('app/services/emotion_diary_service') unless defined?(EmotionDiaryService)
        
        # Инициализируем сервис дневника эмоций
        service = EmotionDiaryService.new(@bot_service, @user, @chat_id)
        
        # Показываем все записи
        service.show_entries(100) # или nil для всех
        
        answer_callback_query("Показываю все записи дневника...")
      end
    end
  end
end
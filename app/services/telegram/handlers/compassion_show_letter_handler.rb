# app/services/telegram/handlers/compassion_show_letter_handler.rb

module Telegram
  module Handlers
    class CompassionShowLetterHandler < BaseHandler
      attr_accessor :letter_id
      
      def process
        log_info("Showing compassion letter #{letter_id}")
        
        # Получаем письмо
        letter = CompassionLetter.find_by(id: letter_id, user_id: @user.id)
        
        if letter.nil?
          send_message(text: "❌ Письмо не найдено.")
          return
        end
        
        # Форматируем письмо для показа
        message = letter.formatted_letter
        
        # Отправляем письмо
        send_message(
          text: message,
          parse_mode: 'Markdown',
          reply_markup: letter_actions_markup(letter.id)
        )
        
        answer_callback_query("Показываю письмо")
        
      rescue => e
        log_error("Error showing compassion letter", e)
        answer_callback_query("Ошибка при показе письма")
      end
      
      private
      
      def letter_actions_markup(letter_id)
        {
          inline_keyboard: [
            [
              { text: "⭐ Добавить в избранное", callback_data: "compassion_favorite_#{letter_id}" },
              { text: "🔄 Написать похожее", callback_data: "compassion_similar_#{letter_id}" }
            ],
            [
              { text: "🗑️ Удалить", callback_data: "compassion_delete_#{letter_id}" }
            ],
            [
              { text: "📚 Назад к списку", callback_data: 'view_compassion_letters' }
            ]
          ]
        }.to_json
      end
    end
  end
end
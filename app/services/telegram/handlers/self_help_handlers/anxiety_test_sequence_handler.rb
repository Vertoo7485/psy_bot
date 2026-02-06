module Telegram
  module Handlers
    class AnxietyTestSequenceHandler < BaseHandler
      def process
        log_info("Starting anxiety test sequence")
        
        # Проверяем состояние пользователя
        if @user.self_help_state == 'awaiting_anxiety_test_completion'
          # Пользователь должен пройти тест на тревожность
          start_anxiety_test_directly
        else
          # Предлагаем пройти тест на тревожность (альтернативный вариант)
          offer_anxiety_test_choice
        end
      end
      
      private
      
      def start_anxiety_test_directly
        log_info("Directly starting anxiety test for user in sequence")
        
        # Запускаем тест на тревожность
        @user.store_self_help_data('current_test_type', 'anxiety')
        @user.store_self_help_data('in_program_test', true)
        
        test_manager = TestManager.new(@bot_service, @user, @chat_id)
        
        if test_manager.prepare_test('anxiety', in_program_context: true)
          answer_callback_query( "Запускаю тест на тревожность...")
        else
          log_error("Failed to prepare anxiety test")
          answer_callback_query( "Ошибка при запуске теста")
        end
      end
      
      def offer_anxiety_test_choice
        log_info("Offering anxiety test choice")
        
        message = <<~MARKDOWN
          🔍 *Рекомендуется пройти тест на тревожность*

          Это поможет получить более полную картину вашего состояния и адаптировать программу самопомощи.

          Хотите пройти тест сейчас?
        MARKDOWN
        
        markup = {
          inline_keyboard: [
            [
              { text: "✅ Да, пройти тест", callback_data: 'start_anxiety_test_from_sequence' }
            ],
            [
              { text: "➡️ Нет, пропустить", callback_data: 'no_anxiety_test_sequence' }
            ]
          ]
        }.to_json
        
        send_message(
          text: message,
          parse_mode: 'Markdown',
          reply_markup: markup
        )
        
        answer_callback_query( "Показываю варианты...")
      end
    end
  end
end
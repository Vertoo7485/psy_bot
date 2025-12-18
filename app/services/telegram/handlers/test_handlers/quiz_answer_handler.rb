# app/services/telegram/handlers/test_handlers/quiz_answer_handler.rb

module Telegram
  module Handlers
    class QuizAnswerHandler < BaseHandler
      def process
        unless has_matches? && matches.length >= 3
          log_error("Invalid callback data format: #{@callback_data}")
          answer_callback_query("Ошибка: неверный формат данных")
          return
        end
        
        question_id = match_group(1).to_i
        answer_option_id = match_group(2).to_i
        test_result_id = match_group(3).to_i
        
        log_info("Processing answer", {
          question_id: question_id, 
          answer_option_id: answer_option_id, 
          test_result_id: test_result_id
        })
        
        # Обрабатываем ответ
        runner = QuizRunner.new(@bot_service, @user, @chat_id)
        success = runner.process_answer(question_id, answer_option_id, test_result_id)
        
        if success
          answer_callback_query("Ответ принят")
        else
          answer_callback_query("Ошибка при обработке ответа")
        end
      end
    end
  end
end
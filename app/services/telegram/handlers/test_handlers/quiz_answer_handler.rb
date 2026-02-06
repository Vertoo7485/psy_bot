module Telegram
  module Handlers
    module TestHandlers
      class QuizAnswerHandler < BaseHandler
        def initialize(bot_service, user, chat_id, callback_query_data)
          super(bot_service, user, chat_id, callback_query_data)
          log_info("QuizAnswerHandler initialized", user_id: @user&.id, callback_data: @callback_data)
        end

        def process
          log_info("Processing quiz answer", callback_data: @callback_data)
          
          # Извлекаем ответ из callback_data
          # Новый формат: answer_<question_id>_<option_id>_<test_result_id>
          match = @callback_data.match(/^answer_(\d+)_(\d+)_(\d+)$/)
          
          unless match
            log_error("Invalid answer format", callback_data: @callback_data)
            send_message(text: "Ошибка: неверный формат ответа")
            return
          end
          
          question_id = match[1].to_i
          option_id = match[2].to_i
          test_result_id = match[3].to_i
          
          # Обрабатываем ответ через QuizRunner
          quiz_runner = QuizRunner.new(@bot_service, @user, @chat_id)
          quiz_runner.process_answer(question_id, option_id, test_result_id)
          
          answer_callback_query("Ответ принят")
        end

        private

        def log_info(message, data = {})
          Rails.logger.info "[QuizAnswerHandler] #{message} - #{data}"
        end

        def log_error(message, data = {})
          Rails.logger.error "[QuizAnswerHandler] #{message} - #{data}"
        end
      end
    end
  end
end
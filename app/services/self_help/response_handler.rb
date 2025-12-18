# app/services/self_help/response_handler.rb
module SelfHelp
  class ResponseHandler
    include TelegramMarkupHelper
    
    attr_reader :bot_service, :user, :chat_id
    
    def initialize(bot_service, user, chat_id)
      @bot_service = bot_service
      @user = user
      @chat_id = chat_id
    end
    
    def handle(response_type)
      case response_type.to_sym
      when :yes
        handle_yes_response
      when :no
        handle_no_response
      when :resume
        handle_resume_response
      when :restart
        handle_restart_response
      else
        handle_unknown_response
      end
    end
    
    private
    
    # Обработка положительного ответа
    def handle_yes_response
      case @user.self_help_state
      when 'awaiting_anxiety_test_completion'
        start_anxiety_test
      else
        send_generic_response("Отлично! Продолжаем.")
      end
    end
    
    # Обработка отрицательного ответа
    def handle_no_response
      case @user.self_help_state
      when 'awaiting_anxiety_test_completion'
        skip_anxiety_test
      else
        send_generic_response("Хорошо, вернемся к этому позже.")
      end
    end
    
    # Обработка возобновления сессии
    def handle_resume_response
      facade = Facade::SelfHelpFacade.new(@bot_service, @user, @chat_id)
      facade.resume_from_state(@user.self_help_state)
    end
    
    # Обработка перезапуска программы
    def handle_restart_response
      facade = Facade::SelfHelpFacade.new(@bot_service, @user, @chat_id)
      facade.clear_and_restart
    end
    
    # Обработка неизвестного ответа
    def handle_unknown_response
      send_error_message("Не удалось обработать ответ. Пожалуйста, попробуйте еще раз.")
    end
    
    # Запуск теста на тревожность
    def start_anxiety_test
      TestSequenceManager.new(@bot_service, @user, @chat_id).start_anxiety_test
    end
    
    # Пропуск теста на тревожность
    def skip_anxiety_test
      TestSequenceManager.new(@bot_service, @user, @chat_id).skip_anxiety_test
    end
    
    # Отправка общего ответа
    def send_generic_response(text)
      @bot_service.send_message(
        chat_id: @chat_id,
        text: text,
        reply_markup: TelegramMarkupHelper.main_menu_markup
      )
    end
    
    # Отправка сообщения об ошибке
    def send_error_message(text)
      @bot_service.send_message(
        chat_id: @chat_id,
        text: text,
        reply_markup: TelegramMarkupHelper.main_menu_markup
      )
    end
  end
end
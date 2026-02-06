# app/services/telegram/handlers/test_handlers/test_completed_handler.rb
module Telegram
  module Handlers
    class TestCompletedHandler < BaseHandler
      def process
        log_info("Processing test completion")
        
        test_type = extract_test_type
        
        unless test_type
          log_error("Could not extract test type", callback_data: @callback_data)
          answer_callback_query( "Ошибка: не удалось определить тест")
          return
        end
        
        log_info("Test completed: #{test_type}")
        
        # ПРОВЕРЯЕМ КОНТЕКСТ
        # Если пользователь НЕ в программе самопомощи - показываем главное меню
        unless @user.in_self_help_program?
          show_main_menu
          return
        end
        
        # Только если пользователь в программе самопомощи
        handle_program_test_completion(test_type)
        
        answer_callback_query( "Продолжаем программу...")
      end
      
      private
      
      def extract_test_type
        case @callback_data
        when 'test_completed_depression'
          :depression
        when 'test_completed_anxiety'
          :anxiety
        else
          nil
        end
      end
      
      def show_main_menu
        require Rails.root.join('app/services/telegram/handlers/general_handlers/main_menu_handler')
        handler = MainMenuHandler.new(@bot_service, @user, @chat_id, nil, @callback_data)
        handler.process
      end
      
      def handle_program_test_completion(test_type)
        require Rails.root.join('app/services/self_help/facade/self_help_facade')
        facade = SelfHelp::Facade::SelfHelpFacade.new(@bot_service, @user, @chat_id)
        facade.handle_test_completion(test_type)
      end
    end
  end
end
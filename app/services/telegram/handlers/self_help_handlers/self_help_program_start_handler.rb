# app/services/telegram/handlers/self_help_handlers/self_help_program_start_handler.rb
module Telegram
  module Handlers
    class SelfHelpProgramStartHandler < BaseHandler
      def process
        log_info("Starting self-help program")
        
        # ПРОВЕРКА ДОСТУПА К ПРОГРАММЕ
        access_service = AccessControlService.new(@user)
        begin
          access_service.check_self_help_access!
        rescue AccessControlService::NotPremiumError => e
          # Показываем сообщение об ошибке из AccessControlService
          answer_callback_query("❌ Для доступа к программе самопомощи необходим премиум доступ")
          send_message(
            text: e.message,
            parse_mode: 'Markdown'
          )
          return
        rescue AccessControlService::AccessDenied => e
          # Общая ошибка доступа
          answer_callback_query("❌ Ошибка доступа")
          send_message(
            text: e.message,
            parse_mode: 'Markdown'
          )
          return
        end
        
        # Если доступ есть - запускаем программу
        facade = SelfHelp::Facade::SelfHelpFacade.new(@bot_service, @user, @chat_id)
        facade.start_program
        
        answer_callback_query("Начинаем программу самопомощи")
      end
    end
  end
end
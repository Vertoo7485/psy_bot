module Telegram
  module Handlers
    class ProgramCompleteHandler < BaseHandler
      def process
        log_info("Completing program - callback: #{@callback_data}")
        
        case @callback_data
        when 'complete_program_final'
          handle_program_completion
        when 'restart_self_help_program'
          handle_program_restart
        else
          log_error("Unknown program completion callback", callback_data: @callback_data)
          answer_callback_query("Неизвестная команда завершения программы")
        end
      end
      
      private
      
      def handle_program_completion
        log_info("Finalizing program completion")
        
        # Очищаем все данные программы
        @user.clear_self_help_program_data
        @user.active_session&.destroy
        
        # Обновляем состояние пользователя
        @user.update(
          self_help_program_step: nil,
          current_diary_step: nil,
          diary_data: {}
        )
        
        # Отправляем финальное сообщение
        send_message(
          text: "🎊 *Программа самопомощи успешно завершена!* 🎊\n\n" \
                "Все ваши данные сохранены. Вы можете в любой момент:\n" \
                "• Пройти программу заново\n" \
                "• Использовать отдельные техники\n" \
                "• Обратиться к дневнику эмоций",
          parse_mode: 'Markdown',
          reply_markup: TelegramMarkupHelper.main_menu_markup
        )
        
        answer_callback_query("Программа завершена!")
      end
      
      def handle_program_restart
        log_info("Restarting self-help program")
        
        # Очищаем данные программы
        @user.clear_self_help_program_data
        @user.active_session&.destroy
        
        # Сбрасываем состояние
        @user.update(
          self_help_program_step: nil,
          current_diary_step: nil,
          diary_data: {}
        )
        
        # Запускаем программу заново
        facade = SelfHelp::Facade::SelfHelpFacade.new(@bot_service, @user, @chat_id)
        facade.start_program
        
        answer_callback_query("Начинаем программу заново!")
      end
    end
  end
end
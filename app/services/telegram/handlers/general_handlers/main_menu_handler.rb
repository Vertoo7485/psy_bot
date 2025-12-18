# app/services/telegram/handlers/general_handlers/main_menu_handler.rb
module Telegram
  module Handlers
    class MainMenuHandler < BaseHandler
      def process
        log_info("Showing main menu")
        
        # Если пользователь в программе, показываем соответствующие кнопки
        if @user.self_help_state&.start_with?('day_')
          day_number = @user.current_day_number
          if day_number
            message = "Вы находитесь в Дне #{day_number} программы самопомощи. Что вы хотите сделать?"
            send_message(
              text: message,
              reply_markup: TelegramMarkupHelper.main_menu_markup
            )
            return
          end
        end
        
        # Стандартное главное меню
        send_message(
          text: "Главное меню. Выберите действие:",
          reply_markup: TelegramMarkupHelper.main_menu_markup
        )
        
        answer_callback_query("Возвращаемся в главное меню")
      end
    end
  end
end
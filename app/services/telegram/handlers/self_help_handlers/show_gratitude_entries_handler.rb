# app/services/telegram/handlers/self_help_handlers/show_gratitude_entries_handler.rb
module Telegram
  module Handlers
    class ShowGratitudeEntriesHandler < BaseHandler
      def process
        log_info("Showing gratitude entries for user")
        
        # Проверяем, находится ли пользователь в контексте дня 3
        if @user.self_help_state&.start_with?('day_3')
          show_day_3_gratitude_entries
        else
          show_all_gratitude_entries
        end
        
        answer_callback_query( "Показываю записи благодарности...")
      end
      
      private
      
      def show_day_3_gratitude_entries
        # Используем Day3Service для показа записей
        require Rails.root.join('app/services/self_help/days/day_3_service') unless defined?(SelfHelp::Days::Day3Service)
        
        service = SelfHelp::Days::Day3Service.new(@bot_service, @user, @chat_id)
        service.show_gratitude_entries
      end
      
      def show_all_gratitude_entries
        # Простой показ всех записей
        entries = @user.gratitude_entries.recent.limit(10)
        
        if entries.empty?
          send_message(
            text: "📭 У вас пока нет записей благодарности.",
            reply_markup: TelegramMarkupHelper.main_menu_markup
          )
          return
        end
        
        message = "❤️ *Ваши записи благодарности* ❤️\n\n"
        
        entries.each_with_index do |entry, index|
          message += "*#{index + 1}. #{entry.entry_date.strftime('%d.%m.%Y')}*\n"
          message += "#{entry.entry_text.truncate(100)}\n"
          message += "─" * 30 + "\n\n"
        end
        
        message += "Всего записей: #{entries.count}"
        
        send_message(
          text: message,
          parse_mode: 'Markdown',
          reply_markup: back_to_day_3_menu_markup
        )
      end
      
      def back_to_day_3_menu_markup
        {
          inline_keyboard: [
            [{ text: "⬅️ Назад к Дню 3", callback_data: 'back_to_day_3_menu' }],
            [{ text: "🏠 Главное меню", callback_data: 'back_to_main_menu' }]
          ]
        }.to_json
      end
    end
  end
end
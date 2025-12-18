# app/services/telegram/handlers/self_help_handlers/day_complete_handler.rb
module Telegram
  module Handlers
    class DayCompleteHandler < BaseHandler
      def process
        day_number = extract_day_number
        
        unless day_number
          log_error("Could not extract day number", callback_data: @callback_data)
          answer_callback_query("Ошибка: не удалось определить день")
          return
        end
        
        log_info("Completing day #{day_number}")
        
        # Для дня 3
        if day_number == 3
          handle_day_3_completion
        else
          # Для других дней
          handle_other_day_completion(day_number)
        end
        
      rescue => e
        log_error("Error in DayCompleteHandler", e)
        answer_callback_query("Ошибка при завершении дня")
      end
      
      private
      
      def extract_day_number
        return match_group(1).to_i if has_matches?
        
        # Пробуем извлечь из callback_data
        match = @callback_data.match(/complete_day_(\d+)/)
        match ? match[1].to_i : nil
      end
      
      def handle_day_3_completion
        # Проверяем, есть ли записи благодарности
        if @user.gratitude_entries.empty?
          send_message(
            text: "📝 *Сначала создайте запись благодарности!*\n\nНажмите 'Ввести благодарности' для создания записи.",
            parse_mode: 'Markdown',
            reply_markup: TelegramMarkupHelper.day_3_menu_markup
          )
          answer_callback_query("Сначала создайте запись")
          return
        end
        
        # Используем Day3Service
        begin
          require Rails.root.join('app/services/self_help/days/day_3_service')
          service = SelfHelp::Days::Day3Service.new(@bot_service, @user, @chat_id)
          service.complete_day
          
          answer_callback_query("День 3 завершен!")
        rescue => e
          log_error("Failed to complete day 3 with Day3Service", e)
          fallback_day_3_completion
        end
      end
      
      def fallback_day_3_completion
        # Простое завершение, если Day3Service не сработал
        @user.complete_self_help_day(3)
        
        message = <<~MARKDOWN
          🎉 *День 3 завершен!* 🎉

          Вы освоили практику благодарности!

          Готовы перейти к следующему дню?
        MARKDOWN
        
        send_message(
          text: message,
          parse_mode: 'Markdown',
          reply_markup: {
            inline_keyboard: [
              [{ text: "➡️ Начать День 4", callback_data: 'start_day_4_from_proposal' }],
              [{ text: "🏠 Главное меню", callback_data: 'back_to_main_menu' }]
            ]
          }.to_json
        )
        
        answer_callback_query("День 3 завершен!")
      end
      
      def handle_other_day_completion(day_number)
        log_info("Completing day #{day_number}")
        
        # Общая логика для других дней
        @user.complete_self_help_day(day_number)
        
        # Предложить следующий день, если не последний
        if day_number < 13
          next_day = day_number + 1
          
          send_message(
            text: "✅ День #{day_number} завершен!\n\nГотовы начать День #{next_day}?",
            reply_markup: TelegramMarkupHelper.day_start_proposal_markup(next_day)
          )
        else
          # Последний день
          send_message(
            text: "🎊 *Программа завершена!* 🎊\n\nВы прошли все 13 дней!",
            parse_mode: 'Markdown',
            reply_markup: TelegramMarkupHelper.final_program_completion_markup
          )
        end
        
        answer_callback_query("День #{day_number} завершен!")
      end
    end
  end
end
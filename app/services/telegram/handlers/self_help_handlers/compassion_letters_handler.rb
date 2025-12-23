# app/services/telegram/handlers/self_help_handlers/compassion_letters_handler.rb

module Telegram
  module Handlers
    class CompassionLettersHandler < BaseHandler
      def process
        log_info("Processing compassion letters callback: #{@callback_data}")
        
        case @callback_data
        when 'view_compassion_letters'
          show_compassion_letters_simple
        when 'compassion_by_date'
          show_by_date_simple
        when 'compassion_best'
          show_best_letters_simple
        else
          show_compassion_menu_simple
        end
      end
      
      private
      
      def show_compassion_letters_simple
        # Простой прямой запрос к базе данных
        letters = CompassionLetter.where(user_id: @user.id).order(created_at: :desc).limit(5)
        
        if letters.empty?
          send_message(
            text: "📭 У вас пока нет сохраненных писем самосострадания.\n\nНапишите первое письмо в упражнении дня 17!",
            reply_markup: simple_day_17_markup
          )
          return
        end
        
        message = "📚 Ваши письма самосострадания:\n\n"
        
        letters.each_with_index do |letter, index|
          date = letter.entry_date.strftime('%d.%m.%Y')
          preview = letter.situation_text.to_s.truncate(50)
          
          message += "#{index + 1}. 📅 #{date}\n"
          message += "   💭 #{preview}\n\n"
        end
        
        send_message(
          text: message,
          parse_mode: 'Markdown',
          reply_markup: simple_compassion_letters_markup
        )
      end
      
      def show_by_date_simple
        letters = CompassionLetter.where(user_id: @user.id).order(entry_date: :desc)
        
        if letters.empty?
          send_message(text: "У вас пока нет сохраненных писем.")
          return
        end
        
        message = "📅 Ваши письма по дате:\n\n"
        
        letters.group_by(&:entry_date).each do |date, date_letters|
          message += "#{date.strftime('%d.%m.%Y')}: #{date_letters.count} писем\n"
        end
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def show_best_letters_simple
        # Показываем последние 3 письма как "лучшие"
        letters = CompassionLetter.where(user_id: @user.id).order(created_at: :desc).limit(3)
        
        if letters.empty?
          send_message(text: "У вас пока нет сохраненных писем.")
          return
        end
        
        send_message(text: "⭐ Ваши последние письма самосострадания:", parse_mode: 'Markdown')
        
        letters.each do |letter|
          message = "📅 #{letter.entry_date.strftime('%d.%m.%Y')}\n"
          message += "💭 #{letter.situation_text.to_s.truncate(100)}\n"
          message += "─" * 20
          
          send_message(text: message, parse_mode: 'Markdown')
        end
      end
      
      def show_compassion_menu_simple
        send_message(
          text: "✉️ Письма самосострадания\n\nВыберите опцию:",
          reply_markup: simple_compassion_menu_markup
        )
      end
      
      def simple_day_17_markup
        {
          inline_keyboard: [
            [
              { text: "✍️ Начать упражнение", callback_data: 'start_day_17_exercise' }
            ]
          ]
        }.to_json
      end
      
      def simple_compassion_letters_markup
        {
          inline_keyboard: [
            [
              { text: "📅 По дате", callback_data: 'compassion_by_date' },
              { text: "✍️ Новое письмо", callback_data: 'start_day_17_exercise' }
            ],
            [
              { text: "📋 Назад", callback_data: 'back_to_day_17_menu' }
            ]
          ]
        }.to_json
      end
      
      def simple_compassion_menu_markup
        {
          inline_keyboard: [
            [
              { text: "📚 Все письма", callback_data: 'view_compassion_letters' },
              { text: "📅 По дате", callback_data: 'compassion_by_date' }
            ],
            [
              { text: "✍️ Новое письмо", callback_data: 'start_day_17_exercise' }
            ],
            [
              { text: "📋 Назад", callback_data: 'back_to_day_17_menu' }
            ]
          ]
        }.to_json
      end
    end
  end
end
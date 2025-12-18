# app/services/self_help/days/day_3_service.rb
module SelfHelp
  module Days
    class Day3Service < DayBaseService
      include TelegramMarkupHelper
      # Константы
      DAY_NUMBER = 3
      GRATITUDE_ITEMS_COUNT = 3
      
      def deliver_intro
        message_text = <<~MARKDOWN
          🎯 *День 3: Практика благодарности* 🎯

          **Сила благодарности**

          Практика благодарности — это один из самых эффективных способов переключить фокус внимания с негатива на позитив. Это не значит игнорировать проблемы, а значит замечать хорошее, что уже есть в вашей жизни.

          **Исследования показывают, что регулярная практика благодарности:**
          • Улучшает настроение
          • Снижает уровень стресса
          • Укрепляет отношения
          • Повышает качество сна
        MARKDOWN
        
        send_message(text: message_text, parse_mode: 'Markdown')
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        
        send_message(
          text: "Готовы начать практику благодарности?",
          reply_markup: TelegramMarkupHelper.day_3_menu_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_gratitude")
        
        exercise_text = <<~MARKDOWN
          📝 *Упражнение: Дневник благодарности* 📝

          **Задание на сегодня:**

          1. Вспомните #{GRATITUDE_ITEMS_COUNT} вещи, за которые вы чувствуете благодарность сегодня
          2. Это может быть что угодно:
            • Люди в вашей жизни
            • Позитивные события
            • Простые удовольствия
            • Личные качества
            • Даже трудности, которые чему-то научили

          **Примеры:**
          • 'Благодарен за солнечное утро'
          • 'Благодарен за поддержку друга'
          • 'Благодарен за возможность учиться новому'
        MARKDOWN
        
        send_message(text: exercise_text, parse_mode: 'Markdown')
        
        send_message(
          text: "Напишите ваши #{GRATITUDE_ITEMS_COUNT} благодарности одним сообщением:",
          reply_markup: TelegramMarkupHelper.day_3_input_markup
        )
      end
      
      def complete_exercise
        # Уже обрабатывается в контекстном обработчике
        # Здесь просто обновляем состояние
        @user.set_self_help_step("day_#{DAY_NUMBER}_entry_saved")
        
        message = <<~MARKDOWN
          🌟 *Отличная работа!* 🌟

          Вы сделали важный шаг в развитии позитивного мышления.

          **Совет:**
          • Практикуйте благодарность ежедневно
          • Заведите отдельную тетрадь для благодарностей
          • Перечитывайте записи в трудные моменты

          Регулярная практика изменит ваше восприятие мира!
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Что хотите сделать дальше?",
          reply_markup: TelegramMarkupHelper.day_3_menu_markup
        )
      end
      
      def complete_day
        @user.complete_self_help_day(DAY_NUMBER)
        
        message = <<~MARKDOWN
          🎉 *День 3 завершен!* 🎉

          Вы освоили мощную практику благодарности.

          Продолжайте замечать хорошее вокруг себя!
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        propose_next_day
      end
      
      def ask_for_input_again
        send_message(
          text: "Пожалуйста, напишите #{GRATITUDE_ITEMS_COUNT} вещи, за которые вы благодарны сегодня:",
          reply_markup: TelegramMarkupHelper.day_3_input_markup
        )
      end
      
      def show_gratitude_entries
        entries = @user.gratitude_entries.recent.limit(5)
        
        if entries.empty?
          send_message(text: "У вас пока нет записей благодарности.")
          return
        end
        
        message = "❤️ *Ваши записи благодарности* ❤️\n\n"
        
        entries.each_with_index do |entry, index|
          message += "*#{entry.entry_date.strftime('%d.%m.%Y')}*\n"
          message += "#{entry.entry_text}\n\n"
        end
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def handle_gratitude_input(input_text)
        return false if input_text.blank?
        
        begin
          GratitudeEntry.create!(
            user: @user,
            entry_date: Date.current,
            entry_text: input_text
          )
          
          @user.set_self_help_step('day_3_entry_saved')
          
          send_message(
            text: "✅ Запись сохранена!",
            reply_markup: TelegramMarkupHelper.day_3_menu_markup
          )
          
          true
        rescue => e
          log_error("Failed to save gratitude entry", e)
          send_message(text: "Ошибка при сохранении. Попробуйте еще раз.")
          false
        end
      end
    end
  end
end
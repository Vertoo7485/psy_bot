# app/services/self_help/days/day_7_service.rb
module SelfHelp
  module Days
    class Day7Service < DayBaseService
      include TelegramMarkupHelper
      # Константы
      DAY_NUMBER = 7
      
      def deliver_intro
        message_text = <<~MARKDOWN
          🎯 *День 7: Подведение итогов* 🎯

          **Первая неделя завершена!**

          За прошедшую неделю вы:
          • Освоили техники осознанности
          • Попрактиковали благодарность
          • Научились регулировать дыхание
          • Добавили движение в свою жизнь
          • Уделили время отдыху

          Сегодня мы подведем итоги и закрепим прогресс.
        MARKDOWN
        
        send_message(text: message_text, parse_mode: 'Markdown')
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        
        # ИСПРАВЛЕНИЕ: Используем правильную разметку для подтверждения
        send_message(
          text: "Готовы к рефлексии первой недели?",
          reply_markup: day_7_exercise_consent_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_reflection")
        
        exercise_text = <<~MARKDOWN
          📖 *Упражнение: Рефлексия недели* 📖

          **Задание:**

          Ответьте на следующие вопросы одним сообщением:

          1. **Что было самым ценным** за эту неделю?
            (Какая техника или insight запомнились больше всего?)

          2. **Что было самым сложным?**
            (С какими упражнениями или мыслями было труднее всего?)

          3. **Что я заметил(а) в себе?**
            (Какие изменения в настроении, мыслях или поведении вы наблюдаете?)

          4. **Что хочу продолжить практиковать?**
            (Какие техники войдут в вашу регулярную практику?)
        MARKDOWN
        
        send_message(text: exercise_text, parse_mode: 'Markdown')
        
        send_message(
          text: "Напишите ваши размышления:",
          reply_markup: TelegramMarkupHelper.day_7_reflection_markup
        )
      end
      
      def complete_exercise
        # Обрабатывается в контекстном обработчике
        @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
        
        message = <<~MARKDOWN
          🌟 *Неделя завершена!* 🌟

          Вы проделали огромную работу над собой!

          **Ваши достижения:**
          ✅ Освоили 6 разных техник
          ✅ Развили навык самонаблюдения
          ✅ Сделали первые шаги к изменениям
          ✅ Проявили настойчивость и дисциплину

          **Помните:**
          • Изменения происходят постепенно
          • Регулярность важнее интенсивности
          • Будьте добры к себе в процессе
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Готовы перейти ко второй неделе программы?",
          reply_markup: TelegramMarkupHelper.complete_program_markup
        )
      end
      
      def ask_for_input_again
        send_message(
          text: "Пожалуйста, поделитесь своими размышлениями о прошедшей неделе:",
          reply_markup: TelegramMarkupHelper.day_7_reflection_markup
        )
      end
      
      def handle_reflection_input(input_text)
        return false if input_text.blank?
        
        begin
          ReflectionEntry.create!(
            user: @user,
            entry_date: Date.current,
            entry_text: input_text
          )
          
          @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
          
          send_message(
            text: "💭 Спасибо за вашу рефлексию! Неделя завершена.",
            reply_markup: TelegramMarkupHelper.complete_program_markup
          )
          
          true
        rescue => e
          log_error("Failed to save reflection entry", e)
          send_message(text: "Ошибка при сохранении. Попробуйте еще раз.")
          false
        end
      end
      
      # ИСПРАВЛЕНИЕ 1: Меняем на false, чтобы не вызывать deliver_exercise автоматически
      def should_deliver_exercise_immediately?
        false
      end
      
      # ИСПРАВЛЕНИЕ 2: Добавляем метод для обработки подтверждения от пользователя
      def handle_exercise_consent
        deliver_exercise
      end
      
      # ИСПРАВЛЕНИЕ 3: Добавляем разметку для подтверждения
      private
      
      def day_7_exercise_consent_markup
        {
          inline_keyboard: [
            [
              { text: "#{EMOJI[:check]} Да, готов(а)!", callback_data: 'start_day_7_exercise' },
              { text: "#{EMOJI[:warning]} Нет, позже", callback_data: 'back_to_main_menu' }
            ]
          ]
        }.to_json
      end
    end
  end
end
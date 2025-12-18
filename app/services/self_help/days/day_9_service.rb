# app/services/self_help/days/day_9_service.rb
module SelfHelp
  module Days
    class Day9Service < DayBaseService
      include TelegramMarkupHelper
      # Константы
      DAY_NUMBER = 9
      MIN_THOUGHT_LENGTH = 3
      MAX_THOUGHT_LENGTH = 500
      PROBABILITY_RANGE = (1..10)
      
      def deliver_intro
        message_text = <<~MARKDOWN
          🎯 *День 9: Когнитивная работа* 🎯

          **Анализ тревожных мыслей**

          Тревожные мысли часто кажутся нам абсолютно правдивыми, но если присмотреться к ним внимательнее, можно обнаружить искажения.

          **Сегодня мы научимся:**
          • Выявлять когнитивные искажения
          • Анализировать мысли объективно
          • Переформулировать их в более реалистичные

          **Метод:** Когнитивно-поведенческий подход
          **Цель:** Сделать мысли более сбалансированными
        MARKDOWN
        
        send_message(text: message_text, parse_mode: 'Markdown')
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        
        send_message(
          text: "Готовы проанализировать тревожную мысль?",
          reply_markup: TelegramMarkupHelper.day_9_menu_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_thought")
        clear_day_data
        
        exercise_text = <<~MARKDOWN
          💭 *Упражнение: Анализ тревожной мысли* 💭

          **Шаг 1: Определение мысли**

          Выберите одну тревожную мысль, которая:
          • Часто приходит в голову
          • Вызывает дискомфорт
          • Влияет на ваше настроение

          **Примеры:**
          • «Я никогда не справлюсь с этой задачей»
          • «Все думают, что я неудачник»
          • «Со мной обязательно случится что-то плохое»

          **Важно:** Не выбирайте самую болезненную мысль, начните с умеренной.
        MARKDOWN
        
        send_message(text: exercise_text, parse_mode: 'Markdown')
        
        send_message(
          text: "Напишите вашу тревожную мысль:",
          reply_markup: TelegramMarkupHelper.day_9_input_markup
        )
      end
      
      def complete_exercise
        # Собираем все данные
        thought = get_day_data('thought')
        probability = get_day_data('probability')
        facts_pro = get_day_data('facts_pro')
        facts_con = get_day_data('facts_con')
        reframe = get_day_data('reframe')
        
        # Проверяем наличие всех необходимых данных
        if thought.blank? || probability.blank? || facts_pro.blank? || facts_con.blank? || reframe.blank?
          send_message(text: "Не все данные заполнены. Пожалуйста, завершите анализ.")
          return
        end
        
        # Сохраняем в базу
        begin
          AnxiousThoughtEntry.create!(
            user: @user,
            entry_date: Date.current,
            thought: thought,
            probability: probability.to_i,
            facts_pro: facts_pro,
            facts_con: facts_con,
            reframe: reframe
          )
          
          @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
          
          summary = <<~MARKDOWN
            📊 *Анализ завершен!* 📊

            **Исходная мысль:** #{thought}
            **Вероятность:** #{probability}/10
            **Факты «за»:** #{facts_pro.truncate(50)}
            **Факты «против»:** #{facts_con.truncate(50)}
            **Переформулировка:** #{reframe.truncate(50)}

            Запись сохранена в вашем дневнике мыслей.
          MARKDOWN
          
          send_message(text: summary, parse_mode: 'Markdown')
          
        rescue => e
          log_error("Failed to save anxious thought entry", e)
          send_message(text: "Ошибка при сохранении анализа. Попробуйте еще раз.")
        end
      end
      
      def ask_for_input_again
        current_state = @user.self_help_state
        
        case current_state
        when "day_9_waiting_for_thought"
          send_message(text: "Напишите вашу тревожную мысль:")
        when "day_9_waiting_for_probability"
          send_message(text: "Оцените вероятность мысли от 1 до 10:")
        when "day_9_waiting_for_facts_pro"
          send_message(text: "Какие факты подтверждают эту мысль?")
        when "day_9_waiting_for_facts_con"
          send_message(text: "Какие факты опровергают эту мысль?")
        when "day_9_waiting_for_reframe"
          send_message(text: "Как можно переформулировать мысль более реалистично?")
        end
      end
      
      def handle_thought_input(input_text)
        return false if input_text.blank?
        
        if input_text.strip.length < MIN_THOUGHT_LENGTH
          send_message(text: "Мысль должна содержать хотя бы #{MIN_THOUGHT_LENGTH} символа. Попробуйте описать подробнее.")
          return false
        end
        
        @user.store_self_help_data('day_9_thought', input_text)
        @user.set_self_help_step('day_9_waiting_for_probability')
        
        send_message(text: "Спасибо. Теперь оцените вероятность этой мысли от 1 до 10:")
        
        true
      end
      
      def handle_probability_input(input_text)
        probability = input_text.to_i
        
        unless PROBABILITY_RANGE.include?(probability)
          send_message(text: "Пожалуйста, введите число от 1 до 10:")
          return false
        end
        
        @user.store_self_help_data('day_9_probability', probability)
        @user.set_self_help_step('day_9_waiting_for_facts_pro')
        
        send_message(text: "Какие факты подтверждают эту мысль?")
        
        true
      end
      
      def handle_facts_pro_input(input_text)
        return false if input_text.blank?
        
        @user.store_self_help_data('day_9_facts_pro', input_text)
        @user.set_self_help_step('day_9_waiting_for_facts_con')
        
        send_message(text: "Какие факты опровергают эту мысль?")
        
        true
      end
      
      def handle_facts_con_input(input_text)
        return false if input_text.blank?
        
        @user.store_self_help_data('day_9_facts_con', input_text)
        @user.set_self_help_step('day_9_waiting_for_reframe')
        
        send_message(text: "Как можно переформулировать мысль более реалистично?")
        
        true
      end
      
      def handle_reframe_input(input_text)
        return false if input_text.blank?
        
        @user.store_self_help_data('day_9_reframe', input_text)
        
        # Все шаги выполнены, показываем кнопку завершения
        send_message(
          text: "✅ Все данные собраны! Нажмите кнопку, чтобы завершить анализ:",
          reply_markup: TelegramMarkupHelper.day_9_back_to_menu_markup
        )
        
        true
      end
      
      def show_current_progress
        thought = get_day_data('thought')
        probability = get_day_data('probability')
        facts_pro = get_day_data('facts_pro')
        facts_con = get_day_data('facts_con')
        reframe = get_day_data('reframe')
        
        message = "📝 *Текущий прогресс по Дню 9:*\n\n"
        
        if thought.present?
          message += "• **Мысль:** #{thought}\n"
          message += "• **Вероятность:** #{probability || '—'}\n"
          message += "• **Факты «за»:** #{facts_pro || '—'}\n"
          message += "• **Факты «против»:** #{facts_con || '—'}\n"
          message += "• **Переформулировка:** #{reframe || '—'}\n\n"
        else
          message += "Анализ еще не начат.\n\n"
        end
        
        # Показываем последние сохраненные анализы
        entries = @user.anxious_thought_entries.recent.limit(3)
        if entries.any?
          message += "📚 **Последние анализы:**\n"
          entries.each_with_index do |entry, index|
            message += "#{index + 1}. #{entry.thought.truncate(40)}\n"
          end
        end
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def show_all_entries
        entries = @user.anxious_thought_entries.recent
        
        if entries.empty?
          send_message(text: "У вас пока нет сохраненных анализов мыслей.")
          return
        end
        
        entries.each_with_index do |entry, index|
          message = <<~MARKDOWN
            📖 *Анализ ##{index + 1}* (#{entry.entry_date.strftime('%d.%m.%Y')})

            💭 **Мысль:** #{entry.thought}
            📊 **Вероятность:** #{entry.probability}/10
            ✅ **Факты «за»:** #{entry.facts_pro}
            ❌ **Факты «против»:** #{entry.facts_con}
            🔄 **Переформулировка:** #{entry.reframe}
            ──────────────────────────────
          MARKDOWN
          
          send_message(text: message, parse_mode: 'Markdown')
        end
        
        send_message(
          text: "Всего анализов: #{entries.count}",
          reply_markup: TelegramMarkupHelper.day_9_menu_markup
        )
      end
    end
  end
end
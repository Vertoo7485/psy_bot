# app/services/self_help/days/day_11_service.rb
module SelfHelp
  module Days
    class Day11Service < DayBaseService
      include TelegramMarkupHelper
      # Константы
      DAY_NUMBER = 11
      GROUNDING_STEPS = {
        'seen' => {
          title: "👀 **Шаг 1: 5 вещей, которые вы видите**",
          instruction: "Оглядитесь вокруг и назовите **5 вещей**, которые вы видите.\n\nЭто могут быть:\n• Предметы в комнате\n• Цвета и формы\n• Детали обстановки\n\n**Напишите их через запятую:**",
          min_count: 5
        },
        'touched' => {
          title: "✋ **Шаг 2: 4 вещи, которые вы можете потрогать**",
          instruction: "Найдите **4 вещи**, которые можете потрогать прямо сейчас.\n\nОбратите внимание на:\n• Текстуру (гладкая, шершавая)\n• Температуру (теплая, холодная)\n• Форму и твердость\n\n**Опишите их и ощущения:**",
          min_count: 1
        },
        'heard' => {
          title: "👂 **Шаг 3: 3 вещи, которые вы слышите**",
          instruction: "Прислушайтесь и назовите **3 звука**, которые слышите.\n\nЭто могут быть:\n• Звуки окружающей среды\n• Ваше собственное дыхание\n• Отдаленные шумы\n\n**Перечислите их:**",
          min_count: 3
        },
        'smelled' => {
          title: "👃 **Шаг 4: 2 вещи, запах которых вы чувствуете**",
          instruction: "Постарайтесь почувствовать **2 разных запаха**.\n\nЕсли рядом нет явных запахов:\n• Почувствуйте запах собственной кожи\n• Запах одежды\n• Запах воздуха в комнате\n\n**Что вы чувствуете?**",
          min_count: 1
        },
        'tasted' => {
          title: "👅 **Шаг 5: 1 вещь, которую вы можете попробовать на вкус**",
          instruction: "Найдите **1 вещь**, которую можете попробовать на вкус.\n\nЭто может быть:\n• Еда или напиток\n• Вкус во рту\n• Жевательная резинка\n\n**Опишите вкус:**",
          min_count: 1
        }
      }.freeze
      
      def deliver_intro
        message_text = <<~MARKDOWN
          🎯 *День 11: Экстренная самопомощь* 🎯

          **Техника «Заземление 5-4-3-2-1»**

          Когда тревога или панические ощущения становятся слишком интенсивными, нужен инструмент для быстрого возвращения в настоящее. Эта техника использует все 5 чувств, чтобы «заземлить» вас в реальности.

          **Почему работает:**
          • Переключает фокус с внутренних переживаний на внешний мир
          • Активирует сенсорные системы мозга
          • Помогает выйти из цикла тревожных мыслей
          • Простая и доступная в любой ситуации
        MARKDOWN
        
        send_message(text: message_text, parse_mode: 'Markdown')
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        
        send_message(
          text: "Готовы освоить технику экстренного заземления?",
          reply_markup: TelegramMarkupHelper.day_11_start_exercise_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        clear_day_data
        
        exercise_text = <<~MARKDOWN
          🌍 *Техника «Заземление 5-4-3-2-1»* 🌍

          **Инструкция:**

          Найдите спокойное место и выполните следующие шаги. Отвечайте на каждый пункт, описывая что видите, чувствуете и т.д.
        MARKDOWN
        
        send_message(text: exercise_text, parse_mode: 'Markdown')
        
        # Начинаем с первого шага
        start_grounding_step('seen')
      end
      
      def complete_exercise
        # Сохраняем результат упражнения
        save_grounding_entry
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
        
        message = <<~MARKDOWN
          🌟 *Техника освоена!* 🌟

          Теперь у вас есть инструмент для экстренной самопомощи.

          **Когда использовать:**
          • При первых признаках панической атаки
          • Когда чувствуете диссоциацию (отрыв от реальности)
          • Перед важными событиями для успокоения
          • В моменты сильного стресса

          **Помните:**
          • Техника работает лучше, если практиковать заранее
          • Можно делать с закрытыми глазами
          • Адаптируйте под свои предпочтения
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        # ИЗМЕНЕНИЕ: Предлагаем следующий день
        propose_next_day
      rescue => e
        log_error("Failed to complete exercise", e)
        # Fallback: все равно предлагаем следующий день
        @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
        propose_next_day
      end
      
      def handle_grounding_input(input_text)
        current_step = get_day_data('current_step')
        step_config = GROUNDING_STEPS[current_step]
        
        return false unless step_config
        
        # Проверяем минимальное количество элементов
        if step_config[:min_count] > 1 && input_text.present?
          items = input_text.split(',').map(&:strip)
          if items.length < step_config[:min_count]
            send_message(text: "Пожалуйста, назовите минимум #{step_config[:min_count]} #{step_config[:min_count] == 1 ? 'вещь' : 'вещи'}.")
            return false
          end
        elsif input_text.blank?
          send_message(text: "Пожалуйста, введите ответ.")
          return false
        end
        
        # Сохраняем данные
        store_day_data("#{current_step}_items", input_text)
        
        # Переходим к следующему шагу
        next_step = get_next_grounding_step(current_step)
        
        if next_step
          start_grounding_step(next_step)
        else
          # Все шаги выполнены
          send_message(
            text: "✅ *Все шаги выполнены!*\n\nВы успешно прошли технику заземления.\n\nНажмите кнопку, чтобы завершить упражнение:",
            reply_markup: TelegramMarkupHelper.grounding_exercise_completed_markup
          )
        end
        
        true
      end
      
      def ask_for_input_again
        current_step = get_day_data('current_step')
        start_grounding_step(current_step) if current_step
      end
      
      private
      
      def start_grounding_step(step_type)
        store_day_data('current_step', step_type)
        
        step = GROUNDING_STEPS[step_type]
        return unless step
        
        send_message(text: step[:title], parse_mode: 'Markdown')
        send_message(text: step[:instruction])
      end
      
      def get_next_grounding_step(current_step)
        steps_order = GROUNDING_STEPS.keys
        current_index = steps_order.index(current_step)
        
        return steps_order[current_index + 1] if current_index && current_index < steps_order.length - 1
        nil
      end
      
      def save_grounding_entry
        begin
          GroundingExerciseEntry.create!(
            user: @user,
            entry_date: Date.current,
            seen: get_day_data('seen_items') || '',
            touched: get_day_data('touched_items') || '',
            heard: get_day_data('heard_items') || '',
            smelled: get_day_data('smelled_items') || '',
            tasted: get_day_data('tasted_items') || ''
          )
        rescue => e
          log_error("Failed to save grounding entry", e)
        end
      end
    end
  end
end
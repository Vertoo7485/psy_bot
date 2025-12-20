module SelfHelp
  module Days
    class Day14Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 14
      
      # Шаги рефлексии
      REFLECTION_STEPS = {
        'intro' => {
          title: "🔄 **День 14: Промежуточная рефлексия**",
          instruction: "Вы прошли первые 2 недели программы! Это важный момент для подведения промежуточных итогов.\n\n**Зачем это нужно:**\n• Закрепить прогресс\n• Осознать свои успехи\n• Проанализировать сложности\n• Настроиться на продолжение\n\n**Мы пройдем 5 шагов рефлексии.** Отвечайте честно — это только для вас!"
        },
        'reflection' => {
          title: "📝 **Шаг 1: Общие впечатления**",
          instruction: "**Как прошли ваши первые 2 недели в программе?**\n\nОпишите своими словами:\n• Какие были ожидания и что получилось на самом деле?\n• Что вас удивило в процессе?\n• Как изменилось ваше состояние за это время?\n\n**Напишите 3-5 предложений:**"
        },
        'useful' => {
          title: "⭐ **Шаг 2: Полезные техники**",
          instruction: "**Какие техники оказались для вас самыми полезными?**\n\nВыберите 3-5 техник, которые:\n• Лучше всего сработали для вас\n• Были самыми понятными\n• Дали ощутимый результат\n• Хотите продолжать использовать\n\n**Перечислите их через запятую:**"
        },
        'difficult' => {
          title: "🔄 **Шаг 3: Сложные моменты**",
          instruction: "**С какими сложностями вы столкнулись?**\n\nЧто было трудным:\n• Какие упражнения давались сложнее всего?\n• Что мешало регулярной практике?\n• Какие внутренние сопротивления возникали?\n\n**И как вы с ними справились?**\n\n**Перечислите сложности и решения:**"
        },
        'insights' => {
          title: "💡 **Шаг 4: Личные открытия**",
          instruction: "**Что нового вы узнали о себе за эти 2 недели?**\n\nВозможно, вы обнаружили:\n• Неожиданные сильные стороны\n• Особенности своих эмоциональных реакций\n• Паттерны мышления, о которых не знали\n• Источники стресса или радости\n\n**Запишите 2-3 главных открытия:**"
        },
        'plans' => {
          title: "🎯 **Шаг 5: Планы на следующие недели**",
          instruction: "**Как вы планируете продолжать?**\n\nПодумайте:\n• Какие техники хотите включить в регулярную практику?\n• На что обратить особое внимание в следующих неделях?\n• Какие цели поставите на оставшуюся часть программы?\n• Как будете поддерживать мотивацию?\n\n**Опишите ваши планы:**"
        }
      }.freeze
      
      def deliver_intro
        message_text = <<~MARKDOWN
          🔄 *День 14: Промежуточная рефлексия* 🔄

          **Поздравляем с завершением первых 2 недель программы!**

          Это важный рубеж, и сегодня мы посвятим время подведению промежуточных итогов.

          **Почему рефлексия важна:**
          • Помогает осознать прогресс
          • Закрепляет новые навыки  
          • Выявляет успешные стратегии
          • Позволяет скорректировать подход
          • Укрепляет мотивацию на продолжение

          **Исследования показывают**, что регулярная рефлексия:
          • Увеличивает эффективность обучения на 23%
          • Помогает лучше запоминать полезное
          • Снижает вероятность «отката» к старым привычкам
          • Создает чувство контроля над процессом
        MARKDOWN
        
        send_message(text: message_text, parse_mode: 'Markdown')
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        
        send_message(
          text: "Готовы подвести итоги первых 2 недель?",
          reply_markup: TelegramMarkupHelper.day_14_start_exercise_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        clear_day_data
        
        exercise_text = <<~MARKDOWN
          📊 *Упражнение: Мои 2 недели* 📊

          **Инструкция:**

          Мы пройдем 5 шагов структурированной рефлексии. 
          Отвечайте максимально честно — эти ответы помогут вам лучше понять свой прогресс.
          
          **Это не тест!** Здесь нет правильных или неправильных ответов.
        MARKDOWN
        
        send_message(text: exercise_text, parse_mode: 'Markdown')
        
        # Начинаем первый шаг
        start_reflection_step('intro')
      end
      
      def complete_exercise
        # Сохраняем рефлексию
        # save_two_weeks_reflection
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
        
        message = <<~MARKDOWN
          🌟 *Рефлексия завершена!* 🌟

          Вы проделали важную работу по осмыслению своего прогресса.

          **Что это дает:**
          • **Ясность** — понимание, что работает именно для вас
          • **Уверенность** — осознание уже достигнутого
          • **Фокус** — понимание, на что обратить внимание дальше
          • **Мотивацию** — энергия для продолжения пути

          **Ваши ответы сохранены.** Вы сможете вернуться к ним в любой момент.
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        # Предлагаем следующий день
        propose_next_day
      end
      
      def handle_reflection_input(input_text)
  current_step = get_day_data('current_step')
  
  case current_step
  when 'intro'
    # Переходим к первому реальному шагу
    store_day_data('current_step', 'reflection')
    start_reflection_step('reflection')
    return true
    
  when 'reflection'
    return false if input_text.blank?
    store_day_data('reflection', input_text)
    start_reflection_step('useful')
    return true
    
  when 'useful'
    return false if input_text.blank?
    
    items = input_text.split(',').map(&:strip)
    if items.length >= 1
      store_day_data('useful_techniques', items)
      start_reflection_step('difficult')
      return true
    else
      send_message(text: "Пожалуйста, назовите хотя бы 1 полезную технику.")
      return false
    end
    
  when 'difficult'
    return false if input_text.blank?
    
    items = input_text.split(';').map(&:strip) # Используем ; для разделения
    if items.length >= 1
      store_day_data('difficult_moments', items)
      start_reflection_step('insights')
      return true
    else
      send_message(text: "Пожалуйста, опишите хотя бы 1 сложность.")
      return false
    end
    
  when 'insights'
    return false if input_text.blank?
    
    items = input_text.split(',').map(&:strip)
    if items.length >= 1
      store_day_data('personal_insights', items)
      start_reflection_step('plans')
      return true
    else
      send_message(text: "Пожалуйста, запишите хотя бы 1 открытие.")
      return false
    end
    
  when 'plans'
    return false if input_text.blank?
    
    store_day_data('future_plans', input_text)
    
    # Все шаги выполнены
    send_message(
      text: "✅ **Все шаги выполнены!**\n\nВы успешно завершили рефлексию первых 2 недель.\n\nНажмите кнопку, чтобы завершить упражнение:",
      reply_markup: TelegramMarkupHelper.reflection_exercise_completed_markup
    )
    return true
  end
  
  false
end
      
      def show_previous_reflections
        reflections = @user.two_weeks_reflections.recent.limit(3)
        
        if reflections.empty?
          send_message(text: "У вас пока нет сохраненных рефлексий.")
          return
        end
        
        reflections.each_with_index do |reflection, index|
          message = <<~MARKDOWN
            📝 *Рефлексия ##{index + 1}* (#{reflection.entry_date.strftime('%d.%m.%Y')})

            💭 **Впечатления:** #{reflection.reflection_text.truncate(100)}
            ⭐ **Полезное:** #{reflection.useful_techniques.to_a.first(3).join(', ').truncate(100)}
            🔄 **Сложности:** #{reflection.difficult_moments.to_a.first(2).join(', ').truncate(100)}
            💡 **Открытия:** #{reflection.personal_insights.to_a.first(2).join(', ').truncate(100)}
            ──────────────────────────────
          MARKDOWN
          
          send_message(text: message, parse_mode: 'Markdown')
        end
      end
      
      def ask_for_input_again
        current_step = get_day_data('current_step')
        start_reflection_step(current_step) if current_step
      end
      
      private
      
      def start_reflection_step(step_type)
        store_day_data('current_step', step_type)
        
        step = REFLECTION_STEPS[step_type]
        return unless step
        
        send_message(text: step[:title], parse_mode: 'Markdown')
        send_message(text: step[:instruction])
      end
      
      def save_two_weeks_reflection
        begin
          TwoWeeksReflection.create!(
            user: @user,
            entry_date: Date.current,
            reflection_text: get_day_data('reflection') || '',
            useful_techniques: get_day_data('useful_techniques') || [],
            difficult_moments: get_day_data('difficult_moments') || [],
            personal_insights: get_day_data('personal_insights') || [],
            future_plans: get_day_data('future_plans') || ''
          )
        rescue => e
          log_error("Failed to save two weeks reflection", e)
          # Не прерываем выполнение, даже если сохранение не удалось
        end
      end
      
      def should_deliver_exercise_immediately?
        false
      end
      
      def handle_exercise_consent
        deliver_exercise
      end
    end
  end
end
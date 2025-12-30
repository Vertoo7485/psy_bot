# app/services/self_help/days/day_23_service.rb

module SelfHelp
  module Days
    class Day23Service < DayBaseService
      include TelegramMarkupHelper
      
      DAY_NUMBER = 23
      
      # Шаги анализа дневника
      ANALYSIS_STEPS = {
        'intro' => {
          title: "📊 **День 23: Анализ дневника тревоги** 📊",
          instruction: "За время программы вы сделали несколько записей в дневнике эмоций. Сегодня мы проанализируем их, чтобы найти закономерности и триггеры.\n\n**Что такое триггеры?**\nЭто ситуации, мысли или обстоятельства, которые запускают цепочку: мысль → эмоция → поведение.\n\n**Зачем анализировать?**\n• **Предсказуемость:** Зная триггеры, вы можете быть готовы\n• **Профилактика:** Можно избегать или минимизировать воздействие\n• **Контроль:** Понимание дает чувство контроля над ситуацией\n• **Эффективность:** Целенаправленная работа над самыми частыми проблемами"
        },
        'select_period' => {
          title: "**Шаг 1: Выбор периода для анализа**",
          instruction: "За какой период вы хотите проанализировать записи?\n\n📅 **Последние 7 дней:** Самые свежие и актуальные записи\n🗓️ **Последний месяц:** Более полная картина паттернов\n📚 **Все записи:** Полный анализ, но требует больше времени\n\n**Рекомендация:** Начните с последних 7 дней, если записей достаточно."
        },
        'analyze_situations' => {
          title: "🔍 **Шаг 2: Анализ ситуаций**",
          instruction: "**Какие ситуации чаще всего вызывали у вас тревогу?**\n\nПосмотрите на свои записи и найдите общее в ситуациях:\n\n🏢 **Работа/учеба:**\n• Сроки, дедлайны\n• Конфликты с коллегами\n• Оценка результатов\n• Публичные выступления\n\n🏠 **Личная жизнь:**\n• Конфликты с близкими\n• Финансовые вопросы\n• Планирование будущего\n• Социальные обязательства\n\n🧠 **Внутренние процессы:**\n• Мысли о прошлом\n• Беспокойство о будущем\n• Самооценка\n• Здоровье\n\n**Какие категории ситуаций встречаются чаще всего?**"
        },
        'analyze_thoughts' => {
          title: "💭 **Шаг 3: Анализ мыслей**",
          instruction: "**Какие автоматические мысли повторяются?**\n\nАвтоматические мысли — это быстрые, часто неосознанные мысли, которые возникают в ответ на ситуацию.\n\n**Типичные паттерны мыслей:**\n\n❌ **Катастрофизация:** 'Если я ошибусь, все будет ужасно'\n❌ **Черно-белое мышление:** 'Либо идеально, либо полный провал'\n❌ **Персонализация:** 'Это все из-за меня'\n❌ **Чтение мыслей:** 'Они думают, что я неудачник'\n❌ **Долженствование:** 'Я должен быть идеальным'\n\n**Какие мыслительные паттерны вы замечаете у себя?**"
        },
        'analyze_emotions' => {
          title: "😔 **Шаг 4: Анализ эмоций**",
          instruction: "**Какие эмоции преобладают в ваших записях?**\n\nОцените интенсивность и частоту эмоций:\n\n🌪️ **Тревога/беспокойство:** Чувство опасности, нервозность\n💔 **Грусть/тоска:** Печаль, уныние, апатия\n🔥 **Гнев/раздражение:** Злость, фрустрация, нетерпение\n😰 **Стыд/вина:** Самокритика, чувство неадекватности\n😫 **Усталость/выгорание:** Эмоциональное истощение\n\n**Также обратите внимание на физические симптомы:**\n• Учащенное сердцебиение\n• Мышечное напряжение\n• Проблемы со сном\n• Изменения аппетита\n\n**Какие эмоции и симптомы встречаются чаще всего?**"
        },
        'identify_triggers' => {
          title: "🎯 **Шаг 5: Определение триггеров**",
          instruction: "**Теперь объединим все вместе. Какие у вас основные триггеры?**\n\nТриггер = Ситуация + Мысль + Эмоция\n\n**Пример триггера:**\n• **Ситуация:** Получение критики на работе\n• **Мысль:** 'Я ни на что не гожусь, меня уволят'\n• **Эмоция:** Сильная тревога, стыд\n• **Поведение:** Избегание работы, прокрастинация\n\n**Попробуйте сформулировать 2-3 своих основных триггера:**"
        },
        'create_strategies' => {
          title: "🛡️ **Шаг 6: Стратегии работы с триггерами**",
          instruction: "**Как вы можете работать с этими триггерами?**\n\nЕсть три подхода:\n\n1️⃣ **Избегание:**\n• Можно ли избежать триггерной ситуации?\n• Если да, как это сделать экологично?\n\n2️⃣ **Изменение реакции:**\n• Как изменить свои мысли в этой ситуации?\n• Какие техники могут помочь (дыхание, заземление)?\n\n3️⃣ **Принятие и действие:**\n• Как действовать, даже испытывая дискомфорт?\n• Какие маленькие шаги можно сделать?\n\n**Для каждого триггера создайте план действий:**"
        },
        'summary' => {
          title: "📝 **Шаг 7: Итоговый план**",
          instruction: "**Давайте составим ваш персональный план работы с триггерами.**\n\nОн должен включать:\n\n🎯 **Триггеры:** 2-3 самых частых\n🛡️ **Стратегии:** Конкретные действия для каждого\n📅 **План на неделю:** Когда и как применять стратегии\n🔔 **Напоминания:** Что делать в момент возникновения триггера\n\n**Составьте ваш итоговый план:**"
        }
      }.freeze
      
      # Категории ситуаций для анализа
      SITUATION_CATEGORIES = [
        { emoji: "🏢", name: "Работа/учеба", key: "work_study" },
        { emoji: "🏠", name: "Личная жизнь", key: "personal_life" },
        { emoji: "🤝", name: "Отношения", key: "relationships" },
        { emoji: "💰", name: "Финансы", key: "finances" },
        { emoji: "🌐", name: "Социальные ситуации", key: "social" },
        { emoji: "🏥", name: "Здоровье", key: "health" },
        { emoji: "🧠", name: "Внутренние процессы", key: "internal" },
        { emoji: "⏰", name: "Время/сроки", key: "time_pressure" }
      ].freeze
      
      # Паттерны мыслей
      THOUGHT_PATTERNS = [
        { name: "Катастрофизация", description: "Предположение худшего исхода" },
        { name: "Черно-белое мышление", description: "Видеть только крайности" },
        { name: "Персонализация", description: "Принимать все на свой счет" },
        { name: "Чтение мыслей", description: "Предполагать, что знаете мысли других" },
        { name: "Долженствование", description: "Использование 'должен', 'надо', 'обязан'" },
        { name: "Эмоциональное обоснование", description: "Если чувствую так, значит это правда" },
        { name: "Чрезмерное обобщение", description: "Делать выводы на основе одного случая" },
        { name: "Ментальный фильтр", description: "Фокусироваться только на негативном" }
      ].freeze
      
      # Стратегии работы с триггерами
      STRATEGIES = [
        { type: "avoidance", name: "Избегание", description: "Планировать, чтобы избежать триггера" },
        { type: "preparation", name: "Подготовка", description: "Готовиться заранее к триггеру" },
        { type: "coping", name: "Совладание", description: "Техники для момента триггера" },
        { type: "reframing", name: "Переоценка", description: "Изменение восприятия ситуации" },
        { type: "exposure", name: "Экспозиция", description: "Постепенное привыкание к триггеру" }
      ].freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        # Проверяем, есть ли записи в дневнике
        diary_entries_count = @user.emotion_diary_entries.count
        
        message_text = <<~MARKDOWN
          📊 *День 23: Анализ дневника тревоги* 📊

          **От записи к пониманию!**

          Вы проделали важную работу, заполняя дневник эмоций. Сегодня мы превратим эти записи в ценные инсайты о ваших триггерах.

          **Ваша статистика:**
          📝 **Записей в дневнике:** #{diary_entries_count}
          📅 **Первая запись:** #{first_entry_date || 'нет записей'}
          📈 **Последняя запись:** #{last_entry_date || 'нет записей'}

          **Что мы сегодня сделаем:**
          1. 📋 Проанализируем ваши записи
          2. 🔍 Определим повторяющиеся паттерны
          3. 🎯 Выявим основные триггеры тревоги
          4. 🛡️ Создадим стратегии работы с ними

          **Научная основа:** Анализ паттернов — ключевой элемент когнитивно-поведенческой терапии. Он помогает разорвать автоматические цепочки "ситуация → мысль → эмоция → поведение".
        MARKDOWN
        
        send_message(text: message_text, parse_mode: 'Markdown')
        
        if diary_entries_count < 3
          send_message(
            text: "⚠️ У вас мало записей в дневнике (#{diary_entries_count}). Для качественного анализа рекомендуется иметь хотя бы 3 записи.\n\nХотите сначала сделать несколько записей в дневнике?",
            reply_markup: diary_analysis_low_entries_markup
          )
        else
          @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
          store_day_data('current_step', 'intro')
          
          send_message(
            text: "Готовы начать анализ ваших записей?",
            reply_markup: day_23_start_markup
          )
        end
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        
        # Инициализируем структуру для анализа
        unless get_day_data('analysis_data')
          store_day_data('analysis_data', {
            'period' => nil,
            'situation_categories' => [],
            'thought_patterns' => [],
            'emotions' => [],
            'triggers' => [],
            'strategies' => [],
            'plan' => nil
          })
          store_day_data('current_step', 'select_period')
        end
        
        exercise_text = <<~MARKDOWN
          📋 *Упражнение: Анализ триггеров тревоги* 📋

          **Мы пройдем 7 шагов анализа:**

          1. **Выбор периода** — какие записи анализировать
          2. **Ситуации** — что вызывает тревогу
          3. **Мысли** — какие автоматические мысли повторяются
          4. **Эмоции** — какие чувства преобладают
          5. **Триггеры** — определение ключевых паттернов
          6. **Стратегии** — план работы с триггерами
          7. **Итоговый план** — конкретные действия

          **Важно:** Отвечайте максимально честно, основываясь на своих записях. Чем точнее анализ, тем эффективнее будут стратегии.

          **Начнем!**
        MARKDOWN
        
        send_message(text: exercise_text, parse_mode: 'Markdown')
        
        # Начинаем процесс
        start_analysis_step('select_period')
      end
      
      # Обработка ввода пользователя
      def handle_text_input(input_text)
        current_step = get_day_data('current_step')
        
        log_info("Handling text input for step: #{current_step}, text: #{input_text.truncate(50)}")
        if get_day_data('awaiting_custom_categories')
    store_day_data('awaiting_custom_categories', false)
    
    categories = input_text.split(/[,\.\n]/).map(&:strip).reject(&:empty?)
    if categories.any?
      analysis_data = get_analysis_data
      analysis_data['situation_categories'] = categories
      store_day_data('analysis_data', analysis_data)
      
      send_message(text: "✅ Добавлены ваши категории: #{categories.join(', ')}")
      start_analysis_step('analyze_thoughts')
      return true
    else
      send_message(text: "⚠️ Пожалуйста, введите хотя бы одну категорию.")
      return false
    end
  end
        case current_step
        when 'intro'
          handle_intro_input(input_text)
        when 'select_period'
          handle_period_selection(input_text)
        when 'analyze_situations'
          handle_situations_analysis(input_text)
        when 'analyze_thoughts'
          handle_thoughts_analysis(input_text)
        when 'analyze_emotions'
          handle_emotions_analysis(input_text)
        when 'identify_triggers'
          handle_triggers_identification(input_text)
        when 'create_strategies'
          handle_strategies_creation(input_text)
        when 'summary'
          handle_summary_input(input_text)
        else
          log_warn("Unknown step for text input: #{current_step}")
          send_message(text: "Пожалуйста, следуйте инструкциям на экране.")
          false
        end
      end
      
      # Обработка кнопок
      def handle_button(callback_data)
        case callback_data
        when 'start_day_23_exercise'
          deliver_exercise
          
        when 'day_23_add_diary_entry'
          redirect_to_diary
          
        when 'day_23_use_existing'
          proceed_with_analysis
          
        when 'day_23_complete_exercise'
          complete_exercise
          
        when 'day_23_show_diary_stats'
          show_diary_statistics
          
        when /^day_23_period_(.+)$/
          period = $1
          handle_period_button(period)
          
        when /^day_23_situation_(.+)$/
          category_key = $1
          handle_situation_category_button(category_key)
          
        when /^day_23_thought_(.+)$/
          pattern_index = $1.to_i
          handle_thought_pattern_button(pattern_index)
          
        when 'day_23_finish_categories'
          finish_categories_selection
          
        when 'day_23_finish_thoughts'
          finish_thoughts_selection
          
        when 'day_23_skip_to_triggers'
          skip_to_triggers
        when 'day_23_show_all_entries'
  period = get_analysis_data['period']
  if period
    show_all_entries(period)
  else
    send_message(text: "Сначала выберите период для анализа.")
  end

when 'day_23_show_entries_again'
  period = get_analysis_data['period']
  if period
    show_entries_for_period(period, limit: 5)
  end

when 'day_23_show_thoughts'
  period = get_analysis_data['period']
  if period
    show_thoughts_from_entries(period)
  end

when 'day_23_show_emotions'
  period = get_analysis_data['period']
  if period
    show_emotions_from_entries(period)
  end

when 'day_23_custom_categories'
  send_message(text: "📝 Напишите свои категории ситуаций (через запятую или с новой строки):")
  store_day_data('awaiting_custom_categories', true)
          
        else
          log_warn("Unknown button callback: #{callback_data}")
          send_message(text: "Неизвестная команда.")
        end
      end

      def show_thoughts_from_entries(period, limit: 10)
  entries = get_entries_for_period(period)
  
  message = "💭 *Мысли из ваших записей (период: #{period}):*\n\n"
  
  entries.last(limit).each_with_index do |entry, index|
    if entry.thoughts.present?
      thoughts = entry.thoughts.gsub(/\n/, ' ').truncate(120)
      message += "#{index + 1}. #{thoughts}\n\n"
    end
  end
  
  send_message(text: message, parse_mode: 'Markdown')
end

def show_emotions_from_entries(period, limit: 10)
  entries = get_entries_for_period(period)
  
  message = "😔 *Эмоции из ваших записей (период: #{period}):*\n\n"
  
  entries.last(limit).each_with_index do |entry, index|
    if entry.emotions.present?
      emotions = entry.emotions.gsub(/\n/, ' ').truncate(120)
      message += "#{index + 1}. #{emotions}\n\n"
    end
  end
  
  send_message(text: message, parse_mode: 'Markdown')
end
      
      # Завершение упражнения
      def complete_exercise
        analysis_data = get_day_data('analysis_data') || {}
        
        if analysis_data['triggers'].blank? || analysis_data['strategies'].blank?
          send_message(text: "⚠️ У вас не заполнены триггеры или стратегии. Давайте закончим анализ.")
          start_analysis_step('identify_triggers')
          return false
        end
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
        
        # Сохраняем анализ
        save_triggers_analysis(analysis_data)
        
        # Показываем итоговый анализ
        show_final_analysis(analysis_data)
        
        # Предлагаем следующий день
        propose_next_day
        
        true
      end
      
      # Показать статистику дневника
      def show_diary_statistics
        entries = @user.emotion_diary_entries
        entries_count = entries.count
        
        if entries_count == 0
          send_message(text: "У вас пока нет записей в дневнике.")
          return
        end
        
        # Анализ по датам
        dates = entries.pluck(:created_at).map(&:to_date)
        date_range = "#{dates.min.strftime('%d.%m.%Y')} - #{dates.max.strftime('%d.%m.%Y')}"
        
        # Анализ эмоций (простейший)
        emotions_text = entries.pluck(:emotions).join(' ').downcase
        emotion_words = {
          'тревог' => emotions_text.scan(/тревог/).count,
          'страх' => emotions_text.scan(/страх/).count,
          'груст' => emotions_text.scan(/груст/).count,
          'гнев' => emotions_text.scan(/гнев/).count,
          'раздраж' => emotions_text.scan(/раздраж/).count,
          'споко' => emotions_text.scan(/споко/).count
        }.select { |_, count| count > 0 }
        
        message = <<~MARKDOWN
          📈 *Статистика вашего дневника эмоций*

          **Общее:**
          📝 **Всего записей:** #{entries_count}
          📅 **Период:** #{date_range}
          📊 **Среднее в неделю:** #{(entries_count.to_f / (dates.max - dates.min + 1).to_i * 7).round(1)} записей

          **Эмоции (частота упоминания):**
          #{emotion_words.map { |emotion, count| "• #{emotion}: #{count} раз" }.join("\n")}

          **Рекомендации для анализа:**
          #{entries_count >= 5 ? "✅ Достаточно записей для качественного анализа" : "⚠️ Рекомендуется сделать еще #{5 - entries_count} записи(ей)"}
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      private

      def get_entries_for_period(period)
    entries = @user.emotion_diary_entries
    
    case period
    when 'Последние 7 дней', '7_days'
      entries.where('created_at >= ?', 7.days.ago)
    when 'Последний месяц', '30_days'
      entries.where('created_at >= ?', 30.days.ago)
    when 'Все записи', 'all'
      entries
    else
      # Если пользователь ввел свой период, показываем все записи
      entries
    end
  end
  
  # Форматировать запись для показа
  def format_diary_entry(entry, index = nil)
    prefix = index ? "#{index}. " : ""
    
    <<~MARKDOWN
      #{prefix}📅 *#{entry.created_at.strftime('%d.%m.%Y %H:%M')}*
      
      🎯 **Ситуация:** #{entry.situation.truncate(80)}
      💭 **Мысли:** #{entry.thoughts.truncate(80)}
      😊 **Эмоции:** #{entry.emotions.truncate(80)}
      🚶 **Поведение:** #{entry.behavior.truncate(80)}
      🔍 **Анализ:** #{entry.evidence_against.truncate(80)}
      🌟 **Новые мысли:** #{entry.new_thoughts.truncate(80)}
    MARKDOWN
  end
  
  # Показать записи за период
  def show_entries_for_period(period, limit: 10)
    entries = get_entries_for_period(period)
    entries_count = entries.count
    
    if entries_count == 0
      send_message(text: "📭 У вас нет записей за выбранный период.")
      return false
    end
    
    # Общая информация
    info_message = <<~MARKDOWN
      📊 *Записи за период: #{period}*
      
      📝 **Найдено записей:** #{entries_count}
      📅 **Период:** #{entries.minimum(:created_at)&.strftime('%d.%m.%Y')} - #{entries.maximum(:created_at)&.strftime('%d.%m.%Y')}
      
      **Показаны последние #{[entries_count, limit].min} записей:**
    MARKDOWN
    
    send_message(text: info_message, parse_mode: 'Markdown')
    
    # Показываем записи (ограниченное количество)
    entries.last(limit).each_with_index do |entry, index|
      entry_message = format_diary_entry(entry, index + 1)
      send_message(text: entry_message, parse_mode: 'Markdown')
      
      # Добавляем разделитель между записями
      unless index == [entries_count, limit].min - 1
        send_message(text: "─" * 30)
      end
    end
    
    # Если записей больше, чем лимит
    if entries_count > limit
      send_message(
        text: "📋 И еще #{entries_count - limit} записей...",
        reply_markup: {
          inline_keyboard: [
            [{ text: "📖 Показать все записи", callback_data: 'day_23_show_all_entries' }]
          ]
        }.to_json
      )
    end
    
    true
  end
  
  # Показать все записи (без лимита)
  def show_all_entries(period)
    entries = get_entries_for_period(period)
    entries_count = entries.count
    
    if entries_count == 0
      send_message(text: "📭 У вас нет записей за выбранный период.")
      return false
    end
    
    send_message(text: "📚 *Все #{entries_count} записей за период: #{period}*", parse_mode: 'Markdown')
    
    entries.order(:created_at).each_with_index do |entry, index|
      entry_message = format_diary_entry(entry, index + 1)
      send_message(text: entry_message, parse_mode: 'Markdown')
      
      # Добавляем разделитель между записями
      unless index == entries_count - 1
        send_message(text: "─" * 30)
      end
    end
    
    true
  end
      
      # ===== ОСНОВНЫЕ МЕТОДЫ АНАЛИЗА =====
      
      def start_analysis_step(step_type)
  store_day_data('current_step', step_type)
  
  step = ANALYSIS_STEPS[step_type]
  return unless step
  
  send_message(text: step[:title], parse_mode: 'Markdown')
  send_message(text: step[:instruction])
  
  # Показываем записи для определенных шагов
  case step_type
  when 'select_period'
    # Для выбора периода показываем общую статистику
    show_diary_statistics_brief
    send_message(
      text: "Выберите период для анализа:",
      reply_markup: day_23_period_markup
    )
    
  when 'analyze_situations'
    # Для анализа ситуаций показываем записи
    period = get_analysis_data['period']
    if period
      send_message(text: "📋 *Ваши записи за период: #{period}*", parse_mode: 'Markdown')
      show_entries_for_period(period, limit: 5)
    end
    
    send_message(
      text: "Изучите свои записи выше. Какие категории ситуаций встречаются чаще всего?",
      reply_markup: day_23_situations_markup
    )
    
  when 'analyze_thoughts'
    # Для анализа мыслей также показываем записи
    period = get_analysis_data['period']
    if period
      send_message(text: "💭 *Мысли из ваших записей:*", parse_mode: 'Markdown')
      
      # Показываем только мысли из записей
      entries = get_entries_for_period(period).last(5)
      entries.each_with_index do |entry, index|
        thoughts_text = entry.thoughts.present? ? entry.thoughts.truncate(100) : "Не указано"
        send_message(text: "#{index + 1}. #{thoughts_text}")
      end
    end
    
    send_message(
      text: "Какие мыслительные паттерны вы замечаете в своих записях?",
      reply_markup: day_23_thoughts_markup
    )
    
  when 'analyze_emotions'
    # Для анализа эмоций показываем эмоции из записей
    period = get_analysis_data['period']
    if period
      send_message(text: "😔 *Эмоции из ваших записей:*", parse_mode: 'Markdown')
      
      entries = get_entries_for_period(period).last(5)
      entries.each_with_index do |entry, index|
        emotions_text = entry.emotions.present? ? entry.emotions.truncate(100) : "Не указано"
        send_message(text: "#{index + 1}. #{emotions_text}")
      end
    end
    
    send_message(text: "Какие эмоции преобладают в ваших записях?")
    
  when 'identify_triggers'
    # Для определения триггеров показываем сводку по ситуациям, мыслям и эмоциям
    show_triggers_summary
    send_message(text: "Основываясь на анализе выше, сформулируйте свои триггеры...")
    
  end
end

# Новый метод для получения данных анализа
def get_analysis_data
  get_day_data('analysis_data') || {}
end

def show_diary_statistics_brief
  entries_count = @user.emotion_diary_entries.count
  
  if entries_count == 0
    send_message(text: "📭 У вас пока нет записей в дневнике.")
    return
  end
  
  # Получаем даты первой и последней записи
  first_entry = @user.emotion_diary_entries.order(:created_at).first
  last_entry = @user.emotion_diary_entries.order(created_at: :desc).first
  
  message = <<~MARKDOWN
    📊 *Статистика вашего дневника:*
    
    📝 **Всего записей:** #{entries_count}
    📅 **Первая запись:** #{first_entry.created_at.strftime('%d.%m.%Y')}
    📅 **Последняя запись:** #{last_entry.created_at.strftime('%d.%m.%Y')}
    
    **Рекомендация:** Для качественного анализа выберите период, где у вас есть хотя бы 3 записи.
  MARKDOWN
  
  send_message(text: message, parse_mode: 'Markdown')
end

def show_triggers_summary
  analysis_data = get_analysis_data
  
  message = <<~MARKDOWN
    📋 *Сводка вашего анализа:*
    
    🎯 **Период анализа:** #{analysis_data['period'] || 'Не выбран'}
    
    🔍 **Выбранные категории ситуаций:**
    #{analysis_data['situation_categories']&.map { |cat| "• #{cat}" }&.join("\n") || '• Еще не выбрано'}
    
    💭 **Выявленные паттерны мыслей:**
    #{analysis_data['thought_patterns']&.map { |pat| "• #{pat}" }&.join("\n") || '• Еще не выбрано'}
    
    😔 **Отмеченные эмоции:**
    #{analysis_data['emotions']&.map { |em| "• #{em}" }&.join("\n") || '• Еще не указано'}
    
    **Теперь объедините эти элементы в триггеры:**
    Триггер = Ситуация + Мысль + Эмоция
  MARKDOWN
  
  send_message(text: message, parse_mode: 'Markdown')
  
  # Показываем примеры триггеров на основе анализа
  show_triggers_examples(analysis_data)
end

def show_triggers_examples(analysis_data)
  # Генерируем примеры триггеров на основе выбранных категорий
  categories = analysis_data['situation_categories'] || []
  patterns = analysis_data['thought_patterns'] || []
  emotions = analysis_data['emotions'] || []
  
  if categories.any? && patterns.any? && emotions.any?
    send_message(text: "🎯 *Примеры триггеров на основе вашего анализа:*")
    
    # Берем первые элементы из каждого списка для примера
    example_category = categories.first
    example_pattern = patterns.first.split(':').first rescue patterns.first
    example_emotion = emotions.first
    
    example = <<~MARKDOWN
      **Пример 1:**
      • **Ситуация:** #{example_category}
      • **Мысль:** #{example_pattern}
      • **Эмоция:** #{example_emotion}
      • **Триггер:** Когда я сталкиваюсь с #{example_category.downcase}, у меня возникает мысль "#{example_pattern}", что вызывает чувство #{example_emotion}.
    MARKDOWN
    
    send_message(text: example, parse_mode: 'Markdown')
  end
end
      
      # Обработчики шагов
      
      def handle_intro_input(input_text)
        start_analysis_step('select_period')
        true
      end
      
      def handle_period_selection(input_text)
        analysis_data = get_day_data('analysis_data') || {}
        analysis_data['period'] = input_text
        store_day_data('analysis_data', analysis_data)
        
        start_analysis_step('analyze_situations')
        true
      end
      
      def handle_situations_analysis(input_text)
        # Если пользователь ввел текст, добавляем как дополнительную категорию
        if input_text.present?
          analysis_data = get_day_data('analysis_data') || {}
          categories = analysis_data['situation_categories'] || []
          categories << "Другое: #{input_text}"
          analysis_data['situation_categories'] = categories
          store_day_data('analysis_data', analysis_data)
        end
        
        start_analysis_step('analyze_thoughts')
        true
      end
      
      def handle_thoughts_analysis(input_text)
        # Если пользователь ввел текст, добавляем как дополнительный паттерн
        if input_text.present?
          analysis_data = get_day_data('analysis_data') || {}
          patterns = analysis_data['thought_patterns'] || []
          patterns << "Другое: #{input_text}"
          analysis_data['thought_patterns'] = patterns
          store_day_data('analysis_data', analysis_data)
        end
        
        start_analysis_step('analyze_emotions')
        true
      end
      
      def handle_emotions_analysis(input_text)
        analysis_data = get_day_data('analysis_data') || {}
        analysis_data['emotions'] = input_text.split(/[,\.\n]/).map(&:strip).reject(&:empty?)
        store_day_data('analysis_data', analysis_data)
        
        start_analysis_step('identify_triggers')
        true
      end
      
      def handle_triggers_identification(input_text)
        # Разделяем триггеры (каждый с новой строки или через точку)
        triggers = input_text.split(/\n|\.(?=\s*[А-Я])/).map(&:strip).reject(&:empty?)
        
        if triggers.size >= 1
          analysis_data = get_day_data('analysis_data') || {}
          analysis_data['triggers'] = triggers
          store_day_data('analysis_data', analysis_data)
          
          start_analysis_step('create_strategies')
          true
        else
          send_message(text: "Пожалуйста, опишите хотя бы один триггер.")
          false
        end
      end
      
      def handle_strategies_creation(input_text)
        analysis_data = get_day_data('analysis_data') || {}
        analysis_data['strategies'] = input_text
        store_day_data('analysis_data', analysis_data)
        
        start_analysis_step('summary')
        true
      end
      
      def handle_summary_input(input_text)
        analysis_data = get_day_data('analysis_data') || {}
        analysis_data['plan'] = input_text
        
        # Сохраняем финальные данные
        store_day_data('analysis_data', analysis_data)
        store_day_data('final_analysis', analysis_data)
        
        # Завершаем упражнение
        complete_exercise
        true
      end
      
      # ===== ОБРАБОТКА КНОПОК =====
      
      def handle_period_button(period)
  period_text = case period
               when '7_days' then 'Последние 7 дней'
               when '30_days' then 'Последний месяц'
               when 'all' then 'Все записи'
               else period
               end
  
  analysis_data = get_day_data('analysis_data') || {}
  analysis_data['period'] = period_text
  store_day_data('analysis_data', analysis_data)
  
  # Сразу показываем записи за выбранный период
  send_message(text: "✅ Выбран период: #{period_text}")
  show_entries_for_period(period_text, limit: 5)
  
  # Через секунду показываем следующий шаг
  sleep(1)
  start_analysis_step('analyze_situations')
end
      
      def handle_situation_category_button(category_key)
        category = SITUATION_CATEGORIES.find { |c| c[:key] == category_key }
        
        if category
          analysis_data = get_day_data('analysis_data') || {}
          categories = analysis_data['situation_categories'] || []
          category_text = "#{category[:emoji]} #{category[:name]}"
          
          if categories.include?(category_text)
            categories.delete(category_text)
            send_message(text: "Убрано: #{category_text}")
          else
            categories << category_text
            send_message(text: "Добавлено: #{category_text}")
          end
          
          analysis_data['situation_categories'] = categories.uniq
          store_day_data('analysis_data', analysis_data)
        end
      end
      
      def handle_thought_pattern_button(pattern_index)
        pattern = THOUGHT_PATTERNS[pattern_index.to_i]
        
        if pattern
          analysis_data = get_day_data('analysis_data') || {}
          patterns = analysis_data['thought_patterns'] || []
          pattern_text = "#{pattern[:name]}: #{pattern[:description]}"
          
          if patterns.include?(pattern_text)
            patterns.delete(pattern_text)
            send_message(text: "Убрано: #{pattern[:name]}")
          else
            patterns << pattern_text
            send_message(text: "Добавлено: #{pattern[:name]}")
          end
          
          analysis_data['thought_patterns'] = patterns.uniq
          store_day_data('analysis_data', analysis_data)
        end
      end
      
      def finish_categories_selection
        analysis_data = get_day_data('analysis_data') || {}
        
        if analysis_data['situation_categories'].blank?
          send_message(text: "⚠️ Пожалуйста, выберите хотя бы одну категорию или напишите свою.")
          return
        end
        
        start_analysis_step('analyze_thoughts')
      end
      
      def finish_thoughts_selection
        analysis_data = get_day_data('analysis_data') || {}
        
        if analysis_data['thought_patterns'].blank?
          send_message(text: "⚠️ Пожалуйста, выберите хотя бы один паттерн или напишите свой.")
          return
        end
        
        start_analysis_step('analyze_emotions')
      end
      
      def skip_to_triggers
        # Пропускаем анализ эмоций и переходим сразу к триггерам
        start_analysis_step('identify_triggers')
      end
      
      def redirect_to_diary
        send_message(text: "Открываю дневник эмоций...")
        
        # Используем существующий EmotionDiaryService
        diary_service = EmotionDiaryService.new(@bot_service, @user, @chat_id)
        diary_service.start_diary_menu
      end
      
      def proceed_with_analysis
        send_message(text: "Продолжаем анализ с имеющимися записями...")
        deliver_exercise
      end
      
      # ===== ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ =====
      
      def first_entry_date
        entry = @user.emotion_diary_entries.order(:created_at).first
        entry&.created_at&.strftime('%d.%m.%Y')
      end
      
      def last_entry_date
        entry = @user.emotion_diary_entries.order(created_at: :desc).first
        entry&.created_at&.strftime('%d.%m.%Y')
      end
      
      def save_triggers_analysis(analysis_data)
        begin
          if defined?(TriggersAnalysis)
            TriggersAnalysis.create!(
              user: @user,
              analysis_date: Date.current,
              period: analysis_data['period'],
              situation_categories: analysis_data['situation_categories'] || [],
              thought_patterns: analysis_data['thought_patterns'] || [],
              emotions: analysis_data['emotions'] || [],
              triggers: analysis_data['triggers'] || [],
              strategies: analysis_data['strategies'],
              plan: analysis_data['plan']
            )
          end
        rescue => e
          log_error("Failed to save triggers analysis", e)
          # Не прерываем выполнение, если сохранение не удалось
        end
      end
      
      def show_final_analysis(analysis_data)
        message = <<~MARKDOWN
          📊 *Ваш анализ триггеров завершен!* 📊

          **Основные выводы:**

          🎯 **Период анализа:** #{analysis_data['period'] || 'Не указано'}
          
          🔍 **Частые ситуации:**
          #{analysis_data['situation_categories']&.map { |cat| "• #{cat}" }&.join("\n") || 'Не указано'}
          
          💭 **Паттерны мыслей:**
          #{analysis_data['thought_patterns']&.map { |pat| "• #{pat}" }&.join("\n") || 'Не указано'}
          
          😔 **Преобладающие эмоции:**
          #{analysis_data['emotions']&.map { |em| "• #{em}" }&.join("\n") || 'Не указано'}
          
          🎯 **Основные триггеры:**
          #{analysis_data['triggers']&.map { |tr| "• #{tr}" }&.join("\n") || 'Не указано'}
          
          🛡️ **Стратегии работы:**
          #{analysis_data['strategies'] || 'Не указано'}

          📝 **Ваш план:**
          #{analysis_data['plan'] || 'Не указано'}

          **Рекомендация:** Сохраните этот анализ. Возвращайтесь к нему раз в месяц, чтобы отслеживать изменения.
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      # ===== РАЗМЕТКА =====
      
      def day_23_start_markup
        {
          inline_keyboard: [
            [
              { text: "📊 Начать анализ дневника", callback_data: 'start_day_23_exercise' },
              { text: "📈 Статистика", callback_data: 'day_23_show_diary_stats' }
            ]
          ]
        }.to_json
      end
      
      def diary_analysis_low_entries_markup
        {
          inline_keyboard: [
            [
              { text: "📝 Сделать запись в дневнике", callback_data: 'day_23_add_diary_entry' },
              { text: "📊 Анализировать имеющиеся", callback_data: 'day_23_use_existing' }
            ]
          ]
        }.to_json
      end
      
      def day_23_period_markup
        {
          inline_keyboard: [
            [
              { text: "📅 Последние 7 дней", callback_data: 'day_23_period_7_days' },
              { text: "🗓️ Последний месяц", callback_data: 'day_23_period_30_days' }
            ],
            [
              { text: "📚 Все записи", callback_data: 'day_23_period_all' }
            ],
            [
              { text: "✍️ Написать свой период", callback_data: 'day_23_period_custom' }
            ]
          ]
        }.to_json
      end
      
      def day_23_situations_markup
  keyboard = SITUATION_CATEGORIES.each_slice(2).map do |pair|
    pair.map do |category|
      { text: "#{category[:emoji]} #{category[:name]}", callback_data: "day_23_situation_#{category[:key]}" }
    end
  end
  
  # Добавляем кнопки для просмотра записей
  keyboard << [
    { text: "📖 Показать записи", callback_data: 'day_23_show_entries_again' },
    { text: "💭 Показать мысли", callback_data: 'day_23_show_thoughts' }
  ]
  
  keyboard << [
    { text: "✅ Завершить выбор", callback_data: 'day_23_finish_categories' },
    { text: "✍️ Свои категории", callback_data: 'day_23_custom_categories' }
  ]
  
  { inline_keyboard: keyboard }.to_json
end

def day_23_thoughts_markup
  keyboard = THOUGHT_PATTERNS.each_with_index.map do |pattern, index|
    [{ text: "#{pattern[:name]}", callback_data: "day_23_thought_#{index}" }]
  end
  
  # Добавляем кнопки для просмотра
  keyboard << [
    { text: "📖 Показать записи", callback_data: 'day_23_show_entries_again' },
    { text: "😔 Показать эмоции", callback_data: 'day_23_show_emotions' }
  ]
  
  keyboard << [
    { text: "✅ Завершить выбор", callback_data: 'day_23_finish_thoughts' },
    { text: "✍️ Свои паттерны", callback_data: 'day_23_custom_thoughts' }
  ]
  
  keyboard << [{ text: "⏩ Пропустить к триггерам", callback_data: 'day_23_skip_to_triggers' }]
  
  { inline_keyboard: keyboard }.to_json
end
      
      def day_23_completion_markup
        {
          inline_keyboard: [
            [
              { text: "📊 Посмотреть анализ", callback_data: 'day_23_show_analysis' },
              { text: "📝 Дополнить дневник", callback_data: 'day_23_add_diary_entry' }
            ],
            [
              { text: "✅ Завершить день", callback_data: 'day_23_complete_exercise' }
            ]
          ]
        }.to_json
      end
      
      def log_warn(message)
        Rails.logger.warn "[#{self.class}] #{message} - User: #{@user.telegram_id}"
      end
    end
  end
end
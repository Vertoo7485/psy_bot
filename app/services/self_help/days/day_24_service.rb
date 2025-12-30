module SelfHelp
  module Days
    class Day24Service < DayBaseService
      include TelegramMarkupHelper
      
      DAY_NUMBER = 24
      
      # Шаги упражнения "Предвосхищение" (без плейсхолдеров)
      EXERCISE_STEPS = {
        'intro' => {
          title: "🛡️ **День 24: Упражнение 'Предвосхищение' (Premeditatio Malorum)** 🛡️",
          instruction: "Сегодня мы будем тренировать стоическую суперсилу — **проактивную гибкость**.\n\n**Что такое 'Предвосхищение'?**\nЭто стоическая техника, где мы мысленно готовимся к возможным трудностям. Не для пессимизма, а чтобы:\n• 📉 Снизить тревогу от неожиданностей\n• 🧠 Сделать реакции более осознанными\n• 💪 Укрепить психологическую устойчивость\n• 🔄 Сохранить гибкость в любых обстоятельствах\n\n**Как это работает:**\n1. Выбираем ситуацию на завтра\n2. Мысленно готовимся к разным сценариям\n3. Планируем, как использовать уже освоенные навыки"
        },
        'select_situation' => {
          title: "**Шаг 1: Выбор ситуации для подготовки**",
          instruction: "Выберите **одну небольшую ситуацию на завтра**, с которой хотели бы поработать.\n\n**Примеры:**\n• 🏢 Рабочая встреча или звонок\n• 🏪 Поход в магазин или госучреждение\n• 👥 Общение с конкретным человеком\n• 📅 Выполнение задачи с дедлайном\n• 🚗 Поездка в транспорте\n• 📞 Сложный телефонный разговор\n\nЧем конкретнее ситуация, тем полезнее упражнение.\n\n**Какую ситуацию выберете?**"
        },
        'identify_challenges' => {
          title: "🔍 **Шаг 2: Возможные трудности**",
          instruction: "Теперь на **2 минуты** представьте, что *может* пойти не так в этой ситуации.\n\n**Не катастрофизируйте**, просто реалистично:\n\n🔹 **Внешние факторы:**\n• 🕐 Задержки, опоздания\n• 📱 Технические неполадки\n• 😠 Чужое раздражение или грубость\n• 🌧️ Плохая погода, пробки\n• 🔄 Изменение планов\n\n🔹 **Внутренние факторы:**\n• 😰 Собственная тревога или нервозность\n• 💤 Усталость, плохое самочувствие\n• 🤯 Рассеянность, забывчивость\n• 😤 Раздражение, нетерпение\n\n**Какие 2-3 возможные трудности вы видите?**"
        },
        'skills_inventory' => {
          title: "🛠️ **Шаг 3: Инвентаризация навыков**",
          instruction: "Вспомните навыки, которые вы освоили за 4 недели:\n\n🧘 **Неделя 1 (Осознанность):**\n• Дыхательные техники\n• Техника заземления 5-4-3-2-1\n• Наблюдение мыслей без вовлечения\n\n💭 **Неделя 2 (Работа с мыслями):**\n• Когнитивная переоценка\n• Отделение фактов от интерпретаций\n• Метод 'остановки мысли'\n\n❤️ **Неделя 3 (Эмоциональная регуляция):**\n• Самосострадание\n• Принятие эмоций\n• Практика благодарности\n\n⚡ **Неделя 4 (Действие):**\n• Разбивание задач на шаги\n• SMART-цели\n• Планирование приятных активностей\n\n**Какие из этих навыков могут пригодиться в вашей ситуации?**"
        },
        'create_flexibility_plan' => {
          title: "📝 **Шаг 4: План гибкости**",
          instruction: "**Теперь создадим ваш персональный 'План Гибкости'.**\n\nДля каждой возможной трудности из Шага 2:\n1. **Конкретная трудность:** Что именно может произойти?\n2. **Первая реакция (навык):** Какой навык применить сразу?\n3. **Вторая линия защиты:** Что сделать, если первое не сработало?\n\n**Пример плана:**\n• **Если:** Встреча переносится в последний момент\n• **Сразу:** 3 глубоких вдоха (неделя 1)\n• **Затем:** Переоценка ('это не катастрофа, а изменение планов') (неделя 2)\n• **Действие:** Использую освободившееся время для приятной задачи (неделя 4)\n\n**Создайте ваш план:**"
        },
        'visualization' => {
          title: "🎭 **Шаг 5: Мысленная репетиция**",
          instruction: "**Закрепим план через визуализацию.**\n\nЗакройте глаза на **1 минуту** и представьте:\n\n1. 🎬 **Сценарий успеха:** Ситуация проходит гладко, вы спокойны и эффективны\n2. ⛈️ **Сценарий трудности:** Возникает проблема, но вы последовательно применяете план гибкости\n3. 💫 **Сценарий восстановления:** Даже если что-то пошло не по плану, вы быстро восстанавливаетесь\n\n**Что вы почувствовали во время мысленной репетиции?**"
        },
        'commitment' => {
          title: "🤝 **Шаг 6: Обязательство**",
          instruction: "**Дайте себе обещание на завтра.**\n\nФормулировка обязательства включает:\n• ⏰ **Когда:** Конкретное время/ситуация\n• 🎯 **Что сделаете:** Основное действие из плана\n• 💖 **Отношение:** С каким настроением подойдете\n• 📱 **Напоминание:** Как себе напомнишь о плане\n\n**Пример:**\n'Завтра на совещании в 11:00, если почувствую тревогу, сделаю технику заземления. Подойду к ситуации с любопытством, а не со страхом. Поставлю напоминание за 5 минут.'\n\n**Ваше обязательство:**"
        },
        'summary' => {
          title: "🎊 **Шаг 7: Итог и интеграция**",
          instruction: "**Поздравляю!** Вы создали мощный инструмент проактивной гибкости.\n\n**Ваш 'План Гибкости' теперь включает:**\n\n🎯 **Ситуация:** [ваша ситуация]\n⚠️ **Возможные трудности:** [ваши трудности]\n🛠️ **Навыки для применения:** [ваши навыки]\n📋 **Конкретный план:** [ваш план]\n💫 **Мысленная подготовка:** [ваша визуализация]\n🤝 **Обязательство:** [ваше обязательство]\n\n**Совет по применению:**\n• 📅 Используйте эту технику для важных событий\n• 🔄 Адаптируйте план по мере получения опыта\n• 📝 Ведите журнал успешных применений\n• 🎯 Фокусируйтесь на процессе, а не только на результате"
        }
      }.freeze
      
      # Категории ситуаций для выбора
      SITUATION_CATEGORIES = [
        { emoji: "🏢", name: "Работа/учеба", examples: ["совещание", "презентация", "дедлайн", "обучение"] },
        { emoji: "👥", name: "Общение", examples: ["сложный разговор", "знакомство", "конфликт", "просьба о помощи"] },
        { emoji: "🏪", name: "Бытовые дела", examples: ["поход в магазин", "визит в госучреждение", "ремонт", "уборка"] },
        { emoji: "🚗", name: "Поездки", examples: ["дорога на работу", "путешествие", "пробки", "общественный транспорт"] },
        { emoji: "💼", name: "Ответственность", examples: ["важная задача", "принятие решения", "финансовые вопросы", "здоровье"] },
        { emoji: "🎉", name: "События", examples: ["праздник", "свидание", "встреча с друзьями", "публичное выступление"] }
      ].freeze
      
      # Навыки по неделям
      SKILLS_BY_WEEK = {
        week1: [
          "Дыхание 4-7-8",
          "Заземление 5-4-3-2-1", 
          "Наблюдение мыслей",
          "Осознанность в моменте"
        ],
        week2: [
          "Когнитивная переоценка",
          "Разделение фактов и интерпретаций",
          "Остановка мысли",
          "Анализ автоматических мыслей"
        ],
        week3: [
          "Самосострадание",
          "Медитация на принятие",
          "Практика благодарности",
          "Эмоциональная валидация"
        ],
        week4: [
          "SMART-цели",
          "Разбивание на шаги",
          "Планирование активностей",
          "Отслеживание прогресса"
        ]
      }.freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        message_text = <<~MARKDOWN
          🛡️ *День 24: Проактивная гибкость через стоическое предвосхищение* 🛡️

          **Четвертая неделя — закрепление навыков!**

          За 3 недели вы освоили множество техник. Сегодня научимся применять их *проактивно* — *до* возникновения сложностей.

          **Что вас ждет:**
          1. 🎯 Выбор ситуации на завтра
          2. 🔍 Реалистичная оценка возможных трудностей  
          3. 🛠️ Инвентаризация ваших навыков
          4. 📝 Создание персонального "Плана гибкости"
          5. 🎭 Мысленная репетиция успеха
          6. 🤝 Обещание самому себе

          **Время выполнения:** 15-20 минут
          **Эффект:** Снижение тревоги, повышение уверенности, гибкость реакций
        MARKDOWN
        
        send_message(text: message_text, parse_mode: 'Markdown')
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        store_day_data('current_step', 'intro')
        
        send_message(
          text: "Готовы создать ваш личный 'План Гибкости'?",
          reply_markup: day_24_start_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        
        # Инициализируем структуру для упражнения
        unless get_day_data('exercise_data')
          store_day_data('exercise_data', {
            'situation' => nil,
            'situation_details' => nil,
            'challenges' => [],
            'skills' => [],
            'flexibility_plan' => nil,
            'visualization_notes' => nil,
            'commitment' => nil,
            'completed_at' => nil
          })
          store_day_data('current_step', 'select_situation')
        end
        
        exercise_text = <<~MARKDOWN
          📋 *Упражнение: Стоическое предвосхищение*

          **Мы пройдем 7 шагов:**

          1. **Выбор ситуации** — что планируем на завтра
          2. **Возможные трудности** — реалистичные сценарии  
          3. **Инвентаризация навыков** — что уже умеем
          4. **План гибкости** — конкретные действия
          5. **Мысленная репетиция** — визуализация
          6. **Обязательство** — обещание себе
          7. **Итог** — ваш готовый инструмент

          **Философская основа:** Техника *Premeditatio Malorum* использовалась стоиками для развития невозмутимости. Не для пессимизма, а для обретения свободы действия в любых обстоятельствах.
        MARKDOWN
        
        send_message(text: exercise_text, parse_mode: 'Markdown')
        
        # Начинаем процесс
        start_exercise_step('select_situation')
      end
      
      # Обработка ввода пользователя
      def handle_text_input(input_text)
        current_step = get_day_data('current_step')
        
        log_info("Day #{DAY_NUMBER}: Handling text input for step: #{current_step}, text: #{input_text.truncate(50)}")
        
        # Проверяем, ждем ли мы категории
        if get_day_data('awaiting_custom_situation')
          store_day_data('awaiting_custom_situation', false)
          handle_custom_situation(input_text)
          return true
        end
        
        case current_step
        when 'intro'
          handle_intro_input(input_text)
        when 'select_situation'
          handle_situation_input(input_text)
        when 'identify_challenges'
          handle_challenges_input(input_text)
        when 'skills_inventory'
          handle_skills_input(input_text)
        when 'create_flexibility_plan'
          handle_plan_input(input_text)
        when 'visualization'
          handle_visualization_input(input_text)
        when 'commitment'
          handle_commitment_input(input_text)
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
  log_info("Day #{DAY_NUMBER}: Handling button: #{callback_data}")
  
  case callback_data
  when 'start_day_24_exercise'
    deliver_exercise
    
  when /^day_24_situation_(.+)$/
    category_key = $1
    handle_situation_category_button(category_key)
    
  # Добавим обработку для случая, когда ключ пустой
  when 'day_24_situation_'
    send_message(text: "Пожалуйста, выберите конкретную категорию ситуации.")
    
  when 'day_24_custom_situation'
    send_message(text: "📝 Опишите свою ситуацию на завтра (что, когда, с кем):")
    store_day_data('awaiting_custom_situation', true)
    
  when 'day_24_finish_situation'
    finish_situation_selection
    
  when 'day_24_add_challenge'
    add_challenge_template
    
  when 'day_24_finish_challenges'
    finish_challenges_selection
    
  when /^day_24_skill_(week\d+)_(\d+)/
    week = $1
    skill_index = $2.to_i
    handle_skill_button(week, skill_index)
    
  when 'day_24_finish_skills'
    finish_skills_selection
    
  when 'day_24_view_my_skills'
    show_user_skills_summary
    
  when 'day_24_complete_exercise'
    complete_exercise
    
  when 'day_24_show_full_plan'
    show_full_flexibility_plan
    
  when 'day_24_save_as_template'
    save_as_template
    
  else
    log_warn("Unknown button callback: #{callback_data}")
    send_message(text: "Неизвестная команда.")
  end
end
      
      # Завершение упражнения
      def complete_exercise
        exercise_data = get_exercise_data
        
        if exercise_data['flexibility_plan'].blank? || exercise_data['commitment'].blank?
          send_message(text: "⚠️ У вас не заполнен план гибкости или обязательство. Давайте закончим.")
          start_exercise_step('create_flexibility_plan')
          return false
        end
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
        exercise_data['completed_at'] = Time.current
        store_day_data('exercise_data', exercise_data)
        
        # Сохраняем упражнение
        save_flexibility_exercise(exercise_data)
        
        # Показываем итоговый план
        show_final_plan(exercise_data)
        
        # Предлагаем следующий день
        propose_next_day
        
        true
      end
      
      private
      
      # ===== ОСНОВНЫЕ МЕТОДЫ УПРАЖНЕНИЯ =====
      
      def start_exercise_step(step_type)
        store_day_data('current_step', step_type)
        
        step = EXERCISE_STEPS[step_type]
        return unless step
        
        # Специальная обработка для summary шага
        if step_type == 'summary'
          instruction = format_summary_instruction(step[:instruction])
        else
          instruction = step[:instruction]
        end
        
        send_message(text: step[:title], parse_mode: 'Markdown')
        send_message(text: instruction)
        
        # Показываем дополнительные элементы для определенных шагов
        case step_type
        when 'select_situation'
          send_message(
            text: "Выберите категорию или опишите свою:",
            reply_markup: day_24_situations_markup
          )
          
        when 'identify_challenges'
          show_current_situation
          send_message(
            text: "Добавьте трудности (можно несколько через запятую или с новой строки):",
            reply_markup: day_24_challenges_markup
          )
          
        when 'skills_inventory'
          show_current_challenges
          send_message(
            text: "Выберите навыки, которые могут помочь:",
            reply_markup: day_24_skills_markup
          )
          
        when 'create_flexibility_plan'
          show_current_skills
          send_message(text: "Используйте формат:\n• ЕСЛИ [трудность] → ТО [навык + действие]\n• ИЛИ ЕСЛИ [другая трудность] → ТО [другое действие]")
          
        when 'visualization'
          show_current_plan
          send_message(text: "Опишите, что почувствовали во время мысленной репетиции:")
          
        when 'commitment'
          send_message(text: "Сформулируйте ваше обязательство на завтра:")
          
        when 'summary'
          send_message(
            text: "Ваш 'План Гибкости' готов! Сохраните его или продолжите программу.",
            reply_markup: day_24_completion_markup
          )
        end
      end
      
      # Новый метод для форматирования инструкции summary
      def format_summary_instruction(base_instruction)
        exercise_data = get_exercise_data
        
        base_instruction
          .gsub('[ваша ситуация]', exercise_data['situation'] || 'Не указано')
          .gsub('[ваши трудности]', exercise_data['challenges']&.join(', ') || 'Не указано')
          .gsub('[ваши навыки]', exercise_data['skills']&.join(', ') || 'Не указано')
          .gsub('[ваш план]', exercise_data['flexibility_plan']&.truncate(100) || 'Не указано')
          .gsub('[ваша визуализация]', exercise_data['visualization_notes']&.truncate(100) || 'Не указано')
          .gsub('[ваше обязательство]', exercise_data['commitment']&.truncate(100) || 'Не указано')
      end
      
      # ===== ОБРАБОТЧИКИ ШАГОВ =====
      
      def handle_intro_input(input_text)
        start_exercise_step('select_situation')
        true
      end
      
      def handle_situation_input(input_text)
        if input_text.present?
          exercise_data = get_exercise_data
          exercise_data['situation'] = "Другое: #{input_text}"
          exercise_data['situation_details'] = input_text
          store_day_data('exercise_data', exercise_data)
        end
        
        start_exercise_step('identify_challenges')
        true
      end
      
      def handle_challenges_input(input_text)
        return false if input_text.strip.empty?
        
        # Разделяем на отдельные трудности
        challenges = input_text.split(/[,\.\n]/).map(&:strip).reject(&:empty?)
        
        if challenges.any?
          exercise_data = get_exercise_data
          exercise_data['challenges'] = challenges
          store_day_data('exercise_data', exercise_data)
          
          start_exercise_step('skills_inventory')
          true
        else
          send_message(text: "Пожалуйста, опишите хотя бы одну возможную трудность.")
          false
        end
      end
      
      def handle_skills_input(input_text)
        # Если пользователь ввел текст, добавляем как дополнительный навык
        if input_text.present?
          exercise_data = get_exercise_data
          skills = exercise_data['skills'] || []
          skills << "Дополнительный: #{input_text}"
          exercise_data['skills'] = skills.uniq
          store_day_data('exercise_data', exercise_data)
        end
        
        start_exercise_step('create_flexibility_plan')
        true
      end
      
      def handle_plan_input(input_text)
        return false if input_text.strip.empty?
        
        exercise_data = get_exercise_data
        exercise_data['flexibility_plan'] = input_text
        store_day_data('exercise_data', exercise_data)
        
        start_exercise_step('visualization')
        true
      end
      
      def handle_visualization_input(input_text)
        return false if input_text.strip.empty?
        
        exercise_data = get_exercise_data
        exercise_data['visualization_notes'] = input_text
        store_day_data('exercise_data', exercise_data)
        
        start_exercise_step('commitment')
        true
      end
      
      def handle_commitment_input(input_text)
        return false if input_text.strip.empty?
        
        exercise_data = get_exercise_data
        exercise_data['commitment'] = input_text
        store_day_data('exercise_data', exercise_data)
        
        start_exercise_step('summary')
        true
      end
      
      def handle_summary_input(input_text)
        # Сохраняем дополнительные заметки, если есть
        if input_text.present?
          exercise_data = get_exercise_data
          exercise_data['additional_notes'] = input_text
          store_day_data('exercise_data', exercise_data)
        end
        
        complete_exercise
        true
      end
      
      # ===== ОБРАБОТКА КНОПОК =====
      
      def handle_situation_category_button(category_key)
  # Ищем категорию по разным возможным форматам ключа
  category = nil
  
  # Пробуем найти по полному ключу
  SITUATION_CATEGORIES.each do |c|
    # Пробуем разные форматы ключа
    possible_keys = [
      c[:name].downcase.gsub(/[^a-zа-я0-9]/, '_'),
      c[:name].parameterize.underscore,
      c[:name].downcase.gsub(' ', '_'),
      c[:name].downcase.gsub(/[^\w]/, '')
    ]
    
    if possible_keys.include?(category_key)
      category = c
      break
    end
  end
  
  # Если не нашли, попробуем найти по части ключа
  unless category
    SITUATION_CATEGORIES.each do |c|
      if category_key.include?(c[:name].downcase[0..3]) || c[:name].downcase.include?(category_key[0..3])
        category = c
        break
      end
    end
  end
  
  if category
    exercise_data = get_exercise_data
    exercise_data['situation'] = "#{category[:emoji]} #{category[:name]}"
    exercise_data['situation_details'] = category[:examples].sample
    store_day_data('exercise_data', exercise_data)
    
    send_message(text: "✅ Выбрано: #{category[:emoji]} #{category[:name]}")
    sleep(1)
    send_message(text: "💡 Пример: #{exercise_data['situation_details']}")
    
    send_message(
      text: "Хотите уточнить ситуацию или продолжить?",
      reply_markup: day_24_situation_details_markup
    )
  else
    log_warn("Category not found for key: #{category_key}")
    send_message(text: "Не удалось определить категорию. Пожалуйста, выберите снова или опишите свою ситуацию.")
  end
end
      
      def handle_custom_situation(input_text)
        if input_text.present?
          exercise_data = get_exercise_data
          exercise_data['situation'] = "📝 Моя ситуация"
          exercise_data['situation_details'] = input_text
          store_day_data('exercise_data', exercise_data)
          
          send_message(text: "✅ Ситуация сохранена: #{input_text.truncate(100)}")
          start_exercise_step('identify_challenges')
        else
          send_message(text: "⚠️ Пожалуйста, опишите ситуацию.")
        end
      end
      
      def handle_skill_button(week, skill_index)
        skills_list = SKILLS_BY_WEEK[week.to_sym]
        return unless skills_list && skill_index < skills_list.length
        
        skill = skills_list[skill_index]
        exercise_data = get_exercise_data
        skills = exercise_data['skills'] || []
        
        if skills.include?(skill)
          skills.delete(skill)
          send_message(text: "Убрано: #{skill}")
        else
          skills << skill
          send_message(text: "Добавлено: #{skill}")
        end
        
        exercise_data['skills'] = skills.uniq
        store_day_data('exercise_data', exercise_data)
      end
      
      def finish_situation_selection
        exercise_data = get_exercise_data
        
        if exercise_data['situation'].blank?
          send_message(text: "⚠️ Пожалуйста, выберите или опишите ситуацию.")
          return
        end
        
        start_exercise_step('identify_challenges')
      end
      
      def finish_challenges_selection
        exercise_data = get_exercise_data
        
        if exercise_data['challenges'].blank?
          send_message(text: "⚠️ Пожалуйста, добавьте хотя бы одну возможную трудность.")
          return
        end
        
        start_exercise_step('skills_inventory')
      end
      
      def finish_skills_selection
        exercise_data = get_exercise_data
        
        if exercise_data['skills'].blank?
          send_message(text: "⚠️ Пожалуйста, выберите хотя бы один навык.")
          return
        end
        
        start_exercise_step('create_flexibility_plan')
      end
      
      # ===== ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ =====
      
      def get_exercise_data
        get_day_data('exercise_data') || {}
      end
      
      def show_current_situation
        exercise_data = get_exercise_data
        return unless exercise_data['situation']
        
        message = <<~MARKDOWN
          📋 *Текущая ситуация:*
          
          🎯 **Категория:** #{exercise_data['situation']}
          📝 **Детали:** #{exercise_data['situation_details'] || 'Не указано'}
          
          **Теперь подумаем о возможных трудностях...**
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def show_current_challenges
        exercise_data = get_exercise_data
        return unless exercise_data['challenges']&.any?
        
        message = "⚠️ *Выявленные трудности:*\n\n"
        exercise_data['challenges'].each_with_index do |challenge, index|
          message += "#{index + 1}. #{challenge}\n"
        end
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def show_current_skills
        exercise_data = get_exercise_data
        return unless exercise_data['skills']&.any?
        
        message = "🛠️ *Выбранные навыки:*\n\n"
        exercise_data['skills'].each_with_index do |skill, index|
          message += "#{index + 1}. #{skill}\n"
        end
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def show_current_plan
        exercise_data = get_exercise_data
        return unless exercise_data['flexibility_plan']
        
        message = <<~MARKDOWN
          📝 *Ваш план гибкости:*
          
          #{exercise_data['flexibility_plan']}
          
          **Теперь закрепим его через визуализацию...**
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def show_user_skills_summary
        # Здесь можно показать навыки, которые пользователь практиковал в программе
        message = <<~MARKDOWN
          🧠 *Ваши навыки за 4 недели:*
          
          **Неделя 1 - Осознанность:**
          • Наблюдение за дыханием
          • Техники заземления  
          • Отслеживание мыслей
          
          **Неделя 2 - Когнитивная гибкость:**
          • Анализ автоматических мыслей
          • Когнитивная переоценка
          • Метод "Остановка мысли"
          
          **Неделя 3 - Эмоциональный интеллект:**
          • Самосострадание
          • Принятие эмоций
          • Практика благодарности
          
          **Неделя 4 - Проактивное действие:**
          • Постановка целей
          • Планирование
          • Разбивание задач
          
          💡 *Сегодня объединяем все навыки!*
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def add_challenge_template
        templates = [
          "Внешние обстоятельства изменятся в последний момент",
          "Кто-то будет раздражен или недоволен",
          "Я почувствую тревогу или неуверенность",
          "Возникнут технические или организационные проблемы",
          "Планы придется корректировать на ходу",
          "Я буду уставшим или не в ресурсе"
        ]
        
        template = templates.sample
        send_message(text: "💡 Пример формулировки: \"#{template}\"\n\nМожете использовать как шаблон или придумать свой вариант.")
      end
      
      def save_flexibility_exercise(exercise_data)
        begin
          if defined?(FlexibilityExercise)
            FlexibilityExercise.create!(
              user: @user,
              exercise_date: Date.current,
              situation: exercise_data['situation'],
              situation_details: exercise_data['situation_details'],
              challenges: exercise_data['challenges'] || [],
              skills_used: exercise_data['skills'] || [],
              flexibility_plan: exercise_data['flexibility_plan'],
              visualization_notes: exercise_data['visualization_notes'],
              commitment: exercise_data['commitment'],
              additional_notes: exercise_data['additional_notes']
            )
          end
        rescue => e
          log_error("Failed to save flexibility exercise", e)
          # Не прерываем выполнение, если сохранение не удалось
        end
      end
      
      def show_final_plan(exercise_data)
        message = <<~MARKDOWN
          🎊 *Ваш "План Гибкости" готов!* 🎊

          🛡️ **Стоическое предвосхищение завершено**

          🎯 **Ситуация на завтра:**
          #{exercise_data['situation']} - #{exercise_data['situation_details']}

          ⚠️ **Подготовлен к трудностям:**
          #{exercise_data['challenges']&.map { |c| "• #{c}" }&.join("\n") || 'Не указано'}

          🛠️ **Арсенал навыков:**
          #{exercise_data['skills']&.map { |s| "• #{s}" }&.join("\n") || 'Не указано'}

          📋 **Конкретный план действий:**
          #{exercise_data['flexibility_plan']}

          💫 **Мысленная подготовка:**
          #{exercise_data['visualization_notes']}

          🤝 **Ваше обязательство:**
          #{exercise_data['commitment']}

          **Советы по применению:**
          1. 📱 Установите напоминание на завтра
          2. 🔄 Утром перечитайте план за 5 минут
          3. 🎯 Фокусируйтесь на процессе, а не на результате
          4. 📝 Вечером отметьте, что сработало
          5. 🧠 Используйте эту технику для важных событий

          **Философская мудрость:** 
          > "Не события волнуют людей, а их мнения об событиях." 
          > — Эпиктет

          Вы создали инструмент, который дает свободу действия в любых обстоятельствах!
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def show_full_flexibility_plan
        exercise_data = get_exercise_data
        show_final_plan(exercise_data)
      end
      
      def save_as_template
        exercise_data = get_exercise_data
        
        # Здесь можно сохранить как шаблон для будущего использования
        send_message(text: "✅ План сохранен как шаблон. Вы можете использовать его для похожих ситуаций в будущем.")
      end
      
      # ===== РАЗМЕТКА =====

def day_24_start_markup
  {
    inline_keyboard: [
      [
        { text: "🛡️ Начать упражнение", callback_data: 'start_day_24_exercise' }
      ]
    ]
  }.to_json
end

def day_24_situations_markup
  keyboard = []
  
  # Создаем кнопки по категориям
  SITUATION_CATEGORIES.each_slice(2).each do |pair|
    row = []
    pair.each do |category|
      # Используем безопасный ключ без сложных преобразований
      key = category[:name].downcase.gsub(/[^a-zа-я0-9]/, '_')
      row << { 
        text: "#{category[:emoji]} #{category[:name]}", 
        callback_data: "day_24_situation_#{key}" 
      }
    end
    keyboard << row
  end
  
  # Кнопки для действий
  keyboard << [
    { text: "✍️ Своя ситуация", callback_data: 'day_24_custom_situation' }
  ]
  
  keyboard << [
    { text: "✅ Продолжить", callback_data: 'day_24_finish_situation' }
  ]
  
  { inline_keyboard: keyboard }.to_json
end

def day_24_situation_details_markup
  {
    inline_keyboard: [
      [
        { text: "✍️ Уточнить детали", callback_data: 'day_24_custom_situation' },
        { text: "✅ Продолжить", callback_data: 'day_24_finish_situation' }
      ]
    ]
  }.to_json
end

def day_24_challenges_markup
  {
    inline_keyboard: [
      [
        { text: "💡 Пример трудности", callback_data: 'day_24_add_challenge' }
      ],
      [
        { text: "✅ Завершить выбор", callback_data: 'day_24_finish_challenges' }
      ]
    ]
  }.to_json
end

def day_24_skills_markup
  keyboard = []
  
  # Добавляем навыки по неделям
  SKILLS_BY_WEEK.each do |week, skills|
    week_name = week.to_s.gsub('week', 'Неделя ')
    keyboard << [{ text: "📅 #{week_name}", callback_data: 'noop' }]
    
    skills.each_with_index do |skill, index|
      # Создаем безопасный ключ для навыка
      safe_skill = skill.downcase.gsub(/[^a-zа-я0-9]/, '_')[0..30]
      keyboard << [
        { text: "• #{skill}", callback_data: "day_24_skill_#{week}_#{index}_#{safe_skill}" }
      ]
    end
    
    keyboard << [] # Пустая строка для разделения
  end
  
  keyboard << [
    { text: "🧠 Мои навыки", callback_data: 'day_24_view_my_skills' },
    { text: "✅ Готово", callback_data: 'day_24_finish_skills' }
  ]
  
  { inline_keyboard: keyboard.compact }.to_json
end

def day_24_completion_markup
  {
    inline_keyboard: [
      [
        { text: "📋 Посмотреть полный план", callback_data: 'day_24_show_full_plan' },
        { text: "💾 Сохранить как шаблон", callback_data: 'day_24_save_as_template' }
      ],
      [
        { text: "✅ Завершить день", callback_data: 'day_24_complete_exercise' }
      ]
    ]
  }.to_json
end
      
      def log_info(message)
        Rails.logger.info "[Day#{DAY_NUMBER}Service] #{message} - User: #{@user.telegram_id}"
      end
      
      def log_error(message, error = nil)
        Rails.logger.error "[Day#{DAY_NUMBER}Service] #{message} - User: #{@user.telegram_id}"
        Rails.logger.error error.message if error
        Rails.logger.error error.backtrace.join("\n") if error
      end
      
      def log_warn(message)
        Rails.logger.warn "[Day#{DAY_NUMBER}Service] #{message} - User: #{@user.telegram_id}"
      end
    end
  end
end
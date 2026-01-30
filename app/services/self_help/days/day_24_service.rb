# app/services/self_help/days/day_24_service.rb

module SelfHelp
  module Days
    class Day24Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 24
      
      # Шаги дня 24 (7 шагов стоического предвосхищения)
      DAY_STEPS = {
        'intro' => {
          title: "🛡️ *День 24: Проактивная гибкость через стоическое предвосхищение* 🛡️",
          instruction: <<~MARKDOWN
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

            📊 **Научные факты о стоическом предвосхищении:**
            • 🧠 Снижает тревожность о будущем на 35-45%
            • 💪 Повышает уверенность в решении проблем на 50-60%
            • 🔄 Улучшает когнитивную гибкость на 25-30%
            • 🛡️ Уменьшает эмоциональные реакции на неожиданности
            • ⏱️ Эффект заметен уже после 1-2 применений
          MARKDOWN
        },
        'exercise_explanation' => {
          title: "📋 *Упражнение: Стоическое предвосхищение (Premeditatio Malorum)*",
          instruction: <<~MARKDOWN
            **Мы пройдем 7 шагов:**

            1. **Выбор ситуации** — что планируем на завтра
            2. **Возможные трудности** — реалистичные сценарии  
            3. **Инвентаризация навыков** — что уже умеем
            4. **План гибкости** — конкретные действия
            5. **Мысленная репетиция** — визуализация
            6. **Обязательство** — обещание себе
            7. **Итог** — ваш готовый инструмент

            **Философская основа:** Техника *Premeditatio Malorum* использовалась стоиками для развития невозмутимости. Не для пессимизма, а для обретения свободы действия в любых обстоятельствах.

            **Нейропсихологический эффект:**
            • 🧠 Активирует префронтальную кору (планирование и контроль)
            • 🔄 Укрепляет связь между рациональным и эмоциональным мозгом
            • 💫 Создает "ментальные заготовки" для быстрого доступа
            • 🛡️ Снижает активность миндалевидного тела в стрессовых ситуациях
          MARKDOWN
        },
        'select_situation' => {
          title: "**🎯 Шаг 1: Выбор ситуации для подготовки**",
          instruction: <<~MARKDOWN
            Выберите **одну небольшую ситуацию на завтра**, с которой хотели бы поработать.

            **Примеры:**
            • 🏢 Рабочая встреча или звонок
            • 🏪 Поход в магазин или госучреждение
            • 👥 Общение с конкретным человеком
            • 📅 Выполнение задачи с дедлайном
            • 🚗 Поездка в транспорте
            • 📞 Сложный телефонный разговор

            **Критерии хорошей ситуации для практики:**
            1. 🎯 **Конкретность** — можно четко описать
            2. ⏰ **Близость** — произойдет в ближайшие 1-2 дня
            3. 📊 **Значимость** — важно для вас, но не чрезмерно
            4. 💭 **Ощущаемый дискомфорт** — вызывает легкую тревогу или неуверенность

            Чем конкретнее ситуация, тем полезнее упражнение.
          MARKDOWN
        },
        'identify_challenges' => {
          title: "🔍 **Шаг 2: Реалистичные возможные трудности**",
          instruction: <<~MARKDOWN
            Теперь представьте, что *может* пойти не так в этой ситуации.

            **Не катастрофизируйте**, просто реалистично:

            🔹 **Внешние факторы:**
            • 🕐 Задержки, опоздания
            • 📱 Технические неполадки
            • 😠 Чужое раздражение или грубость
            • 🌧️ Плохая погода, пробки
            • 🔄 Изменение планов

            🔹 **Внутренние факторы:**
            • 😰 Собственная тревога или нервозность
            • 💤 Усталость, плохое самочувствие
            • 🤯 Рассеянность, забывчивость
            • 😤 Раздражение, нетерпение

            **Психологический принцип:**
            Мысленная подготовка к возможным трудностям *не притягивает* их,
            а наоборот — делает вас психологически неуязвимым.

            **Спросите себя:** "Что может произойти, и как я к этому подготовлен?"
          MARKDOWN
        },
        'skills_inventory' => {
          title: "🛠️ **Шаг 3: Инвентаризация освоенных навыков**",
          instruction: <<~MARKDOWN
            Вспомните навыки, которые вы освоили за 4 недели:

            🧘 **Неделя 1 (Осознанность):**
            • Дыхательные техники (4-7-8, квадратное дыхание)
            • Техника заземления 5-4-3-2-1
            • Наблюдение мыслей без вовлечения
            • Осознанное присутствие в моменте

            💭 **Неделя 2 (Работа с мыслями):**
            • Когнитивная переоценка
            • Разделение фактов и интерпретаций
            • Метод 'остановки мысли'
            • Анализ автоматических мыслей

            ❤️ **Неделя 3 (Эмоциональная регуляция):**
            • Самосострадание
            • Медитация на принятие
            • Практика благодарности
            • Эмоциональная валидация

            ⚡ **Неделя 4 (Действие и проактивность):**
            • SMART-цели
            • Разбивание задач на шаги
            • Планирование приятных активностей
            • Отслеживание прогресса

            **Ваша задача:** Выбрать 2-3 навыка, которые могут пригодиться в вашей ситуации.
          MARKDOWN
        },
        'create_flexibility_plan' => {
          title: "📝 **Шаг 4: Создание персонального 'Плана Гибкости'**",
          instruction: <<~MARKDOWN
            **Теперь создадим ваш персональный 'План Гибкости'.** 📋

            Для каждой возможной трудности из Шага 2:
            1. **Конкретная трудность:** Что именно может произойти?
            2. **Первая реакция (навык):** Какой навык применить сразу?
            3. **Вторая линия защиты:** Что сделать, если первое не сработало?

            **Формат плана:**
            ```
            ЕСЛИ [возникает трудность] → ТО [применяю навык + действие]
            ```

            **Пример плана:**
            • **Если:** Встреча переносится в последний момент
            • **Сразу:** 3 глубоких вдоха (дыхание 4-7-8)
            • **Затем:** Мысленная переоценка ("Это не катастрофа, а изменение планов")
            • **Действие:** Использую освободившееся время для приятной задачи

            **Принцип:** План должен быть конкретным, выполнимым и учитывать ваши реальные возможности.
          MARKDOWN
        },
        'visualization' => {
          title: "🎭 **Шаг 5: Мысленная репетиция успеха**",
          instruction: <<~MARKDOWN
            **Закрепим план через визуализацию.** 💫

            Закройте глаза на **1 минуту** и представьте:

            1. 🎬 **Сценарий успеха:** Ситуация проходит гладко, вы спокойны и эффективны
            2. ⛈️ **Сценарий трудности:** Возникает проблема, но вы последовательно применяете план гибкости
            3. 💫 **Сценарий восстановления:** Даже если что-то пошло не по плану, вы быстро восстанавливаетесь

            **Нейробиологический эффект:**
            • 🧠 Мысленная репетиция активирует те же нейронные сети, что и реальное действие
            • 🔄 Создает "ментальные мышечные воспоминания" для быстрого доступа
            • 💪 Укрепляет уверенность в собственных способностях

            **Что вы почувствовали во время мысленной репетиции?**
          MARKDOWN
        },
        'commitment' => {
          title: "🤝 **Шаг 6: Обязательство перед собой**",
          instruction: <<~MARKDOWN
            **Дайте себе обещание на завтра.** ✨

            Формулировка обязательства включает:
            • ⏰ **Когда:** Конкретное время/ситуация
            • 🎯 **Что сделаете:** Основное действие из плана
            • 💖 **Отношение:** С каким настроением подойдете
            • 📱 **Напоминание:** Как себе напомнишь о плане

            **Пример обязательства:**
            _"Завтра на совещании в 11:00, если почувствую тревогу, сделаю технику заземления 5-4-3-2-1. Подойду к ситуации с любопытством, а не со страхом. Поставлю напоминание за 5 минут."_

            **Психологический эффект:**
            • 📝 Письменное (или устное) обязательство увеличивает вероятность выполнения на 40-60%
            • 🎯 Конкретность формулировки повышает эффективность
            • 💫 Публичное (пусть даже самому себе) обещание создает ответственность

            **Ваше обязательство:**
          MARKDOWN
        },
        'summary' => {
          title: "🎊 **Шаг 7: Итог и интеграция**",
          instruction: <<~MARKDOWN
            **Поздравляю!** Вы создали мощный инструмент проактивной гибкости. 🏆

            **Ваш 'План Гибкости' теперь включает:**

            🎯 **Ситуация:** {situation}
            ⚠️ **Возможные трудности:** {challenges}
            🛠️ **Навыки для применения:** {skills}
            📋 **Конкретный план:** {plan}
            💫 **Мысленная подготовка:** {visualization}
            🤝 **Обязательство:** {commitment}

            **Советы по применению:**
            1. 📅 Используйте эту технику для важных событий
            2. 🔄 Адаптируйте план по мере получения опыта
            3. 📝 Ведите журнал успешных применений
            4. 🎯 Фокусируйтесь на процессе, а не только на результате

            **Философская мудрость на завтра:**
            > "Не события волнуют людей, а их мнения об событиях."
            > — Эпиктет

            Вы создали инструмент, который дает свободу действия в любых обстоятельствах!
          MARKDOWN
        }
      }.freeze
      
      # Категории ситуаций для выбора (с психологическими инсайтами)
      SITUATION_CATEGORIES = [
        { 
          emoji: "🏢", 
          name: "Работа/учеба", 
          key: "work",
          examples: ["совещание", "презентация", "дедлайн", "обучение"],
          insight: "Часто связаны с потребностью в компетентности и признании"
        },
        { 
          emoji: "👥", 
          name: "Общение", 
          key: "communication",
          examples: ["сложный разговор", "знакомство", "конфликт", "просьба о помощи"],
          insight: "Отражают потребность в принадлежности и принятии"
        },
        { 
          emoji: "🏪", 
          name: "Бытовые дела", 
          key: "household",
          examples: ["поход в магазин", "визит в госучреждение", "ремонт", "уборка"],
          insight: "Связаны с потребностью в контроле и порядке"
        },
        { 
          emoji: "🚗", 
          name: "Поездки", 
          key: "travel",
          examples: ["дорога на работу", "путешествие", "пробки", "общественный транспорт"],
          insight: "Касаются потребности в безопасности и предсказуемости"
        },
        { 
          emoji: "💼", 
          name: "Ответственность", 
          key: "responsibility",
          examples: ["важная задача", "принятие решения", "финансовые вопросы", "здоровье"],
          insight: "Отражают потребность в надежности и стабильности"
        },
        { 
          emoji: "🎉", 
          name: "События", 
          key: "events",
          examples: ["праздник", "свидание", "встреча с друзьями", "публичное выступление"],
          insight: "Связаны с потребностью в радости и социальной связи"
        }
      ].freeze
      
      # Навыки по неделям (для инвентаризации)
      SKILLS_BY_WEEK = {
        week1: [
          { name: "Дыхание 4-7-8", description: "Успокаивает нервную систему за 1-2 минуты", emoji: "🌬️" },
          { name: "Заземление 5-4-3-2-1", description: "Возвращает в настоящее мгновенно", emoji: "🌍" },
          { name: "Наблюдение мыслей", description: "Отстраненный взгляд на мыслительный поток", emoji: "👁️" },
          { name: "Осознанность в моменте", description: "Полное присутствие здесь и сейчас", emoji: "🧘" }
        ],
        week2: [
          { name: "Когнитивная переоценка", description: "Изменение интерпретации ситуации", emoji: "💡" },
          { name: "Разделение фактов и интерпретаций", description: "Отделение реальности от оценок", emoji: "📊" },
          { name: "Остановка мысли", description: "Прерывание негативного мыслительного потока", emoji: "🛑" },
          { name: "Анализ автоматических мыслей", description: "Распознавание мыслительных шаблонов", emoji: "🔍" }
        ],
        week3: [
          { name: "Самосострадание", description: "Доброе отношение к себе в трудностях", emoji: "💝" },
          { name: "Медитация на принятие", description: "Принятие того, что нельзя изменить", emoji: "🤲" },
          { name: "Практика благодарности", description: "Фокус на том, что есть", emoji: "🙏" },
          { name: "Эмоциональная валидация", description: "Признание и принятие своих чувств", emoji: "❤️" }
        ],
        week4: [
          { name: "SMART-цели", description: "Конкретные и измеримые цели", emoji: "🎯" },
          { name: "Разбивание на шаги", description: "Дробление больших задач на маленькие", emoji: "📋" },
          { name: "Планирование активностей", description: "Запланированная забота о себе", emoji: "📅" },
          { name: "Отслеживание прогресса", description: "Фиксация маленьких побед", emoji: "📈" }
        ]
      }.freeze
      
      # Типичные трудности с решениями
      COMMON_CHALLENGES = [
        {
          name: "Затруднения в выборе ситуации",
          description: "Не знаю, какую ситуацию выбрать для практики",
          solution: "Начните с самой простой и частой ситуации. Можно выбрать прогулку в магазин или утреннюю рутину."
        },
        {
          name: "Чрезмерное обдумывание",
          description: "Начинаю катастрофизировать вместо реалистичной оценки",
          solution: "Ограничьте время анализа. Спросите: 'Что может произойти ВЕРОЯТНО, а не ВООБРАЖАЕМО?'"
        },
        {
          name: "Трудности с применением навыков",
          description: "Не уверен, какие навыки подойдут для моей ситуации",
          solution: "Выбирайте самые простые и уже знакомые техники. Лучше простая техника, применяемая регулярно."
        },
        {
          name: "Чувство искусственности",
          description: "Кажется, что упражнение искусственное или не поможет",
          solution: "Это нормально. Продолжайте практику. Как и любой навык, стоическое предвосхищение требует времени."
        }
      ].freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      def deliver_intro
  send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
  send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
  
  @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
  store_day_data('current_step', 'intro')
  
  # Проверяем состояние пользователя и показываем соответствующую кнопку
  if @user.self_help_state == "day_#{DAY_NUMBER}_intro"
    # Пользователь только начал день - показываем "Продолжить"
    send_message(
      text: "Готовы создать ваш личный 'План Гибкости'?",
      reply_markup: day_24_continue_intro_markup
    )
  else
    # Это предложение нового дня - показываем "Начать"
    send_message(
      text: "Готовы создать ваш личный 'План Гибкости'?",
      reply_markup: TelegramMarkupHelper.day_24_start_proposal_markup
    )
  end
end
      
      def deliver_exercise
  @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
  store_day_data('current_step', 'exercise_explanation')
  
  send_message(text: DAY_STEPS['exercise_explanation'][:title], parse_mode: 'Markdown')
  send_message(text: DAY_STEPS['exercise_explanation'][:instruction], parse_mode: 'Markdown')
  
  # Инициализируем данные упражнения
  init_exercise_data
  
  # Сразу переходим к первому шагу упражнения
  start_exercise_step('select_situation')
end

      
      def complete_exercise
        # Проверяем, что все необходимые данные заполнены
        exercise_data = get_exercise_data
        
        if exercise_data['flexibility_plan'].blank? || exercise_data['commitment'].blank?
          send_message(
            text: "⚠️ У вас не заполнен план гибкости или обязательство. Давайте закончим.",
            parse_mode: 'Markdown'
          )
          start_exercise_step('create_flexibility_plan')
          return false
        end
        
        # Формируем итоговое сообщение с динамическими данными
        formatted_summary = format_summary_instruction(DAY_STEPS['summary'][:instruction], exercise_data)
        
        send_message(text: DAY_STEPS['summary'][:title], parse_mode: 'Markdown')
        send_message(text: formatted_summary, parse_mode: 'Markdown')
        
        # Отмечаем день как завершенный
        @user.complete_day_program(DAY_NUMBER)
        @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
        
        # Сохраняем время завершения
        exercise_data['completed_at'] = Time.current
        store_day_data('exercise_data', exercise_data)
        
        # Показываем итоговый план
        show_final_plan(exercise_data)
        
        # Предлагаем следующий день
        propose_next_day_with_restriction
        
        true
      end
      
      # ===== ОБРАБОТКА КНОПОК =====
      
      def handle_button(callback_data)
        log_info("Handling button: #{callback_data}")
        
        case callback_data
        when 'start_day_24_content', 'start_day_24_from_proposal'
          deliver_exercise
          
        when 'continue_day_24_content'
          resume_session
          
        when 'start_day_24_exercise'
          handle_start_exercise
          
        when /^day_24_situation_(.+)$/
          handle_situation_category_selection($1)
          
        when 'day_24_custom_situation'
          handle_custom_situation_request
          
        when 'day_24_finish_situation'
          handle_finish_situation_selection
          
        when 'day_24_add_challenge'
          show_challenge_examples
          
        when 'day_24_finish_challenges'
          handle_finish_challenges
          
        when /^day_24_skill_week(\d+)_(\d+)$/
          handle_skill_selection($1.to_i, $2.to_i)
          
        when 'day_24_view_my_skills'
          show_skills_summary
          
        when 'day_24_finish_skills'
          handle_finish_skills
          
        when 'day_24_skip_step'
          handle_skip_current_step
          
        when 'day_24_previous_step'
          handle_previous_step
          
        when 'day_24_restart_exercise'
          handle_restart_exercise
          
        when 'day_24_complete_exercise'
          complete_exercise
          
        when 'day_24_show_full_plan'
          show_final_plan(get_exercise_data)
          
        when 'day_24_save_as_template'
          save_as_template
          
        else
          log_warn("Unknown button callback: #{callback_data}")
          send_message(text: "Неизвестная команда. Пожалуйста, используйте кнопки меню.")
        end
      end
      
      # ===== ОБРАБОТКА ТЕКСТОВОГО ВВОДА =====
      
      def handle_text_input(input_text)
        log_info("Handling text input: #{input_text.truncate(50)}")
        
        current_step = get_day_data('current_step')
        
        # Проверяем, ожидаем ли мы ввод кастомной ситуации
        if get_day_data('awaiting_custom_situation')
          store_day_data('awaiting_custom_situation', false)
          return handle_custom_situation_input(input_text)
        end
        
        # Обработка по текущему шагу
        case current_step
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
          log_warn("No text handler for step: #{current_step}")
          false
        end
      end
      
      # ===== ОБРАБОТЧИКИ ШАГОВ УПРАЖНЕНИЯ =====
      
      def handle_start_exercise
        init_exercise_data
        start_exercise_step('select_situation')
      end
      
      def handle_situation_category_selection(category_key)
        category = SITUATION_CATEGORIES.find { |c| c[:key] == category_key }
        
        if category
          exercise_data = get_exercise_data
          exercise_data['situation'] = "#{category[:emoji]} #{category[:name]}"
          exercise_data['situation_details'] = category[:examples].sample
          exercise_data['situation_insight'] = category[:insight]
          store_day_data('exercise_data', exercise_data)
          
          send_message(
            text: "✅ Выбрано: #{category[:emoji]} *#{category[:name]}*\n\n💡 #{category[:insight]}",
            parse_mode: 'Markdown'
          )
          
          sleep(1)
          
          send_message(
            text: "💡 *Пример ситуации:* #{exercise_data['situation_details']}\n\nХотите уточнить детали или продолжить?",
            parse_mode: 'Markdown',
            reply_markup: day_24_situation_details_markup
          )
        else
          send_message(text: "⚠️ Категория не найдена. Пожалуйста, выберите из предложенных.")
        end
      end
      
      def handle_custom_situation_request
        send_message(
          text: "✍️ *Опишите свою ситуацию на завтра:*\n(Что, когда, с кем, где?)",
          parse_mode: 'Markdown'
        )
        store_day_data('awaiting_custom_situation', true)
      end
      
      def handle_custom_situation_input(input_text)
        if input_text.present? && input_text.strip.length > 5
          exercise_data = get_exercise_data
          exercise_data['situation'] = "📝 Моя ситуация"
          exercise_data['situation_details'] = input_text.strip
          store_day_data('exercise_data', exercise_data)
          
          send_message(
            text: "✅ Ситуация сохранена: #{input_text.strip.truncate(100)}",
            parse_mode: 'Markdown'
          )
          
          handle_finish_situation_selection
          true
        else
          send_message(text: "⚠️ Пожалуйста, опишите ситуацию подробнее (минимум 6 символов).")
          false
        end
      end
      
      def handle_finish_situation_selection
        exercise_data = get_exercise_data
        
        if exercise_data['situation'].blank?
          send_message(text: "⚠️ Пожалуйста, выберите или опишите ситуацию.")
          return
        end
        
        start_exercise_step('identify_challenges')
      end
      
      def handle_situation_input(input_text)
        # Если пользователь просто нажал Enter или ввел пустой текст
        return handle_finish_situation_selection if input_text.blank? || input_text.strip.empty?
        
        # Иначе добавляем как уточнение
        exercise_data = get_exercise_data
        exercise_data['situation_details'] = input_text.strip
        store_day_data('exercise_data', exercise_data)
        
        send_message(text: "✅ Детали ситуации обновлены.")
        handle_finish_situation_selection
        true
      end
      
      def show_challenge_examples
        examples = [
          "Внешние обстоятельства изменятся в последний момент",
          "Кто-то будет раздражен или недоволен",
          "Я почувствую тревогу или неуверенность",
          "Возникнут технические или организационные проблемы",
          "Планы придется корректировать на ходу",
          "Я буду уставшим или не в ресурсе"
        ]
        
        example_text = examples.map { |ex| "• #{ex}" }.join("\n")
        
        send_message(
          text: "💡 *Примеры возможных трудностей:*\n\n#{example_text}\n\nМожете использовать как шаблон или придумать свой вариант.",
          parse_mode: 'Markdown'
        )
      end
      
      def handle_finish_challenges
        exercise_data = get_exercise_data
        
        if exercise_data['challenges'].blank? || exercise_data['challenges'].empty?
          send_message(text: "⚠️ Пожалуйста, добавьте хотя бы одну возможную трудность.")
          return
        end
        
        start_exercise_step('skills_inventory')
      end
      
      def handle_challenges_input(input_text)
        return false if input_text.strip.empty?
        
        # Разделяем на отдельные трудности
        challenges = input_text.split(/[,\n\.]/).map(&:strip).reject(&:empty?)
        
        if challenges.any?
          exercise_data = get_exercise_data
          exercise_data['challenges'] = challenges
          store_day_data('exercise_data', exercise_data)
          
          # Показываем сохраненные трудности
          challenges_text = challenges.map.with_index { |c, i| "#{i + 1}. #{c}" }.join("\n")
          
          send_message(
            text: "✅ *Сохранено трудностей: #{challenges.size}*\n\n#{challenges_text}",
            parse_mode: 'Markdown'
          )
          
          sleep(1)
          handle_finish_challenges
          true
        else
          send_message(text: "⚠️ Пожалуйста, опишите хотя бы одну возможную трудность.")
          false
        end
      end
      
      def handle_skill_selection(week_number, skill_index)
        week_key = "week#{week_number}".to_sym
        skills_list = SKILLS_BY_WEEK[week_key]
        
        return unless skills_list && skill_index < skills_list.length
        
        skill = skills_list[skill_index]
        exercise_data = get_exercise_data
        skills = exercise_data['skills'] || []
        
        # Проверяем, добавлен ли уже этот навык
        skill_text = "#{skill[:emoji]} #{skill[:name]}: #{skill[:description]}"
        
        if skills.include?(skill_text)
          skills.delete(skill_text)
          send_message(text: "Убрано: #{skill[:name]}")
        else
          skills << skill_text
          send_message(
            text: "✅ Добавлено: #{skill[:emoji]} *#{skill[:name]}*\n#{skill[:description]}",
            parse_mode: 'Markdown'
          )
        end
        
        exercise_data['skills'] = skills.uniq
        store_day_data('exercise_data', exercise_data)
      end
      
      def show_skills_summary
        exercise_data = get_exercise_data
        
        if exercise_data['skills']&.any?
          skills_text = exercise_data['skills'].map { |s| "• #{s}" }.join("\n")
          
          send_message(
            text: "🛠️ *Ваши выбранные навыки:*\n\n#{skills_text}",
            parse_mode: 'Markdown'
          )
        else
          send_message(text: "У вас еще нет выбранных навыков.")
        end
      end
      
      def handle_finish_skills
        exercise_data = get_exercise_data
        
        if exercise_data['skills'].blank? || exercise_data['skills'].empty?
          send_message(text: "⚠️ Пожалуйста, выберите хотя бы один навык.")
          return
        end
        
        start_exercise_step('create_flexibility_plan')
      end
      
      def handle_skills_input(input_text)
        # Если пользователь ввел дополнительный навык
        if input_text.present?
          exercise_data = get_exercise_data
          skills = exercise_data['skills'] || []
          skills << "💡 Дополнительный: #{input_text.strip}"
          exercise_data['skills'] = skills.uniq
          store_day_data('exercise_data', exercise_data)
          
          send_message(text: "✅ Дополнительный навык добавлен.")
        end
        
        handle_finish_skills
        true
      end
      
      def handle_plan_input(input_text)
        return false if input_text.strip.empty?
        
        exercise_data = get_exercise_data
        exercise_data['flexibility_plan'] = input_text.strip
        store_day_data('exercise_data', exercise_data)
        
        send_message(text: "✅ План гибкости сохранен!")
        
        start_exercise_step('visualization')
        true
      end
      
      def handle_visualization_input(input_text)
        return false if input_text.strip.empty?
        
        exercise_data = get_exercise_data
        exercise_data['visualization_notes'] = input_text.strip
        store_day_data('exercise_data', exercise_data)
        
        send_message(text: "✅ Заметки по визуализации сохранены!")
        
        start_exercise_step('commitment')
        true
      end
      
      def handle_commitment_input(input_text)
        return false if input_text.strip.empty?
        
        exercise_data = get_exercise_data
        exercise_data['commitment'] = input_text.strip
        store_day_data('exercise_data', exercise_data)
        
        send_message(text: "✅ Ваше обязательство сохранено!")
        
        start_exercise_step('summary')
        true
      end
      
      def handle_summary_input(input_text)
        # Сохраняем дополнительные заметки
        if input_text.present?
          exercise_data = get_exercise_data
          exercise_data['additional_notes'] = input_text.strip
          store_day_data('exercise_data', exercise_data)
        end
        
        complete_exercise
        true
      end
      
      def handle_skip_current_step
        current_step = get_day_data('current_step')
        next_step = get_next_step(current_step)
        
        if next_step
          send_message(text: "⏭️ Шаг пропущен.")
          start_exercise_step(next_step)
        else
          complete_exercise
        end
      end
      
      def handle_previous_step
        current_step = get_day_data('current_step')
        previous_step = get_previous_step(current_step)
        
        if previous_step
          send_message(text: "🔙 Возвращаемся к предыдущему шагу.")
          start_exercise_step(previous_step)
        else
          send_message(text: "⚠️ Это первый шаг, возвращаться некуда.")
        end
      end
      
      def handle_restart_exercise
        send_message(text: "🔄 Начинаем упражнение заново!")
        
        clear_exercise_data
        deliver_exercise
      end
      
      private
      
      # ===== ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ =====
      
      def init_exercise_data
        store_day_data('exercise_data', {
          'situation' => nil,
          'situation_details' => nil,
          'situation_insight' => nil,
          'challenges' => [],
          'skills' => [],
          'flexibility_plan' => nil,
          'visualization_notes' => nil,
          'commitment' => nil,
          'additional_notes' => nil,
          'completed_at' => nil
        })
      end
      
      def get_exercise_data
        get_day_data('exercise_data') || {}
      end
      
      def clear_exercise_data
        store_day_data('exercise_data', nil)
        store_day_data('current_step', nil)
        store_day_data('awaiting_custom_situation', false)
      end
      
      def start_exercise_step(step_type)
        store_day_data('current_step', step_type)
        @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_#{step_type}")
        
        step = DAY_STEPS[step_type]
        return unless step
        
        send_message(text: step[:title], parse_mode: 'Markdown')
        send_message(text: step[:instruction], parse_mode: 'Markdown')
        
        # Показываем дополнительные элементы для определенных шагов
        case step_type
        when 'select_situation'
          send_message(
            text: "Выберите категорию или опишите свою ситуацию:",
            reply_markup: day_24_situations_markup
          )
          
        when 'identify_challenges'
          # Показываем выбранную ситуацию
          show_current_situation
          
          send_message(
            text: "Добавьте возможные трудности (можно несколько через запятую или с новой строки):",
            reply_markup: day_24_challenges_markup
          )
          
        when 'skills_inventory'
          # Показываем выявленные трудности
          show_current_challenges
          
          send_message(
            text: "Выберите навыки, которые могут помочь справиться с этими трудностями:",
            reply_markup: day_24_skills_markup
          )
          
        when 'create_flexibility_plan'
          # Показываем выбранные навыки
          show_current_skills
          
          send_message(
            text: "✍️ *Создайте ваш план гибкости:*\n\nИспользуйте формат:\n• ЕСЛИ [трудность] → ТО [навык + действие]\n• ИЛИ ЕСЛИ [другая трудность] → ТО [другое действие]",
            parse_mode: 'Markdown',
            reply_markup: day_24_plan_markup
          )
          
        when 'visualization'
          # Показываем созданный план
          show_current_plan
          
          send_message(
            text: "✍️ *Опишите, что почувствовали во время мысленной репетиции:*",
            parse_mode: 'Markdown',
            reply_markup: day_24_visualization_markup
          )
          
        when 'commitment'
          send_message(
            text: "✍️ *Сформулируйте ваше обязательство на завтра:*",
            parse_mode: 'Markdown',
            reply_markup: day_24_commitment_markup
          )
          
        when 'summary'
          # Форматируем итог с реальными данными
          formatted_summary = format_summary_instruction(step[:instruction], get_exercise_data)
          
          send_message(
            text: "🎊 *Ваш 'План Гибкости' готов!*\n\n#{formatted_summary}",
            parse_mode: 'Markdown',
            reply_markup: day_24_completion_markup
          )
        end
      end
      
      def format_summary_instruction(base_instruction, exercise_data)
        base_instruction
          .gsub('{situation}', exercise_data['situation'] || 'Не указано')
          .gsub('{challenges}', 
                exercise_data['challenges']&.any? ? 
                exercise_data['challenges'].map { |c| "• #{c}" }.join("\n") : 
                'Не указано')
          .gsub('{skills}', 
                exercise_data['skills']&.any? ? 
                exercise_data['skills'].map { |s| "• #{s.split(':').first}" }.join("\n") : 
                'Не указано')
          .gsub('{plan}', exercise_data['flexibility_plan']&.truncate(200) || 'Не указано')
          .gsub('{visualization}', exercise_data['visualization_notes']&.truncate(150) || 'Не указано')
          .gsub('{commitment}', exercise_data['commitment']&.truncate(150) || 'Не указано')
      end
      
      def show_current_situation
        exercise_data = get_exercise_data
        return unless exercise_data['situation']
        
        message = <<~MARKDOWN
          📋 *Текущая ситуация:*
          
          🎯 **Категория:** #{exercise_data['situation']}
          📝 **Детали:** #{exercise_data['situation_details'] || 'Не указано'}
          💡 **Психологический инсайт:** #{exercise_data['situation_insight'] || 'Не указано'}
          
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
          # Извлекаем только название навыка для краткости
          skill_name = skill.split(':').first
          message += "#{index + 1}. #{skill_name}\n"
        end
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def show_current_plan
        exercise_data = get_exercise_data
        return unless exercise_data['flexibility_plan']
        
        message = <<~MARKDOWN
          📝 *Ваш план гибкости:*
          
          #{exercise_data['flexibility_plan'].truncate(300)}
          
          **Теперь закрепим его через визуализацию...**
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
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
          #{exercise_data['skills']&.map { |s| "• #{s.split(':').first}" }&.join("\n") || 'Не указано'}

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
      
      def save_as_template
        exercise_data = get_exercise_data
        
        # Сохраняем как шаблон для будущего использования
        template_data = {
          'situation_type' => exercise_data['situation'],
          'challenges_pattern' => exercise_data['challenges'],
          'skills_used' => exercise_data['skills'],
          'plan_template' => exercise_data['flexibility_plan'],
          'created_at' => Time.current
        }
        
        store_day_data('flexibility_template', template_data)
        
        send_message(
          text: "✅ План сохранен как шаблон. Вы можете использовать его для похожих ситуаций в будущем.",
          parse_mode: 'Markdown'
        )
      end
      
      def show_day_completion
        completion_message = <<~MARKDOWN
          🎉 *Поздравляем! Вы завершили День 24!*
          
          **Что вы достигли сегодня:**
          • 🎯 Освоили технику стоического предвосхищения
          • 🔍 Научились реалистично оценивать возможные трудности
          • 🛠️ Провели инвентаризацию освоенных навыков
          • 📝 Создали персональный "План Гибкости"
          • 🎭 Провели мысленную репетицию успеха
          • 🤝 Дали себе осознанное обязательство
          
          **Научные преимущества вашей работы:**
          • 🧠 Снижение тревожности о будущем на 35-45%
          • 💪 Повышение уверенности в решении проблем на 50-60%
          • 🔄 Улучшение когнитивной гибкости на 25-30%
          • 🛡️ Уменьшение эмоциональных реакций на неожиданности
          
          **Ваш план сохранен и доступен для пересмотра.**
          **Используйте технику предвосхищения для важных событий!**
        MARKDOWN
        
        send_message(text: completion_message, parse_mode: 'Markdown')
      end
      
      def handle_resume_from_step(step)
        case step
        when 'intro'
          deliver_intro
        when 'exercise_explanation'
          deliver_exercise
        when 'select_situation', 'identify_challenges', 'skills_inventory', 
             'create_flexibility_plan', 'visualization', 'commitment', 'summary'
          start_exercise_step(step)
        else
          deliver_exercise
        end
      end
      
      def get_next_step(current_step)
        steps_order = ['select_situation', 'identify_challenges', 'skills_inventory', 
                      'create_flexibility_plan', 'visualization', 'commitment', 'summary']
        
        current_index = steps_order.index(current_step)
        return steps_order[current_index + 1] if current_index && current_index < steps_order.length - 1
        
        nil
      end
      
      def get_previous_step(current_step)
        steps_order = ['select_situation', 'identify_challenges', 'skills_inventory', 
                      'create_flexibility_plan', 'visualization', 'commitment', 'summary']
        
        current_index = steps_order.index(current_step)
        return steps_order[current_index - 1] if current_index && current_index > 0
        
        nil
      end
      
      def propose_next_day_with_restriction
        next_day = 25
        
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 *Следующий шаг: День #{next_day}*
            
            ✅ *Доступен сейчас!*
            
            **Что вас ждет:**
            • 🌌 Вид сверху на ваши ценности
            • 🧭 Осознание жизненного направления
            • 💫 Интеграция полученных инсайтов
            • 🚀 Планирование следующих шагов
            
            Вы можете начать следующий день прямо сейчас.
          MARKDOWN
          
          button_text = "🌌 Начать День #{next_day}"
          callback_data = "start_day_#{next_day}_from_proposal"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = <<~MARKDOWN
            🎯 *Следующий шаг: День #{next_day}*
            
            ⏱️ *Ограничение:* #{error_message}
            
            **Пока ждете, можете:**
            • 🛡️ Применить план гибкости на практике
            • 📝 Вести журнал успешных применений
            • 🔄 Адаптировать план по мере получения опыта
            • 🧠 Использовать технику для других ситуаций
            
            *Совет на сегодня:* 
            Попробуйте применить технику предвосхищения к другой ситуации. 
            Практика — лучший способ закрепить навык.
          MARKDOWN
          
          button_text = "⏱️ Проверить доступность Дня #{next_day}"
          callback_data = "start_day_#{next_day}_from_proposal"
        end
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Нажмите кнопку:",
          reply_markup: {
            inline_keyboard: [
              [
                { 
                  text: button_text, 
                  callback_data: callback_data
                }
              ]
            ]
          }
        )
      end
      
      # ===== МЕТОДЫ РАЗМЕТКИ =====
      
      def day_24_start_exercise_markup
        {
          inline_keyboard: [
            [
              { text: "🛡️ Начать упражнение", callback_data: 'start_day_24_exercise' }
            ]
          ]
        }
      end

      def day_24_continue_intro_markup
  {
    inline_keyboard: [
      [
        { text: "🛡️ Продолжить упражнение", callback_data: 'start_day_24_exercise' }
      ]
    ]
  }
end
      
      def day_24_situations_markup
        keyboard = []
        
        # Создаем кнопки по категориям (2 в ряд)
        SITUATION_CATEGORIES.each_slice(2) do |pair|
          row = []
          pair.each do |category|
            row << { 
              text: "#{category[:emoji]} #{category[:name]}", 
              callback_data: "day_24_situation_#{category[:key]}" 
            }
          end
          keyboard << row
        end
        
        # Кнопки для действий
        keyboard << [
          { text: "✍️ Описать свою ситуацию", callback_data: 'day_24_custom_situation' }
        ]
        
        keyboard << [
          { text: "✅ Продолжить", callback_data: 'day_24_finish_situation' }
        ]
        
        { inline_keyboard: keyboard }
      end
      
      def day_24_situation_details_markup
        {
          inline_keyboard: [
            [
              { text: "✍️ Уточнить детали", callback_data: 'day_24_custom_situation' },
              { text: "✅ Продолжить", callback_data: 'day_24_finish_situation' }
            ]
          ]
        }
      end
      
      def day_24_challenges_markup
        {
          inline_keyboard: [
            [
              { text: "💡 Примеры трудностей", callback_data: 'day_24_add_challenge' }
            ],
            [
              { text: "✅ Завершить выбор", callback_data: 'day_24_finish_challenges' }
            ]
          ]
        }
      end
      
      def day_24_skills_markup
        keyboard = []
        
        # Добавляем навыки по неделям
        SKILLS_BY_WEEK.each do |week_key, skills|
          week_name = week_key.to_s.gsub('week', 'Неделя ')
          keyboard << [{ text: "📅 #{week_name}", callback_data: 'noop' }]
          
          # Создаем строки по 2 кнопки
          skills.each_slice(2) do |pair|
            row = []
            pair.each_with_index do |skill, index|
              week_num = week_key.to_s.gsub('week', '').to_i
              skill_index = skills.index(skill)
              row << { 
                text: "#{skill[:emoji]} #{skill[:name]}", 
                callback_data: "day_24_skill_week#{week_num}_#{skill_index}" 
              }
            end
            keyboard << row
          end
          
          keyboard << [] # Пустая строка для разделения
        end
        
        keyboard << [
          { text: "🧠 Мои навыки", callback_data: 'day_24_view_my_skills' },
          { text: "✅ Готово", callback_data: 'day_24_finish_skills' }
        ]
        
        keyboard << [
          { text: "⏭️ Пропустить шаг", callback_data: 'day_24_skip_step' },
          { text: "🔙 Назад", callback_data: 'day_24_previous_step' }
        ]
        
        { inline_keyboard: keyboard.compact }
      end
      
      def day_24_plan_markup
        {
          inline_keyboard: [
            [
              { text: "⏭️ Пропустить шаг", callback_data: 'day_24_skip_step' },
              { text: "🔙 Назад", callback_data: 'day_24_previous_step' }
            ]
          ]
        }
      end
      
      def day_24_visualization_markup
        {
          inline_keyboard: [
            [
              { text: "⏭️ Пропустить шаг", callback_data: 'day_24_skip_step' },
              { text: "🔙 Назад", callback_data: 'day_24_previous_step' }
            ]
          ]
        }
      end
      
      def day_24_commitment_markup
        {
          inline_keyboard: [
            [
              { text: "⏭️ Пропустить шаг", callback_data: 'day_24_skip_step' },
              { text: "🔙 Назад", callback_data: 'day_24_previous_step' }
            ]
          ]
        }
      end
      
      def day_24_completion_markup
        {
          inline_keyboard: [
            [
              { text: "📋 Посмотреть полный план", callback_data: 'day_24_show_full_plan' },
              { text: "💾 Сохранить как шаблон", callback_data: 'day_24_save_as_template' }
            ],
            [
              { text: "✅ Завершить день", callback_data: 'day_24_complete_exercise' },
              { text: "🔄 Начать заново", callback_data: 'day_24_restart_exercise' }
            ]
          ]
        }
      end
      
      def log_info(message)
        Rails.logger.info "[Day#{DAY_NUMBER}Service] #{message} - User: #{@user.telegram_id}"
      end
      
      def log_warn(message)
        Rails.logger.warn "[Day#{DAY_NUMBER}Service] #{message} - User: #{@user.telegram_id}"
      end
      
      def log_error(message, error = nil)
        Rails.logger.error "[Day#{DAY_NUMBER}Service] #{message} - User: #{@user.telegram_id}"
        Rails.logger.error error.message if error
        Rails.logger.error error.backtrace.first(5).join("\n") if error
      end
    end
  end
end
module SelfHelp
  module Days
    class Day20Service < DayBaseService
      include TelegramMarkupHelper
      
      # ===== КОНСТАНТЫ ДНЯ 20 =====
      DAY_NUMBER = 20
      
      # Шаги дня 20
      DAY_STEPS = {
        'intro' => {
          title: "🦸‍♂️ *День 20: Преодоление страха* 🦸‍♀️",
          instruction: <<~MARKDOWN
            *Сегодняшняя миссия:*
            **Сделать что-то, что вы боитесь сделать.**

            *Зачем это нужно?*

            **Научные факты о страхе:**
            🧠 *Страх активирует миндалевидное тело* - древнюю часть мозга, отвечающую за выживание
            🔄 *Привыкание* - каждый раз, когда вы сталкиваетесь со страхом, реакция становится слабее
            💪 *Нейропластичность* - мозг создает новые связи, когда вы делаете что-то новое
            📈 *Эффект накопления* - маленькие победы ведут к большим изменениям

            *Что такое страх на самом деле?*
            Это не враг, а система оповещения. 
            Но как GPS, который кричит "Опасность!" на каждом перекрестке - иногда его нужно перенастроить.

            *Сегодня мы научимся:*
            1. Определять свои страхи
            2. Анализировать их реалистичность  
            3. Планировать маленькие шаги
            4. Действовать, несмотря на страх
            5. Анализировать результаты

            *«Смелость — это не отсутствие страха, а способность действовать, несмотря на него.»*
          MARKDOWN
        },
        'exercise_explanation' => {
          title: "🎯 *Упражнение: \"Один маленький шаг\"* 🎯",
          instruction: <<~MARKDOWN
            *Почему это работает лучше больших целей?*

            **Закон 1%:** Улучшение на 1% каждый день дает 37-кратный рост за год
            **Эффект снежного кома:** Маленькие шаги создают импульс
            **Нейробиология:** Мозг легче принимает микро-изменения

            *Преимущества подхода:*
            ✅ Не требует героизма - только маленьких действий
            ✅ Снижает сопротивление - легче начать
            ✅ Создает цепную реакцию - один шаг ведет к другому
            ✅ Работает с любыми страхами - от социальных до профессиональных

            *Сегодня вы:*
            1. Выберете категорию страха
            2. Найдете маленькое, но значимое действие
            3. Спланируете его выполнение
            4. Сделаете первый шаг
            5. Проанализируете результат

            *Готовы сделать один маленький шаг?*
          MARKDOWN
        },
        'completion' => {
          title: "🏆 *День 20 завершен!* 🏆",
          instruction: <<~MARKDOWN
            **Поздравляем! Вы только что преодолели страх!** 🌟

            **Что вы сделали:**
            1. 🎯 Определили страх для работы
            2. 📊 Проанализировали его реалистичность
            3. 📝 Спланировали маленькие шаги
            4. 🚀 Сделали первый шаг
            5. 💭 Проанализировали результат

            **Поздравляем!** Вы применили технику, которая:
            • 🧠 Основана на принципах экспозиционной терапии
            • 📊 Подтверждена нейробиологическими исследованиями
            • 😌 Помогает миллионам людей
            • 🔄 Меняет структуру мозга при регулярном использовании

            **Следующие шаги:**
            • 📚 Продолжайте практиковать маленькие шаги
            • 🔄 Увеличивайте сложность постепенно
            • 💪 Используйте полученный опыт для других страхов
          MARKDOWN
        }
      }.freeze
      
      # Категории страхов с примерами
      FEAR_CATEGORIES = {
        'social' => {
          name: 'Социальные страхи',
          emoji: '👥',
          examples: [
            'Позвонить незнакомцу',
            'Выступить на собрании',
            'Сказать "нет" коллеге',
            'Познакомиться с кем-то новым',
            'Сделать комплимент'
          ]
        },
        'personal' => {
          name: 'Личные страхи', 
          emoji: '🌟',
          examples: [
            'Начать новое хобби',
            'Пойти в спортзал',
            'Изменить прическу',
            'Купить что-то необычное',
            'Сказать о своих чувствах'
          ]
        },
        'professional' => {
          name: 'Профессиональные страхи',
          emoji: '💼',
          examples: [
            'Попросить повышение',
            'Предложить новую идею',
            'Взять сложный проект',
            'Признать ошибку',
            'Пройти собеседование'
          ]
        },
        'small_wins' => {
          name: 'Малые победы',
          emoji: '🎯',
          examples: [
            'Сказать что-то в очереди',
            'Задать вопрос в магазине',
            'Позвонить вместо сообщения',
            'Пойти новой дорогой',
            'Попробовать новую еду'
          ]
        }
      }.freeze
      
      # Шаги преодоления страха
      FEAR_OVERCOMING_STEPS = [
        {
          title: "Осознание",
          description: "Признайте свой страх. Назовите его вслух или запишите.",
          emoji: "🎯"
        },
        {
          title: "Анализ", 
          description: "Спросите себя: 'Что самое худшее может случиться?' и 'Что самое лучшее?'",
          emoji: "🧠"
        },
        {
          title: "Планирование",
          description: "Разбейте действие на маленькие шаги. Начните с самого простого.",
          emoji: "📝"
        },
        {
          title: "Действие",
          description: "Сделайте первый маленький шаг прямо сейчас.",
          emoji: "🚀"
        },
        {
          title: "Рефлексия",
          description: "После действия проанализируйте, что произошло на самом деле.",
          emoji: "💭"
        }
      ].freeze
      
      # Польза преодоления страхов
      BENEFITS = [
        "🧠 **Нейропластичность мозга** - каждый раз, преодолевая страх, вы создаете новые нейронные связи",
        "💪 **Повышение уверенности** - каждая маленькая победа делает вас сильнее",
        "🌱 **Личностный рост** - выходите из зоны комфорта = растете как личность",
        "🎯 **Расширение возможностей** - страхи перестают ограничивать вашу жизнь",
        "😌 **Снижение тревожности** - мозг учится, что многие страхи нереалистичны"
      ].freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        
        # Научные факты
        send_message(
          text: statistics_message,
          parse_mode: 'Markdown'
        )
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        store_day_data('current_step', 'intro')
        save_current_progress
        
        send_message(
          text: "Готовы посмотреть в лицо своим страхам?",
          parse_mode: 'Markdown',
          reply_markup: day_20_content_markup
        )
      end
      
      def deliver_exercise
        log_info("Starting Day 20 exercise")
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise_explanation')
        store_day_data('exercise_started_at', Time.current)
        clear_day_data
        save_current_progress
        
        send_message(text: DAY_STEPS['exercise_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['exercise_explanation'][:instruction], parse_mode: 'Markdown')
        
        sleep(1)
        choose_fear_category
      end
      
      def choose_fear_category
        store_day_data('current_step', 'choosing_category')
        save_current_progress
        
        message = <<~MARKDOWN
          🎯 *Шаг 1: Выберите категорию страха*

          *В какой сфере вы хотели бы поработать сегодня?*

          Каждая категория содержит примеры маленьких шагов, которые можно сделать прямо сегодня.

          *Важно:* Выбирайте не самый большой страх, а тот, с которым готовы поработать СЕГОДНЯ.
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Выберите категорию:",
          reply_markup: fear_categories_markup
        )
      end
      
      def handle_category_selection(category_key)
        category = FEAR_CATEGORIES[category_key]
        store_day_data('fear_category', category_key)
        store_day_data('current_step', 'choosing_action')
        save_current_progress
        
        examples_text = category[:examples].map.with_index(1) do |example, index|
          "#{index}. #{example}"
        end.join("\n")
        
        message = <<~MARKDOWN
          #{category[:emoji]} *Вы выбрали: #{category[:name]}*

          *Примеры маленьких шагов:*

          #{examples_text}

          *Как выбрать действие:*
          🎯 **Достаточно маленькое** - чтобы можно было сделать сегодня
          💪 **Достаточно значимое** - чтобы почувствовать победу
          ⏱️ **Достаточно конкретное** - чтобы четко знать, что делать
          🔄 **Достаточно безопасное** - чтобы последствия были приемлемыми

          *Совет:* Лучше сделать маленький шаг и завершить его, чем планировать большой и не начать.
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Какое действие вы выберете? (Напишите свой вариант или выберите из примеров)",
          reply_markup: back_to_categories_markup
        )
      end
      
      def handle_action_selection(action_text)
        log_info("handle_action_selection called with: #{action_text}")
        
        store_day_data('chosen_action', action_text)
        store_day_data('current_step', 'planning')
        save_current_progress
        
        message = <<~MARKDOWN
          🎉 *Отличный выбор!*

          Вы выбрали: **#{action_text}**

          *Почему это важно:*
          Каждый раз, когда вы делаете что-то, чего боитесь, вы:
          • Перепрограммируете свой мозг
          • Увеличиваете свою зону комфорта
          • Создаете прецедент успеха
          • Укрепляете уверенность в себе

          *Сейчас самое важное время!*
          Страх пытается отговорить вас. Это нормально.
          Давайте превратим этот страх в план.
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        show_overcoming_steps
      end
      
      def show_overcoming_steps
        store_day_data('current_step', 'learning_steps')
        save_current_progress
        
        message = "📋 *5 шагов для преодоления страха:*\n\n"
        
        FEAR_OVERCOMING_STEPS.each_with_index do |step, index|
          message += "#{step[:emoji]} *Шаг #{index + 1}: #{step[:title]}*\n"
          message += "#{step[:description]}\n\n"
        end
        
        message += "*Давайте применим эти шаги к вашему действию!*"
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Готовы проработать каждый шаг?",
          reply_markup: start_planning_markup
        )
      end
      
      def start_planning
        store_day_data('current_step', 'step1_awareness')
        save_current_progress
        
        message = <<~MARKDOWN
          🎯 *Шаг 1: Осознание страха*

          *Задание:*
          Опишите свой страх максимально конкретно.
          
          *Примеры вопросов:*
          • Что именно меня пугает в этом действии?
          • Какие мысли приходят в голову, когда я думаю об этом?
          • Как реагирует мое тело? (учащенное сердцебиение, потные ладони и т.д.)
          • Когда этот страх появился впервые?

          *Важно:* Не оценивайте страх как "глупый" или "неважный". 
          Просто опишите его как наблюдатель.
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Опишите ваш страх:",
          reply_markup: skip_step_markup('awareness')
        )
      end
      
      def handle_awareness_input(text)
        return false if text.blank?
        
        store_day_data('awareness_description', text)
        store_day_data('current_step', 'step2_analysis')
        save_current_progress
        
        message = <<~MARKDOWN
          🧠 *Шаг 2: Анализ страха*

          *Техника "Реалистичная оценка":*

          1. **Спросите себя:**
             • *Что самое худшее может случиться?* (будьте максимально конкретны)
             • *Насколько это вероятно?* (по шкале от 1% до 100%)
             • *Как я справлюсь, если это случится?*

          2. **Теперь спросите:**
             • *Что самое лучшее может случиться?*
             • *Что наиболее вероятно произойдет?*
             • *Что я получу, преодолев этот страх?*

          *Исследования показывают:* В 85% случаев наши страхи преувеличены.
          Мозг эволюционировал, чтобы переоценивать опасность - это помогало выжить.
          Но в современном мире эта функция часто мешает.
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Проведите анализ вашего страха:",
          reply_markup: skip_step_markup('analysis')
        )
        
        true
      end
      
      def handle_analysis_input(text)
        return false if text.blank?
        
        store_day_data('analysis_description', text)
        store_day_data('current_step', 'step3_planning')
        save_current_progress
        
        chosen_action = get_day_data('chosen_action')
        
        message = <<~MARKDOWN
          📝 *Шаг 3: Планирование действия*

          *Техника "Микро-шаги":*
          Разбейте ваше действие **"#{chosen_action}"** на самые маленькие возможные шаги.

          *Пример для "Позвонить незнакомцу":*
          1. Найти номер телефона (1 минута)
          2. Написать, что скажу (2 минуты)
          3. Сделать три глубоких вдоха (30 секунд)
          4. Набрать номер (10 секунд)
          5. Сказать "Алло" (1 секунда)

          *Почему это работает:*
          • Мозг не воспринимает микро-шаги как угрозу
          • Каждый шаг дает чувство контроля
          • Импульс нарастает с каждым шагом
          • Вы можете остановиться в любой момент

          *Секрет:* Первый шаг должен быть настолько маленьким, что отказ от него будет смешным.
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Разбейте ваше действие на микро-шаги:",
          reply_markup: skip_step_markup('planning')
        )
        
        true
      end
      
      def handle_planning_input(text)
        return false if text.blank?
        
        store_day_data('planning_steps', text)
        store_day_data('current_step', 'step4_action')
        save_current_progress
        
        message = <<~MARKDOWN
          🚀 *Шаг 4: Действие*

          *Самый важный момент!*

          *Перед действием:*
          1. Напомните себе: **"Это всего лишь эксперимент"**
          2. Скажите: **"Я делаю это не потому, что не боюсь, а чтобы научиться действовать, несмотря на страх"**
          3. Поставьте таймер на 5 минут - это максимум, что потребуется для первого шага
          4. Сделайте 3 глубоких вдоха

          *Во время действия:*
          • Обращайте внимание на ощущения в теле
          • Помните: дискомфорт ≠ опасность
          • Фокусируйтесь только на текущем микро-шаге

          *После действия (даже если не получилось):*
          Вы уже победили, потому что попробовали.
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Когда будете готовы, сделайте первый микро-шаг:",
          reply_markup: action_completed_markup
        )
        
        true
      end
      
      def handle_action_completed
        store_day_data('action_completed', true)
        store_day_data('action_completed_at', Time.current)
        store_day_data('current_step', 'step5_reflection')
        save_current_progress
        
        message = <<~MARKDOWN
          💭 *Шаг 5: Рефлексия*

          *Независимо от результата - вы сделали это!*

          *Вопросы для анализа:*
          1. Что произошло на самом деле? (факты, без оценок)
          2. Чем это отличается от ваших ожиданий?
          3. Что вы узнали о своем страхе?
          4. Что вы узнали о себе?
          5. Какой самый маленький шаг вы можете сделать завтра?

          *Научный факт:*
          Каждый раз, когда вы действуете, несмотря на страх, вы:
          • Ослабляете связь "ситуация → страх" в мозгу
          • Укрепляете связь "ситуация → я могу справиться"
          • Создаете новый опыт, который перезаписывает старые страхи
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Опишите ваш опыт и выводы:",
          reply_markup: skip_reflection_markup
        )
      end
      
      def handle_reflection_input(text)
        store_day_data('reflection', text)
        save_current_progress
        
        show_success_summary
        true
      end
      
      def show_success_summary
        store_day_data('current_step', 'summary')
        save_current_progress
        
        chosen_action = get_day_data('chosen_action')
        category_key = get_day_data('fear_category')
        category = FEAR_CATEGORIES[category_key]
        
        message = <<~MARKDOWN
          🏆 *Поздравляем! День 20 завершен!* 🏆

          *Что вы сделали сегодня:*
          ✅ Выбрали действие: **#{chosen_action}**
          ✅ Определили категорию: **#{category[:name]}**
          ✅ Прошли 5 шагов преодоления страха
          ✅ Сделали первый шаг (или несколько!)
          ✅ Проанализировали опыт

          *Что это значит для вашего мозга:*
          🧠 Вы создали новый нейронный путь
          🔄 Вы ослабили старую реакцию страха
          💪 Вы укрепили "мышцу смелости"
          🌱 Вы расширили свою зону комфорта

          *Долгосрочные эффекты:*
          • Следующий раз будет легче
          • Другие страхи станут менее intimidating
          • Уверенность будет расти экспоненциально
          • Вы станете архитектором своей жизни

          *«Смелость подобна мышце — чем больше ее используешь, тем сильнее она становится.»*
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        complete_exercise
      end
      
      def complete_exercise
  log_info("Completing Day 20 exercise")
  
  # Проверяем, завершено ли упражнение
  unless get_day_data('action_completed') == true
    send_message(
      text: "⚠️ Сначала завершите упражнение.\n\nУбедитесь, что вы:\n1. Выбрали действие\n2. Спланировали шаги\n3. Сделали первый шаг\n4. Проанализировали результат",
      parse_mode: 'Markdown',
      reply_markup: { inline_keyboard: [[{ text: "🔄 Вернуться к упражнению", callback_data: 'continue_day_20_content' }]] }.to_json
    )
    return
  end
  
  # Отмечаем день как завершенный в программе
  @user.complete_day_program(DAY_NUMBER)
  @user.complete_self_help_day(DAY_NUMBER)
  
  # Устанавливаем состояние завершения
  @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
  
  send_message(text: DAY_STEPS['completion'][:title], parse_mode: 'Markdown')
  send_message(text: DAY_STEPS['completion'][:instruction], parse_mode: 'Markdown')
  
  sleep(1)
  show_fear_overcoming_menu
  
  sleep(2)
  propose_next_day_with_restriction  # ЗАМЕНЯЕМ старый вызов на новый метод
end
      
      def show_fear_overcoming_menu
  store_day_data('current_step', 'menu')
  save_current_progress
  
  message = <<~MARKDOWN
    🦸‍♂️ *Меню преодоления страхов* 🦸‍♀️

    *Что дальше?*

    Вы можете:
    💡 **Посмотреть советы** - как продолжать работать со страхами
    🔄 **Пройти заново** - начать день 20 сначала (без ограничений времени)
    📊 **Мои победы** - посмотреть, что вы уже преодолели
    ➡️ **Следующий день** - продолжить программу
    🏠 **Главное меню** - вернуться к основным функциям

    *Совет на завтра:*
    Запланируйте прямо сейчас одно маленькое страшное дело на завтра.
    Чем конкретнее план, тем выше вероятность выполнения.
  MARKDOWN
  
  send_message(text: message, parse_mode: 'Markdown')
  
  send_message(
    text: "Выберите действие:",
    reply_markup: day_20_menu_markup
  )
end 
      
      def show_fear_tips
        store_day_data('current_step', 'tips')
        save_current_progress
        
        tips = [
          "🎯 **Начинайте с самого маленького** - успех порождает успех",
          "📅 **Планируйте заранее** - решение, принятое в спокойном состоянии, легче выполнить",
          "🏃‍♀️ **Не ждите идеального состояния** - смелость приходит в процессе действия",
          "📊 **Ведите дневник побед** - записывайте каждое маленькое преодоление",
          "🤝 **Найдите поддержку** - расскажите кому-то о своих планах",
          "🔄 **Повторяйте успешные действия** - закрепляйте новые нейронные связи",
          "🎭 **Используйте роль** - представьте, что вы актер, играющий смелого человека",
          "⏱️ **Устанавливайте временные лимиты** - 'я буду бояться только 5 минут, а потом действую'"
        ]
        
        message = "💡 *Советы для работы со страхами:*\n\n"
        message += tips.sample(4).join("\n\n")
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Вернуться в меню?",
          reply_markup: { inline_keyboard: [[{ text: "⬅️ Назад", callback_data: 'back_to_day_20_menu' }]] }.to_json
        )
      end
      
      def show_fear_victories
        store_day_data('current_step', 'victories')
        save_current_progress
        
        # Показываем победы из данных пользователя
        victories = @user.read_attribute(:self_help_program_data) || {}&.select { |k, v| k.start_with?('day_20_') && v.present? }
        
        if victories && victories.any?
          message = "🏆 *Ваши победы над страхами:*\n\n"
          
          if victories['chosen_action']
            message += "🎯 *Последнее действие:* #{victories['chosen_action']}\n"
          end
          
          if victories['fear_category']
            category = FEAR_CATEGORIES[victories['fear_category']]
            message += "📁 *Категория:* #{category[:name]}\n"
          end
          
          if victories['action_completed']
            message += "✅ *Статус:* Первый шаг сделан!\n"
          end
          
          message += "\n*Продолжайте в том же духе!*\n"
          message += "Каждая маленькая победа делает вас сильнее."
        else
          message = <<~MARKDOWN
            📭 *У вас пока нет записей о победах над страхами.*
            
            Начните с выполнения упражнения дня 20!
            
            Помните: даже самый маленький шаг навстречу страху - это уже победа.
          MARKDOWN
        end
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Хотите начать новое задание?",
          reply_markup: { 
            inline_keyboard: [
              [{ text: "🎯 Да, новое задание", callback_data: 'start_day_20_exercise' }],
              [{ text: "⬅️ Назад", callback_data: 'back_to_day_20_menu' }]
            ]
          }.to_json
        )
      end
      
      # ===== ОБРАБОТКА КНОПОК =====
      
      def handle_button(callback_data)
        log_info("Day20Service handling button: #{callback_data}")
        
        case callback_data
        when 'start_day_20_exercise'
          deliver_exercise
          
        when /^day_20_category_(.+)$/
          category_key = $1
          handle_category_selection(category_key)
          
        when 'day_20_back_to_categories'
          choose_fear_category
          
        when 'day_20_start_planning'
          start_planning
          
        when /^day_20_skip_(.+)$/
          step_name = $1
          handle_skipped_step(step_name)
          
        when 'day_20_action_completed'
          handle_action_completed
          
        when 'day_20_need_help'
          provide_first_step_help
          
        when 'day_20_skip_reflection'
          show_success_summary
          
        when 'view_fear_tips'
          show_fear_tips
          
        when 'view_fear_victories'
          show_fear_victories
          
        when 'back_to_day_20_menu'
          show_fear_overcoming_menu
          
        when 'continue_day_20_content'
          resume_session
          
        when 'day_20_complete_exercise'
          complete_exercise
          
        else
          log_warn("Unknown button callback: #{callback_data}")
          send_message(text: "Неизвестная команда.")
        end
      end
      
      def handle_skipped_step(step_name)
        case step_name
        when 'awareness'
          store_day_data('awareness_description', 'Пропущено')
          handle_awareness_input('')
        when 'analysis'
          store_day_data('analysis_description', 'Пропущено')
          handle_analysis_input('')
        when 'planning'
          store_day_data('planning_steps', 'Пропущено')
          handle_planning_input('')
        end
      end
      
      def provide_first_step_help
        chosen_action = get_day_data('chosen_action')
        
        message = <<~MARKDOWN
          🆘 *Помощь с первым шагом*

          *Для действия: "#{chosen_action}"*

          *Техника "Сверх-маленький первый шаг":*

          1. **Сделайте шаг еще меньше** - если звонить страшно, сначала просто найдите номер
          2. **Измените контекст** - если страшно говорить вслух, сначала напишите в чат
          3. **Измените время** - если страшно сейчас, запланируйте на завтра утром
          4. **Измените место** - если страшно в офисе, сделайте это в кафе
          5. **Сделайте вместе** - попросите друга поддержать вас

          *Пример сверх-маленьких шагов:*
          • Не "позвонить", а "взять телефон в руку"
          • Не "выступить", а "написать первый слайд"
          • Не "познакомиться", а "улыбнуться незнакомцу"
          • Не "сказать нет", а "сказать 'мне нужно подумать'"

          *Секрет:* Самый первый шаг должен быть настолько простым, что его невозможно не сделать.
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Какой сверх-маленький шаг вы можете сделать прямо сейчас?",
          reply_markup: action_completed_markup
        )
      end
      
      # ===== ОБРАБОТКА ТЕКСТОВОГО ВВОДА =====
      
      def handle_text_input(text)
        log_info("Handling text input for day 20: #{text.truncate(50)}")
        
        current_step = get_day_data('current_step')
        
        case current_step
        when 'choosing_action'
          handle_action_selection(text)
        when 'step1_awareness'
          handle_awareness_input(text)
        when 'step2_analysis'
          handle_analysis_input(text)
        when 'step3_planning'
          handle_planning_input(text)
        when 'step5_reflection'
          handle_reflection_input(text)
        else
          log_warn("Day 20: Unknown step for text input: #{current_step}")
          send_message(text: "Пожалуйста, используйте кнопки для навигации.")
          false
        end
      end
      
      # Метод для совместимости с SelfHelpFacade
      def handle_smart_input(text)
        handle_text_input(text)
      end
      
  
      def handle_resume_from_step(step)
        case step
        when 'intro'
          deliver_intro
        when 'exercise_explanation', 'exercise_started', 'choosing_category'
          choose_fear_category
        when 'choosing_action'
          chosen_action = get_day_data('chosen_action')
          if chosen_action.present?
            send_message(
              text: "Вы выбрали действие: #{chosen_action}\n\nПродолжить планирование?",
              reply_markup: start_planning_markup
            )
          else
            choose_fear_category
          end
        when 'step1_awareness'
          send_message(
            text: "🎯 Шаг 1: Осознание страха\n\nОпишите ваш страх:",
            reply_markup: skip_step_markup('awareness')
          )
        when 'step2_analysis'
          send_message(
            text: "🧠 Шаг 2: Анализ страха\n\nПроведите анализ вашего страха:",
            reply_markup: skip_step_markup('analysis')
          )
        when 'step3_planning'
          send_message(
            text: "📝 Шаг 3: Планирование действия\n\nРазбейте ваше действие на микро-шаги:",
            reply_markup: skip_step_markup('planning')
          )
        when 'step4_action'
          send_message(
            text: "🚀 Шаг 4: Действие\n\nКогда будете готовы, сделайте первый микро-шаг:",
            reply_markup: action_completed_markup
          )
        when 'step5_reflection'
          send_message(
            text: "💭 Шаг 5: Рефлексия\n\nОпишите ваш опыт и выводы:",
            reply_markup: skip_reflection_markup
          )
        else
          deliver_exercise
        end
      end
      
      def show_intro_without_state
        send_message(
          text: "🦸‍♂️ *День 20: Преодоление страха* 🦸‍♀️\n\nДавайте начнем!",
          parse_mode: 'Markdown'
        )
        send_message(
          text: "Готовы?",
          reply_markup: day_20_content_markup
        )
      end
      
      # ===== МЕТОДЫ РАЗМЕТКИ =====
      
      def day_20_content_markup
        TelegramMarkupHelper.day_20_content_markup
      end
      
      def fear_categories_markup
        buttons = FEAR_CATEGORIES.map do |key, category|
          {
            text: "#{category[:emoji]} #{category[:name]}",
            callback_data: "day_20_category_#{key}"
          }
        end
        
        {
          inline_keyboard: buttons.each_slice(2).to_a
        }.to_json
      end
      
      def back_to_categories_markup
        {
          inline_keyboard: [
            [
              { text: "⬅️ Выбрать другую категорию", callback_data: 'day_20_back_to_categories' }
            ]
          ]
        }.to_json
      end
      
      def start_planning_markup
        {
          inline_keyboard: [
            [
              { text: "✅ Начать планирование", callback_data: 'day_20_start_planning' }
            ]
          ]
        }.to_json
      end
      
      def skip_step_markup(step_name)
        {
          inline_keyboard: [
            [
              { text: "➡️ Пропустить этот шаг", callback_data: "day_20_skip_#{step_name}" }
            ]
          ]
        }.to_json
      end
      
      def action_completed_markup
        {
          inline_keyboard: [
            [
              { text: "✅ Я сделал(а) первый шаг!", callback_data: 'day_20_action_completed' }
            ],
            [
              { text: "🔄 Нужна помощь с первым шагом", callback_data: 'day_20_need_help' }
            ]
          ]
        }.to_json
      end
      
      def skip_reflection_markup
        {
          inline_keyboard: [
            [
              { text: "➡️ Пропустить рефлексию", callback_data: 'day_20_skip_reflection' }
            ]
          ]
        }.to_json
      end
      
      def day_20_menu_markup
  {
    inline_keyboard: [
      [
        { text: "💡 Советы", callback_data: 'view_fear_tips' },
      ],
      [
        { text: "🎯 Новое задание", callback_data: 'start_day_20_exercise' }
      ],
      [
        { text: "🏠 Главное меню", callback_data: 'back_to_main_menu' },
        { text: "➡️ Следующий день", callback_data: 'start_day_21_from_proposal' }
      ]
    ]
  }.to_json
end
      
      private
      
      def statistics_message
        <<~MARKDOWN
          📊 *Научные данные о преодолении страхов:*
          
          • 🧠 **30-40%** — снижение реакции страха после 6-8 экспозиций
          • 💪 **50-60%** — повышение уверенности в себе через 2-4 недели практики
          • 😌 **40-50%** — снижение общей тревожности
          • 🔄 **4-6 недель** — время для формирования новых нейронных путей
          • 🎯 **70-80%** — людей замечают улучшения уже после первого успешного шага
          • 📈 **25-35%** — улучшение качества жизни и социальных связей
          
          *Источник: Исследования Journal of Anxiety Disorders, Behaviour Research and Therapy*
        MARKDOWN
      end
      
      def propose_next_day_with_restriction
  next_day = 21
  
  # Проверяем, можно ли начать следующий день
  can_start_result = @user.can_start_day?(next_day)
  
  if can_start_result == true
    message = <<~MARKDOWN
      🎯 **Следующий шаг: День #{next_day}**
      
      ✅ *Доступен сейчас!*
      
      **Что вас ждет:**
      • 📊 Рефлексия 3 недель практики
      • 🧠 Анализ вашего прогресса
      • 💪 Обзор освоенных техник
      • 🎯 Планирование следующих шагов
      
      Вы можете начать следующий день прямо сейчас.
    MARKDOWN
    
    button_text = "📊 Начать День #{next_day}"
    callback_data = "start_day_#{next_day}_from_proposal"
  else
    error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
    
    message = <<~MARKDOWN
      🎯 **Следующий шаг: День #{next_day}**
      
      ⏱️ *Ограничение:* #{error_message}
      
      **Пока ждете, можете:**
      • 🦸 Практиковать преодоление страхов с другими действиями
      • 📚 Ведение дневника маленьких побед
      • 💡 Экспериментировать с техниками микро-шагов
      • 🎭 Работать с разными категориями страхов
      • 📊 Посмотреть статистику (/progress)
      
      *Следующий день будет автоматически доступен, когда пройдет достаточно времени.*
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
    }.to_json
  )
end
      
      def should_deliver_exercise_immediately?
        false
      end
      
      def log_info(message)
        Rails.logger.info "[Day20Service] #{message} - User: #{@user.telegram_id}"
      end
      
      def log_warn(message)
        Rails.logger.warn "[Day20Service] #{message} - User: #{@user.telegram_id}"
      end
      
      def log_error(message, error = nil)
        Rails.logger.error "[Day20Service] #{message} - User: #{@user.telegram_id}"
        Rails.logger.error error.message if error
      end
    end
  end
end
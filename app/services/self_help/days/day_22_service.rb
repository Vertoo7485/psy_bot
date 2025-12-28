# app/services/self_help/days/day22_service.rb

module SelfHelp
  module Days
    class Day22Service < DayBaseService
      include TelegramMarkupHelper
      
      DAY_NUMBER = 22
      
      # Шаги формирования SMART цели
      SMART_STEPS = {
        'intro' => {
          title: "🎯 **День 22: Планирование будущего с SMART целями** 🎯",
          instruction: "Сегодня мы перейдем от рефлексии к действию. Вы научитесь ставить **SMART-цели** — метод, который используют успешные люди по всему миру.\n\n**Что такое SMART?** Это аббревиатура, где каждая буква означает критерий качественной цели:\n\n🔹 **S** - Specific (Конкретная)\n🔹 **M** - Measurable (Измеримая)\n🔹 **A** - Achievable (Достижимая)\n🔹 **R** - Relevant (Актуальная)\n🔹 **T** - Time-bound (Ограниченная по времени)\n\n**Преимущества SMART-подхода:**\n• Повышает вероятность достижения на 75%\n• Делает прогресс отслеживаемым\n• Предотвращает разочарование\n• Создает четкий план действий"
        },
        'choose_domain' => {
          title: "**Шаг 1: Выберите сферу жизни**",
          instruction: "В какой сфере жизни вы хотите поставить цель?\n\n📈 **Карьера и развитие**\n❤️ **Здоровье и самочувствие**\n🤝 **Отношения и общение**\n💰 **Финансы и достаток**\n🎨 **Хобби и творчество**\n🧠 **Личностный рост**\n🏡 **Дом и быт**\n\n**Напишите, в какой сфере хотите достичь цели:**"
        },
        'specific' => {
          title: "🔹 **S - Конкретная**",
          instruction: "**Сформулируйте цель максимально конкретно.**\n\n❌ *Плохо:* 'Хочу стать здоровее'\n✅ *Хорошо:* 'Хочу начать бегать 3 раза в неделю'\n\n**Вопросы для помощи:**\n• Что именно я хочу достичь?\n• Где это будет происходить?\n• Когда я буду это делать?\n• С кем я буду это делать?\n• Какие ресурсы мне понадобятся?\n\n**Сформулируйте конкретную цель:**"
        },
        'measurable' => {
          title: "📊 **M - Измеримая**",
          instruction: "**Как вы будете измерять прогресс?**\n\n❌ *Плохо:* 'Хочу больше читать'\n✅ *Хорошо:* 'Хочу читать 20 страниц в день'\n\n**Критерии измеримости:**\n• Количественные показатели\n• Проценты\n• Частота\n• Время\n• Деньги\n\n**Как вы будете измерять прогресс к вашей цели?**"
        },
        'achievable' => {
          title: "💪 **A - Достижимая**",
          instruction: "**Реалистична ли ваша цель?**\n\n❌ *Плохо:* 'С завтрашнего дня буду бегать марафон'\n✅ *Хорошо:* 'Начну с 10 минут бега и буду увеличивать время'\n\n**Проверка достижимости:**\n• Есть ли у вас необходимые ресурсы?\n• Есть ли у вас необходимые навыки?\n• Реально ли это при вашем образе жизни?\n• Что может помешать и как это преодолеть?\n\n**Опишите, почему ваша цель достижима:**"
        },
        'relevant' => {
          title: "❤️ **R - Актуальная**",
          instruction: "**Насколько цель важна для вас?**\n\n❌ *Плохо:* 'Надо, потому что модно'\n✅ *Хорошо:* 'Это поможет мне чувствовать себя энергичнее и продуктивнее'\n\n**Вопросы для проверки актуальности:**\n• Соответствует ли цель моим ценностям?\n• Поможет ли это мне стать тем, кем я хочу быть?\n• Согласуется ли это с другими моими целями?\n• Правильное ли сейчас время для этой цели?\n\n**Почему эта цель важна именно для вас?**"
        },
        'time_bound' => {
          title: "⏰ **T - Ограниченная по времени**",
          instruction: "**Установите четкие сроки.**\n\n❌ *Плохо:* 'Когда-нибудь'\n✅ *Хорошо:* 'К 1 июня следующего года'\n\n**Типы сроков:**\n🎯 **Крайний срок:** 'До 31 декабря'\n📅 **Промежуточные этапы:** 'Через месяц, через три месяца'\n🔄 **Регулярность:** 'Каждый день, раз в неделю'\n\n**Установите сроки для своей цели:**"
        },
        'summary' => {
          title: "📝 **Итог: Ваша SMART-цель**",
          instruction: "**Давайте соберем все вместе.**\n\nВаша цель должна выглядеть так:\n\n🎯 *Пример:* 'Я буду бегать 3 раза в неделю по 30 минут в парке возле дома, чтобы улучшить выносливость и здоровье. Начну с 10 минут и буду увеличивать время. Цель важна для моего долголетия. Достигну регулярных пробежек к 1 марта.'"
        }
      }.freeze
      
      # Примеры SMART-целей для вдохновения
      SMART_EXAMPLES = [
        {
          domain: "Здоровье",
          goal: "Я буду заниматься йогой 3 раза в неделю по 30 минут дома с приложением Down Dog, чтобы уменьшить боли в спине. Начну с 15 минут и буду увеличивать. Это важно для моего комфорта. Достигну регулярных занятий к 15 февраля."
        },
        {
          domain: "Карьера",
          goal: "Я пройду курс по веб-разработке на Coursera за 3 месяца, уделяя 5 часов в неделю, чтобы сменить профессию. Это достижимо благодаря гибкому графику. Цель соответствует моему желанию работать в IT. Завершу курс к 30 апреля."
        },
        {
          domain: "Финансы",
          goal: "Я отложу 50 000 рублей за 6 месяцев, откладывая по 8 333 рубля в месяц. Это реалистично при моей зарплате. Цель важна для финансовой подушки. Достигну суммы к 1 июля."
        }
      ].freeze
      
      # Категории сфер жизни
      LIFE_DOMAINS = [
        { emoji: "📈", name: "Карьера и развитие", key: "career" },
        { emoji: "❤️", name: "Здоровье и самочувствие", key: "health" },
        { emoji: "🤝", name: "Отношения и общение", key: "relationships" },
        { emoji: "💰", name: "Финансы и достаток", key: "finance" },
        { emoji: "🎨", name: "Хобби и творчество", key: "hobby" },
        { emoji: "🧠", name: "Личностный рост", key: "personal_growth" },
        { emoji: "🏡", name: "Дом и быт", key: "home" }
      ].freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        message_text = <<~MARKDOWN
          🎯 *День 22: Планирование будущего* 🎯

          **От рефлексии к действию!**

          Вы проделали огромную работу по осознанию своих изменений. Теперь настало время направить эту энергию в будущее.

          **Сегодня вы научитесь:**
          ✅ Ставить цели, которые действительно достигаются
          ✅ Использовать научно доказанный метод SMART
          ✅ Создавать четкие планы действий
          ✅ Избегать разочарования от нереалистичных ожиданий

          **Факт:** Люди, которые записывают свои цели, достигают их на 42% чаще.

          **Научная основа:** Метод SMART был разработан в 1981 году и с тех пор используется в бизнесе, спорте и личном развитии по всему миру.
        MARKDOWN
        
        send_message(text: message_text, parse_mode: 'Markdown')
        
        # Показываем пример SMART-цели
        example = SMART_EXAMPLES.sample
        example_text = <<~MARKDOWN
          **📋 Пример SMART-цели:**

          *Сфера:* #{example[:domain]}
          *Цель:* #{example[:goal]}

          **Обратите внимание на:**
          🔹 Конкретное действие
          🔹 Измеримые показатели
          🔹 Реалистичные сроки
          🔹 Ясную пользу для вас
        MARKDOWN
        
        send_message(text: example_text, parse_mode: 'Markdown')
        
        # Сохраняем состояние
        store_day_data('current_goal_index', 0)  # Начинаем с первой цели
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        
        # Предлагаем начать
        send_message(
          text: "Готовы создать свою первую SMART-цель?",
          reply_markup: day_22_start_markup
        )
      end
      
      def deliver_exercise
  @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
  
  # Инициализируем структуру для целей
  unless get_day_data('goals')
    store_day_data('goals', [])
    store_day_data('current_goal', {})
    store_day_data('current_step', 'choose_domain')  # ← сразу начинаем с выбора сферы
  end
  
  exercise_text = <<~MARKDOWN
    🎯 *Упражнение: Формулирование SMART-целей* 🎯

    **Мы создадим 1-3 цели, которые действительно будут работать.**

    **Процесс:**
    1. Выберите сферу жизни
    2. Пройдете все 5 шагов SMART для каждой цели
    3. Получите готовую формулировку
    4. Проверите реалистичность

    **Рекомендация:** Начните с одной, самой важной цели. После успеха можно добавить еще.

    **Важно:** Отвечайте максимально честно и конкретно. Чем детальнее цель, тем выше шансы на успех.
  MARKDOWN
  
  send_message(text: exercise_text, parse_mode: 'Markdown')
  
  # Начинаем процесс - сразу с выбора сферы
  start_smart_step('choose_domain')
end
      
      # Обработка ввода пользователя
      # app/services/self_help/days/day_22_service.rb

def handle_text_input(input_text)
  current_step = get_day_data('current_step')
  
  log_info("Handling text input for step: #{current_step}, text: #{input_text.truncate(50)}")
  
  case current_step
  when 'intro'
    # Для шага intro просто переходим к следующему шагу
    handle_intro_input(input_text)
  when 'choose_domain'
    handle_domain_selection(input_text)
  when 'specific'
    handle_specific_input(input_text)
  when 'measurable'
    handle_measurable_input(input_text)
  when 'achievable'
    handle_achievable_input(input_text)
  when 'relevant'
    handle_relevant_input(input_text)
  when 'time_bound'
    handle_time_bound_input(input_text)
  when 'summary'
    handle_summary_input(input_text)
  else
    log_warn("Unknown step for text input: #{current_step}")
    # Пробуем начать с первого шага
    start_smart_step('choose_domain')
    false
  end
end

# Добавить новый метод для обработки intro
def handle_intro_input(input_text)
  # Пользователь что-то написал на шаге intro
  # Просто переходим к выбору сферы
  start_smart_step('choose_domain')
  true
end
      
      # Завершение упражнения
      # app/services/self_help/days/day_22_service.rb

def complete_exercise
  goals = get_day_data('goals') || []
  
  if goals.empty?
    send_message(text: "⚠️ У вас нет сохраненных целей. Хотите создать хотя бы одну?")
    start_smart_step('choose_domain')
    return
  end
  
  # Сохраняем финальные цели
  store_day_data('final_goals', goals)
  
  @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
  
  # Отправляем сводку
  show_goals_summary(goals)
  
  # Предлагаем следующие шаги
  send_message(
    text: "🎉 Отлично! Ваши SMART-цели сохранены.",
    reply_markup: day_22_completion_markup
  )
  
  # ВАЖНО: Добавить предложение следующего дня
  propose_next_day
  
  true
end
      
      # Показать сохраненные цели
      def show_goals_summary(goals = nil)
        goals ||= get_day_data('goals') || []
        
        if goals.empty?
          send_message(text: "У вас пока нет сохраненных целей.")
          return
        end
        
        message = "📋 *Ваши SMART-цели:*\n\n"
        
        goals.each_with_index do |goal, index|
          message += "**Цель #{index + 1}:** #{goal['domain']}\n"
          message += "🎯 **Конкретная:** #{goal['specific']}\n"
          message += "📊 **Измеримая:** #{goal['measurable']}\n"
          message += "💪 **Достижимая:** #{goal['achievable']}\n"
          message += "❤️ **Актуальная:** #{goal['relevant']}\n"
          message += "⏰ **Сроки:** #{goal['time_bound']}\n\n"
          
          # Полная формулировка
          full_goal = format_full_goal(goal)
          message += "📝 **Полная формулировка:** #{full_goal}\n\n"
          message += "─" * 30 + "\n\n"
        end
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      # Добавить еще одну цель
      def add_another_goal
        current_goal_count = (get_day_data('goals') || []).size
        
        if current_goal_count >= 3
          send_message(text: "У вас уже 3 цели. Рекомендуется сосредоточиться на их достижении.")
          show_goals_summary
          return
        end
        
        # Начинаем новую цель
        store_day_data('current_goal', {})
        store_day_data('current_step', 'choose_domain')
        
        send_message(text: "Отлично! Создадим еще одну цель.")
        start_smart_step('choose_domain')
      end
      
      # Редактировать существующую цель
      def edit_goal(goal_index)
        goals = get_day_data('goals') || []
        
        if goal_index >= goals.size
          send_message(text: "Цель с таким номером не найдена.")
          return
        end
        
        # Загружаем цель для редактирования
        store_day_data('current_goal', goals[goal_index])
        store_day_data('editing_goal_index', goal_index)
        store_day_data('current_step', 'specific')  # Начинаем с первого шага
        
        send_message(text: "Редактируем цель #{goal_index + 1}.")
        start_smart_step('specific')
      end
      
      # ===== ОБРАБОТКА КНОПОК =====
      
      # app/services/self_help/days/day_22_service.rb

def handle_button(callback_data)
  case callback_data
  when 'start_day_22_exercise'
    deliver_exercise
    
  when 'day_22_add_goal'
    add_another_goal
    
  when 'day_22_show_goals'
    show_goals_summary
    
  when 'day_22_complete_exercise'
    complete_exercise
    
  # ВАЖНО: Добавить обработку кнопок доменов!
  when /^day_22_domain_(.+)$/
    domain_key = $1
    handle_domain_button(domain_key)
    
  when 'day_22_edit_goal_1', 'day_22_edit_goal_2', 'day_22_edit_goal_3'
    goal_index = callback_data.split('_').last.to_i - 1
    edit_goal(goal_index)
    
  when 'day_22_restart_goal'
    store_day_data('current_step', 'choose_domain')
    start_smart_step('choose_domain')
    
  when 'day_22_show_examples'
    show_smart_examples
    
  when 'day_22_save_and_continue'
    save_current_goal_and_continue
    
  else
    log_warn("Unknown button callback: #{callback_data}")
    send_message(text: "Неизвестная команда. Пожалуйста, используйте кнопки меню.")
  end
end

# Добавить новый метод для обработки кнопок доменов
def handle_domain_button(domain_key)
  log_info("Handling domain button: #{domain_key}")
  
  # Находим домен по ключу
  domain = LIFE_DOMAINS.find { |d| d[:key] == domain_key }
  
  if domain
    # Сохраняем выбранный домен
    current_goal = get_day_data('current_goal') || {}
    current_goal['domain'] = "#{domain[:emoji]} #{domain[:name]}"
    store_day_data('current_goal', current_goal)
    
    # Переходим к следующему шагу
    start_smart_step('specific')
  else
    log_warn("Domain not found for key: #{domain_key}")
    send_message(text: "Неизвестная сфера. Пожалуйста, выберите из списка или напишите свою.")
  end
end
      
      # ===== МЕТОДЫ РАЗМЕТКИ =====
      
      def day_22_start_markup
        {
          inline_keyboard: [
            [
              { text: "🎯 Начать создание целей", callback_data: 'start_day_22_exercise' },
              { text: "📋 Примеры целей", callback_data: 'day_22_show_examples' }
            ]
          ]
        }.to_json
      end
      
      def day_22_domain_markup
        keyboard = LIFE_DOMAINS.each_slice(2).map do |pair|
          pair.map do |domain|
            { text: "#{domain[:emoji]} #{domain[:name]}", callback_data: "day_22_domain_#{domain[:key]}" }
          end
        end
        
        # Добавляем кнопку "Другое"
        keyboard << [{ text: "✍️ Другое (опишите)", callback_data: "day_22_domain_other" }]
        
        { inline_keyboard: keyboard }.to_json
      end
      
      def day_22_completion_markup
        {
          inline_keyboard: [
            [
              { text: "📋 Посмотреть все цели", callback_data: 'day_22_show_goals' },
              { text: "➕ Добавить еще цель", callback_data: 'day_22_add_goal' }
            ],
            [
              { text: "✏️ Редактировать цель 1", callback_data: 'day_22_edit_goal_1' },
              { text: "✏️ Редактировать цель 2", callback_data: 'day_22_edit_goal_2' },
              { text: "✏️ Редактировать цель 3", callback_data: 'day_22_edit_goal_3' }
            ],
            [
              { text: "✅ Завершить упражнение", callback_data: 'day_22_complete_exercise' }
            ]
          ]
        }.to_json
      end
      
      def day_22_step_navigation_markup
        {
          inline_keyboard: [
            [
              { text: "🔙 Назад", callback_data: 'day_22_previous_step' },
              { text: "⏩ Пропустить", callback_data: 'day_22_skip_step' },
              { text: "🔄 Начать заново", callback_data: 'day_22_restart_goal' }
            ]
          ]
        }.to_json
      end
      
      private
      
      # Начать шаг SMART
      def start_smart_step(step_type)
  store_day_data('current_step', step_type)
  
  step = SMART_STEPS[step_type]
  return unless step
  
  send_message(text: step[:title], parse_mode: 'Markdown')
  send_message(text: step[:instruction])
  
  # Для шага выбора сферы показываем клавиатуру
  if step_type == 'choose_domain'
    send_message(
      text: "Выберите из списка или напишите свою:",
      reply_markup: day_22_domain_markup
    )
  end
end
      
      # Обработчики для каждого шага SMART
      
      def handle_domain_selection(input_text)
        current_goal = get_day_data('current_goal') || {}
        current_goal['domain'] = input_text.strip
        store_day_data('current_goal', current_goal)
        
        # Переходим к следующему шагу
        start_smart_step('specific')
      end
      
      def handle_specific_input(input_text)
        current_goal = get_day_data('current_goal') || {}
        current_goal['specific'] = input_text.strip
        
        # Проверяем конкретность
        if input_text.split.size < 5
          send_message(text: "⚠️ Попробуйте сделать цель более конкретной. Добавьте деталей: где, когда, с кем?")
          return false
        end
        
        store_day_data('current_goal', current_goal)
        start_smart_step('measurable')
        true
      end
      
      def handle_measurable_input(input_text)
        current_goal = get_day_data('current_goal') || {}
        current_goal['measurable'] = input_text.strip
        
        # Проверяем измеримость
        measurable_words = ['раз', 'минут', 'часов', 'дней', 'процент', 'рублей', 'долларов', 'евро', 'кг', 'км', 'страниц', 'раз в']
        unless measurable_words.any? { |word| input_text.downcase.include?(word) }
          send_message(text: "⚠️ Добавьте измеримые показатели: количество, время, деньги, проценты и т.д.")
          return false
        end
        
        store_day_data('current_goal', current_goal)
        start_smart_step('achievable')
        true
      end
      
      def handle_achievable_input(input_text)
        current_goal = get_day_data('current_goal') || {}
        current_goal['achievable'] = input_text.strip
        
        # Проверяем на наличие сомнений
        doubt_words = ['не знаю', 'сомневаюсь', 'наверное', 'возможно', 'может быть']
        if doubt_words.any? { |word| input_text.downcase.include?(word) }
          send_message(text: "⚠️ Похоже, у вас есть сомнения. Может, сделать цель менее амбициозной или разбить на этапы?")
          # Не переходим дальше, просим переформулировать
          return false
        end
        
        store_day_data('current_goal', current_goal)
        start_smart_step('relevant')
        true
      end
      
      def handle_relevant_input(input_text)
        current_goal = get_day_data('current_goal') || {}
        current_goal['relevant'] = input_text.strip
        
        # Проверяем на наличие смысла
        if input_text.split.size < 3
          send_message(text: "⚠️ Опишите подробнее, почему это важно для вас. Как это изменит вашу жизнь?")
          return false
        end
        
        store_day_data('current_goal', current_goal)
        start_smart_step('time_bound')
        true
      end
      
      def handle_time_bound_input(input_text)
        current_goal = get_day_data('current_goal') || {}
        current_goal['time_bound'] = input_text.strip
        
        # Проверяем наличие сроков
        time_words = ['до', 'через', 'месяц', 'год', 'неделя', 'день', 'число', 'январ', 'феврал', 'март', 'апрел', 'май', 'июн', 'июл', 'август', 'сентябр', 'октябр', 'ноябр', 'декабр']
        unless time_words.any? { |word| input_text.downcase.include?(word) }
          send_message(text: "⚠️ Добавьте конкретные сроки: 'до 1 марта', 'через 3 месяца', 'каждый день' и т.д.")
          return false
        end
        
        store_day_data('current_goal', current_goal)
        start_smart_step('summary')
        true
      end
      
      def handle_summary_input(input_text)
        # Получаем текущую цель
        current_goal = get_day_data('current_goal') || {}
        
        # Формируем полную цель
        full_goal = format_full_goal(current_goal)
        current_goal['full_goal'] = full_goal
        
        # Сохраняем в список целей
        goals = get_day_data('goals') || []
        
        # Если редактируем существующую цель
        editing_index = get_day_data('editing_goal_index')
        if editing_index
          goals[editing_index] = current_goal
          store_day_data('editing_goal_index', nil)
          message = "✅ Цель обновлена!"
        else
          goals << current_goal
          message = "✅ Цель сохранена!"
        end
        
        store_day_data('goals', goals)
        store_day_data('current_goal', {})  # Очищаем для следующей цели
        
        # Показываем результат
        send_message(text: message)
        send_message(text: "📝 **Ваша SMART-цель:**\n\n#{full_goal}", parse_mode: 'Markdown')
        
        # Спрашиваем, что дальше
        goals_count = goals.size
        if goals_count < 3
          send_message(
            text: "У вас #{goals_count} цель(ей). Хотите добавить еще? (Максимум 3)",
            reply_markup: {
              inline_keyboard: [
                [
                  { text: "➕ Добавить еще цель", callback_data: 'day_22_add_goal' },
                  { text: "✅ Завершить", callback_data: 'day_22_complete_exercise' }
                ]
              ]
            }.to_json
          )
        else
          send_message(text: "У вас максимальное количество целей (3). Рекомендуется сосредоточиться на них.")
          complete_exercise
        end
      end
      
      # Форматирование полной цели
      def format_full_goal(goal)
        "Я #{goal['specific']}. Буду измерять прогресс так: #{goal['measurable']}. " \
        "Это достижимо, потому что #{goal['achievable']}. " \
        "Цель важна для меня, так как #{goal['relevant']}. " \
        "Сроки: #{goal['time_bound']}."
      end
      
      # Показать примеры SMART-целей
      def show_smart_examples
        message = "📚 *Примеры SMART-целей для вдохновения:*\n\n"
        
        SMART_EXAMPLES.each_with_index do |example, index|
          message += "**Пример #{index + 1}:** #{example[:domain]}\n"
          message += "🎯 #{example[:goal]}\n\n"
        end
        
        message += "**Обратите внимание на структуру:**\n"
        message += "1. Начинается с 'Я буду...'\n"
        message += "2. Содержит все элементы SMART\n"
        message += "3. Звучит уверенно и реалистично\n"
        message += "4. Имеет четкие сроки\n"
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      # Сохранить текущую цель и продолжить
      def save_current_goal_and_continue
        current_goal = get_day_data('current_goal') || {}
        
        # Проверяем, заполнены ли все поля
        required_fields = ['domain', 'specific', 'measurable', 'achievable', 'relevant', 'time_bound']
        missing_fields = required_fields.select { |field| current_goal[field].blank? }
        
        if missing_fields.any?
          send_message(text: "⚠️ Заполните сначала текущий шаг: #{missing_fields.join(', ')}")
          return
        end
        
        # Сохраняем цель
        goals = get_day_data('goals') || []
        goals << current_goal
        store_day_data('goals', goals)
        store_day_data('current_goal', {})
        
        send_message(text: "✅ Текущая цель сохранена!")
        
        # Предлагаем продолжить
        if goals.size < 3
          start_smart_step('choose_domain')
        else
          complete_exercise
        end
      end
      
      def log_warn(message)
        Rails.logger.warn "[#{self.class}] #{message} - User: #{@user.telegram_id}"
      end
    end
  end
end
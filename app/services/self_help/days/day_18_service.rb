# app/services/self_help/days/day_18_service.rb

module SelfHelp
  module Days
    class Day18Service < DayBaseService
      include TelegramMarkupHelper
      
      DAY_NUMBER = 18
      
      # Категории активностей с описаниями
      ACTIVITY_CATEGORIES = {
        'reading' => {
          title: "📚 Чтение",
          description: "Книги, статьи, блоги",
          examples: ["Почитать любимую книгу", "Исследовать новую тему", "Читать поэзию вслух"]
        },
        'music' => {
          title: "🎵 Музыка",
          description: "Слушать или создавать музыку",
          examples: ["Создать плейлист настроения", "Сыграть на инструменте", "Танцевать под любимые песни"]
        },
        'art' => {
          title: "🎨 Творчество",
          description: "Рисование, рукоделие, дизайн",
          examples: ["Нарисовать картину", "Сделать скетч", "Попробовать новую технику"]
        },
        'sports' => {
          title: "🏃 Спорт и движение",
          description: "Физическая активность",
          examples: ["Прогулка на свежем воздухе", "Йога или растяжка", "Танцевальная тренировка"]
        },
        'nature' => {
          title: "🌳 Природа",
          description: "Связь с природой",
          examples: ["Прогулка в парке", "Уход за растениями", "Наблюдение за птицами"]
        },
        'cooking' => {
          title: "🍳 Кулинария",
          description: "Готовка и выпечка",
          examples: ["Приготовить новое блюдо", "Испечь печенье", "Сделать смузи"]
        },
        'games' => {
          title: "🎮 Игры",
          description: "Настольные, видео, головоломки",
          examples: ["Сыграть в настольную игру", "Разгадать кроссворд", "Попробовать новую видеоигру"]
        },
        'learning' => {
          title: "🧠 Обучение",
          description: "Новые знания и навыки",
          examples: ["Пройти онлайн-курс", "Изучить иностранное слово", "Посмотреть документальный фильм"]
        },
        'social' => {
          title: "👥 Общение",
          description: "Взаимодействие с людьми",
          examples: ["Позвонить другу", "Устроить видеочат", "Написать письмо"]
        },
        'relaxation' => {
          title: "🧘‍♀️ Релаксация",
          description: "Отдых и восстановление",
          examples: ["Принять ванну", "Послушать медитацию", "Полежать с закрытыми глазами"]
        },
        'other' => {
          title: "✨ Другое",
          description: "Ваши уникальные интересы",
          examples: ["Придумать свое занятие"]
        }
      }.freeze
      
      # Шкала чувств
      FEELINGS_SCALE = {
        1 => "😔 Очень плохо",
        2 => "🙁 Плохо",
        3 => "😐 Нейтрально",
        4 => "🙂 Хорошо",
        5 => "😊 Отлично"
      }.freeze
      
      # ===== ОСНОВНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        message_text = <<~MARKDOWN
          🌟 *День 18: Время для себя и своих интересов* 🌟

          *Зачем это нужно?*

          Исследования показывают, что регулярное занятие любимыми делами:
          🧠 Снижает стресс на 45%
          ❤️ Повышает уровень счастья
          💪 Укрепляет психическое здоровье
          🌱 Развивает креативность и мотивацию

          *Сегодня мы:*
          1. Вспомним, что приносит вам радость
          2. Выберем конкретную активность
          3. Запланируем время для нее
          4. Отразим на полученных эмоциях

          *«Удовольствие — это не роскошь, а психологическая необходимость.»*
        MARKDOWN
        
        send_message(text: message_text, parse_mode: 'Markdown')
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        
        send_message(
          text: "Готовы вспомнить, что приносит вам радость?",
          reply_markup: day_18_start_exercise_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        clear_day_data
        
        exercise_text = <<~MARKDOWN
          🎯 *Упражнение: Карта удовольствий* 🎯

          Инструкция:

          1. *Вспомните* - что вам нравилось делать в детстве?
          2. *Обнаружьте* - какие занятия заставляют вас забыть о времени?
          3. *Мечтайте* - чем бы вы занялись, если бы у вас было свободное время?

          Не думайте о продуктивности. Думайте о радости!
        MARKDOWN
        
        send_message(text: exercise_text, parse_mode: 'Markdown')
        
        # Начинаем первый шаг
        start_activity_planning
      end
      
      def start_activity_planning
        @user.set_self_help_step("day_#{DAY_NUMBER}_planning_activity")
        
        message = <<~MARKDOWN
          📝 *Шаг 1: Как вы себя чувствуете сейчас?*

          По шкале от 1 до 5 оцените ваше текущее настроение:
          
          1. 😔 Очень плохо
          2. 🙁 Плохо  
          3. 😐 Нейтрально
          4. 🙂 Хорошо
          5. 😊 Отлично

          *Это поможет отследить влияние активности на ваше настроение.*
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Выберите цифру, соответствующую вашему настроению:",
          reply_markup: feelings_scale_markup('before')
        )
      end
      
      def handle_feelings_input(scale, feelings_type)
  store_day_data("feelings_#{feelings_type}", scale)
  
  if feelings_type == 'before'
    show_activity_categories
  else
    # После оценки настроения - запрашиваем текстовую рефлексию
    store_day_data('current_step', 'reflection')
    
    message = <<~MARKDOWN
      ✨ *Отлично! Ваше настроение после активности: #{scale}/5*

      💭 *Поделитесь вашими мыслями и ощущениями*

      Что вы почувствовали во время активности?
      Что было приятного или интересного?
      Хотели бы вы повторить эту активность?

      *Поделитесь вашими впечатлениями:*
    MARKDOWN
    
    send_message(text: message, parse_mode: 'Markdown')
    
    # БЕЗ КНОПКИ ПРОПУСТИТЬ - только текстовый ввод
    send_message(text: "Напишите несколько слов о вашем опыте:")
  end
end
      
      def show_activity_categories
        store_day_data('current_step', 'choosing_category')
        
        message = <<~MARKDOWN
          🎨 *Шаг 2: Выберите категорию активности*

          Какая сфера интересов вас привлекает сегодня?

          *Необязательно выбирать самое продуктивное занятие. Выбирайте то, что принесет радость!*
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Выберите категорию:",
          reply_markup: activity_categories_markup
        )
      end
      
      def handle_category_selection(category)
  store_day_data('activity_category', category)
  store_day_data('current_step', 'planning_details')
  
  category_info = ACTIVITY_CATEGORIES[category]
  
  message = <<~MARKDOWN
    #{category_info[:title]} *– #{category_info[:description]}*

    *Примеры:*
    #{category_info[:examples].map { |ex| "• #{ex}" }.join("\n")}

    📝 *Шаг 3: Спланируйте вашу активность*

    *Что именно* вы хотите сделать?
    *Например*: "Прочитать главу книги" или "Пройтись 30 минут в парке"

    Чем конкретнее план, тем легче его выполнить!
  MARKDOWN
  
  send_message(text: message, parse_mode: 'Markdown')
  
  # БЕЗ КНОПКИ ПРОПУСТИТЬ - только текстовый ввод
  send_message(text: "Напишите, чем именно вы планируете заняться:")
end
      
 def handle_activity_plan_input(activity_text)
  log_info("Handling activity plan input: #{activity_text}")
  
  # Сохраняем данные
  store_day_data('activity_plan', activity_text)
  store_day_data('current_step', 'planning_time')
  
  # ВАЖНО: Обновляем состояние пользователя
  @user.set_self_help_step("day_#{DAY_NUMBER}_planning_time")
  
  message = <<~MARKDOWN
    ✅ *План сохранен!*

    *"#{activity_text.truncate(50)}"*

    📅 *Шаг 4: Когда вы этим займетесь?*

    Исследования показывают:
    • Конкретное время повышает вероятность выполнения на 70%
    • Даже 15 минут достаточно для положительного эффекта
    • Лучше короткая, но регулярная активность

    *Когда у вас есть время для этой активности?*
  MARKDOWN
  
  send_message(text: message, parse_mode: 'Markdown')
  
  # Отправляем запрос на ввод времени
  send_message(text: "Напишите, когда планируете заняться этим (например: 'сегодня вечером', 'завтра утром', 'после работы'):")
  
  log_info("Activity plan saved, state updated to: day_#{DAY_NUMBER}_planning_time")
end
      
  def handle_time_plan_input(time_text)
  log_info("Handling time plan input: #{time_text}")
  
  # Сохраняем данные
  store_day_data('planned_time', time_text)
  
  # ВАЖНО: Обновляем состояние пользователя
  @user.set_self_help_step("day_#{DAY_NUMBER}_activity_planned")
  
  log_info("Time plan saved, state updated to: day_#{DAY_NUMBER}_activity_planned")
  
  # Показываем сводку
  show_activity_summary
end
      
  def show_activity_summary
  category = get_day_data('activity_category')
  activity_plan = get_day_data('activity_plan')
  planned_time = get_day_data('planned_time')
  feelings_before = get_day_data('feelings_before')
  
  category_info = ACTIVITY_CATEGORIES[category]
  
  message = <<~MARKDOWN
    📋 *Ваш план удовольствия* 📋

    #{category_info[:title]}
    
    *Что делать:* #{activity_plan}
    *Когда:* #{planned_time}
    *Настроение до:* #{FEELINGS_SCALE[feelings_before.to_i] || feelings_before}

    ⏰ *Совет:* Установите напоминание на телефоне!

    💡 *Помните:* 
    • Нет "неправильного" способа отдыхать
    • Вы заслуживаете это время для себя
    • Даже маленькие радости имеют значение
  MARKDOWN
  
  send_message(text: message, parse_mode: 'Markdown')
  
  # ВАЖНО: Обновляем состояние
  @user.set_self_help_step("day_#{DAY_NUMBER}_activity_summary_shown")
  
  send_message(
    text: "Готовы сохранить план и приступить к выполнению?",
    reply_markup: activity_plan_confirmation_markup
  )
end

def activity_plan_confirmation_markup
  {
    inline_keyboard: [
      [
        { text: "✅ Сохранить план", callback_data: 'day_18_save_activity' },
        { text: "🔄 Изменить план", callback_data: 'day_18_change_plan' }
      ]
    ]
  }.to_json
end
      
      def save_activity_plan
        begin
          PleasureActivity.create!(
            user: @user,
            title: get_day_data('activity_plan') || "Время для себя",
            description: "Активность дня 18: #{ACTIVITY_CATEGORIES.dig(get_day_data('activity_category'), :title)}",
            activity_type: get_day_data('activity_category'),
            feelings_before: get_day_data('feelings_before'),
            completed: false
          )
          
          log_info("Pleasure activity plan saved successfully")
          
        rescue => e
          log_error("Failed to save pleasure activity plan", e)
        end
      end
      
      def mark_activity_completed
        # Находим последнюю активность пользователя
        activity = @user.pleasure_activities.where(completed: false).last
        
        if activity
          activity.update(
            completed: true,
            completed_at: Time.current,
            feelings_after: get_day_data('feelings_after')
          )
          
          log_info("Pleasure activity marked as completed")
          return activity
        end
        
        nil
      end
      
      def show_activity_reflection
  message = <<~MARKDOWN
    ✨ *Отлично! Вы уделили время себе!* ✨

    Теперь давайте оценим, как изменилось ваше настроение после активности.

    💡 *Почему это важно:*
    • Помогает заметить положительный эффект
    • Укрепляет связь между активностью и улучшением настроения
    • Дает мотивацию для повторения

    *Как вы себя чувствуете сейчас?*
  MARKDOWN
  
  send_message(text: message, parse_mode: 'Markdown')
  
  send_message(
    text: "Оцените ваше настроение по шкале от 1 до 5:",
    reply_markup: feelings_scale_markup('after')
  )
end
      
      def handle_reflection_input(text)
        store_day_data('reflection_text', text)
        
        # Отмечаем активность как выполненную
        activity = mark_activity_completed
        
        if activity && activity.feelings_before && activity.feelings_after
          mood_change = activity.mood_improvement
          
          message = <<~MARKDOWN
            📊 *Ваш результат:*

            Настроение до: #{activity.feelings_before}/5 #{FEELINGS_SCALE[activity.feelings_before]}
            Настроение после: #{activity.feelings_after}/5 #{FEELINGS_SCALE[activity.feelings_after]}
            
            #{mood_change > 0 ? "✅ Настроение улучшилось на #{mood_change} баллов!" : "📈 Зафиксировали ваше состояние"}

            💭 *Ваши мысли:*
            #{text}

            *Исследования подтверждают:* Даже короткие перерывы на приятные занятия значительно улучшают эмоциональное состояние!
          MARKDOWN
        else
          message = <<~MARKDOWN
            ✅ *Активность завершена!*

            💭 *Ваши мысли:*
            #{text}

            *Поздравляю!* Вы уделили время тому, что действительно важно - себе и своим интересам.
          MARKDOWN
        end
        
        send_message(text: message, parse_mode: 'Markdown')
        
        complete_exercise
      end
      
      def complete_exercise
        save_activity_plan unless get_day_data('activity_saved')
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
        
        message = <<~MARKDOWN
          🎉 *День 18 завершен!* 🎉

          *Что вы сделали сегодня:*
          ✅ Признали важность времени для себя
          ✅ Выбрали активность, приносящую радость
          ✅ Создали конкретный план
          ✅ Уделили время своим интересам
          ✅ Отразили на эффекте

          *Как продолжать практику:*
          📅 Добавляйте по одной "активности удовольствия" в день
          💖 Разрешите себе заниматься этим без чувства вины
          🔄 Экспериментируйте с разными видами активностей
          📊 Отслеживайте, что приносит больше всего радости

          *«Радость — не в том, чтобы делать что-то особенное, а в том, чтобы особым образом относиться к тому, что делаешь.»*
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        # Показываем меню для работы с активностями
        show_pleasure_activities_menu
        propose_next_day
      end
      
      def show_pleasure_activities_menu
  stats = @user.pleasure_stats
  
  message = <<~MARKDOWN
    🌈 *Меню "Время для себя"* 🌈

    *Ваша статистика:*
    📊 Всего активностей: #{stats[:total]}
    ✅ Выполнено: #{stats[:completed]} (#{stats[:completion_rate]}%)

    Теперь у вас есть инструмент для регулярной заботы о себе через приятные активности!
  MARKDOWN
  
  send_message(text: message, parse_mode: 'Markdown')
  
  send_message(
    text: "Что вы хотите сделать?",
    reply_markup: day_18_menu_markup
  )
end
      
      def show_previous_activities
        activities = @user.pleasure_activities.completed.order(completed_at: :desc).limit(5)
        
        if activities.empty?
          send_message(
            text: "📭 У вас пока нет завершенных активностей.\n\nСоздайте первую активность в упражнении дня 18!",
            reply_markup: day_18_start_exercise_markup
          )
          return
        end
        
        message = "📚 *Ваши активности удовольствия:*\n\n"
        
        activities.each_with_index do |activity, index|
          date = activity.completed_at.strftime('%d.%m.%Y')
          title = activity.title
          type_emoji = activity.type_emoji
          
          message += "#{index + 1}. #{type_emoji} 📅 *#{date}*\n"
          message += "   🎯 #{title.truncate(40)}\n"
          
          if activity.feelings_before && activity.feelings_after
            change = activity.mood_improvement
            if change > 0
              message += "   📈 +#{change} баллов настроения!\n"
            end
          end
          
          message += "\n"
        end
        
        send_message(
          text: message,
          parse_mode: 'Markdown',
          reply_markup: pleasure_activities_markup
        )
      end
      
      def show_activity_ideas
        recommendations = @user.activity_recommendations
        
        message = "💡 *Идеи для ваших следующих активностей:*\n\n"
        
        recommendations.each do |type|
          category = ACTIVITY_CATEGORIES[type]
          next unless category
          
          message += "#{category[:title]} – #{category[:description]}\n"
          message += "*Пример:* #{category[:examples].sample}\n\n"
        end
        
        message += "*Совет:* Выберите то, что вызывает у вас любопытство, а не кажется ."
                send_message(text: message, parse_mode: 'Markdown')
      end
      
      # ===== МЕТОДЫ РАЗМЕТКИ =====
      
      def day_18_start_exercise_markup
        {
          inline_keyboard: [
            [
              { text: "🌈 Начать упражнение", callback_data: 'start_day_18_exercise' }
            ]
          ]
        }.to_json
      end
      
      def feelings_scale_markup(type)
        buttons = (1..5).map do |num|
          emoji = case num
                  when 1 then '😔'
                  when 2 then '🙁'
                  when 3 then '😐'
                  when 4 then '🙂'
                  when 5 then '😊'
                  end
          {
            text: "#{emoji} #{num}",
            callback_data: "day_18_feelings_#{type}_#{num}"
          }
        end
        
        {
          inline_keyboard: [buttons]
        }.to_json
      end
      
      def activity_categories_markup
        # Создаем 2 колонки для кнопок
        categories = ACTIVITY_CATEGORIES.keys
        
        keyboard = categories.each_slice(2).map do |pair|
          pair.map do |category|
            {
              text: ACTIVITY_CATEGORIES[category][:title],
              callback_data: "day_18_category_#{category}"
            }
          end
        end
        
        { inline_keyboard: keyboard }.to_json
      end
      
      def activity_plan_confirmation_markup
        {
          inline_keyboard: [
            [
              { text: "✅ Сохранить и выполнить", callback_data: 'day_18_save_activity' },
              { text: "🔄 Изменить план", callback_data: 'day_18_change_plan' }
            ]
          ]
        }.to_json
      end
      
      def day_18_menu_markup
        {
          inline_keyboard: [
            [
              { text: "📚 Мои активности", callback_data: 'view_pleasure_activities' },
              { text: "💡 Идеи", callback_data: 'view_activity_ideas' }
            ],
            [
              { text: "➕ Новая активность", callback_data: 'start_day_18_exercise' }
            ],
            [
              { text: "🏠 Главное меню", callback_data: 'back_to_main_menu' },
              { text: "➡️ Следующий день", callback_data: 'start_day_19_from_proposal' }
            ]
          ]
        }.to_json
      end
      
      def pleasure_activities_markup
        {
          inline_keyboard: [
            [
              { text: "📊 Статистика", callback_data: 'pleasure_stats' },
              { text: "💡 Новые идеи", callback_data: 'view_activity_ideas' }
            ],
            [
              { text: "➕ Новая активность", callback_data: 'start_day_18_exercise' }
            ],
            [
              { text: "📋 Назад", callback_data: 'back_to_day_18_menu' }
            ]
          ]
        }.to_json
      end
      
      def day_18_exercise_completed_markup
        {
          inline_keyboard: [
            [
              { text: "✅ Завершить упражнение", callback_data: 'day_18_exercise_completed' }
            ]
          ]
        }.to_json
      end
      
      # ===== ОБРАБОТКА КНОПОК =====
      
      def handle_button(callback_data)
        case callback_data
        when /^day_18_feelings_(before|after)_(\d+)$/
          type = $1
          scale = $2.to_i
          handle_feelings_input(scale, type)
          
        when /^day_18_category_(.+)$/
          category = $1
          handle_category_selection(category)
          
        when 'day_18_save_activity'
          store_day_data('activity_saved', true)
          send_message(text: "✅ План сохранен! Приступайте к выполнению, когда будете готовы.")
          send_message(
            text: "Когда завершите активность, нажмите кнопку ниже:",
            reply_markup: activity_completed_markup
          )
          
        when 'day_18_activity_completed'
          show_activity_reflection
          
        when 'day_18_change_plan'
          show_activity_categories
          
        when 'view_pleasure_activities'
          show_previous_activities
          
        when 'view_activity_ideas'
          show_activity_ideas
          
        when 'pleasure_stats'
          show_pleasure_stats
          
        when 'back_to_day_18_menu'
          show_pleasure_activities_menu
        end
      end
      
      def activity_completed_markup
        {
          inline_keyboard: [
            [
              { text: "✅ Я завершил(а) активность", callback_data: 'day_18_activity_completed' }
            ]
          ]
        }.to_json
      end
      
      def show_pleasure_stats
        stats = @user.pleasure_stats
        
        activities = @user.pleasure_activities.completed
        
        # Самые популярные категории
        popular_categories = activities.group(:activity_type).count
        top_category = popular_categories.max_by { |_, count| count }
        
        message = <<~MARKDOWN
          📊 *Статистика ваших активностей:*

          • Всего запланировано: #{stats[:total]}
          • Выполнено: #{stats[:completed]} (#{stats[:completion_rate]}%)
          • Избранных: #{stats[:favorites]}

          #{if top_category && top_category[1] > 0
            "*Самая частая категория:* #{ACTIVITY_CATEGORIES.dig(top_category[0], :title) || top_category[0]} (#{top_category[1]} раз)"
          else
            "*Начните добавлять активности, чтобы увидеть статистику*"
          end}

          💡 *Совет:* Попробуйте разные категории, чтобы найти то, что приносит максимальную радость!
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
      end
    end
  end
end
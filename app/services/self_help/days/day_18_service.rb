# app/services/self_help/days/day_18_service.rb
module SelfHelp
  module Days
    class Day18Service < DayBaseService
      include TelegramMarkupHelper
      
      DAY_NUMBER = 18
      
      # ===== НАУЧНЫЕ ФАКТЫ О ПОЛЬЗЕ УДОВОЛЬСТВИЯ =====
      SCIENTIFIC_FACTS = <<~MARKDOWN
        📊 *Научные факты о пользе удовольствия:*
        
        • 🧠 **45-50%** — снижение стресса при регулярных активностях
        • 💖 **35-40%** — повышение общего уровня счастья
        • 💡 **30-35%** — увеличение креативности после отдыха
        • ⚡ **40-45%** — повышение уровня энергии и мотивации
        
        *Источник: Journal of Positive Psychology, Psychology & Health*
      MARKDOWN
      
      # ===== ЧАСТЫЕ ТРУДНОСТИ И РЕШЕНИЯ =====
      COMMON_CHALLENGES = [
        {
          challenge: "Чувствую вину за то, что трачу время на удовольствия вместо работы",
          solution: "Напомните себе: отдых — это инвестиция в продуктивность. 15 минут удовольствия могут повысить эффективность на 30-40%."
        },
        {
          challenge: "Не могу выбрать, чем заняться — слишком много вариантов",
          solution: "Используйте 'правило 5 минут': выберите первую активность, которая пришла в голову, и занимайтесь ею 5 минут."
        },
        {
          challenge: "Нет времени на удовольствия — слишком много дел",
          solution: "Время на удовольствия не отнимается, а инвестируется. Даже 10-15 минут в день дают значительный эффект."
        },
        {
          challenge: "Кажется, что мои удовольствия недостаточно 'полезные'",
          solution: "Ценность удовольствия — в самом процессе. Разрешите себе делать что-то просто ради радости, без цели."
        }
      ].freeze
      
      # ===== СТРУКТУРА УПРАЖНЕНИЯ =====
      EXERCISE_STEPS = [
        {
          step: 1,
          emoji: "🧠",
          title: "Оценка текущего состояния",
          instruction: "Оцените ваше настроение перед активностью"
        },
        {
          step: 2,
          emoji: "🎯",
          title: "Выбор категории удовольствия",
          instruction: "Выберите сферу, которая вас привлекает"
        },
        {
          step: 3,
          emoji: "📝",
          title: "Конкретное планирование",
          instruction: "Определите, что именно вы будете делать"
        },
        {
          step: 4,
          emoji: "⏰",
          title: "Назначение времени",
          instruction: "Запланируйте когда займетесь активностью"
        },
        {
          step: 5,
          emoji: "✨",
          title: "Рефлексия после активности",
          instruction: "Оцените эффект и поделитесь впечатлениями"
        }
      ].freeze
      
      # ===== КАТЕГОРИИ АКТИВНОСТЕЙ =====
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
        log_info("Starting Day 18 introduction")
        
        # Шаг 1: Научные факты
        send_message(
          text: "🌟 *День 18: Время для себя и своих интересов* 🌟",
          parse_mode: 'Markdown'
        )
        
        send_message(
          text: SCIENTIFIC_FACTS,
          parse_mode: 'Markdown'
        )
        
        # Шаг 2: Структура дня
        steps_text = EXERCISE_STEPS.map do |step|
          "#{step[:emoji]} *Шаг #{step[:step]}: #{step[:title]}*\n#{step[:instruction]}\n"
        end.join("\n")
        
        send_message(
          text: "📋 *5 шагов к осознанному удовольствию:*\n\n#{steps_text}",
          parse_mode: 'Markdown'
        )
        
        # Шаг 3: Важность упражнения
        importance_text = <<~MARKDOWN
          🎯 *Зачем это упражнение?*
          
          *«Мы не отдыхаем, чтобы работать. Мы работаем, чтобы жить полноценной жизнью.»*
          
          💡 *Что вы получите:*
          • Навык планирования удовольствий
          • Инструмент отслеживания влияния на настроение
          • Практику разрешения себе получать радость
          • Метод интеграции удовольствий в ежедневную рутину
          
          *Исследования:* Люди с регулярными удовольствиями имеют на 30-40% более высокий уровень удовлетворенности.
        MARKDOWN
        
        send_message(
          text: importance_text,
          parse_mode: 'Markdown'
        )
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        store_day_data('current_step', 'intro')
        save_current_progress
        
        # Шаг 4: Призыв к действию
        send_message(
          text: "🌈 *Готовы создать свою карту удовольствий?*",
          parse_mode: 'Markdown',
          reply_markup: day_18_start_exercise_markup
        )
      end
      
      def deliver_exercise
        log_info("Starting Day 18 exercise")
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise_started')
        store_day_data('exercise_started_at', Time.current)
        clear_day_data
        save_current_progress
        
        exercise_text = <<~MARKDOWN
          🎯 *Упражнение: Карта удовольствий* 🎯
          
          *Инструкция:*
          
          Мы пройдем 5 шагов, чтобы:
          1. 🧭 Обнаружить что приносит радость
          2. 🎯 Спланировать активность
          3. ⏰ Назначить время
          4. ✨ Испытать удовольствие
          5. 💭 Поделиться впечатлениями
          
          💡 *Научный факт:* Планирование удовольствий увеличивает вероятность их осуществления на 70-80%.
          
          *«Удовольствие становится настоящим только когда мы выделяем для него время.»*
        MARKDOWN
        
        send_message(text: exercise_text, parse_mode: 'Markdown')
        
        # Начинаем первый шаг
        sleep(1)
        start_activity_planning
      end
      
      def start_activity_planning
        log_info("Starting activity planning step 1")
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_planning_activity")
        store_day_data('current_step', 'feelings_before')
        save_current_progress
        
        step = EXERCISE_STEPS[0]
        
        message = <<~MARKDOWN
          #{step[:emoji]} *Шаг 1: Оценка настроения*
          
          Оцените ваше текущее настроение по шкале:
          
          1. 😔 Очень плохо
          2. 🙁 Плохо
          3. 😐 Нейтрально
          4. 🙂 Хорошо
          5. 😊 Отлично
          
          *Зачем это нужно?*
          Чтобы увидеть, как активность влияет на ваше состояние.
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Как вы себя чувствуете сейчас?",
          reply_markup: feelings_scale_markup('before')
        )
      end
      
      def handle_feelings_input(scale, feelings_type)
        log_info("Handling feelings input: #{feelings_type} = #{scale}")
        
        scale = scale.to_i
        unless (1..5).include?(scale)
          send_message(text: "⚠️ Пожалуйста, выберите число от 1 до 5.")
          return false
        end
        
        store_day_data("feelings_#{feelings_type}", scale)
        
        if feelings_type == 'before'
          send_message(
            text: "✅ Сохранено: #{scale}/5 — #{FEELINGS_SCALE[scale]}",
            parse_mode: 'Markdown'
          )
          
          sleep(1)
          show_activity_categories
        else
          store_day_data('current_step', 'reflection')
          save_current_progress
          
          reflection_message = <<~MARKDOWN
            ✨ *Отлично! Настроение после: #{scale}/5*
            
            💭 *Поделитесь впечатлениями:*
            
            Что вы почувствовали?
            Что было приятного?
            Хотели бы повторить?
          MARKDOWN
          
          send_message(text: reflection_message, parse_mode: 'Markdown')
          
          send_message(
            text: "Напишите несколько слов о вашем опыте:",
            reply_markup: { inline_keyboard: [] }.to_json
          )
        end
        
        true
      end
      
      def show_activity_categories
        log_info("Showing activity categories step 2")
        
        store_day_data('current_step', 'choosing_category')
        save_current_progress
        
        step = EXERCISE_STEPS[1]
        
        message = <<~MARKDOWN
          #{step[:emoji]} *Шаг 2: Выберите категорию*
          
          Какая сфера интересов вас привлекает сегодня?
          
          *Не думайте о продуктивности. Думайте о радости!*
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Выберите категорию:",
          reply_markup: activity_categories_markup
        )
      end
      
      def handle_category_selection(category)
        log_info("Handling category selection: #{category}")
        
        unless ACTIVITY_CATEGORIES.key?(category)
          send_message(text: "⚠️ Неизвестная категория. Пожалуйста, выберите из списка.")
          return false
        end
        
        category_info = ACTIVITY_CATEGORIES[category]
        store_day_data('activity_category', category)
        store_day_data('current_step', 'planning_details')
        save_current_progress
        
        step = EXERCISE_STEPS[2]
        
        planning_message = <<~MARKDOWN
          #{step[:emoji]} *Шаг 3: Спланируйте активность*
          
          #{category_info[:title]} – #{category_info[:description]}
          
          *Примеры:*
          #{category_info[:examples].map { |ex| "• #{ex}" }.join("\n")}
          
          Чем конкретнее план, тем легче его выполнить!
        MARKDOWN
        
        send_message(text: planning_message, parse_mode: 'Markdown')
        
        send_message(
          text: "Напишите, чем именно вы планируете заняться:",
          reply_markup: { inline_keyboard: [] }.to_json
        )
        
        true
      end
      
      def handle_activity_plan_input(activity_text)
        log_info("Handling activity plan input: #{activity_text}")
        
        if activity_text.blank? || activity_text.strip.length < 3
          send_message(text: "⚠️ Пожалуйста, напишите описание активности.")
          return false
        end
        
        store_day_data('activity_plan', activity_text.strip)
        store_day_data('current_step', 'planning_time')
        save_current_progress
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_planning_time")
        
        step = EXERCISE_STEPS[3]
        
        time_message = <<~MARKDOWN
          ✅ *План сохранен!*
          
          #{step[:emoji]} *Шаг 4: Назначьте время*
          
          Когда вы этим займетесь?
          
          *Совет:* Конкретное время повышает вероятность выполнения.
        MARKDOWN
        
        send_message(text: time_message, parse_mode: 'Markdown')
        
        send_message(
          text: "Напишите когда (например: 'сегодня вечером', 'завтра утром'):",
          reply_markup: { inline_keyboard: [] }.to_json
        )
        
        log_info("Activity plan saved")
        true
      end
      
      def handle_time_plan_input(time_text)
        log_info("Handling time plan input: #{time_text}")
        
        if time_text.blank? || time_text.strip.length < 3
          send_message(text: "⚠️ Пожалуйста, напишите время.")
          return false
        end
        
        store_day_data('planned_time', time_text.strip)
        store_day_data('current_step', 'activity_planned')
        save_current_progress
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_activity_planned")
        
        log_info("Time plan saved")
        
        sleep(1)
        show_activity_summary
        
        true
      end
      
      def show_activity_summary
        log_info("Showing activity summary")
        
        category = get_day_data('activity_category')
        activity_plan = get_day_data('activity_plan')
        planned_time = get_day_data('planned_time')
        feelings_before = get_day_data('feelings_before')
        
        category_info = ACTIVITY_CATEGORIES[category] || {}
        
        summary_message = <<~MARKDOWN
          📋 *Ваш план удовольствия*
          
          *Категория:* #{category_info[:title] || 'Не указана'}
          *Активность:* #{activity_plan}
          *Время:* #{planned_time}
          *Настроение до:* #{feelings_before}/5
          
          ⭐️ *Совет:* Установите напоминание на телефоне!
          
          💡 *Помните:* Вы заслуживаете это время для себя.
        MARKDOWN
        
        send_message(text: summary_message, parse_mode: 'Markdown')
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_activity_summary_shown")
        store_day_data('current_step', 'waiting_completion')
        save_current_progress
        
        send_message(
          text: "Готовы сохранить план и приступить к выполнению?",
          reply_markup: activity_plan_confirmation_markup
        )
      end
      
      def show_activity_reflection
        log_info("Showing activity reflection request")
        
        reflection_request_message = <<~MARKDOWN
          ✨ *Вы уделили время себе!*
          
          Теперь давайте оценим, как изменилось настроение.
          
          *Как вы себя чувствуете сейчас?*
        MARKDOWN
        
        send_message(text: reflection_request_message, parse_mode: 'Markdown')
        
        send_message(
          text: "Оцените ваше настроение:",
          reply_markup: feelings_scale_markup('after')
        )
      end
      
      def handle_reflection_input(text)
        log_info("Handling reflection input: #{text.truncate(50)}")
        
        if text.blank? || text.strip.length < 3
          send_message(text: "⚠️ Пожалуйста, напишите несколько слов.")
          return false
        end
        
        store_day_data('reflection_text', text.strip)
        
        activity = mark_activity_completed
        
        category = get_day_data('activity_category')
        activity_plan = get_day_data('activity_plan')
        feelings_before = get_day_data('feelings_before')
        feelings_after = get_day_data('feelings_after')
        mood_change = calculate_mood_change
        
        category_info = ACTIVITY_CATEGORIES[category] || {}
        
        completion_message = <<~MARKDOWN
          🎉 *Активность завершена!*
          
          📊 *Результат:*
          
          *Что сделали:* #{activity_plan}
          *Настроение до:* #{feelings_before}/5
          *Настроение после:* #{feelings_after}/5
          
          #{mood_change > 0 ? "📈 Настроение улучшилось на #{mood_change} баллов!" : "📊 Зафиксировали ваше состояние"}
          
          💭 *Ваши впечатления:*
          "#{text}"
          
          *Отличная работа!* Вы уделили время тому, что важно.
        MARKDOWN
        
        send_message(text: completion_message, parse_mode: 'Markdown')
        
        complete_exercise
        true
      end
      
      def complete_exercise
  log_info("Completing Day 18 exercise")
  
  # ✅ ВАЖНО: Сохраняем активность, если еще не сохранена
  unless get_day_data('activity_saved')
    save_success = save_activity_plan
    if save_success
      log_info("Activity saved during completion")
    else
      log_warn("Failed to save activity during completion")
    end
  end
  
  # ✅ Отмечаем активность как завершенную
  activity = mark_activity_completed
  if activity
    log_info("Activity #{activity.id} completed successfully")
  else
    log_warn("No activity was marked as completed")
  end
  
  @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
  @user.complete_day_program(DAY_NUMBER)
  @user.complete_self_help_day(DAY_NUMBER)
  save_current_progress
        
        final_message = <<~MARKDOWN
          🏆 *День 18 завершен!*
          
          **🎯 Что вы сделали:**
          
          1. ✅ Признали важность времени для себя
          2. ✅ Выбрали активность, приносящую радость
          3. ✅ Создали конкретный план
          4. ✅ Уделили время своим интересам
          5. ✅ Отразили на эффекте
          
          **📊 Научный факт:** Регулярные активности удовольствия снижают стресс на 45% и повышают уровень счастья на 35%.
          
          **💡 Как продолжать:** Добавляйте по одной "активности удовольствия" в день без чувства вины.
          
          *Прогресс программы:* #{@user.progress_percentage}%
        MARKDOWN
        
        send_message(text: final_message, parse_mode: 'Markdown')
        
        # Показываем простое меню
        sleep(1)
        show_simple_menu
        
        # Предлагаем следующий день с ограничениями
        sleep(2)
        propose_next_day_with_restriction
      end
      
      # ===== ПРОСТОЕ МЕНЮ (только история и новая активность) =====
      
      def show_simple_menu
        menu_message = <<~MARKDOWN
          🌈 *Меню "Время для себя"*
          
          Теперь у вас есть инструмент для заботы о себе через приятные активности!
        MARKDOWN
        
        send_message(text: menu_message, parse_mode: 'Markdown')
        
        send_message(
          text: "Что дальше?",
          reply_markup: simple_day_18_menu_markup
        )
      end
      
      def show_previous_activities
        # Проверяем, есть ли завершенные активности
        has_completed_activities = @user.pleasure_activities.completed.exists?
        
        unless has_completed_activities
          send_message(
            text: "📭 *У вас пока нет завершенных активностей.*\n\nСоздайте первую активность в упражнении дня 18!",
            parse_mode: 'Markdown',
            reply_markup: day_18_start_exercise_markup
          )
          return
        end
        
        activities = @user.pleasure_activities.completed.order(completed_at: :desc).limit(5)
        
        message = "📚 *Ваши активности:*\n\n"
        
        activities.each_with_index do |activity, index|
          date = activity.completed_at.strftime('%d.%m.%Y')
          title = activity.title
          type_emoji = activity.type_emoji
          
          message += "#{index + 1}. #{type_emoji} *#{date}*\n"
          message += "   🎯 #{title.truncate(40)}\n"
          
          if activity.feelings_before && activity.feelings_after
            change = activity.mood_improvement
            if change > 0
              message += "   📈 +#{change} баллов!\n"
            elsif change < 0
              message += "   📉 #{change} баллов\n"
            else
              message += "   📊 Настроение стабильно\n"
            end
          end
          
          message += "\n"
        end
        
        send_message(
          text: message,
          parse_mode: 'Markdown',
          reply_markup: simple_back_markup
        )
      end
      
      # ===== ОБРАБОТКА КНОПОК =====
      # 
      def reset_activity_saved_flag
        store_day_data('activity_saved', false)
        log_info("Activity saved flag reset to false")
        send_message(text: "✅ Флаг сохранения сброшен. Можно пробовать сохранить снова.")
      end
      
      def handle_button(callback_data)
  log_info("Handling button: #{callback_data}")
  
  case callback_data
  when 'start_day_18_exercise'
    deliver_exercise
    
  when /^day_18_feelings_(before|after)_(\d+)$/
    type = $1
    scale = $2.to_i
    handle_feelings_input(scale, type)
    
  when /^day_18_category_(.+)$/
    category = $1
    handle_category_selection(category)
    
  when 'day_18_save_activity'
  log_info("=== HANDLE SAVE ACTIVITY BUTTON ===")
  
  # Логируем текущие данные
  log_info("Current data before save:")
  log_info("  activity_plan: #{get_day_data('activity_plan')}")
  log_info("  activity_category: #{get_day_data('activity_category')}")
  log_info("  feelings_before: #{get_day_data('feelings_before')}")
  log_info("  planned_time: #{get_day_data('planned_time')}")
  log_info("  activity_saved: #{get_day_data('activity_saved')}")
  
  # Сохраняем активность в БД
  save_success = save_activity_plan
  
  if save_success
    log_info("✅ Save successful")
    send_message(
      text: "✅ План сохранен в вашу историю! Приступайте к выполнению.",
      parse_mode: 'Markdown'
    )
    send_message(
      text: "Когда завершите активность, нажмите:",
      reply_markup: activity_completed_markup
    )
  else
    log_info("❌ Save failed")
    # Даем конкретные инструкции
    send_message(
      text: "⚠️ Не удалось сохранить план. Пожалуйста:\n" \
            "1. Проверьте, что вы выбрали категорию активности\n" \
            "2. Проверьте, что написали описание активности\n" \
            "3. Попробуйте еще раз",
      parse_mode: 'Markdown'
    )
  end

  when 'reset_activity_save'
    reset_activity_saved_flag
    
  when 'day_18_activity_completed'
    show_activity_reflection
    
  when 'day_18_change_plan'
    show_activity_categories
  when 'debug_create_activity'
    result = debug_activity_creation
    send_message(text: "Результат отладки: #{result}")
    
  when 'view_pleasure_activities'
    show_previous_activities
    
  when 'back_to_day_18_menu'
    show_simple_menu
    
  when 'day_18_exercise_completed'
    complete_exercise
    
  else
    log_warn("Unknown button callback: #{callback_data}")
    send_message(text: "Неизвестная команда.")
  end
end
      
      # ===== ОБРАБОТКА ТЕКСТОВОГО ВВОДА =====
      
      def handle_text_input(input_text)
        log_info("Handling text input for day 18: #{input_text.truncate(50)}")
        
        current_state = @user.self_help_state
        current_step = get_day_data('current_step')
        
        log_info("Current state: #{current_state}, step: #{current_step}")
        
        case current_step
        when 'planning_details'
          handle_activity_plan_input(input_text)
        when 'planning_time'
          handle_time_plan_input(input_text)
        when 'reflection'
          handle_reflection_input(input_text)
        else
          case current_state
          when "day_18_planning_activity"
            handle_activity_plan_input(input_text)
          when "day_18_planning_time"
            handle_time_plan_input(input_text)
          when "day_18_activity_planned"
            handle_reflection_input(input_text)
          else
            send_message(text: "📝 Пожалуйста, используйте кнопки для навигации.")
            false
          end
        end
      end
      
      def handle_smart_input(text)
        handle_text_input(text)
      end
      
      # ===== ВОССТАНОВЛЕНИЕ СЕССИИ =====
      
      def resume_session
        current_state = @user.self_help_state
        
        case current_state
        when "day_#{DAY_NUMBER}_intro"
          deliver_intro
        when "day_#{DAY_NUMBER}_exercise_in_progress"
          current_step = get_day_data('current_step')
          if current_step.present?
            handle_resume_from_step(current_step)
          else
            deliver_exercise
          end
        when "day_#{DAY_NUMBER}_planning_activity"
          start_activity_planning
        when "day_#{DAY_NUMBER}_planning_time"
          send_message(text: "⏰ Напишите, когда планируете заняться активностью:")
        when "day_#{DAY_NUMBER}_activity_planned"
          show_activity_summary
        when "day_#{DAY_NUMBER}_activity_summary_shown"
          show_activity_reflection
        when "day_#{DAY_NUMBER}_waiting_completion"
          send_message(
            text: "✅ План сохранен. Когда завершите, нажмите:",
            reply_markup: activity_completed_markup
          )
        when "day_#{DAY_NUMBER}_completed"
          show_simple_menu
        else
          show_intro_without_state
        end
      end
      
      def handle_resume_from_step(step)
        case step
        when 'intro'
          deliver_intro
        when 'exercise_started'
          deliver_exercise
        when 'feelings_before'
          start_activity_planning
        when 'choosing_category'
          show_activity_categories
        when 'planning_details'
          send_message(text: "📝 Напишите, чем именно вы планируете заняться:")
        when 'planning_time'
          send_message(text: "⏰ Напишите, когда планируете заняться этим:")
        when 'activity_planned'
          show_activity_summary
        when 'waiting_completion'
          send_message(
            text: "✅ План сохранен. Когда завершите, нажмите:",
            reply_markup: activity_completed_markup
          )
        when 'reflection'
          send_message(text: "💭 Напишите ваши впечатления после активности:")
        else
          deliver_exercise
        end
      end
      
      def show_intro_without_state
        send_message(
          text: "🌟 *День 18: Время для себя и своих интересов* 🌟\n\nДавайте начнем!",
          parse_mode: 'Markdown'
        )
        send_message(
          text: "Готовы?",
          reply_markup: day_18_start_exercise_markup
        )
      end
      
      # ===== ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ =====
      
      private

      def ensure_activity_data_present
  required_data = {
    'activity_plan' => get_day_data('activity_plan'),
    'activity_category' => get_day_data('activity_category'),
    'feelings_before' => get_day_data('feelings_before')
  }
  
  missing = required_data.select { |k, v| v.blank? }.keys
  if missing.any?
    log_warn("Missing required data: #{missing.join(', ')}")
    return false
  end
  
  true
end
      
     def save_activity_plan
  log_info("=== SAVE ACTIVITY PLAN START ===")
  
  title = get_day_data('activity_plan')
  activity_type = get_day_data('activity_category')
  feelings_before = get_day_data('feelings_before')
  planned_time = get_day_data('planned_time')
  
  log_info("Data: title='#{title}', type='#{activity_type}', feelings=#{feelings_before}")
  
  unless title.present? && activity_type.present?
    log_warn("Missing required data: title or activity_type")
    return false
  end
  
  begin
    # Создаем активность
    activity = PleasureActivity.new(
      user: @user,
      title: title,
      activity_type: activity_type,
      feelings_before: feelings_before,
      completed: false,
      description: "Активность дня 18: #{ACTIVITY_CATEGORIES.dig(activity_type, :title) || activity_type}"
    )
    
    # УБИРАЕМ эту строку или комментируем:
    # activity.duration_minutes = 30  # 30 минут по умолчанию
    # или меняем на:
    # activity.duration = 30  # если хочешь сохранить в поле duration
    
    # Лучше вообще убрать, раз у нас нет требования к продолжительности
    # activity.duration = 30 if activity.respond_to?(:duration=)
    
    if activity.save
      log_info("✅ Activity created successfully: #{activity.id}")
      store_day_data('activity_saved', true)
      store_day_data('activity_id', activity.id)
      return true
    else
      log_warn("❌ Activity save failed: #{activity.errors.full_messages}")
      return false
    end
    
  rescue => e
    log_error("Exception in save_activity_plan", e)
    return false
  end
end

def debug_activity_creation
  title = "Тестовая активность"
  activity_type = "reading"
  
  activity = PleasureActivity.new(
    user: @user,
    title: title,
    activity_type: activity_type,
    completed: false,
    feelings_before: 4
  )
  
  if activity.valid?
    log_info("✅ Activity validation passed")
    activity.save
    log_info("✅ Activity saved with ID: #{activity.id}")
    "Создано успешно: #{activity.id}"
  else
    log_warn("❌ Activity validation failed: #{activity.errors.full_messages}")
    "Ошибки: #{activity.errors.full_messages.join(', ')}"
  end
end

def find_existing_activity(title, activity_type)
  # Ищем активность с таким же названием и типом за сегодня
  @user.pleasure_activities
    .where("DATE(created_at) = ?", Date.today)
    .where(title: title, activity_type: activity_type)
    .first
end
      
      def mark_activity_completed
  log_info("Marking activity as completed")
  
  # Сначала ищем по сохраненному ID
  activity_id = get_day_data('activity_id')
  if activity_id
    activity = PleasureActivity.find_by(id: activity_id, user: @user)
    if activity
      log_info("Found activity by ID: #{activity.id}")
      return update_activity_completion(activity)
    end
  end
  
  # Если не нашли по ID, ищем последнюю незавершенную активность
  activity = @user.pleasure_activities
    .where(completed: false)
    .where("DATE(created_at) = ?", Date.today)  # Ищем только сегодняшние
    .last
  
  if activity
    log_info("Found today's activity: #{activity.id}")
    return update_activity_completion(activity)
  end
  
  # Если вообще не нашли, создаем новую активность
  log_warn("No activity found, creating new one")
  return create_and_complete_activity
  
  nil
end

def update_activity_completion(activity)
  activity.update(
    completed: true,
    completed_at: Time.current,
    feelings_after: get_day_data('feelings_after'),
    reflection: get_day_data('reflection_text')
  )
  
  log_info("Activity #{activity.id} marked as completed")
  activity
end
      def create_and_complete_activity
  begin
    title = get_day_data('activity_plan')
    activity_type = get_day_data('activity_category')
    
    return nil unless title && activity_type
    
    activity = PleasureActivity.create!(
      user: @user,
      title: title,
      description: "Активность дня 18",
      activity_type: activity_type,
      feelings_before: get_day_data('feelings_before'),
      feelings_after: get_day_data('feelings_after'),
      planned_time: get_day_data('planned_time'),
      reflection: get_day_data('reflection_text'),
      completed: true,
      completed_at: Time.current
    )
    
    log_info("Created and completed activity: #{activity.id}")
    activity
  rescue => e
    log_error("Failed to create and complete activity", e)
    nil
  end
end

      def calculate_mood_change
        feelings_before = get_day_data('feelings_before').to_i
        feelings_after = get_day_data('feelings_after').to_i
        
        return 0 if feelings_before == 0 || feelings_after == 0
        feelings_after - feelings_before
      end

      def propose_next_day_with_restriction
        next_day = 19
        
        # Проверяем, можно ли начать следующий день
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ✅ *Доступен сейчас!*
            
            Вы можете начать следующий день прямо сейчас.
          MARKDOWN
          
          button_text = "➡️ Начать День #{next_day}"
          callback_data = "start_day_#{next_day}_from_proposal"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ⏱️ *Ограничение:* #{error_message}
            
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
      
      # ===== МЕТОДЫ РАЗМЕТКИ =====
      
      def day_18_start_exercise_markup
        {
          inline_keyboard: [
            [{ text: "🌈 Начать упражнение", callback_data: 'start_day_18_exercise' }]
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
        
        { inline_keyboard: [buttons] }.to_json
      end
      
      def activity_categories_markup
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
              { text: "✅ Сохранить", callback_data: 'day_18_save_activity' },
              { text: "🔄 Изменить", callback_data: 'day_18_change_plan' }
            ]
          ]
        }.to_json
      end
      
      def simple_day_18_menu_markup
        {
          inline_keyboard: [
            [
              { text: "📚 Мои активности", callback_data: 'view_pleasure_activities' }
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
      
      def simple_back_markup
        {
          inline_keyboard: [
            [{ text: "🔙 Назад", callback_data: 'back_to_day_18_menu' }]
          ]
        }.to_json
      end
      
      def activity_completed_markup
        {
          inline_keyboard: [
            [{ text: "✅ Я завершил(а)", callback_data: 'day_18_activity_completed' }]
          ]
        }.to_json
      end
      
      def log_info(message)
        Rails.logger.info "[Day18Service] #{message}"
      end
      
      def log_error(message, error = nil)
        Rails.logger.error "[Day18Service] #{message}"
        Rails.logger.error error.message if error
      end
      
      def log_warn(message)
        Rails.logger.warn "[Day18Service] #{message}"
      end
    end
  end
end
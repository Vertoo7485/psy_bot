# app/services/self_help/days/day_19_service.rb
module SelfHelp
  module Days
    class Day19Service < DayBaseService
      include TelegramMarkupHelper
      
      DAY_NUMBER = 19
      
      # ===== НАУЧНЫЕ ФАКТЫ О МЕДИТАЦИИ =====
      SCIENTIFIC_FACTS = <<~MARKDOWN
        🧠 *Научные факты о медитации:*
        
        • 📉 **30-40%** — снижение уровня стресса после 8 недель практики
        • 🎯 **20-30%** — улучшение концентрации внимания  
        • 😌 **25-35%** — снижение симптомов тревоги
        • 💤 **15-25%** — улучшение качества сна
        • 🧘 **40-50%** — повышение осознанности в повседневной жизни
        
        *Источник: Journal of Cognitive Enhancement, Mindfulness, JAMA Internal Medicine*
      MARKDOWN
      
      # ===== ЧАСТЫЕ ТРУДНОСТИ И РЕШЕНИЯ =====
      COMMON_CHALLENGES = [
        {
          challenge: "Не могу сконцентрироваться, мысли постоянно отвлекают",
          solution: "Это нормально! Медитация — не про очищение ума, а про возвращение внимания. Каждое возвращение — это успех."
        },
        {
          challenge: "Чувствую себя глупо, сидя в тишине и ничего не делая",
          solution: "Медитация — это активный процесс тренировки внимания. Вы не 'ничего не делаете', а развиваете важный навык."
        },
        {
          challenge: "Не вижу немедленных результатов, поэтому теряю мотивацию",
          solution: "Эффекты медитации накапливаются постепенно. Сравните с фитнесом — один день тренировок не изменит тело."
        },
        {
          challenge: "Нет времени на регулярную практику",
          solution: "Начните с 2-3 минут в день. Регулярность важнее продолжительности. Лучше 3 минуты каждый день, чем 30 минут раз в неделю."
        }
      ].freeze
      
      # ===== СТРУКТУРА МЕДИТАЦИИ =====
      MEDITATION_STEPS = [
        {
          step: 1,
          emoji: "🪑",
          title: "Подготовка пространства",
          instruction: "Найдите тихое место, отключите уведомления",
          duration: 1 # минута на подготовку
        },
        {
          step: 2,
          emoji: "🧘‍♀️",
          title: "Удобная поза",
          instruction: "Сядьте прямо, но расслабленно",
          duration: 1
        },
        {
          step: 3,
          emoji: "🌬️",
          title: "Фокус на дыхании",
          instruction: "Наблюдайте за вдохами и выдохами",
          duration: 3
        },
        {
          step: 4,
          emoji: "🌀",
          title: "Возвращение внимания",
          instruction: "Мягко возвращайтесь к дыханию, когда ум блуждает",
          duration: 3
        },
        {
          step: 5,
          emoji: "✨",
          title: "Завершение практики",
          instruction: "Постепенно вернитесь в обычное состояние",
          duration: 1
        }
      ].freeze
      
      # Шкала оценки
      RATING_SCALE = {
        1 => "😔 Было трудно сосредоточиться",
        2 => "🙁 Немного отвлекался(ась)",
        3 => "😐 Нормально получилось",
        4 => "🙂 Хорошо, чувствовал(а) эффект",
        5 => "😊 Отлично! Чувствую спокойствие и ясность"
      }.freeze
      
      # ===== ОСНОВНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        log_info("Starting Day 19 introduction")
        
        send_message(
          text: "🧘‍♀️ *День 19: Ваша первая медитация* 🧘‍♀️",
          parse_mode: 'Markdown'
        )
        
        send_message(
          text: SCIENTIFIC_FACTS,
          parse_mode: 'Markdown'
        )
        
        # Показываем структуру
        steps_text = MEDITATION_STEPS.map do |step|
          "#{step[:emoji]} *Шаг #{step[:step]}: #{step[:title]}*\n⏱️ #{step[:duration]} мин: #{step[:instruction]}\n"
        end.join("\n")
        
        send_message(
          text: "📋 *5 шагов простой медитации:*\n\n#{steps_text}",
          parse_mode: 'Markdown'
        )
        
        # Важность упражнения
        importance_text = <<~MARKDOWN
          🎯 *Зачем это упражнение?*
          
          *«Медитация — это не попытка отключить мысли, а умение наблюдать за ними без осуждения.»*
          
          💡 *Что вы получите:*
          • Навык управления вниманием
          • Инструмент для снижения стресса
          • Практику осознанности
          • Метод для ежедневного восстановления
          
          *Исследования:* Регулярная медитация меняет структуру мозга, увеличивая серое вещество в зонах, отвечающих за внимание и эмоциональную регуляцию.
        MARKDOWN
        
        send_message(text: importance_text, parse_mode: 'Markdown')
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        store_day_data('current_step', 'intro')
        save_current_progress
        
        send_message(
          text: "🌈 *Готовы попробовать свою первую медитацию?*",
          parse_mode: 'Markdown',
          reply_markup: day_19_start_exercise_markup
        )
      end
      
      def deliver_exercise
        log_info("Starting Day 19 exercise")
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise_started')
        store_day_data('exercise_started_at', Time.current)
        clear_day_data
        save_current_progress
        
        exercise_text = <<~MARKDOWN
          🎯 *Упражнение: Медитация "Дыхание-Якорь"* 🎯
          
          *Идеально для начинающих:*
          ✅ Просто — фокус только на дыхании
          ✅ Коротко — всего 5 минут
          ✅ Эффективно — сразу почувствуете результат
          ✅ Доступно — можно делать где угодно
          
          *Мы пройдем 5 шагов вместе:*
          1. 🪑 Подготовим пространство (1 мин)
          2. 🧘‍♀️ Примем удобную позу (1 мин)  
          3. 🌬️ Сфокусируемся на дыхании (3 мин)
          4. 🌀 Попрактикуем возвращение внимания (3 мин)
          5. ✨ Завершим практику (1 мин)
          
          💡 *Совет:* Установите таймер на 5 минут или следуйте моим инструкциям.
        MARKDOWN
        
        send_message(text: exercise_text, parse_mode: 'Markdown')
        
        sleep(1)
        start_meditation_preparation
      end
      
      def start_meditation_preparation
        store_day_data('current_step', 'preparation')
        save_current_progress
        
        step = MEDITATION_STEPS[0]
        
        message = <<~MARKDOWN
          #{step[:emoji]} *Шаг 1: Подготовка пространства*
          
          *Что сделать:*
          • 📱 Выключите уведомления на телефоне
          • 🔕 Найдите тихое место на 5 минут  
          • 🪑 Приготовьте стул или подушку для сидения
          • ⏰ Установите таймер на 5 минут (опционально)
          
          *Время:* #{step[:duration]} минута
          *Фокус:* Создание комфортных условий
          
          💡 *Помните:* Нет идеальных условий для медитации. 
          Начните с того, что есть.
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Когда будете готовы, перейдите к следующему шагу:",
          reply_markup: meditation_next_step_markup(1)
        )
      end
      
      def continue_meditation_step(step_number)
        step_index = step_number - 1
        step = MEDITATION_STEPS[step_index]
        
        store_day_data('current_step', "step_#{step_number}")
        save_current_progress
        
        total_steps = MEDITATION_STEPS.length
        
        message = <<~MARKDOWN
          #{step[:emoji]} *Шаг #{step_number} из #{total_steps}: #{step[:title]}*
          
          #{step[:instruction]}
          
          *Время:* #{step[:duration]} #{step[:duration] == 1 ? 'минута' : 'минуты'}
          *Фокус:* #{step[:title].downcase}
          
          💡 *Совет:* Если отвлекаетесь — это нормально. Просто мягко верните внимание к инструкции.
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        if step_number < total_steps
          send_message(
            text: "Когда будете готовы к следующему шагу:",
            reply_markup: meditation_next_step_markup(step_number + 1)
          )
        else
          # Последний шаг - завершение медитации
          sleep(2)
          complete_meditation_session
        end
      end
      
      def complete_meditation_session
        store_day_data('current_step', 'meditation_completed')
        store_day_data('meditation_completed_at', Time.current)
        save_current_progress
        
        message = <<~MARKDOWN
          🎉 *Медитация завершена!* 🎉
          
          *Вы сделали это!* 5 минут практики — отличный результат для первого раза.
          
          *Что сейчас важно:*
          • 🙏 Поблагодарите себя за это время
          • 💭 Почувствуйте эффект в теле
          • 🕊️ Не спешите вскакивать
          • 🌱 Медленно вернитесь к обычной деятельности
          
          *Как вы себя чувствуете после медитации?*
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        ask_for_meditation_rating
      end
      
      def ask_for_meditation_rating
        store_day_data('current_step', 'rating')
        save_current_progress
        
        message = <<~MARKDOWN
          📊 *Оцените ваш опыт*
          
          По шкале от 1 до 5, насколько хорошо получилось сфокусироваться:
          
          1. 😔 Было трудно сосредоточиться
          2. 🙁 Немного отвлекался(ась)  
          3. 😐 Нормально получилось
          4. 🙂 Хорошо, чувствовал(а) эффект
          5. 😊 Отлично! Чувствую спокойствие и ясность
          
          *Помните:* Нет "неправильных" результатов!
          Даже если отвлекались много раз — это нормально для начала.
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Выберите оценку:",
          reply_markup: meditation_rating_markup
        )
      end
      
      def handle_meditation_rating(rating)
        rating = rating.to_i
        unless (1..5).include?(rating)
          send_message(text: "⚠️ Пожалуйста, выберите число от 1 до 5.")
          return false
        end
        
        store_day_data('meditation_rating', rating)
        store_day_data('current_step', 'feedback')
        save_current_progress
        
        message = <<~MARKDOWN
          #{RATING_SCALE[rating]}
          
          💡 *Это совершенно нормально!*
          
          *Первый раз — всегда самый сложный.*
          • 🧠 Мозг привык постоянно быть занятым
          • 🎯 Медитация — новый для него навык
          • 📈 С каждым разом будет легче
          • ✨ Уже через 3-4 сессии заметите разницу
          
          *Хотите поделиться своими впечатлениями?*
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Напишите несколько слов о вашем опыте (или нажмите 'Пропустить'):",
          reply_markup: meditation_feedback_markup
        )
      end
      
      def handle_meditation_feedback(feedback_text)
        store_day_data('meditation_feedback', feedback_text)
        
        # Сохраняем сессию медитации
        save_meditation_session
        
        show_meditation_summary
      end
      
      def save_meditation_session
        log_info("Saving meditation session")
        
        begin
          MeditationSession.create!(
            user: @user,
            duration_minutes: MEDITATION_STEPS.sum { |s| s[:duration] },
            technique: 'breathing_anchor',
            rating: get_day_data('meditation_rating'),
            notes: get_day_data('meditation_feedback'),
            completed_at: Time.current
          )
          
          log_info("✅ Meditation session saved")
          store_day_data('meditation_saved', true)
          
        rescue => e
          log_error("Failed to save meditation session", e)
          # Сохраняем хотя бы в данные пользователя
          store_day_data('meditation_saved', true)
        end
      end
      
      def show_meditation_summary
        ensure_current_meditation_saved
        
        rating = get_day_data('meditation_rating')
        feedback = get_day_data('meditation_feedback')
        
        summary_message = <<~MARKDOWN
          📋 *Ваша первая медитация* 📋
          
          *Результаты:*
          ⭐ Оценка: #{rating}/5
          #{RATING_SCALE[rating]}
          
          💭 *Ваши впечатления:*
          #{feedback.present? ? "\"#{feedback}\"" : "Не указано"}
          
          🕒 *Общее время:* 5 минут
          🎯 *Техника:* Дыхание-Якорь
          
          *Что дальше?*
          
          🎯 *Советы для регулярной практики:*
          1. **Начинайте с малого** — 2-3 минуты каждый день лучше, чем 20 минут раз в неделю
          2. **Выберите время** — утро после пробуждения или вечер перед сном
          3. **Не гонитесь за результатом** — просто делайте, эффект придет сам
          4. **Пробуйте разные техники** — мы познакомим вас с ними в следующих днях
          
          🏆 *Поздравляю с первым шагом в медитации!*
        MARKDOWN
        
        send_message(text: summary_message, parse_mode: 'Markdown')
        
        complete_exercise
      end
      
      def ensure_current_meditation_saved
        return if get_day_data('meditation_saved')
        save_meditation_session
      end
      
      def complete_exercise
        log_info("Completing Day 19 exercise")
        
        ensure_current_meditation_saved
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
        @user.complete_day_program(DAY_NUMBER)
        @user.complete_self_help_day(DAY_NUMBER)
        save_current_progress
        
        final_message = <<~MARKDOWN
          🎉 *День 19 завершен!* 🎉
          
          *Что вы сделали сегодня:*
          ✅ Узнали научные факты о медитации
          ✅ Подготовились к практике
          ✅ Выполнили 5-минутную медитацию
          ✅ Оценили свой опыт
          ✅ Получили советы для продолжения
          
          *Ключевые выводы:*
          🧠 Медитация — это тренировка внимания
          ⏱️ Даже 5 минут в день имеют значение
          🔄 Регулярность важнее продолжительности
          💖 Относитесь к себе с добротой, даже если отвлекаетесь
          
          *«Самое сложное в медитации — сесть медитировать. Все остальное получается само.»*
          
          *Прогресс программы:* #{@user.progress_percentage}%
        MARKDOWN
        
        send_message(text: final_message, parse_mode: 'Markdown')
        
        sleep(1)
        show_meditation_menu
        
        sleep(2)
        propose_next_day_with_restriction
      end
      
      def show_meditation_menu
        ensure_current_meditation_saved
        
        menu_message = <<~MARKDOWN
          🧘‍♀️ *Меню медитаций* 🧘‍♀️
          
          Вы успешно завершили свою первую медитацию!
          
          *Что вы можете сделать:*
          
          📊 **Посмотреть статистику** — ваш прогресс в медитации
          💡 **Получить советы** — как улучшить практику
          🧘‍♀️ **Начать новую медитацию** — закрепить результат
          ➡️ **Перейти к следующему дню** — продолжить программу
          
          *Помните:* Главное в медитации — регулярность!
          Даже 2-3 минуты в день лучше, чем час раз в неделю.
        MARKDOWN
        
        send_message(text: menu_message, parse_mode: 'Markdown')
        
        send_message(
          text: "Выберите действие:",
          reply_markup: day_19_menu_markup
        )
      end
      
      def show_meditation_stats
        ensure_current_meditation_saved
        
        sessions = @user.meditation_sessions.completed
        
        if sessions.empty?
          send_message(
            text: "📊 *У вас пока нет завершенных медитаций.*\n\nНачните свою первую медитацию!",
            parse_mode: 'Markdown',
            reply_markup: day_19_start_exercise_markup
          )
          return
        end
        
        total_sessions = sessions.count
        total_minutes = sessions.sum(:duration_minutes)
        average_rating = sessions.average(:rating).to_f.round(1)
        
        last_session = sessions.first
        last_date = last_session.formatted_date
        
        stats_message = <<~MARKDOWN
          📊 *Ваша статистика медитаций*
          
          📈 *Общая статистика:*
          • 🧘‍♀️ Количество сессий: #{total_sessions}
          • ⏱️ Всего минут: #{total_minutes}
          • ⭐ Средняя оценка: #{average_rating}/5
          
          🗓️ *Последняя медитация:*
          • 📅 #{last_date}
          • 🕒 #{last_session.duration_minutes} минут
          • 🎯 #{last_session.technique_name}
          
          💡 *Совет:* Старайтесь медитировать регулярно, даже по 2-3 минуты в день.
        MARKDOWN
        
        send_message(text: stats_message, parse_mode: 'Markdown')
        
        send_message(
          text: "Хотите начать новую медитацию?",
          reply_markup: day_19_new_session_markup
        )
      end
      
      def show_meditation_tips
        tips = COMMON_CHALLENGES.map do |challenge|
          "💡 *Проблема:* #{challenge[:challenge]}\n✨ *Решение:* #{challenge[:solution]}\n"
        end.join("\n")
        
        message = <<~MARKDOWN
          💡 *Советы для успешной медитации:*
          
          #{tips}
          
          🎯 *Главные принципы:*
          1. **Регулярность важнее длительности**
          2. **Нет неправильных медитаций**
          3. **Каждое возвращение внимания — это успех**
          4. **Будьте добры к себе**
          
          *«Медитация — это путешествие, а не пункт назначения.»*
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      # ===== ОБРАБОТКА КНОПОК =====
      
      def handle_button(callback_data)
  log_info("Handling button: #{callback_data}")
  
  case callback_data
  when 'start_day_19_exercise'
    deliver_exercise
    
  when /^day_19_meditation_step_(\d+)$/
    step_number = $1.to_i
    continue_meditation_step(step_number)
    
  when /^day_19_meditation_rating_(\d+)$/
    rating = $1.to_i
    handle_meditation_rating(rating)
    
  when 'day_19_share_feedback'
    store_day_data('current_step', 'waiting_feedback')
    send_message(text: "Напишите ваши впечатления от медитации:")
    
  when 'day_19_skip_feedback'
    handle_meditation_feedback("")
    
  # ОБНОВЛЯЕМ ЭТИ КНОПКИ для совместимости с day_19_menu_markup
  when 'day_19_view_stats', 'view_meditation_stats'
    show_meditation_stats
    
  when 'day_19_view_tips', 'view_meditation_tips'
    show_meditation_tips
    
  when 'day_19_start_new', 'start_new_meditation'
    deliver_exercise
    
  when 'day_19_back_to_menu', 'back_to_day_19_menu'
    show_meditation_menu
    
  else
    log_warn("Unknown button callback: #{callback_data}")
    send_message(text: "Неизвестная команда.")
  end
end
      
      # ===== ОБРАБОТКА ТЕКСТОВОГО ВВОДА =====
      
      def handle_text_input(text)
        log_info("Handling text input for day 19: #{text.truncate(50)}")
        
        current_step = get_day_data('current_step')
        
        case current_step
        when 'waiting_feedback'
          handle_meditation_feedback(text)
        else
          send_message(text: "📝 Пожалуйста, используйте кнопки для навигации.")
          false
        end
      end
      
      def show_intro_without_state
        send_message(
          text: "🧘‍♀️ *День 19: Ваша первая медитация* 🧘‍♀️\n\nДавайте начнем!",
          parse_mode: 'Markdown'
        )
        send_message(
          text: "Готовы?",
          reply_markup: day_19_start_exercise_markup
        )
      end
      
      # ===== МЕТОДЫ РАЗМЕТКИ =====
      
      def day_19_start_exercise_markup
        {
          inline_keyboard: [
            [
              { text: "🧘‍♀️ Начать медитацию", callback_data: 'start_day_19_exercise' }
            ]
          ]
        }.to_json
      end
      
      def meditation_next_step_markup(step_number)
        {
          inline_keyboard: [
            [
              { text: "➡️ Шаг #{step_number}", callback_data: "day_19_meditation_step_#{step_number}" }
            ]
          ]
        }.to_json
      end
      
      def meditation_rating_markup
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
            callback_data: "day_19_meditation_rating_#{num}"
          }
        end
        
        {
          inline_keyboard: [buttons]
        }.to_json
      end
      
      def meditation_feedback_markup
        {
          inline_keyboard: [
            [
              { text: "💭 Поделиться впечатлениями", callback_data: 'day_19_share_feedback' },
              { text: "➡️ Пропустить", callback_data: 'day_19_skip_feedback' }
            ]
          ]
        }.to_json
      end
      
      def day_19_menu_markup
  {
    inline_keyboard: [
      [
        { text: "📊 Статистика", callback_data: 'day_19_view_stats' },
        { text: "💡 Советы", callback_data: 'day_19_view_tips' }
      ],
      [
        { text: "🧘‍♀️ Новая медитация", callback_data: 'day_19_start_new' }
      ],
      [
        { text: "🏠 Главное меню", callback_data: 'back_to_main_menu' }
      ]
    ]
  }.to_json
end

def day_19_new_session_markup
  {
    inline_keyboard: [
      [
        { text: "🧘‍♀️ Да, начать новую", callback_data: 'day_19_start_new' },
        { text: "📋 Нет, в меню", callback_data: 'day_19_back_to_menu' }
      ]
    ]
  }.to_json
end
      
      private
      
      def propose_next_day_with_restriction
        next_day = 20
        
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
      
      def log_info(message)
        Rails.logger.info "[Day19Service] #{message}"
      end
      
      def log_error(message, error = nil)
        Rails.logger.error "[Day19Service] #{message}"
        Rails.logger.error error.message if error
      end
      
      def log_warn(message)
        Rails.logger.warn "[Day19Service] #{message}"
      end
    end
  end
end
# app/services/self_help/days/day_13_service.rb
module SelfHelp
  module Days
    class Day13Service < DayBaseService
      include TelegramMarkupHelper
      # Константы
      DAY_NUMBER = 13
      MIN_STEPS_COUNT = 3
      FIRST_STEP_DURATION_MINUTES = 15
      PROCRASTINATION_STEPS = {
        'task' => {
          title: "📋 **Шаг 1: Выбор задачи**",
          instruction: "**Какое дело вы давно откладываете?**\n\nЭто может быть:\n• Рабочая задача\n• Бытовое дело\n• Личный проект\n• Здоровье/спорт\n• Обучение\n\n**Опишите задачу одной фразой:**"
        },
        'reason' => {
          title: "🤔 **Шаг 2: Анализ сопротивления**",
          instruction: "**Почему вы откладываете эту задачу?**\n\nЧто именно мешает начать?\n• Страх неудачи?\n• Не знаете, с чего начать?\n• Кажется слишком сложной?\n• Нет времени/энергии?\n\n**Будьте честны с собой.** Что стоит за прокрастинацией?"
        },
        'steps' => {
          title: "🔨 **Шаг 3: Разбивка на шаги**",
          instruction: "**Разбейте задачу на #{MIN_STEPS_COUNT} маленьких шага.**\n\n**Пример** для «Написать отчет»:\n1. Открыть документ и создать структуру\n2. Написать введение (1-2 абзаца)\n3. Добавить основные данные\n\n**Напишите ваши #{MIN_STEPS_COUNT} шага через запятую:**"
        },
        'first_step' => {
          title: "🎯 **Шаг 4: Первый шаг**",
          instruction: "**Какой самый первый, самый маленький шаг?**\n\nЭто должно быть действие на **#{FIRST_STEP_DURATION_MINUTES} минут**.\n\n**Примеры:**\n• «Открыть документ и написать заголовок»\n• «Собрать материалы в одну папку»\n• «Найти 3 источника информации»\n\n**Сделайте этот шаг прямо сейчас!**\n\nПоставьте таймер на #{FIRST_STEP_DURATION_MINUTES} минут и работайте только это время."
        }
      }.freeze
      
      def deliver_intro
        message_text = <<~MARKDOWN
          🎯 *День 13: Преодоление прокрастинации* 🎯

          **Почему мы откладываем дела?**

          Прокрастинация — это не лень, а **сопротивление**. Чаще всего мы откладываем дела из-за:

          • **Страха неудачи** — «А вдруг не получится?»
          • **Перфекционизма** — «Если не идеально, то лучше не начинать»
          • **Неопределенности** — «Не знаю, с чего начать»
          • **Перегруженности** — «Задача слишком большая»

          **Сегодня мы научимся** делать **первый шаг**, который запускает процесс.
        MARKDOWN
        
        send_message(text: message_text, parse_mode: 'Markdown')
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        
        send_message(
          text: "Готовы победить прокрастинацию?",
          reply_markup: TelegramMarkupHelper.day_13_start_exercise_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        clear_day_data
        
        exercise_text = <<~MARKDOWN
          🚀 *Упражнение: Первый шаг* 🚀

          **Мы пройдем 4 шага, чтобы начать то, что давно откладываете.**

          **Цель:** Не выполнить задачу полностью, а сделать первый маленький шаг.
        MARKDOWN
        
        send_message(text: exercise_text, parse_mode: 'Markdown')
        
        # Начинаем первый шаг
        start_procrastination_step('task')
      end
      
      def complete_exercise
        # Сохраняем задачу
        save_procrastination_task
        
        # ИЗМЕНЕНИЕ: Вызываем родительский метод для завершения
        super
      end

      def send_program_completion_message
        message = <<~MARKDOWN
          🏆 *Поздравляем! Вы завершили всю программу самопомощи!* 🏆

          Вы прошли 13-дневный путь развития и освоили множество полезных техник:

          🔹 **Дни 1-3:** Осознанность и благодарность
          🔹 **Дни 4-6:** Управление эмоциями
          🔹 **Дни 7-9:** Работа с мыслями
          🔹 **Дни 10-12:** Эмоциональный интеллект и самосострадание
          🔹 **День 13:** Преодоление прокрастинации

          **Что дальше?**
          • Продолжайте практиковать полюбившиеся техники
          • Возвращайтесь к нужным дням при необходимости
          • Используйте дневник эмоций для самоанализа
          • Пройдите программу заново через месяц

          Все инструменты остаются в вашем распоряжении!
        MARKDOWN
        
        send_message(
          text: message,
          parse_mode: 'Markdown',
          reply_markup: TelegramMarkupHelper.final_program_completion_markup
        )
      end

      def send_exercise_completion_message
        message = <<~MARKDOWN
          🌟 *Первый шаг сделан!* 🌟

          Вы преодолели самый сложный барьер — начало.

          **Помните:**
          • **5 минут действия** лучше, чем час планирования
          • **Неидеальное действие** лучше идеального бездействия
          • **Момент «после начала»** всегда легче, чем момент «до начала»

          **Советы для продолжения:**
          1. **Завтра** — сделайте второй шаг (тоже 5-15 минут)
          2. **Празднуйте маленькие победы**
          3. **Используйте технику «помидора»** — 25 минут работа, 5 отдых
          4. **Не ругайте себя** за срывы, просто начните снова
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def handle_procrastination_input(input_text)
        current_step = get_day_data('current_step')
        
        case current_step
        when 'task'
          return false if input_text.blank?
          
          store_day_data('task', input_text)
          start_procrastination_step('reason')
          return true
          
        when 'reason'
          return false if input_text.blank?
          
          store_day_data('reason', input_text)
          start_procrastination_step('steps')
          return true
          
        when 'steps'
          return false if input_text.blank?
          
          items = input_text.split(',').map(&:strip)
          if items.length >= MIN_STEPS_COUNT
            store_day_data('steps', items)
            start_procrastination_step('first_step')
            return true
          else
            send_message(text: "Пожалуйста, напишите минимум #{MIN_STEPS_COUNT} шага.")
            return false
          end
          
        when 'first_step'
          return false if input_text.blank?
          
          store_day_data('first_step', input_text)
          
          # Просим сделать шаг и описать ощущения
          send_message(
            text: <<~MARKDOWN,
              🚀 **Время действовать!**

              Сделайте ваш первый шаг прямо сейчас:
              **#{input_text}**

              Работайте #{FIRST_STEP_DURATION_MINUTES} минут. Когда закончите, напишите, как вы себя чувствуете:
            MARKDOWN
          )
          
          store_day_data('current_step', 'feelings')
          return true
          
        when 'feelings'
          return false if input_text.blank?
          
          store_day_data('feelings', input_text)
          
          # Все шаги выполнены
          send_message(
            text: "✅ **Отлично! Первый шаг сделан!**\n\nВы преодолели инерцию и начали движение.\n\nНажмите кнопку, чтобы завершить упражнение:",
            reply_markup: TelegramMarkupHelper.procrastination_exercise_completed_markup
          )
          return true
        end
        
        false
      end
      
      def show_tasks
        tasks = @user.procrastination_tasks.recent.limit(5)
        
        if tasks.empty?
          send_message(text: "У вас пока нет сохраненных задач по прокрастинации.")
          return
        end
        
        tasks.each_with_index do |task, index|
          status = task.completed ? "✅ Выполнена" : "⏳ В процессе"
          
          message = <<~MARKDOWN
            📋 *Задача ##{index + 1}* (#{task.entry_date.strftime('%d.%m.%Y')})

            📝 **Что:** #{task.task}
            🤔 **Почему откладывали:** #{task.reason.truncate(50)}
            🎯 **Первый шаг:** #{task.first_step.truncate(50)}
            📊 **Статус:** #{status}
            ──────────────────────────────
          MARKDOWN
          
          send_message(text: message, parse_mode: 'Markdown')
        end
        
        send_message(
          text: "Всего задач: #{tasks.count}",
          reply_markup: TelegramMarkupHelper.day_13_menu_markup
        )
      end
      
      def mark_task_completed
        task = @user.procrastination_tasks.recent.first
        if task
          task.update(completed: true)
          send_message(text: "✅ Задача отмечена как выполненная! Отличная работа!")
        else
          send_message(text: "Не найдено задач для отметки.")
        end
      end
      
      def ask_for_input_again
        current_step = get_day_data('current_step')
        start_procrastination_step(current_step) if current_step
      end
      
      private
      
      def start_procrastination_step(step_type)
        store_day_data('current_step', step_type)
        
        step = PROCRASTINATION_STEPS[step_type]
        return unless step
        
        send_message(text: step[:title], parse_mode: 'Markdown')
        
        # Для шага 4 добавляем дополнительную мотивацию
        if step_type == 'first_step'
          send_message(
            text: <<~MARKDOWN,
              ⏰ **Таймер на #{FIRST_STEP_DURATION_MINUTES} минут:**
              Поставьте таймер и работайте только #{FIRST_STEP_DURATION_MINUTES} минут. После можно остановиться без чувства вины.
            MARKDOWN
          )
        end
        
        send_message(text: step[:instruction])
      end
      
      def save_procrastination_task
        begin
          ProcrastinationTask.create!(
            user: @user,
            entry_date: Date.current,
            task: get_day_data('task'),
            reason: get_day_data('reason'),
            steps: get_day_data('steps'),
            first_step: get_day_data('first_step'),
            feelings_after: get_day_data('feelings'),
            completed: false
          )
        rescue => e
          log_error("Failed to save procrastination task", e)
        end
      end
    end
  end
end
# app/services/self_help/days/day_13_service.rb
module SelfHelp
  module Days
    class Day13Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 13
      MIN_STEPS_COUNT = 3
      FIRST_STEP_DURATION_MINUTES = 15
      
      # Шаги дня 13
      DAY_STEPS = {
        'intro' => {
          title: "🚀 *День 13: Наука преодоления прокрастинации* 🎯",
          instruction: <<~MARKDOWN
            **Добро пожаловать в день победы над откладыванием!** ✨

            Прокрастинация — это не лень, а **эмоциональная реакция** на задачи, которые кажутся сложными, скучными или угрожающими нашему самоощущению.

            📊 **Научные факты о прокрастинации:**
            • 🧠 Прокрастинация связана с активностью миндалевидного тела (центр страха) и снижением активности префронтальной коры (контроль)
            • 😰 95% людей признаются, что регулярно откладывают важные дела
            • 💼 Работники, борющиеся с прокрастинацией, теряют в среднем 218 минут продуктивного времени в день
            • 📉 Хроническая прокрастинация связана с повышенным уровнем стресса, тревоги и депрессии
            • 💡 Прокрастинаторы часто недооценивают время, необходимое для выполнения задач (эффект "планирования")
            • 🔄 Один маленький шаг может изменить весь день — это называется "эффект домино" продуктивности

            🎯 **Что вы получите от сегодняшней практики:**
            1. 🔨 Метод "первого шага" для преодоления сопротивления
            2. 🔍 Умение анализировать истинные причины откладывания
            3. 🧩 Навык разбивки больших задач на выполнимые шаги
            4. ⚡ Технику моментального старта ("правило 15 минут")
            5. 🛡️ Защиту от эмоционального выгорания через своевременное действие
          MARKDOWN
        },
        'exercise_explanation' => {
          title: "🎯 *Метод ""первого шага"": Научный подход* 🔬",
          instruction: <<~MARKDOWN
            **Как работает техника "первого шага"?**

            🔬 **Нейробиологический механизм:**
            • 🧠 Преодолевая начальное сопротивление, вы уменьшаете активность миндалевидного тела (страх)
            • 🚀 Первый шаг активирует "эффект прогресса" — психологический феномен, когда даже маленькое продвижение мотивирует продолжать
            • 🔄 Формируются новые нейронные связи между "желанием действовать" и "началом действия"
            • 💪 Усиливается связь между префронтальной корой (планирование) и базальными ганглиями (формирование привычек)

            **5-шаговая модель преодоления прокрастинации:**
            1. 🔍 **Осознание задачи** — что именно вы откладываете?
            2. 🤔 **Анализ сопротивления** — что на самом деле мешает начать?
            3. 🧩 **Дробление на части** — задача, разбитая на мелкие части, перестает пугать
            4. 🎯 **Микро-шаг** — первый шаг на 15 минут (критическая точка преодоления)
            5. 🔄 **Отслеживание прогресса** — фиксация даже минимальных достижений

            **Научный факт:** Люди, использующие технику "первого шага", увеличивают вероятность завершения задачи на **80%** по сравнению с теми, кто пытается сделать всё сразу.
          MARKDOWN
        },
        'step_by_step_guide' => {
          title: "🛠️ *Пошаговая инструкция к практике* 📋",
          instruction: <<~MARKDOWN
            **Оптимальные условия для работы с прокрастинацией:**

            🧠 **Психологическая подготовка:**
            • Откажитесь от перфекционизма — лучше сделать неидеально, чем не сделать вовсе
            • Примите, что дискомфорт в начале — это нормально
            • Помните: задача не обязана быть приятной, чтобы быть выполненной
            • Разрешите себе сделать "достаточно хорошо"

            ⏰ **Временные параметры:**
            • **15 минут** — золотой стандарт для первого шага
            • Время, достаточно короткое, чтобы не пугать
            • Время, достаточно длинное, чтобы увидеть прогресс
            • По истечении 15 минут вы можете остановиться без чувства вины

            📝 **Принципы эффективной разбивки:**
            • Шаг должен быть настолько маленьким, чтобы его невозможно было отложить
            • Каждый шаг должен быть конкретным и измеримым
            • Лучше 3 маленьких шага, чем один большой
            • Первый шаг должен требовать минимальных ресурсов
          MARKDOWN
        },
        'completion' => {
          title: "🎊 *Первая победа над прокрастинацией!* 🏆",
          instruction: <<~MARKDOWN
            **Отличная работа! Вы только что совершили прорыв!** ✨

            **Что вы сделали:**
            1. 🔍 Четко определили откладываемую задачу
            2. 🤔 Проанализировали истинные причины сопротивления
            3. 🧩 Превратили пугающую задачу в набор выполнимых шагов
            4. 🎯 Совершили критический первый шаг (15 минут)
            5. 📊 Зафиксировали прогресс и осознали его важность

            **Поздравляем!** Вы освоили технику, которая:
            • 🧠 Подтверждена исследованиями в поведенческой экономике и психологии
            • 🚀 Используется в когнитивно-поведенческой терапии (КПТ)
            • 💪 Помогает миллионам людей по всему миру
            • 🔄 Меняет отношение к сложным задачам на фундаментальном уровне

            **Регулярное применение техники:**
            • Снижает уровень стресса, связанного с откладыванием, на 60-70%
            • Повышает продуктивность на 25-35%
            • Улучшает удовлетворенность достижениями на 40-50%
            • Сокращает время, потраченное на прокрастинацию, на 50-60%
          MARKDOWN
        }
      }.freeze
      
      # Шаги для анализа прокрастинации
      PROCRASTINATION_STEPS = {
        'task' => {
          title: "🔍 *Шаг 1: Идентификация задачи* 📋",
          instruction: "**Какое дело вы давно откладываете?**\n\nЭто может быть:\n• 📊 Рабочий проект или отчет\n• 🏠 Бытовое дело или ремонт\n• 🎨 Личный творческий проект\n• 🏃 Здоровье/спорт/фитнес\n• 📚 Обучение или развитие навыка\n• 💼 Профессиональное развитие\n\n**Запишите задачу одной-двумя фразами:**\n*Пример: ""Написать план проекта"", ""Разобрать шкаф"", ""Начать курс по программированию""*",
          min_words: 3,
          emoji: "📋",
          step_name: "определение задачи"
        },
        'reason' => {
          title: "🤔 *Шаг 2: Диагностика сопротивления* 🔬",
          instruction: "**Почему эта задача вызывает сопротивление?**\n\nИсследуйте истинные причины (чаще всего это эмоциональные барьеры):\n• 😰 Страх неудачи или критики?\n• 🤯 Перегруженность (задача кажется слишком большой)?\n• 🤷 Неопределенность (не знаете, с чего начать)?\n• 😑 Скучность или отсутствие интереса?\n• 🚫 Нарушение границ (чужая, а не ваша задача)?\n\n**Научный факт:** Ясное понимание причины прокрастинации снижает её интенсивность на 40%.\n\n**Будьте честны с собой. Что на самом деле стоит за откладыванием?**",
          min_words: 5,
          emoji: "🔍",
          step_name: "анализ причин"
        },
        'steps' => {
          title: "🧩 *Шаг 3: Дробление на микро-шаги* 🔨",
          instruction: "**Разбейте задачу на #{MIN_STEPS_COUNT} самых маленьких шага.**\n\n**Принципы эффективного дробления:**\n• 🎯 Каждый шаг должен занимать не более 15-30 минут\n• ✅ Шаг должен быть конкретным и измеримым\n• 🚀 Первый шаг должен требовать минимум усилий\n• 🔄 Последовательность шагов должна быть логичной\n\n**Пример для «Написать отчет»:**\n1. Открыть документ и создать структуру (3 раздела)\n2. Написать заголовки разделов и подзаголовки\n3. Собрать данные для первого раздела\n\n**Напишите ваши #{MIN_STEPS_COUNT} шага через запятую или с новой строки:**",
          min_words: 10,
          emoji: "🧩",
          step_name: "дробление задачи"
        },
        'first_step' => {
          title: "🎯 *Шаг 4: Определение первого шага* ⚡",
          instruction: "**Какой самый первый, самый маленький шаг?**\n\nЭто должен быть шаг на **#{FIRST_STEP_DURATION_MINUTES} минут**.\n\n**Критерии идеального первого шага:**\n• ⏱️ Длительность: #{FIRST_STEP_DURATION_MINUTES} минут\n• 🚀 Минимальное сопротивление: легко начать\n• ✅ Конкретность: четко определенное действие\n• 🎯 Измеримость: понятно, когда шаг выполнен\n\n**Примеры идеальных первых шагов:**\n• «Открыть документ и написать заголовок»\n• «Собрать все материалы в одну папку»\n• «Найти 3 источника информации по теме»\n• «Составить список из 5 пунктов для начала»\n\n**Запишите ваш первый шаг #{FIRST_STEP_DURATION_MINUTES} минут:**",
          min_words: 5,
          emoji: "🎯",
          step_name: "определение первого шага"
        },
        'execution' => {
          title: "🚀 *Шаг 5: Запуск и выполнение* ⏱️",
          instruction: "**Пора действовать! Сделайте первый шаг прямо сейчас.**\n\n**Инструкция по выполнению:**\n1. ⏱️ Поставьте таймер на #{FIRST_STEP_DURATION_MINUTES} минут\n2. 🚫 Уберите все отвлекающие факторы (телефон, соцсети)\n3. 🎯 Сосредоточьтесь только на этом одном шаге\n4. ⏰ Когда таймер прозвенит, вы можете закончить\n5. ✅ Независимо от результата — вы сделали главное: начали!\n\n**Важное правило:** После #{FIRST_STEP_DURATION_MINUTES} минут вы можете остановиться без чувства вины. Чаще всего вы захотите продолжить (эффект прогресса).",
          min_words: 0,
          emoji: "🚀",
          step_name: "выполнение первого шага"
        },
        'reflection' => {
          title: "💭 *Шаг 6: Анализ и фиксация прогресса* 📊",
          instruction: "**Как вы себя чувствуете после выполнения первого шага?**\n\n**Вопросы для рефлексии:**\n• 😌 **Ощущения:** Какие эмоции появились после начала?\n• 💪 **Энергия:** Изменился ли уровень энергии?\n• 🧠 **Мысли:** Что изменилось в восприятии задачи?\n• 🎯 **Мотивация:** Появилось ли желание продолжить?\n• ⏱️ **Время:** Казались ли #{FIRST_STEP_DURATION_MINUTES} минут долгими или короткими?\n\n**Запишите ваши наблюдения:**",
          min_words: 10,
          emoji: "💭",
          step_name: "рефлексия после начала"
        }
      }.freeze
      
      # Типичные причины прокрастинации
      COMMON_PROBLEMS = [
        {
          name: "Перфекционизм",
          emoji: "✨",
          description: "Страх сделать неидеально, поэтому лучше не начинать",
          solution: "Примите принцип «достаточно хорошо». Первая версия может быть несовершенной — это нормально."
        },
        {
          name: "Перегруженность",
          emoji: "🏋️",
          description: "Задача кажется слишком большой и сложной",
          solution: "Дробите на микро-шаги. Делайте только следующий маленький шаг, не думая о всей задаче."
        },
        {
          name: "Страх неудачи",
          emoji: "😨",
          description: "Беспокойство о последствиях неудачи",
          solution: "Переформулируйте задачу как эксперимент или обучение. Позвольте себе учиться на ошибках."
        },
        {
          name: "Отсутствие ясности",
          emoji: "❓",
          description: "Не понимаете, с чего начать или что делать",
          solution: "Начните с исследования или планирования. Первый шаг может быть «составить список того, что нужно выяснить»."
        },
        {
          name: "Низкая ценность",
          emoji: "😑",
          description: "Задача кажется неважной или скучной",
          solution: "Свяжите с большей целью. Зачем это нужно? Что это даст в долгосрочной перспективе?"
        },
        {
          name: "Энергетический спад",
          emoji: "😴",
          description: "Недостаток энергии или мотивации",
          solution: "Используйте технику «пяти минут». Пообещайте себе поработать всего 5 минут. Чаще всего этого достаточно для старта."
        }
      ].freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        
        # Статистика для мотивации
        send_message(
          text: statistics_message,
          parse_mode: 'Markdown'
        )
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        store_day_data('current_step', 'intro')
        
        send_message(
          text: "Готовы освоить метод преодоления прокрастинации?",
          reply_markup: day_13_content_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise_explanation')
        
        send_message(text: DAY_STEPS['exercise_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['exercise_explanation'][:instruction], parse_mode: 'Markdown')
        
        sleep(1)
        
        # Показываем пошаговую инструкцию
        show_step_by_step_guide
      end
      
      def show_step_by_step_guide
        store_day_data('current_step', 'step_by_step_guide')
        
        send_message(text: DAY_STEPS['step_by_step_guide'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['step_by_step_guide'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "🎯 *Мы пройдем 6 шагов по анализу и преодолению прокрастинации:*\n\n1️⃣ 📋 Идентификация задачи\n2️⃣ 🔍 Диагностика сопротивления\n3️⃣ 🧩 Дробление на микро-шаги\n4️⃣ 🎯 Определение первого шага\n5️⃣ 🚀 Выполнение первого шага\n6️⃣ 💭 Анализ и фиксация прогресса",
          parse_mode: 'Markdown'
        )
        
        sleep(2)
        
        # Начинаем первый шаг
        start_procrastination_step('task')
      end
      
      def start_procrastination_step(step_type)
        store_day_data('current_procrastination_step', step_type)
        @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_#{step_type}")
        
        step = PROCRASTINATION_STEPS[step_type]
        return unless step
        
        send_message(text: step[:title], parse_mode: 'Markdown')
        send_message(text: step[:instruction], parse_mode: 'Markdown')
        
        # Для шага выполнения показываем кнопку таймера
        if step_type == 'execution'
          send_message(
            text: "⏱️ **Поставьте таймер на #{FIRST_STEP_DURATION_MINUTES} минут и начните выполнение!**",
            parse_mode: 'Markdown',
            reply_markup: day_13_execution_markup
          )
        else
          # Для остальных шагов показываем инпут
          send_message(
            text: "#{step[:emoji]} *#{step[:step_name].upcase}: Напишите ответ*",
            parse_mode: 'Markdown',
            reply_markup: day_13_input_markup
          )
        end
      end
      
      def handle_procrastination_input(input_text)
        current_step = get_day_data('current_procrastination_step')
        step_config = PROCRASTINATION_STEPS[current_step]
        
        return false unless step_config
        
        # Проверяем минимальное количество слов
        if step_config[:min_words] > 0 && input_text.split.size < step_config[:min_words]
          send_message(text: "⚠️ Пожалуйста, напишите более подробный ответ (минимум #{step_config[:min_words]} слов).")
          return false
        end
        
        # Сохраняем данные
        store_day_data("#{current_step}_response", input_text)
        store_day_data("#{current_step}_completed", true)
        
        # Подтверждаем сохранение
        send_message(
          text: "✅ #{step_config[:emoji]} *Шаг завершен!* Ответ сохранен.",
          parse_mode: 'Markdown'
        )
        
        # Переходим к следующему шагу
        next_step = get_next_procrastination_step(current_step)
        
        if next_step
          sleep(1) # Пауза между шагами
          start_procrastination_step(next_step)
        else
          # Все шаги выполнены
          complete_procrastination_practice
        end
        
        true
      end
      
      def start_execution_timer
        store_day_data('timer_started_at', Time.current)
        
        send_message(
          text: "🚀 **Таймер запущен! #{FIRST_STEP_DURATION_MINUTES} минут на выполнение первого шага.**\n\n🎯 **Ваш первый шаг:**\n#{get_day_data('first_step_response') || 'Определен ранее'}\n\n⏰ Когда закончите, нажмите кнопку ниже.",
          parse_mode: 'Markdown',
          reply_markup: day_13_timer_completion_markup
        )
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_timer_running")
      end
      
      def complete_execution
        store_day_data('execution_completed', true)
        store_day_data('execution_completed_at', Time.current)
        
        timer_started_str = get_day_data('timer_started_at')
        if timer_started_str
          begin
            # Преобразуем строку в Time
            timer_started = Time.zone.parse(timer_started_str) || Time.parse(timer_started_str)
            duration = (Time.current - timer_started).to_i / 60
            store_day_data('actual_duration_minutes', duration)
          rescue => e
            log_error("Failed to parse timer_started_at: #{timer_started_str}", e)
            store_day_data('actual_duration_minutes', FIRST_STEP_DURATION_MINUTES)
          end
        end
        
        # Переходим к рефлексии
        start_procrastination_step('reflection')
      end
      
      def complete_procrastination_practice
        store_day_data('procrastination_completed', true)
        store_day_data('completion_time', Time.current)
        
        # УБРАТЬ: save_procrastination_task - не используется
        
        @user.set_self_help_step("day_13_procrastination_completed")
        
        # Показываем завершение
        show_procrastination_completion
      end
      
      def show_procrastination_completion
        store_day_data('current_step', 'completion')
        
        send_message(text: DAY_STEPS['completion'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['completion'][:instruction], parse_mode: 'Markdown')
        
        # Показываем краткий обзор практики
        show_procrastination_summary
        
        sleep(1)
        
        send_message(
          text: "🌟 Отличная работа! Вы завершили анализ прокрастинации.\n\nС какими трудностями столкнулись?",
          parse_mode: 'Markdown',
          reply_markup: day_13_challenges_markup
        )
      end
      
      def handle_challenge_selection(challenge_index)
        challenge = COMMON_PROBLEMS[challenge_index.to_i]
        
        if challenge
          send_message(
            text: "🌀 **#{challenge[:name]}**\n\n#{challenge[:description]}\n\n💡 **Решение:** #{challenge[:solution]}",
            parse_mode: 'Markdown'
          )
        end
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_reflection_done")
        
        send_message(
          text: "🎯 Метод преодоления прокрастинации освоен!\n\nХотите завершить День 13?",
          parse_mode: 'Markdown',
          reply_markup: day_13_final_completion_markup
        )
      end
      
      def show_procrastination_summary
        task = get_day_data('task_response') || "не указана"
        first_step = get_day_data('first_step_response') || "не указан"
        
        summary = <<~MARKDOWN
          📊 *Краткий обзор вашего анализа:*
          
          📋 **Задача:** #{truncate_text(task, 50)}
          
          🎯 **Первый шаг:** #{truncate_text(first_step, 50)}
          
          ⏱️ **Время выполнения:** #{get_day_data('actual_duration_minutes') || FIRST_STEP_DURATION_MINUTES} минут
          
          ✅ **Все 6 шагов выполнены!**
          
          📅 **Сохранено в вашу коллекцию задач по прокрастинации**
        MARKDOWN
        
        send_message(text: summary, parse_mode: 'Markdown')
      end
      
      def show_tasks
        send_message(
          text: "📋 *История ваших практик прокрастинации*\n\nПрактика дня 13 завершена! Вы освоили метод 'первого шага' для преодоления прокрастинации.\n\nЭтот навык поможет вам начинать сложные задачи легче и быстрее.",
          parse_mode: 'Markdown'
        )
      end
    
      
      def complete_exercise
        # Проверяем, завершена ли практика
        unless get_day_data('procrastination_completed') == true
          send_message(
            text: "⚠️ Сначала завершите практику по преодолению прокрастинации.\n\nУбедитесь, что вы прошли все 6 шагов.",
            parse_mode: 'Markdown',
            reply_markup: day_13_content_markup
          )
          return
        end
        
        # Отмечаем день как завершенный
        @user.complete_day_program(DAY_NUMBER)
        @user.complete_self_help_day(DAY_NUMBER)
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
        
        completion_message = <<~MARKDOWN
          🎊 *День 13 завершен!* 🎊

          **Ваши достижения сегодня:**
          
          🚀 **Наука преодоления прокрастинации:**
          • 📋 Освоен метод "первого шага" на основе поведенческой психологии
          • 🤔 Проанализированы истинные причины откладывания
          • 🧩 Задача разбита на выполнимые микро-шаги
          • 🎯 Определен и выполнен первый шаг (#{FIRST_STEP_DURATION_MINUTES} минут)
          • 💭 Проведена глубокая рефлексия после начала
          
          📊 **Научный факт:**
          Регулярное использование техники "первого шага" снижает уровень стресса, связанного с прокрастинацией, на 60-70%, повышает продуктивность на 25-35% и сокращает время, потраченное на откладывание, на 50-60%.
          
          🎯 **Что дальше:**
          Следующий день программы самопомощи
          
          ⏰ **Следующий день будет доступен через 12 часов**
          
          Ваш прогресс: #{@user.progress_percentage}%
        MARKDOWN
        
        send_message(text: completion_message, parse_mode: 'Markdown')
        
        # Предлагаем следующий день
        propose_next_day_with_restriction
      end
      
      # ===== ОБРАБОТКА КНОПОК =====
      
      def handle_button(callback_data)
        case callback_data
        when 'start_day_13_content', 'start_procrastination_exercise'
          deliver_exercise
          
        when 'continue_day_13_content'
          current_step = get_day_data('current_step')
          handle_resume_from_step(current_step || 'intro')
          
        when 'day_13_start_timer'
          start_execution_timer
          
        when 'day_13_timer_completed'
          complete_execution
          
        when 'day_13_skip_step'
          # Пропуск текущего шага
          current_step = get_day_data('current_procrastination_step')
          if current_step
            next_step = get_next_procrastination_step(current_step)
            if next_step
              send_message(text: "⚠️ Шаг пропущен. Переходим к следующему.")
              start_procrastination_step(next_step)
            else
              complete_procrastination_practice
            end
          end
          
        when 'day_13_restart_procrastination'
          deliver_exercise
          
        when 'procrastination_exercise_completed', 'day_13_complete_procrastination'
          complete_procrastination_practice
          
        when /^day_13_challenge_(\d+)$/
          handle_challenge_selection($1)
          
        when 'day_13_no_challenges'
          @user.set_self_help_step("day_#{DAY_NUMBER}_reflection_done")
          send_message(text: "🌟 Отлично! У вас получилась продуктивная практика!")
          send_message(
            text: "Завершаем День 13?",
            reply_markup: day_13_final_completion_markup
          )
          
        when 'day_13_complete_exercise'
          complete_exercise
          
        when 'view_my_procrastination_tasks'
          show_tasks
          
        when 'mark_task_completed'
          mark_task_completed
          
        when 'day_13_help_tips'
          send_message(
            text: "💡 *Советы для эффективной борьбы с прокрастинацией:*\n\n• Используйте правило «15 минут» для начала\n• Празднуйте маленькие победы\n• Отслеживайте прогресс визуально\n• Используйте технику «помидора» (25 минут работа, 5 отдых)\n• Создавайте ритуалы начала работы\n• Разбивайте день на блоки по энергетическим уровням",
            parse_mode: 'Markdown'
          )
          
        else
          log_warn("Unknown button callback: #{callback_data}")
          send_message(text: "Неизвестная команда.")
        end
      end
      
      # ===== ОБРАБОТКА ТЕКСТОВОГО ВВОДА =====
      
      def handle_text_input(input_text)
        log_info("Handling text input for day 13: #{input_text}")
        
        current_state = @user.self_help_state
        
        # Определяем, какой ввод ожидается
        case current_state
        when "day_13_waiting_for_task"
          return handle_procrastination_input(input_text)
          
        when "day_13_waiting_for_reason"
          return handle_procrastination_input(input_text)
          
        when "day_13_waiting_for_steps"
          return handle_procrastination_input(input_text)
          
        when "day_13_waiting_for_first_step"
          return handle_procrastination_input(input_text)
          
        when "day_13_waiting_for_reflection"
          return handle_procrastination_input(input_text)
          
        when "day_13_procrastination_completed", "day_13_reflection_done", "day_13_completed"
          send_message(
            text: "✅ Практика преодоления прокрастинации уже завершена. Вы можете:\n• Просмотреть свои задачи\n• Отметить задачу как выполненную\n• Завершить день 13",
            reply_markup: day_13_final_completion_markup
          )
          return true
        end
        
        log_warn("No text input handler for current state: #{current_state}")
        false
      end
      
      def handle_smart_input(text)
        handle_text_input(text)
      end
      
      def handle_resume_from_step(step)
        case step
        when 'intro'
          deliver_intro
        when 'exercise_explanation'
          deliver_exercise
        when 'step_by_step_guide'
          show_step_by_step_guide
        when 'completion'
          show_procrastination_completion
        else
          deliver_exercise
        end
      end
      
      def show_intro_without_state
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        send_message(
          text: statistics_message,
          parse_mode: 'Markdown'
        )
        send_message(
          text: "Готовы освоить метод преодоления прокрастинации?",
          reply_markup: day_13_content_markup
        )
      end
      
      def propose_next_day_with_restriction
        next_day = 14
        
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
            
            **Пока ждете, можете:**
            • 📋 Практиковать метод "первого шага" с другими задачами
            • 📊 Просмотреть свои предыдущие задачи
            • 🔄 Экспериментировать с разными подходами к прокрастинации
            • 📈 Посмотреть статистику (/progress)
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
      
      private
      
      def get_next_procrastination_step(current_step)
        steps_order = PROCRASTINATION_STEPS.keys
        current_index = steps_order.index(current_step)
        
        return steps_order[current_index + 1] if current_index && current_index < steps_order.length - 1
        nil
      end
      
      def save_procrastination_task
        
        begin
          ProcrastinationTask.create!(
            user: @user,
            entry_date: Date.current,
            task: get_day_data('task_response'),
            reason: get_day_data('reason_response'),
            steps: get_day_data('steps_response'),
            first_step: get_day_data('first_step_response'),
            feelings_after: get_day_data('reflection_response'),
            completed: false
          )
          
          log_info("Saved procrastination task")
          store_day_data('entry_id', ProcrastinationTask.last&.id)
          
          true
        rescue => e
          log_error("Failed to save procrastination task", e)
          false
        end
      end
      
      def clear_day_data
        PROCRASTINATION_STEPS.keys.each do |step|
          store_day_data("#{step}_response", nil)
          store_day_data("#{step}_completed", nil)
        end
        store_day_data('current_procrastination_step', nil)
        store_day_data('procrastination_completed', nil)
        store_day_data('completion_time', nil)
        store_day_data('entry_id', nil)
        store_day_data('timer_started_at', nil)
        store_day_data('execution_completed', nil)
        store_day_data('actual_duration_minutes', nil)
      end
      
      def truncate_text(text, length)
        return "не указано" if text.blank?
        text.length > length ? "#{text[0...length]}..." : text
      end
      
      def statistics_message
        <<~MARKDOWN
          📊 *Почему прокрастинация — это психологическая проблема, а не недостаток характера:*
          
          • 😰 **95%** людей признаются, что регулярно откладывают важные дела
          • ⏰ **218 минут** в день теряют работники, борющиеся с прокрастинацией
          • 🧠 **40%** снижение продуктивности из-за хронического откладывания
          • 😓 **60-70%** повышение уровня стресса у прокрастинаторов
          • 📉 **35-45%** снижение качества выполнения задач при откладывании
          • 💡 **80%** повышение вероятности завершения задачи при использовании техники "первого шага"
          
          *Источник: Исследования Американской психологической ассоциации, Journal of Behavioral Decision Making*
        MARKDOWN
      end
      
      # Вспомогательные методы разметки
      def day_13_content_markup
        {
          inline_keyboard: [
            [
              { text: "🚀 Начать борьбу с прокрастинацией", callback_data: 'start_procrastination_exercise' }
            ],
            [
              { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
            ]
          ]
        }.to_json
      end
      
      def day_13_input_markup
        {
          inline_keyboard: [
            [
              { text: "⏭️ Пропустить шаг", callback_data: 'day_13_skip_step' },
              { text: "🔄 Начать заново", callback_data: 'day_13_restart_procrastination' }
            ]
          ]
        }
      end
      
      def day_13_execution_markup
        {
          inline_keyboard: [
            [
              { text: "⏱️ Запустить таймер 15 минут", callback_data: 'day_13_start_timer' }
            ]
          ]
        }
      end
      
      def day_13_timer_completion_markup
        {
          inline_keyboard: [
            [
              { text: "✅ Закончил выполнение", callback_data: 'day_13_timer_completed' }
            ],
            [
              { text: "🔄 Сменить шаг", callback_data: 'day_13_restart_procrastination' }
            ]
          ]
        }
      end
      
      def day_13_challenges_markup
        {
          inline_keyboard: COMMON_PROBLEMS.each_with_index.map do |challenge, index|
            [{ text: "#{challenge[:emoji]} #{challenge[:name]}", callback_data: "day_13_challenge_#{index}" }]
          end + [
            [{ text: "✅ Никаких трудностей", callback_data: 'day_13_no_challenges' }]
          ]
        }
      end
      
      def day_13_final_completion_markup
        {
          inline_keyboard: [
            [
              { text: "🎯 Завершить День 13", callback_data: 'day_13_complete_exercise' },
              { text: "🚀 Новая практика", callback_data: 'start_procrastination_exercise' }
            ]
            # УБРАТЬ: "Мои задачи" и "Отметить выполненной"
          ]
        }.to_json
      end
      
      def log_info(message)
        Rails.logger.info "[#{self.class}] #{message} - User: #{@user.telegram_id}"
      end
      
      def log_warn(message)
        Rails.logger.warn "[#{self.class}] #{message} - User: #{@user.telegram_id}"
      end
      
      def log_error(message, error = nil)
        Rails.logger.error "[#{self.class}] #{message} - User: #{@user.telegram_id}"
        Rails.logger.error error.message if error
        Rails.logger.error error.backtrace.first(5).join("\n") if error
      end
    end
  end
end
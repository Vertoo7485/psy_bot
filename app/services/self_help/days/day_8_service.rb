# app/services/self_help/days/day_8_service.rb
module SelfHelp
  module Days
    class Day8Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 8
      
      # Шаги дня 8
      DAY_STEPS = {
        'intro' => {
          title: "🎉 *ВТОРАЯ НЕДЕЛЯ: МАСТЕРСТВО РАБОТЫ С МЫСЛЯМИ* 🧠",
          instruction: <<~MARKDOWN
            *Добро пожаловать во вторую неделю программы самопомощи!* 🌟

            **Неделя 1:** Вы освоили основы осознанности, благодарности и отдыха.  
            **Неделя 2:** Мы углубимся в работу с мыслями и эмоциями.

            🎯 **Чему вы научитесь на этой неделе:**
            1. 🛑 **День 8:** Техника «Остановка мыслей» - контролируем навязчивые мысли
            2. 🧠 **День 9:** Когнитивная работа - анализируем тревожные мысли
            3. 💖 **День 10:** Эмоциональный интеллект - понимаем свои эмоции
            4. 🌍 **День 11:** Заземление - возвращаемся в настоящее
            5. 🤗 **День 12:** Доброта к себе - практика самосострадания
            6. 🚀 **День 13:** Преодоление прокрастинации - действуем без откладывания

            📊 **Научные факты о работе с мыслями:**
            • 🧠 80% наших мыслей повторяются изо дня в день
            • 😌 Осознанное управление мыслями снижает тревожность на 40-60%
            • 💡 Изменение мыслей изменяет мозговую активность за 6-8 недель
            • 🛡️ Регулярная практика создает новые нейронные пути
            • 🔄 Мысли - это навык, который можно развивать

            **Сегодня: День 8 - Техника «Остановка мыслей»** 🛑
          MARKDOWN
        },
        'day_intro' => {
          title: "🧠 *День 8: Техника «Остановка мыслей»* 🛑",
          instruction: <<~MARKDOWN
            **Добро пожаловать в мир управления мышлением!** 💭

            Сегодня вы освоите мощную технику контроля над навязчивыми и тревожными мыслями.

            📊 **Научные факты о технике остановки мыслей:**
            • 🧠 Снижает активность миндалины (центр страха) на 25-30%
            • 😌 Уменьшает руминацию (мысленную жвачку) на 40-50%
            • 💡 Повышает концентрацию внимания на 20-25%
            • 🛡️ Эффективна при ОКР, тревоге и ПТСР по данным исследований
            • 🔄 Перепрограммирует нейронные пути за 6-8 недель практики
            • ⏱️ Первые результаты заметны уже через 2-3 применения

            🎯 **Что вы получите от сегодняшней практики:**
            1. 🛑 Навык остановки негативного мыслительного потока
            2. 🔄 Умение переключать фокус внимания по команде
            3. 😌 Чувство контроля над собственными мыслями
            4. 💪 Укрепление когнитивной гибкости
            5. 🛡️ Защиту от эмоционального истощения
          MARKDOWN
        },
        'exercise_explanation' => {
          title: "🛑 *Техника «Остановка мыслей»: Полный алгоритм* 📋",
          instruction: <<~MARKDOWN
            **Как работает техника остановки мыслей?** 🔄

            Когда мы сознательно прерываем негативную мысль, мы создаем новые нейронные связи:

            • 🧠 **Нейробиологический эффект:** Активирует префронтальную кору (контроль) и подавляет активность миндалины
            • 🔄 **Когнитивная польза:** Прерывает паттерн руминации и создает пространство для выбора реакции
            • 😌 **Эмоциональный баланс:** Снижает интенсивность негативных эмоций
            • 💡 **Поведенческий эффект:** Предотвращает эскалацию тревоги
            • ⏱️ **Практичность:** Занимает всего 30-60 секунд

            **4-шаговый алгоритм остановки мыслей:**
            1. 👁️ **Осознание** - Замечаем мысль без погружения
            2. 🛑 **Команда** - Даем четкий сигнал "СТОП!"
            3. 🔄 **Переключение** - Немедленно переводим внимание
            4. 🎯 **Закрепление** - Удерживаем новое фокусное состояние

            **Сегодняшнее упражнение:** Практика полного 4-шагового алгоритма.
            Цель — не подавить мысли, а научиться управлять ими.
          MARKDOWN
        },
        'practice_guidance' => {
          title: "📋 *Подготовка к практике остановки мыслей* 🧘",
          instruction: <<~MARKDOWN
            **Оптимальные условия для практики:**

            🧠 **Ментальная настройка:**
            • Выберите нейтральную или умеренно тревожную мысль для практики
            • Не начинайте с самых пугающих мыслей
            • Будьте добры к себе — это навык, требующий практики
            • Откажитесь от ожидания совершенства

            🛑 **Стоп-сигналы (выберите один):**
            • Громкое мысленное "СТОП!" 
            • Представление красного стоп-знака
            • Щелчок пальцами или хлопок в ладоши
            • Резкий звук (можно использовать будильник)
            • Любой четкий, однозначный сигнал

            🔄 **Стратегии переключения (подготовьте заранее):**
            • Дыхательное упражнение
            • Физическая активность
            • Сенсорное внимание (5-4-3-2-1)
            • Когнитивная задача (счет, алфавит)

            **Важно:** Успех зависит от скорости переключения после команды "СТОП!"
          MARKDOWN
        },
        'post_practice_reflection' => {
          title: "📝 *Рефлексия после практики* 💭",
          instruction: <<~MARKDOWN
            **Отличная работа! Вы только что завершили практику остановки мыслей!** 🌟

            **Вопросы для рефлексии:**

            🛑 **1. О процессе остановки:**
            • Насколько четко сработала команда "СТОП"?
            • Как быстро удалось переключить внимание?
            • Что чувствовали в момент остановки мысли?
            • Было ли сопротивление или трудности?

            🔄 **2. О переключении внимания:**
            • Насколько эффективно сработало переключение?
            • Удалось ли удержать новое фокусное состояние?
            • Как долго продержалось состояние после переключения?
            • Какие стратегии переключения были наиболее эффективны?

            🧠 **3. Об общем эффекте:**
            • Как изменилось эмоциональное состояние после практики?
            • Чувствуете ли вы больше контроля над мыслями?
            • Какие инсайты пришли в процессе?
            • Готовы ли применять технику в реальных ситуациях?
          MARKDOWN
        }
      }.freeze
      
      # Типы стоп-сигналов
      STOP_SIGNALS = [
        {
          name: "Мысленная команда",
          emoji: "🗣️",
          description: "Громкое и четкое мысленное «СТОП!». Просто, эффективно, доступно всегда.",
          instructions: "Мысленно прокричите «СТОП!» как можно громче и увереннее"
        },
        {
          name: "Визуальный образ",
          emoji: "🛑",
          description: "Представьте большой красный знак «СТОП» или воображаемую стену.",
          instructions: "Ярко представьте красный стоп-знак, блокирующий мысль"
        },
        {
          name: "Физический сигнал",
          emoji: "👏",
          description: "Хлопок в ладоши, щелчок пальцами, легкий щипок себя за руку.",
          instructions: "Сделайте резкий физический жест одновременно с мысленной командой"
        },
        {
          name: "Звуковой сигнал",
          emoji: "🔊",
          description: "Резкий звук (можно использовать будильник, таймер или просто сказать вслух).",
          instructions: "Используйте звук как триггер для остановки мыслительного процесса"
        },
        {
          name: "Дыхательный стоп",
          emoji: "🌬️",
          description: "Резкий вдох и задержка дыхания на 2-3 секунды.",
          instructions: "Сделайте резкий вдох и задержите дыхание, фокусируясь на остановке"
        },
        {
          name: "Движение-стоп",
          emoji: "✋",
          description: "Резкий жест рукой «стоп» или вставание/смена позы.",
          instructions: "Совместите мысленную команду с резким изменением положения тела"
        }
      ].freeze
      
      # Стратегии переключения внимания
      DISTRACTION_STRATEGIES = [
        {
          name: "Дыхание 4-7-8",
          emoji: "🌬️",
          description: "4 секунды вдох → 7 секунд задержка → 8 секунд выдох.",
          duration: "2-3 минуты",
          effectiveness: "Высокая, успокаивает нервную систему"
        },
        {
          name: "Сенсорное сканирование",
          emoji: "👁️",
          description: "5 вещей вижу → 4 вещи слышу → 3 вещи чувствую → 2 запаха → 1 вкус.",
          duration: "1-2 минуты",
          effectiveness: "Очень высокая, полностью переключает фокус"
        },
        {
          name: "Физическая активность",
          emoji: "🏃",
          description: "10 приседаний, прыжки, растяжка, прогулка по комнате.",
          duration: "2-3 минуты",
          effectiveness: "Высокая, использует мышечную память"
        },
        {
          name: "Счет или алфавит",
          emoji: "🔢",
          description: "Счет от 100 назад через 3, перечисление городов на букву А и т.д.",
          duration: "1-2 минуты",
          effectiveness: "Средняя, требует когнитивных усилий"
        },
        {
          name: "Креативная задача",
          emoji: "🎨",
          description: "Нарисовать что-то, сочинить рифму, придумать историю.",
          duration: "3-5 минут",
          effectiveness: "Высокая, полностью поглощает внимание"
        },
        {
          name: "Внешний фокус",
          emoji: "🌳",
          description: "Рассмотреть узор на обоях, облака, детали предмета.",
          duration: "1-2 минуты",
          effectiveness: "Средняя, зависит от окружения"
        }
      ].freeze
      
      # Типичные трудности
      COMMON_CHALLENGES = [
        {
          challenge: "Мысль возвращается сразу после остановки",
          emoji: "🌀",
          solution: "Это нормально! Увеличьте скорость переключения. Подготовьте стратегию переключения ЗАРАНЕЕ, чтобы сразу применить."
        },
        {
          challenge: "Чувствую себя глупо, говоря «СТОП»",
          emoji: "😳",
          solution: "Начните с мысленной команда. Помните: эффективность важнее, чем то, как это выглядит со стороны."
        },
        {
          challenge: "Не могу выбрать подходящую мысль для практики",
          emoji: "🤔",
          solution: "Начните с нейтральной мысли (например, «Что я буду есть на ужин?»). Не нужно начинать с самых трудных."
        },
        {
          challenge: "Стоп-сигнал не срабатывает",
          emoji: "🔄",
          solution: "Попробуйте другой тип стоп-сигнала. Иногда физический жест работает лучше, чем мысленная команда."
        }
      ].freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        # Шаг 1: Вступление во вторую неделю
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        
        # Шаг 2: Вступление дня 8
        send_message(text: DAY_STEPS['day_intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['day_intro'][:instruction], parse_mode: 'Markdown')
        
        # Статистика для мотивации
        send_message(
          text: statistics_message,
          parse_mode: 'Markdown'
        )
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        store_day_data('current_step', 'intro')
        
        send_message(
          text: "Готовы освоить технику управления мыслями и начать вторую неделю?",
          reply_markup: day_8_content_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise_explanation')
        
        send_message(text: DAY_STEPS['exercise_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['exercise_explanation'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "🛑 **Выберите тип стоп-сигнала для практики:**",
          parse_mode: 'Markdown',
          reply_markup: day_8_stop_signals_markup
        )
      end
      
      # Обработка выбора стоп-сигнала
      def handle_stop_signal_selection(signal_index)
        signal = STOP_SIGNALS[signal_index.to_i]
        
        if signal
          store_day_data('selected_stop_signal', signal)
          
          send_message(
            text: "✅ Выбран стоп-сигнал: #{signal[:emoji]} *#{signal[:name]}*\n\n#{signal[:description]}",
            parse_mode: 'Markdown'
          )
          
          send_message(
            text: "📋 **Инструкция:** #{signal[:instructions]}",
            parse_mode: 'Markdown'
          )
          
          # Переходим к выбору мысли
          sleep(1)
          show_thought_selection_guidance
        else
          send_message(text: "⚠️ Неизвестный стоп-сигнал. Пожалуйста, выберите из предложенных.")
        end
      end
      
      def show_thought_selection_guidance
        store_day_data('current_step', 'thought_selection')
        
        guidance_text = <<~MARKDOWN
          🤔 *Выбор мысли для практики*

          **Рекомендации по выбору:**

          🟢 **Для начинающих (рекомендуется):**
          • Нейтральная мысль («Что приготовить на ужин?»)
          • Повседневная забота («Не забыть купить молоко»)
          • Легкое беспокойство («Опоздаю ли я на встречу?»)

          🟡 **Для среднего уровня:**
          • Умеренно тревожная мысль
          • Повторяющаяся, но не разрушительная мысль
          • Мысль, которая вызывает легкое беспокойство

          🔴 **Не рекомендуется для первой практики:**
          • Травматические воспоминания
          • Сильно пугающие мысли
          • Мысли, вызывающие панику

          *Выберите мысль из 🟢 или 🟡 категории для сегодняшней практики.*
        MARKDOWN
        
        send_message(text: guidance_text, parse_mode: 'Markdown')
        
        send_message(
          text: "💭 *Напишите мысль, которую будете использовать для практики:*",
          parse_mode: 'Markdown'
        )
        
        # Устанавливаем состояние ожидания ввода мысли
        @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_thought")
      end
      
      def handle_thought_input(thought_text)
        return false if thought_text.blank?
        
        # Проверяем, не завершил ли пользователь уже практику
        if get_day_data('practice_completed') == true
          send_message(
            text: "⚠️ Вы уже завершили практику остановки мыслей. Чтобы изменить мысль, начните заново.",
            reply_markup: day_8_final_completion_markup
          )
          return false
        end
        
        store_day_data('practice_thought', thought_text)
        store_day_data('thought_received_at', Time.current)
        
        send_message(
          text: "✅ Мысль сохранена: \"#{thought_text.truncate(50)}...\"",
          parse_mode: 'Markdown'
        )
        
        # Переходим к практике
        sleep(1)
        start_practice_session
        
        true
      end
      
      def start_practice_session
        store_day_data('current_step', 'practice_session')
        selected_signal = get_day_data('selected_stop_signal') || {}
        practice_thought = get_day_data('practice_thought') || "выбранная мысль"
        
        practice_instructions = <<~MARKDOWN
          🎬 *Начинаем практику остановки мыслей!*

          **Подготовка:**
          1. 🧠 Вспомните мысль: "#{practice_thought.truncate(30)}..."
          2. 🛑 Подготовьте стоп-сигнал: #{selected_signal[:emoji]} #{selected_signal[:name]}
          3. 🔄 Выберите стратегию переключения (следующий шаг)

          **Алгоритм практики:**
          1. Позвольте мысли появиться (5-10 секунд)
          2. Примените стоп-сигнал
          3. НЕМЕДЛЕННО переключите внимание
          4. Удерживайте новое состояние 1-2 минуты

          **Готовы начать?**
        MARKDOWN
        
        send_message(text: practice_instructions, parse_mode: 'Markdown')
        
        send_message(
          text: "🔄 **Выберите стратегию переключения внимания:**",
          parse_mode: 'Markdown',
          reply_markup: day_8_distraction_strategies_markup
        )
      end
      
      def handle_distraction_selection(strategy_index)
        strategy = DISTRACTION_STRATEGIES[strategy_index.to_i]
        
        if strategy
          store_day_data('selected_distraction_strategy', strategy)
          
          send_message(
            text: "✅ Выбрана стратегия: #{strategy[:emoji]} *#{strategy[:name]}*\n\n#{strategy[:description]}",
            parse_mode: 'Markdown'
          )
          
          send_message(
            text: "⏱️ **Рекомендуемое время:** #{strategy[:duration]}\n**Эффективность:** #{strategy[:effectiveness]}",
            parse_mode: 'Markdown'
          )
          
          # Начинаем таймер практики
          start_practice_timer
        else
          send_message(text: "⚠️ Неизвестная стратегия. Пожалуйста, выберите из предложенных.")
        end
      end
      
      def start_practice_timer
        selected_strategy = get_day_data('selected_distraction_strategy') || {}
        duration = selected_strategy[:duration] || "2-3 минуты"
        
        timer_message = <<~MARKDOWN
          ⏱️ *Практика начинается!*

          **Процесс:**
          1. 💭 Позвольте мысли появиться (5-10 секунд)
          2. 🛑 Примените стоп-сигнал
          3. 🔄 Немедленно переключитесь на стратегию
          4. ⏰ Практикуйте #{duration}

          **Важные моменты:**
          • Не оценивайте, насколько хорошо получается
          • Каждая попытка укрепляет навык
          • Если мысль возвращается — снова «СТОП!»
          • Фокус на процессе, а не на результате
          
          Нажмите кнопку, когда завершите практику.
        MARKDOWN
        
        send_message(text: timer_message, parse_mode: 'Markdown')
        
        send_message(
          text: "🔄 Практикуйте выбранную стратегию...",
          reply_markup: day_8_practice_completion_markup
        )
      end
      
      def complete_practice
        store_day_data('practice_completed', true)
        store_day_data('completion_time', Time.current)
        
        # МЕНЯЕМ СОСТОЯНИЕ пользователя
        @user.set_self_help_step("day_#{DAY_NUMBER}_practice_completed")
        
        # Показываем рефлексию
        show_post_practice_reflection
      end
      
      def show_post_practice_reflection
        store_day_data('current_step', 'post_practice_reflection')
        
        send_message(text: DAY_STEPS['post_practice_reflection'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['post_practice_reflection'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "🤔 *С какими трудностями столкнулись в практике?*",
          parse_mode: 'Markdown',
          reply_markup: day_8_challenges_markup
        )
      end
      
      def handle_challenge_selection(challenge_index)
        challenge = COMMON_CHALLENGES[challenge_index.to_i]
        
        if challenge
          send_message(
            text: "🌀 **#{challenge[:challenge]}**\n\n#{challenge[:solution]}",
            parse_mode: 'Markdown'
          )
        end
        
        # МЕНЯЕМ СОСТОЯНИЕ после выбора трудности
        @user.set_self_help_step("day_#{DAY_NUMBER}_reflection_done")
        
        send_message(
          text: "🌟 Отлично! Вы завершили практику остановки мыслей!\n\nХотите завершить День 8?",
          reply_markup: day_8_final_completion_markup
        )
      end
      
      def complete_exercise
        selected_signal = get_day_data('selected_stop_signal') || {}
        selected_strategy = get_day_data('selected_distraction_strategy') || {}
        practice_thought = get_day_data('practice_thought') || "не указана"
        
        # Извлекаем названия из данных (обрабатываем разные форматы)
        signal_name = extract_name(selected_signal)
        strategy_name = extract_name(selected_strategy)
        
        # Отмечаем день как завершенный в программе
        @user.complete_day_program(DAY_NUMBER)
        @user.complete_self_help_day(DAY_NUMBER)
        
        # МЕНЯЕМ СОСТОЯНИЕ на завершенное
        @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
        
        # Сохраняем статистику практики с проверенными названиями
        save_thought_stopping_stats(signal_name, strategy_name)
        
        completion_message = <<~MARKDOWN
          🎊 *День 8 завершен!* 🎊

          **Ваши достижения сегодня:**
          
          🛑 **Практика остановки мыслей:**
          • 🎯 Стоп-сигнал: #{signal_name || "Не выбран"}
          • 🔄 Стратегия: #{strategy_name || "Не выбрана"}
          • 💭 Практическая мысль: "#{practice_thought.truncate(30)}..."
          • 🧠 Приобретение: Навык управления мысленным потоком
          
          📊 **Научный факт:**
          Регулярная практика остановки мыслей снижает тревожность на 35-45% и улучшает когнитивный контроль на 25-30%.
          
          🎯 **Что дальше:**
          Завтра - День 9: Когнитивная работа с тревожными мыслями
          
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
        when 'start_day_8_content', 'start_day_8_from_proposal'
          deliver_exercise
          
        when 'continue_day_8_content'
          current_step = get_day_data('current_step')
          handle_resume_from_step(current_step || 'intro')
          
        when /^day_8_stop_signal_(\d+)$/
          handle_stop_signal_selection($1)
          
        when /^day_8_distraction_(\d+)$/
          handle_distraction_selection($1)
          
        when 'day_8_practice_complete'
          complete_practice
          
        when 'day_8_practice_restart'
          deliver_exercise
          
        when /^day_8_challenge_(\d+)$/
          handle_challenge_selection($1)
          
        when 'day_8_no_challenges'
          # МЕНЯЕМ СОСТОЯНИЕ после выбора "нет трудностей"
          @user.set_self_help_step("day_#{DAY_NUMBER}_reflection_done")
          send_message(text: "🌟 Отлично! У вас получилась продуктивная практика!")
          send_message(
            text: "Завершаем День 8?",
            reply_markup: day_8_final_completion_markup
          )
          
        when 'day_8_complete_exercise', 'day_8_exercise_completed'
          complete_exercise
          
        when 'day_8_restart_practice'
          deliver_exercise
          
        when 'day_8_change_thought'
          show_thought_selection_guidance
          
        when 'day_8_help_choose_signal'
          send_message(
            text: "🎯 **Рекомендация по выбору стоп-сигнала:**\n\n• Новички: Мысленная команда или визуальный образ\n• Если мысль сильная: Физический сигнал или звук\n• Для быстрого применения: Дыхательный стоп\n• В публичных местах: Мысленная команда\n• При тревоге: Сочетание физического и мысленного сигнала",
            parse_mode: 'Markdown'
          )
          
        else
          log_warn("Unknown button callback: #{callback_data}")
          send_message(text: "Неизвестная команда.")
        end
      end
      
      # ===== ОБРАБОТКА ТЕКСТОВОГО ВВОДА =====
      
      def handle_text_input(input_text)
        log_info("Handling text input for day 8: #{input_text}")
        
        current_state = @user.self_help_state
        
        # Проверяем, ожидаем ли мы ввод мысли для практики
        if current_state == "day_8_waiting_for_thought"
          return handle_thought_input(input_text)
        elsif current_state == "day_8_practice_completed" || 
              current_state == "day_8_reflection_done" ||
              current_state == "day_8_completed"
          # Если практика уже завершена, игнорируем ввод мысли
          send_message(
            text: "⚠️ Вы уже завершили практику остановки мыслей. Чтобы изменить мысль, начните заново.",
            reply_markup: day_8_final_completion_markup
          )
          return true
        end
        
        log_warn("No text input handler for current state: #{current_state}")
        false
      end
      
      # Метод для совместимости с SelfHelpFacade
      def handle_smart_input(text)
        handle_text_input(text)
      end
      
      # Метод для обработки рефлексии (для совместимости)
      def handle_reflection_input(text)
        log_info("Handling reflection input: #{text}")
        store_day_data('reflection_note', text)
        send_message(text: "✅ Ваша заметка сохранена!")
        true
      end
      
      # ===== ВОССТАНОВЛЕНИЕ СЕССИИ =====
      
      def handle_exercise_completion
        # Перенаправляем на полный метод завершения
        complete_exercise
      end

      def handle_resume_from_step(step)
        case step
        when 'intro'
          deliver_intro
        when 'exercise_explanation'
          deliver_exercise
        when 'thought_selection'
          show_thought_selection_guidance
        when 'practice_session'
          start_practice_session
        when 'post_practice_reflection'
          show_post_practice_reflection
        else
          deliver_intro
        end
      end

      def show_intro_without_state
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['day_intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['day_intro'][:instruction], parse_mode: 'Markdown')
        send_message(
          text: statistics_message,
          parse_mode: 'Markdown'
        )
        send_message(
          text: "Готовы освоить технику управления мыслями и начать вторую неделю?",
          reply_markup: day_8_content_markup
        )
      end

      def propose_next_day_with_restriction
        next_day = 9
        
        # Проверяем, можно ли начать следующий день
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day} - Когнитивная работа** 🧠
            
            ✅ *Доступен сейчас!*
            
            **Что вас ждет:**
            • 🧠 Анализ тревожных мыслей
            • 📝 Работа с когнитивными искажениями  
            • 💡 Переформулирование негативных мыслей
            • 🌟 Укрепление психологической устойчивости
            
            Вы можете начать следующий день прямо сейчас.
          MARKDOWN
          
          button_text = "🧠 Начать День #{next_day}"
          callback_data = "start_day_#{next_day}_from_proposal"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ⏱️ *Ограничение:* #{error_message}
            
            **Пока ждете, можете:**
            • 🛑 Практиковать технику остановки мыслей
            • 🔄 Экспериментировать с разными стоп-сигналами
            • 🧠 Наблюдать, как техника влияет на ваш мыслительный поток
            • 📊 Посмотреть статистику (/progress)
            
            *Следующий день будет автоматически доступен, когда пройдет достаточно времени.*
          MARKDOWN
          
          # Если день недоступен, НЕ отправляем активную кнопку
          button_text = "⏱️ Проверить доступность Дня #{next_day}"
          callback_data = "start_day_#{next_day}_from_proposal"  # Оставляем ту же, но Day9Handler проверит
        end
        
        # Отправляем сообщение
        send_message(text: message, parse_mode: 'Markdown')
        
        # Отправляем кнопку ВСЕГДА, но Day9Handler проверит доступность
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

      def extract_name(data)
        return nil if data.blank?
        
        # Пробуем разные форматы ключей
        if data.is_a?(Hash)
          # Пробуем строковые ключи
          return data['name'] if data['name'].present?
          
          # Пробуем символьные ключи
          return data[:name] if data[:name].present?
          
          # Пробуем ключ с префиксом name
          return data['Name'] if data['Name'].present?
        elsif data.is_a?(String)
          # Если это уже строка, возвращаем как есть
          return data
        end
        
        nil
      end
      
      # Вспомогательные методы разметки
      def day_8_content_markup
        {
          inline_keyboard: [
            [
              { text: "🛑 Начать практику остановки мыслей", callback_data: 'start_day_8_content' }
            ],
            [
              { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
            ]
          ]
        }.to_json
      end
      
      def day_8_stop_signals_markup
        {
          inline_keyboard: [
            [
              { text: "🗣️ Мысленная команда", callback_data: 'day_8_stop_signal_0' },
              { text: "🛑 Визуальный образ", callback_data: 'day_8_stop_signal_1' }
            ],
            [
              { text: "👏 Физический сигнал", callback_data: 'day_8_stop_signal_2' },
              { text: "🔊 Звуковой сигнал", callback_data: 'day_8_stop_signal_3' }
            ],
            [
              { text: "🌬️ Дыхательный стоп", callback_data: 'day_8_stop_signal_4' },
              { text: "✋ Движение-стоп", callback_data: 'day_8_stop_signal_5' }
            ],
            [
              { text: "❓ Помогите выбрать", callback_data: 'day_8_help_choose_signal' }
            ]
          ]
        }.to_json
      end
      
      def day_8_distraction_strategies_markup
        {
          inline_keyboard: [
            [
              { text: "🌬️ Дыхание 4-7-8", callback_data: 'day_8_distraction_0' },
              { text: "👁️ Сенсорное сканирование", callback_data: 'day_8_distraction_1' }
            ],
            [
              { text: "🏃 Физическая активность", callback_data: 'day_8_distraction_2' },
              { text: "🔢 Счет или алфавит", callback_data: 'day_8_distraction_3' }
            ],
            [
              { text: "🎨 Креативная задача", callback_data: 'day_8_distraction_4' },
              { text: "🌳 Внешний фокус", callback_data: 'day_8_distraction_5' }
            ]
          ]
        }.to_json
      end
      
      def day_8_practice_completion_markup
        {
          inline_keyboard: [
            [
              { text: "✅ Завершить практику", callback_data: 'day_8_practice_complete' }
            ],
            [
              { text: "🔄 Начать заново", callback_data: 'day_8_practice_restart' },
              { text: "💭 Сменить мысль", callback_data: 'day_8_change_thought' }
            ]
          ]
        }.to_json
      end
      
      def day_8_challenges_markup
        {
          inline_keyboard: [
            [
              { text: "🌀 Мысль возвращается", callback_data: 'day_8_challenge_0' }
            ],
            [
              { text: "😳 Чувствую себя глупо", callback_data: 'day_8_challenge_1' }
            ],
            [
              { text: "🤔 Не могу выбрать мысль", callback_data: 'day_8_challenge_2' }
            ],
            [
              { text: "🔄 Стоп-сигнал не работает", callback_data: 'day_8_challenge_3' }
            ],
            [
              { text: "✅ Никаких трудностей", callback_data: 'day_8_no_challenges' }
            ]
          ]
        }.to_json
      end
      
      def day_8_final_completion_markup
        {
          inline_keyboard: [
            [
              { text: "🎯 Завершить День 8", callback_data: 'day_8_complete_exercise' },
              { text: "🔄 Повторить практику", callback_data: 'day_8_restart_practice' }
            ]
          ]
        }.to_json
      end
      
      def statistics_message
        <<~MARKDOWN
          📊 *Научные данные о технике остановки мыслей:*
          
          • 🧠 **35-45%** — снижение общей тревожности после 4 недель практики
          • 😌 **40-50%** — уменьшение навязчивых мыслей (руминации)
          • 💡 **25-30%** — улучшение концентрации и когнитивного контроля
          • 🛡️ **50-60%** — эффективность при легких формах ОКР
          • 🔄 **6-8 недель** — время формирования устойчивого навык
          • ⏱️ **2-3 применения** — достаточно для первых заметных результатов
          
          *Источник: Исследования Cognitive Therapy and Research, Journal of Anxiety Disorders*
        MARKDOWN
      end
      
      def save_thought_stopping_stats(signal_name, strategy_name)
        begin
          log_info("Saving thought stopping stats - Signal: #{signal_name}, Strategy: #{strategy_name}")
          
          store_day_data('thought_stopping_stats', {
            date: Date.current.to_s,
            stop_signal: signal_name || "Не указан",
            distraction_strategy: strategy_name || "Не указана",
            completed: true,
            saved_at: Time.current.to_s
          })
          
          log_info("Successfully saved thought stopping stats")
        rescue => e
          log_error("Failed to save thought stopping stats", e)
          
          # Сохраняем хотя бы минимальную информацию
          begin
            store_day_data('thought_stopping_stats_fallback', {
              date: Date.current.to_s,
              completed: true,
              error: e.message
            })
          rescue => e2
            log_error("Failed to save fallback stats", e2)
          end
        end
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
      end
    end
  end
end
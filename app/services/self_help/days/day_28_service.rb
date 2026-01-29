# app/services/self_help/days/day_28_service.rb
module SelfHelp
  module Days
    class Day28Service < DayBaseService
      include TelegramMarkupHelper
      
      DAY_NUMBER = 28
      
      # Константы дня 28 с научными исследованиями
      PROGRAM_COMPLETION_STATS = {
        days_to_form_habit: 28,
        neuroplasticity_effect: "28 дней достаточно для создания устойчивых нейронных связей",
        completion_rate: "Только 8-12% людей завершают такие программы полностью",
        relapse_prevention: "Рефлексия на 28 день снижает риск отката на 65%"
      }.freeze
      
      # Категории достижений для научного анализа
      ACHIEVEMENT_CATEGORIES = [
        { 
          emoji: "🧠", 
          name: "Нейрокогнитивные достижения",
          achievements: [
            "Научился(ась) распознавать автоматические мысли (когнитивные искажения)",
            "Могу переоценить негативные мысли через когнитивный рефрейминг",
            "Использую технику 'остановки мысли' для прерывания руминации",
            "Различаю факты, интерпретации и эмоциональные реакции",
            "Практикую метакогницию — мышление о своем мышлении"
          ],
          neuroscience: "Укрепление префронтальной коры и ослабление реакции амигдалы"
        },
        { 
          emoji: "❤️", 
          name: "Нейроэмоциональные достижения", 
          achievements: [
            "Лучше понимаю свои эмоции через модель эмоционального интеллекта",
            "Могу успокоиться с помощью научно обоснованного дыхания 4-7-8",
            "Практикую самосострадание как форму эмоциональной регуляции",
            "Выражаю благодарность для создания позитивных нейронных следов",
            "Различаю первичные и вторичные эмоции"
          ],
          neuroscience: "Балансировка лимбической системы и усиление парасимпатического тонуса"
        },
        { 
          emoji: "⚡", 
          name: "Нейроповеденческие достижения", 
          achievements: [
            "Планирую задачи через SMART-цели (нейронаука планирования)",
            "Преодолеваю прокрастинацию через понимание дофаминовой системы",
            "Ставлю реалистичные цели с учетом когнитивных ресурсов",
            "Выполняю неприятные задачи через поведенческую активацию",
            "Создаю микропривычки через петли привычек"
          ],
          neuroscience: "Активация дорсального стриатума и системы награды"
        },
        { 
          emoji: "🛡️", 
          name: "Нейроустойчивость", 
          achievements: [
            "Быстрее восстанавливаюсь после стресса через нейропластичность",
            "Имею научно обоснованные инструменты для трудных ситуаций",
            "Могу предвидеть трудности через когнитивное предвосхищение",
            "Сохраняю спокойствие через регуляцию вегетативной нервной системы",
            "Использую технику заземления для возвращения в настоящее"
          ],
          neuroscience: "Усиление вагусного тонуса и регуляция HPA-оси"
        }
      ].freeze
      
      # Шаги финального дня с научной базой (без вызовов методов в константах)
      DAY_STEPS = {
        'intro' => {
          title: "🎊 *День 28: Гранд-финал и Научная рефлексия полного цикла* 🎊",
          instruction: <<~MARKDOWN
            **Месяц назад вы начали нейронаучный эксперимент над самим собой.** 🔬

            **Сегодня мы празднуем не просто завершение программы, а завершение полного цикла нейропластичности!**

            🧠 **Научные факты о 28 днях:**
            • 📈 **Полный цикл:** 28 дней = полный цикл формирования устойчивой привычки на уровне мозга (исследования Лондонского Университета)
            • 🧬 **Нейропластичность:** За 28 дней мозг создает прочные синаптические связи для новых паттернов поведения
            • 🔄 **Консолидация:** Четвертая неделя закрепляет изменения через мета-познание и рефлексию
            • 🏆 **Статистика:** Только 9,2% участников завершают такие программы полностью — вы в элитной группе!

            **Ваш 28-дневный нейронаучный эксперимент показал:**
            1. ✅ Вы можете сознательно менять работу своего мозга
            2. ✅ Нейропластичность работает в вашу пользу
            3. ✅ Научные техники действительно эффективны
            4. ✅ Вы создали личную систему психологической устойчивости

            **Сегодняшняя цель:** Провести полную научную рефлексию, интегрировать все навыки в единую систему и создать персональный план поддержки на основе доказательной психологии.
          MARKDOWN
        },
        'celebration' => {
          title: "🎉 *Шаг 1: Церемония признания с нейробиологической точки зрения* 🧬",
          instruction: <<~MARKDOWN
            **Прежде чем анализировать — давайте отпразднуем на уровне нейронов!** 🎯

            **Нейробиологические достижения за 28 дней:**

            🧠 **Изменения в мозге:**
            • ✅ **Префронтальная кора:** Усилен контроль над эмоциями и импульсами на 25-40%
            • ✅ **Амигдала:** Снижена реактивность на стресс на 30-50%
            • ✅ **Гиппокамп:** Улучшена консолидация позитивных воспоминаний
            • ✅ **Островковая доля:** Повышена интероцепция — осознание телесных сигналов

            📊 **Научные результаты:**
            • 🏆 **28 различных психологических техник** освоено
            • 🔄 **4 полных недели** регулярной практики
            • 🧬 **Созданы новые нейронные пути** для осознанности, саморегуляции и проактивности
            • 💫 **Доказана самоэффективность** — вера в свою способность меняться

            **Нейробиологический факт:** Каждое достижение, которое вы признаете сегодня, создает дофаминовый след в мозге, укрепляя мотивацию на будущее.

            **Как вы себя чувствуете, достигнув финишной черты с научной точки зрения?**
            
            📝 **Опишите свои эмоции через призму нейробиологии (1-3 слова или метафоры):**
          MARKDOWN
        },
        'review_achievements' => {
          title: "📊 *Шаг 2: Анализ пути через призму поведенческой психологии* 📈",
          instruction: <<~MARKDOWN
            **Давайте посмотрим на ваши ключевые достижения через научные модели изменения поведения.**

            📋 **Ваша статистика за 4 недели (поведенческий анализ):**
            • 🗓️ **Дней завершено:** [days_count] /28
            • 📝 **Техник освоено:** 28+ (когнитивные, эмоциональные, поведенческие)
            • 🔄 **Циклов практики:** [practice_cycles] полных циклов
            • 🎯 **Уровень самоэффективности:** [self_efficacy_level]

            🧩 **Модель изменения поведения (Prochaska & DiClemente):**
            1. **До-размышление →** Вы начали с желания измениться
            2. **Размышление →** Изучали техники и принципы
            3. **Подготовка →** Планировали практику
            4. **Действие →** Регулярно практиковали 28 дней
            5. **Поддержание →** Сегодня создаем систему для закрепления

            **Научный факт:** Люди, которые проводят рефлексию достижений, имеют на 73% выше вероятность поддерживать изменения через 6 месяцев.

            **Какие 3 самых значимых для вас результата с точки зрения изменения поведения?**
            
            📝 **Ваши топ-3 достижения (с научной точки зрения):**
          MARKDOWN
        },
        'skills_integration' => {
          title: "🧩 *Шаг 3: Интеграция навыков в вашу личную когнитивно-поведенческую систему* ⚙️",
          instruction: <<~MARKDOWN
            **Теперь соберем все навыки в вашу уникальную систему устойчивости!**

            📋 **Ваш научно обоснованный набор инструментов:**

            🔹 **Когнитивный уровень (мышление):**
            • 💭 Распознавание автоматических мыслей
            • 🔄 Когнитивная переоценка
            • 🛑 Техника остановки мысли
            • 🎯 Метакогниция — мышление о мышлении

            🔹 **Эмоциональный уровень (чувства):**
            • ❤️ Эмоциональная грамотность
            • 🌬️ Дыхательная саморегуляция
            • 💝 Самосострадание
            • 🙏 Практика благодарности

            🔹 **Поведенческий уровень (действия):**
            • 🎯 SMART-планирование
            • 🚀 Преодоление прокрастинации
            • 🌍 Техники заземления
            • 🔄 Предвосхищение трудностей

            🔹 **Нейробиологический уровень (мозг):**
            • 🧠 Понимание работы дофамина
            • ⚖️ Балансировка системы награда
            • 🎭 Нейрохакинг радости
            • 📊 Осознание нейропластичности

            **Научный факт:** Интеграция знаний на разных уровнях (когнитивном, эмоциональном, поведенческом) создает синергетический эффект — результат больше, чем сумма частей.

            **Какой из этих научных инструментов стал для вас самым ценным с точки зрения понимания работы психики?**
            
            📝 **Опишите ваш самый ценный научный инструмент:**
          MARKDOWN
        },
        'personal_support_plan' => {
          title: "📋 *Шаг 4: Создание персональной системы поддержки на основе доказательной психологии* 🛡️",
          instruction: <<~MARKDOWN
            **Чтобы навыки не забылись, создадим персональную систему поддержки с научной основой!**

            🎯 **Еженедельный научный ритуал (15 минут):**
            • 📝 **Проверка когнитивных искажений** — какие автоматические мысли появились?
            • 🔄 **Анализ поведенческих паттернов** — что сработало, что нет?
            • 🧠 **Нейропластичность мониторинг** — какие новые нейронные пути укрепляю?
            • 🙏 **Научная благодарность** — за какие изменения в мозге благодарен?

            🚨 **Научно обоснованный чек-лист 'Сигналы тревоги':**
            • 🔴 **Эмоциональные:** Постоянная тревога > 3 дней (нарушение регуляции амигдалы)
            • 🟡 **Поведенческие:** Избегание > 2 важных дел (поведенческая активация снижена)
            • 🟠 **Когнитивные:** Катастрофизация > 5 раз в день (когнитивные искажения)
            • 🔵 **Физиологические:** Нарушение сна > 3 ночей (вегетативная дисрегуляция)

            🌈 **Практика радости с нейробиологической основой (минимум 3 в неделю):**
            • 🎵 **Музыка** — активация слуховой коры + эмоциональных центров
            • 🌳 **Природа** — синхронизация с циркадными ритмами + снижение кортизола
            • 👥 **Социальное** — окситоцин + зеркальные нейроны
            • ✨ **Новизна** — дофамин + обучение + нейрогенез

            **Научный факт:** Системы поддержки с регулярными ритуалами повышают вероятность сохранения результатов на 85% через 6 месяцев.

            **Добавьте свой научно обоснованный пункт в практику радости:**
            
            📝 **Ваша добавка к практике радости (с объяснением эффекта):**
          MARKDOWN
        },
        'future_horizons' => {
          title: "🚀 *Шаг 5: Научные горизонты дальнейшего развития* 🔬",
          instruction: <<~MARKDOWN
            **Куда дальше? Ваш мозг готов к новым научным открытиям!**

            🏆 **Вы освоили базовый курс по доказательной психологии и нейронауке!** 
            Теперь можете углубиться в научно обоснованные направления:

            🔹 **Углубленная когнитивно-поведенческая терапия (КПТ):**
            • Работа с глубинными убеждениями (схемы)
            • Протоколы для специфических расстройств
            • Продвинутые техники когнитивного рефрейминга
            • **Научная база:** 900+ исследований эффективности

            🔹 **Нейронаука и практическая психология:**
            • Нейрофидбек и биологическая обратная связь
            • Хронобиология и циркадные ритмы
            • Психофизиология стресса и восстановления
            • **Научная база:** Современные нейровизуализационные исследования

            🔹 **Позитивная психология и благополучие:**
            • Сильные стороны характера (VIA)
            • Поток и оптимальные переживания
            • Осмысленность и экзистенциальное благополучие
            • **Научная база:** Исследования Мартина Селигмана и Mihaly Csikszentmihalyi

            🔹 **Прикладная поведенческая наука:**
            • Формирование сложных привычек
            • Изменение поведения на уровне окружения
            • Nudge-теория и архитектура выбора
            • **Научная база:** Работы Даниэля Канемана и Ричарда Талера

            **Научный факт:** Продолжающееся обучение создает когнитивный резерв, защищающий мозг от возрастных изменений и снижающий риск деменции на 46%.

            **Что вас интересует с научной точки зрения больше всего?**
            
            📝 **Ваши научные интересы для дальнейшего развития:**
          MARKDOWN
        },
        'final_message' => {
          title: "🌟 *Шаг 6: Научное письмо себе от будущего нейроученого* 📝",
          instruction: <<~MARKDOWN
            **Напишите короткое научное письмо себе на будущее от лица 'нейроученого', которым вы стали.**

            **Формат научного письма:**
            'Дорогой(ая) [ваше имя],
            
            Как специалист по твоей собственной нейропластичности хочу напомнить:

            1. **Когнитивный уровень:** Ты научился(ась) [ваш главный когнитивный навык]...
            2. **Эмоциональный уровень:** Ты укрепил(а) [ваш главный эмоциональный навык]...
            3. **Поведенческий уровень:** Ты создал(а) [ваша главная поведенческая стратегия]...
            4. **Нейробиологический уровень:** Ты изменил(а) [ваше главное изменение в работе мозга]...

            **Научный факт о тебе:** [ваше главное научное открытие о себе]

            Когда будет трудно, вспомни: [ваша самая сильная нейронаучная техника]

            С уважением к твоей нейропластичности,
            Твой внутренний нейроученый.'

            **Напишите ваше научное письмо себе на будущее:**
          MARKDOWN
        },
        'summary' => {
          title: "🎁 *Шаг 7: Ваш научный сертификат мастера психологической устойчивости* 📜",
          instruction: <<~MARKDOWN
            **🏆 Поздравляю с успешным завершением 28-дневного научного эксперимента!** 🏆

            ✨ **Вы официально становитесь:**
            **'Специалистом по собственной нейропластичности и доказательной психологической устойчивости'**

            📜 **Ваши научно подтвержденные компетенции:**

            1. 🧘 **Нейроосознанность** — Управление вниманием через понимание работы префронтальной коры
            2. 💭 **Когнитивная нейропластичность** — Изменение мышления через создание новых нейронных путей
            3. ❤️ **Эмоциональная нейронаука** — Регуляция чувств через балансировку лимбической системы
            4. ⚡ **Проактивная нейробиология** — Управление действиями через дофаминовую систему награда

            🧠 **Научный итог вашего эксперимента:**
            • ✅ **Доказана гипотеза:** Вы можете сознательно менять работу своего мозга
            • ✅ **Подтверждена теория:** Нейропластичность работает в вашу пользу
            • ✅ **Верифицирован метод:** Научные техники эффективны в повседневной жизни
            • ✅ **Создана модель:** Ваша личная система психологической устойчивости

            **Философско-научная мудрость на прощание:**
            > *'Мы — это то, что мы постоянно делаем. Совершенство, следовательно, не действие, а привычка.'*
            > — Аристотель (переосмыслено через призму нейропластичности)

            **Вы не просто сделали первый шаг — вы прошли полный научный эксперимент по изменению себя!**

            🛠️ **Все научные инструменты остаются с вами навсегда как часть вашего когнитивного арсенала!**
          MARKDOWN
        }
      }.freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ (ИЗ DayBaseService) =====
      
      def deliver_intro
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        
        # Научная статистика для мотивации
        send_message(
          text: neuroscience_statistics_message,
          parse_mode: 'Markdown'
        )
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        store_day_data('current_step', 'intro')
        
        send_message(
          text: "Готовы к вашему научному финалу и нейропластическому триумфу?",
          reply_markup: day_28_content_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'celebration')
        
        send_message(text: DAY_STEPS['celebration'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['celebration'][:instruction], parse_mode: 'Markdown')
        
        # Инициализируем данные финальной рефлексии
        init_final_reflection_data
        
        # Предлагаем начать ввод
        send_message(
          text: "📝 *Опишите ваши эмоции через призму нейробиологии:*",
          parse_mode: 'Markdown',
          reply_markup: day_28_input_markup
        )
      end
      
      def resume_session
        current_state = @user.self_help_state
        
        case current_state
        when "day_#{DAY_NUMBER}_intro"
          # Если пользователь только начал день, показываем упражнение
          deliver_exercise
        when "day_#{DAY_NUMBER}_exercise_in_progress"
          # Восстанавливаем с текущего шага
          current_step = get_day_data('current_step')
          if current_step.present?
            handle_resume_from_step(current_step)
          else
            # Если шаг не сохранен, начинаем упражнение
            deliver_exercise
          end
        else
          # Если состояние не определено или не соответствует дню 28
          log_warn("Unknown or invalid state for resume: #{current_state}")
          # Показываем введение и предлагаем начать
          show_intro_without_state
        end
      end
      
      def complete_exercise
        # Отмечаем день как завершенный в программе
        @user.complete_day_program(DAY_NUMBER)
        
        # Также вызываем старый метод для совместимости
        @user.complete_self_help_day(DAY_NUMBER)
        
        # Сохраняем научную статистику завершения
        save_neuroscience_completion_stats
        
        # Показываем завершение дня и всей программы
        show_program_completion
      end
      
      def show_program_completion
        # Получаем данные финальной рефлексии
        final_data = get_final_data
        
        completion_message = <<~MARKDOWN
          🎊 *День 28 и вся 28-дневная программа завершены!* 🎊

          **Ваши научные достижения за 28 дней:**

          🧬 **Нейропластический эксперимент успешен:**
          • ✅ Завершено полных 28 дней — полный цикл формирования привычки
          • 📊 Освоено 28+ научно обоснованных техник психологической устойчивости
          • 🔬 Доказана способность сознательно менять работу мозга
          • 🧩 Создана персональная система на основе доказательной психологии
          • 🏆 Вы вошли в 9.2% людей, завершающих такие программы полностью
          
          📈 **Научные результаты:**
          • 🧠 **Нейропластичность:** Созданы новые синаптические связи для осознанности и саморегуляции
          • 💪 **Самоэффективность:** Доказана вера в свою способность меняться
          • 🔄 **Поведенческие изменения:** Устойчивые паттерны мышления и действия
          • 🛡️ **Устойчивость:** Научно обоснованный арсенал для трудных ситуаций
          
          📊 **Научный факт:**
          Люди, завершившие 28-дневные программы с научной рефлексией, имеют на 73% выше вероятность поддерживать изменения через 6 месяцев и на 85% ниже риск психологического отката.
          
          *"Самый важный научный эксперимент — тот, который вы провели над собой. Вы доказали, что нейропластичность работает, когда вы работаете."*
          — Доктор Норман Дойдж, автор "Пластичность мозга"
          
          🎉 **Поздравляем с завершением вашего нейропластического путешествия!**
          
          Ваш прогресс: 100% — Программа завершена!
        MARKDOWN
        
        send_message(text: completion_message, parse_mode: 'Markdown')
        
        # Показываем сертификат завершения
        sleep(2)
        show_completion_certificate
        
        # Предлагаем дальнейшие действия
        sleep(3)
        show_final_actions_menu
      end
      
      # ===== ОБРАБОТКА КНОПОК =====
      
      def handle_button(callback_data)
        log_info("Day #{DAY_NUMBER}: Handling button: #{callback_data}")
        
        case callback_data
        when 'start_day_28_content', 'start_day_28_from_proposal'
          deliver_exercise
          
        when 'continue_day_28_content'
          # Проверяем, на каком шаге остановился пользователь
          current_step = get_day_data('current_step')
          handle_resume_from_step(current_step || 'intro')
          
        when 'day_28_show_neuroscience_stats'
          show_neuroscience_stats
          
        when 'day_28_show_achievement_categories'
          show_achievement_categories
          
        when 'day_28_select_achievement'
          # Этот callback обрабатывается в Day28Handler
          log_info("Achievement selection button pressed")
          
        when 'day_28_complete_exercise'
          complete_exercise
          
        when 'day_28_show_certificate'
          show_completion_certificate
          
        when 'day_28_create_maintenance_plan'
          create_maintenance_plan
          
        when 'day_28_restart_program'
          restart_program
          
        when 'day_28_skip_step'
          handle_skip_step
          
        when 'day_28_restart_reflection'
          restart_reflection
          
        when 'day_28_make_scientific_note'
          send_message(
            text: "🔬 *Напишите научную заметку о вашем 28-дневном эксперименте:*\n• Какие нейробиологические изменения вы заметили?\n• Какая научная концепция была самой откровенной?\n• Как вы будете применять научный подход к себе в будущем?",
            parse_mode: 'Markdown'
          )
          store_day_data('awaiting_scientific_note', true)
          
        when 'day_28_help_neuroscience'
          send_message(
            text: "🧠 **Помощь по нейронауке завершения:**\n\n• Нейропластичность = способность мозга меняться через опыт\n• Самоэффективность = вера в свою способность достигать целей\n• Петля привычки = сигнал → действие → награда\n• Когнитивный резерв = защита мозга через обучение\n\n**Ключевой научный принцип:** Изменения требуют времени, потому что мозг строит новые нейронные пути, а не просто меняет мысли.",
            parse_mode: 'Markdown'
          )
          
        else
          log_warn("Unknown button callback: #{callback_data}")
          send_message(text: "Неизвестная команда.")
        end
      end
      
      # Обработка текстового ввода
      def handle_text_input(input_text)
        current_step = get_day_data('current_step')
        
        log_info("Day #{DAY_NUMBER}: Handling text input for step: #{current_step}, text: #{input_text.truncate(50)}")
        
        # Проверяем все awaiting_* флаги
        case true
        when get_day_data('awaiting_scientific_note')
          store_day_data('awaiting_scientific_note', false)
          return handle_scientific_note_input(input_text)
          
        else
          # Обработка по текущему шагу
          case current_step
          when 'intro'
            handle_intro_input(input_text)
          when 'celebration'
            handle_celebration_input(input_text)
          when 'review_achievements'
            handle_achievements_input(input_text)
          when 'skills_integration'
            handle_skills_input(input_text)
          when 'personal_support_plan'
            handle_support_plan_input(input_text)
          when 'future_horizons'
            handle_future_input(input_text)
          when 'final_message'
            handle_letter_input(input_text)
          when 'summary'
            handle_summary_input(input_text)
          else
            log_warn("Unknown step for text input: #{current_step}")
            send_message(text: "Пожалуйста, следуйте инструкциям на экране.")
            false
          end
        end
      end
      
      # ===== ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ =====
      
      private
      
      def init_final_reflection_data
        store_day_data('final_data', {
          'celebration_feelings' => nil,
          'top_achievements' => [],
          'most_valuable_skill' => nil,
          'joy_practice_item' => nil,
          'future_interests' => [],
          'scientific_letter' => nil,
          'completion_date' => nil,
          'scientific_note' => nil
        })
      end
      
      def clear_final_reflection_data
        day_data_keys = @user.self_help_program_data.keys.select { |k| k.start_with?('day_28_') }
        day_data_keys.each do |key|
          @user.self_help_program_data.delete(key)
        end
        @user.save
        log_info("Cleared final reflection data for day 28")
      end
      
      def start_exercise_step(step_type)
        store_day_data('current_step', step_type)
        
        step = DAY_STEPS[step_type]
        return unless step
        
        send_message(text: step[:title], parse_mode: 'Markdown') if step[:title]
        
        # Динамическое форматирование для определенных шагов
        instruction = case step_type
        when 'review_achievements'
          format_review_achievements_instruction(step[:instruction])
        when 'summary'
          format_summary_instruction(step[:instruction])
        else
          step[:instruction]
        end
        
        send_message(text: instruction, parse_mode: 'Markdown') if instruction
        
        # Показываем дополнительные элементы для определенных шагов
        case step_type
        when 'review_achievements'
          send_message(
            text: "Хотите увидеть научные категории достижений?",
            reply_markup: day_28_achievement_categories_markup
          )
          
        when 'summary'
          send_message(
            text: "🎉 Ваш научный эксперимент завершен успешно!",
            reply_markup: day_28_completion_markup
          )
        end
        
        # Для всех шагов, кроме summary, предлагаем ввод
        unless step_type == 'summary'
          send_message(
            text: "📝 *Опишите ваши научные инсайты:*",
            parse_mode: 'Markdown',
            reply_markup: day_28_input_markup
          )
        end
      end
      
      # Метод для форматирования инструкции review_achievements с динамическими данными
      def format_review_achievements_instruction(base_instruction)
        days_completed = calculate_completed_days
        practice_cycles = calculate_practice_cycles
        self_efficacy_level = calculate_self_efficacy_level
        
        base_instruction
          .gsub('[days_count]', days_completed.to_s)
          .gsub('[practice_cycles]', practice_cycles.to_s)
          .gsub('[self_efficacy_level]', self_efficacy_level)
      end
      
      # Метод для форматирования инструкции summary
      def format_summary_instruction(base_instruction)
        final_data = get_final_data
        
        base_instruction
          .gsub('[ваш главный когнитивный навык]', final_data['most_valuable_skill']&.truncate(50) || 'когнитивную гибкость')
          .gsub('[ваш главный эмоциональный навык]', final_data['top_achievements']&.first&.truncate(50) || 'эмоциональную регуляцию')
          .gsub('[ваша главная поведенческая стратегия]', final_data['joy_practice_item']&.truncate(50) || 'регулярную практику')
          .gsub('[ваше главное изменение в работе мозга]', final_data['future_interests']&.first&.truncate(50) || 'нейропластичность')
          .gsub('[ваше главное научное открытие о себе]', final_data['scientific_note']&.truncate(80) || 'способность меняться через практику')
          .gsub('[ваша самая сильная нейронаучная техника]', final_data['most_valuable_skill']&.truncate(50) || 'научное понимание себя')
      end
      
      # ===== ОБРАБОТЧИКИ ШАГОВ =====
      
      def handle_intro_input(input_text)
        start_exercise_step('celebration')
        true
      end
      
      def handle_celebration_input(input_text)
        return false if input_text.strip.empty?
        
        final_data = get_final_data
        final_data['celebration_feelings'] = input_text
        store_day_data('final_data', final_data)
        
        start_exercise_step('review_achievements')
        true
      end
      
      def handle_achievements_input(input_text)
        return false if input_text.strip.empty?
        
        # Разбиваем ввод на отдельные достижения
        achievements = input_text.split(/[,\.\n]/).map(&:strip).reject(&:empty?)
        
        if achievements.any?
          final_data = get_final_data
          final_data['top_achievements'] = achievements.first(3)
          store_day_data('final_data', final_data)
        end
        
        start_exercise_step('skills_integration')
        true
      end
      
      def handle_skills_input(input_text)
        return false if input_text.strip.empty?
        
        final_data = get_final_data
        final_data['most_valuable_skill'] = input_text
        store_day_data('final_data', final_data)
        
        start_exercise_step('personal_support_plan')
        true
      end
      
      def handle_support_plan_input(input_text)
        return false if input_text.strip.empty?
        
        final_data = get_final_data
        final_data['joy_practice_item'] = input_text
        store_day_data('final_data', final_data)
        
        # Показываем научный чек-лист
        show_neuroscience_checklist
        
        start_exercise_step('future_horizons')
        true
      end
      
      def handle_future_input(input_text)
        return false if input_text.strip.empty?
        
        final_data = get_final_data
        interests = final_data['future_interests'] || []
        interests << input_text
        final_data['future_interests'] = interests
        store_day_data('final_data', final_data)
        
        start_exercise_step('final_message')
        true
      end
      
      def handle_letter_input(input_text)
        return false if input_text.strip.empty?
        
        final_data = get_final_data
        final_data['scientific_letter'] = input_text
        store_day_data('final_data', final_data)
        
        start_exercise_step('summary')
        true
      end
      
      def handle_summary_input(input_text)
        complete_exercise
        true
      end
      
      def handle_skip_step
        current_step = get_day_data('current_step')
        
        # Определяем следующий шаг
        next_step = case current_step
                   when 'celebration' then 'review_achievements'
                   when 'review_achievements' then 'skills_integration'
                   when 'skills_integration' then 'personal_support_plan'
                   when 'personal_support_plan' then 'future_horizons'
                   when 'future_horizons' then 'final_message'
                   when 'final_message' then 'summary'
                   else 'summary'
                   end
        
        start_exercise_step(next_step)
      end
      
      def handle_scientific_note_input(input_text)
        if input_text.present?
          final_data = get_final_data
          final_data['scientific_note'] = input_text
          store_day_data('final_data', final_data)
          
          send_message(text: "🔬 Научная заметка сохранена!")
          return true
        else
          send_message(text: "⚠️ Пожалуйста, поделитесь вашими научными инсайтами.")
          return false
        end
      end
      
      def restart_reflection
        clear_final_reflection_data
        deliver_exercise
      end
      
      def handle_resume_from_step(step)
        case step
        when 'intro'
          deliver_intro
        when 'celebration', 'review_achievements', 'skills_integration', 'personal_support_plan',
             'future_horizons', 'final_message'
          start_exercise_step(step)
        when 'summary'
          show_summary_step
        else
          deliver_intro
        end
      end
      
      def show_summary_step
        store_day_data('current_step', 'summary')
        
        # Показываем итоговый научный отчет
        show_final_scientific_report(get_final_data)
        
        send_message(
          text: "🎉 Ваш 28-дневный научный эксперимент завершен!",
          reply_markup: day_28_completion_markup
        )
      end
      
      def show_intro_without_state
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        send_message(
          text: neuroscience_statistics_message,
          parse_mode: 'Markdown'
        )
        send_message(
          text: "Готовы к вашему научному финалу?",
          reply_markup: day_28_content_markup
        )
      end
      
      # ===== МЕТОДЫ РАЗМЕТКИ =====
      
      def day_28_content_markup
        {
          inline_keyboard: [
            [
              { text: "🧬 Начать научный финал", callback_data: 'start_day_28_content' }
            ],
            [
              { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
            ]
          ]
        }.to_json
      end
      
      def day_28_input_markup
        {
          inline_keyboard: [
            [
              { text: "⏭️ Пропустить шаг", callback_data: 'day_28_skip_step' },
              { text: "🔄 Начать заново", callback_data: 'day_28_restart_reflection' }
            ]
          ]
        }.to_json
      end
      
      def day_28_achievement_categories_markup
        {
          inline_keyboard: [
            [
              { text: "🧠 Нейрокогнитивные достижения", callback_data: 'day_28_show_achievement_categories' }
            ]
          ]
        }.to_json
      end
      
      def day_28_completion_markup
        {
          inline_keyboard: [
            [
              { text: "📜 Сертификат завершения", callback_data: 'day_28_show_certificate' },
              { text: "📋 План поддержки", callback_data: 'day_28_create_maintenance_plan' }
            ],
            [
              { text: "✅ Завершить программу", callback_data: 'day_28_complete_exercise' }
            ],
            [
              { text: "🔬 Сделать научную заметку", callback_data: 'day_28_make_scientific_note' },
              { text: "🔄 Пройти заново", callback_data: 'day_28_restart_program' }
            ]
          ]
        }.to_json
      end
      
      def neuroscience_statistics_message
        <<~MARKDOWN
          📊 *Научные факты о завершении 28-дневной программы:*
          
          • 🧠 **Нейропластичность:** 28 дней = полный цикл формирования новых нейронных связей
          • 📈 **Эффективность:** Участники завершившие программу имеют на 65% лучшее психологическое благополучие
          • 🏆 **Статистика:** Только 9.2% людей завершают такие программы полностью
          • 🔄 **Устойчивость:** Научная рефлексия на 28 день снижает риск отката на 73%
          • 🧬 **Долгосрочный эффект:** Изменения сохраняются через 6 месяцев у 85% завершивших
          • 💪 **Самоэффективность:** Вера в свою способность меняться повышается на 200%
          • 🛡️ **Устойчивость к стрессу:** Увеличивается на 40-60% после полного цикла
          
          *Источник: Исследования нейропластичности (Doidge, 2007), мета-анализ программ самопомощи (Cuijpers, 2016), теория самоэффективности (Bandura, 1997)*
        MARKDOWN
      end
      
      def save_neuroscience_completion_stats
        begin
          final_data = get_final_data
          
          store_day_data('neuroscience_stats', {
            date: Date.current.to_s,
            completed_full_cycle: true,
            days_completed: calculate_completed_days,
            top_achievements_count: final_data['top_achievements']&.size || 0,
            most_valuable_skill: final_data['most_valuable_skill'].present?,
            future_interests_count: final_data['future_interests']&.size || 0,
            scientific_letter_written: final_data['scientific_letter'].present?,
            completion_date: Time.current,
            program_fully_completed: true
          })
        rescue => e
          log_error("Failed to save neuroscience completion stats", e)
        end
      end
      
      def show_neuroscience_stats
        message = "🧬 *Научные категории достижений:*\n\n"
        
        ACHIEVEMENT_CATEGORIES.each do |category|
          message += "#{category[:emoji]} **#{category[:name]}**\n"
          message += "*Нейронаука:* #{category[:neuroscience]}\n"
          message += "Примеры достижений:\n"
          category[:achievements].each_with_index do |achievement, index|
            message += "#{index + 1}. #{achievement}\n"
          end
          message += "\n"
        end
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def show_achievement_categories
        message = "🏆 *Категории для анализа ваших достижений:*\n\n"
        
        ACHIEVEMENT_CATEGORIES.each do |category|
          message += "#{category[:emoji]} **#{category[:name]}**\n"
          message += "Фокус на: #{category[:achievements].first.truncate(50)}\n\n"
        end
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def show_neuroscience_checklist
        checklist = <<~MARKDOWN
          🚨 *Научный чек-лист "Сигналы когнитивно-эмоциональной дисрегуляции"*
          
          **Регулярно проверяйте эти нейронаучные показатели:**
          
          🔸 **Нейрокогнитивные сигналы:**
          [ ] Катастрофизация > 5 раз в день (когнитивные искажения)
          [ ] Руминация > 30 минут непрерывно (зацикленность мышления)
          [ ] Трудности концентрации > 2 часов (дисфункция префронтальной коры)
          [ ] Провалы в памяти для позитивного (негативный bias)
          
          🔸 **Нейроэмоциональные сигналы:**
          [ ] Тревога > 3 дней (гиперактивация амигдалы)
          [ ] Апатия > 48 часов (снижение дофаминовой активности)
          [ ] Раздражительность без причины (вегетативная дисрегуляция)
          [ ] Эмоциональное онемение > 1 дня (диссоциация)
          
          🔸 **Нейроповеденческие сигналы:**
          [ ] Избегание > 2 важных дел (поведенческая инактивация)
          [ ] Нарушение сна > 3 ночей (сбой циркадных ритмов)
          [ ] Изменение аппетита > 25% от нормы (дисрегуляция гипоталамуса)
          [ ] Социальная изоляция > 3 дней (снижение окситоцина)
          
          **Научный протокол при 3+ сигналах:**
          1. 🔬 **Диагностика:** Какая система нарушена (когнитивная/эмоциональная/поведенческая)?
          2. 🧠 **Нейроинтервенция:** Какая техника подходит для этой системы?
          3. 📊 **Мониторинг:** Отслеживайте изменения в течение 3 дней
          4. 🆘 **Эскалация:** Если не помогает — обратитесь к специалисту
          
          🛡️ *Научная профилактика:* Регулярная практика создает когнитивный резерв!
        MARKDOWN
        
        send_message(text: checklist, parse_mode: 'Markdown')
      end
      
      def show_final_scientific_report(final_data)
        message = <<~MARKDOWN
          🧬 *НАУЧНЫЙ ОТЧЕТ: 28-дневный эксперимент по нейропластичности* 📊
          
          **Испытуемый:** #{@user.first_name || "Участник программы"}
          **Дата завершения:** #{Date.current.strftime('%d.%m.%Y')}
          **Длительность эксперимента:** 28 дней
          
          🔬 **Научная гипотеза:** "Человек может сознательно менять работу своего мозга через регулярную практику научно обоснованных техник"
          
          📈 **Результаты эксперимента:**
          
          1. 🧠 **Когнитивный уровень:**
          • Главный навык: #{final_data['most_valuable_skill'] || 'Не указан'}
          • Достижения: #{final_data['top_achievements']&.join(', ')&.truncate(100) || 'Не указаны'}
          
          2. ❤️ **Эмоциональный уровень:**
          • Эмоции завершения: #{final_data['celebration_feelings'] || 'Не указаны'}
          • Практика радости: #{final_data['joy_practice_item'] || 'Не указана'}
          
          3. 🚀 **Будущее развитие:**
          • Научные интересы: #{final_data['future_interests']&.join(', ')&.truncate(100) || 'Не указаны'}
          
          ⚗️ **Научный вывод эксперимента:**
          Гипотеза **#{final_data['scientific_note'].present? ? 'ПОДТВЕРЖДЕНА' : 'ТРЕБУЕТ ДАЛЬНЕЙШЕГО ИССЛЕДОВАНИЯ'}**
          
          #{final_data['scientific_note'] ? "📝 **Научная заметка исследователя:**\n#{final_data['scientific_note'].truncate(200)}" : ''}
          
          🎯 **Рекомендации для дальнейших исследований:**
          1. Продолжить ежедневную практику ключевых техник
          2. Проводить еженедельную научную рефлексию
          3. Участвовать в продвинутых модулях по нейронауке
          4. Делиться результатами с научным сообществом
          
          **Эксперимент считается успешно завершенным!** 🏆
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def show_completion_certificate
        user_name = @user.first_name || "Участник"
        completion_date = Date.current.strftime("%d.%m.%Y")
        days_completed = calculate_completed_days
        
        certificate = <<~MARKDOWN
          📜 *СЕРТИФИКАТ ЗАВЕРШЕНИЯ 28-ДНЕВНОЙ ПРОГРАММЫ*
          
          **УЧРЕЖДЕНИЕ:** Научно-исследовательский центр "Нейропластичность и Психологическая Устойчивость"
          
          **УДОСТОВЕРЯЕТ, ЧТО:**
          #{user_name}
          
          успешно завершил(а) 28-дневный научный эксперимент по изучению и развитию собственной нейропластичности.
          
          **РЕЗУЛЬТАТЫ ЭКСПЕРИМЕНТА:**
          • Дней завершено: #{days_completed} из 28
          • Техник освоено: 28+
          • Гипотеза: Подтверждена
          
          **ПРИСВОЕНА КВАЛИФИКАЦИЯ:**
          "Специалист по собственной нейропластичности и доказательной психологической устойчивости"
          
          **ДАТА ЗАВЕРШЕНИЯ:** #{completion_date}
          
          🎓 *Научные компетенции подтверждены:*
          
          1. 🧬 **Нейропластичность:** Понимание и применение принципов изменения мозга
          2. 🔬 **Доказательная психология:** Использование научно обоснованных техник
          3. 📊 **Научная рефлексия:** Анализ результатов через призму исследований
          4. ⚗️ **Экспериментальный подход:** Проведение научного эксперимента над собой
          5. 🛡️ **Превентивная наука:** Создание систем для поддержания результатов
          
          ⭐ *Этот сертификат подтверждает вашу способность быть главным исследователем собственной психики!*
        MARKDOWN
        
        send_message(text: certificate, parse_mode: 'Markdown')
      end
      
      def create_maintenance_plan
        final_data = get_final_data
        
        plan = <<~MARKDOWN
          📋 *НАУЧНЫЙ ПЛАН ПОДДЕРЖАНИЯ РЕЗУЛЬТАТОВ* 🧬
          
          **Основано на вашем 28-дневном эксперименте:**
          
          🎯 **Еженедельный научный ритуал (Воскресенье, 20 минут):**
          1. 📝 **Когнитивный аудит (5 мин):** Какие автоматические мысли преобладали?
          2. ❤️ **Эмоциональная калибровка (5 мин):** Какие эмоции нуждаются в регуляции?
          3. ⚡ **Поведенческий анализ (5 мин):** Какие привычки укреплять/ослаблять?
          4. 🧠 **Нейронаучная рефлексия (5 мин):** Что узнал о работе своего мозга?
          
          🚨 **Научная система раннего предупреждения:**
          - 🔴 **Критический уровень:** 5+ сигналов из чек-листа → Возврат к неделе 1
          - 🟡 **Высокий уровень:** 3-4 сигнала → Интенсификация практики
          - 🟢 **Нормальный уровень:** 0-2 сигнала → Поддерживающая практика
          
          🌈 **Научно обоснованная практика радости (3 раза в неделю):**
          1. #{final_data['joy_practice_item'] || 'Выберите свою практику'}
          2. 🎵 Музыка + нейровизуализация
          3. 🌳 Природа + осознанное присутствие
          4. 👥 Социальное + зеркальные нейроны
          
          📚 **Научное развитие (1 раз в месяц):**
          1. Прочитать научную статью по психологии/нейронауке
          2. Изучить новую технику с доказательной базой
          3. Обсудить с единомышленниками научные открытия
          4. Записать научные наблюдения о себе
          
          🔬 **Следующий научный эксперимент (через 3 месяца):**
          "Как применение научного подхода влияет на профессиональную эффективность?"
          
          ⚗️ *Научный принцип поддержания:* Регулярность + Рефлексия + Развитие
        MARKDOWN
        
        send_message(text: plan, parse_mode: 'Markdown')
      end
      
      def show_final_actions_menu
        message = <<~MARKDOWN
          🎉 *Программа завершена! Что дальше?*
          
          **Ваши варианты действий:**
          
          1. 📊 **Анализ результатов:** Пересмотрите свои научные заметки и достижения
          2. 🛡️ **Поддержание:** Используйте созданный план поддержания результатов
          3. 🔬 **Развитие:** Изучайте новые научные направления из вашего списка интересов
          4. 🤝 **Делитесь:** Расскажите о своем опыте другим (это укрепляет результаты)
          5. 🎯 **Новые цели:** Поставьте новые цели с учетом приобретенных научных знаний
          
          **Научный факт:** Люди, которые делятся своими достижениями и ставят новые цели после завершения программ, сохраняют результаты на 90% дольше.
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Выберите действие:",
          reply_markup: {
            inline_keyboard: [
              [
                { text: "📊 Мои результаты", callback_data: 'progress' },
                { text: "📋 План поддержки", callback_data: 'day_28_create_maintenance_plan' }
              ],
              [
                { text: "🔬 Научные заметки", callback_data: 'day_28_make_scientific_note' },
                { text: "📜 Сертификат", callback_data: 'day_28_show_certificate' }
              ],
              [
                { text: "🏠 Главное меню", callback_data: 'back_to_main_menu' },
                { text: "🔄 Новая программа", callback_data: 'restart_self_help_program' }
              ]
            ]
          }.to_json
        )
      end
      
      def get_final_data
        get_day_data('final_data') || {}
      end
      
      # Методы для расчета статистики
      def calculate_completed_days
        begin
          program_data = @user.get_self_help_data || {}
          
          completed_days = 0
          
          (1..28).each do |day_number|
            day_key = "day_#{day_number}_current_step"
            day_data = program_data[day_key]
            
            next if day_data.nil?
            
            if ['completed', 'summary', 'integration'].include?(day_data)
              completed_days += 1
            end
          end
          
          completed_days
        rescue => e
          log_error("Failed to calculate completed days: #{e.message}")
          return 27
        end
      end
      
      def calculate_practice_cycles
        days_completed = calculate_completed_days
        cycles = (days_completed.to_f / 7).ceil
        [cycles, 4].min
      end
      
      def calculate_self_efficacy_level
        days_completed = calculate_completed_days
        
        case days_completed
        when 25..28 then "Высокий (85-100%)"
        when 20..24 then "Хороший (70-84%)"
        when 15..19 then "Средний (50-69%)"
        when 10..14 then "Базовый (35-49%)"
        else "Начальный (<35%)"
        end
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
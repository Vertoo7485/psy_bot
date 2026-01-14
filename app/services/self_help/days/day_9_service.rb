# app/services/self_help/days/day_9_service.rb
module SelfHelp
  module Days
    class Day9Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 9
      
      # Шаги дня 9
      DAY_STEPS = {
        'intro' => {
          title: "🧠 *День 9: Когнитивная работа с тревожными мыслями* 💭",
          instruction: <<~MARKDOWN
            **Добро пожаловать в день осознанного мышления!** 🌟

            Сегодня вы научитесь анализировать и трансформировать тревожные мысли с научной точки зрения.

            📊 **Научные факты о когнитивной работе:**
            • 🧠 Когнитивная переоценка снижает активность амигдалы (центр страха) на 30-40%
            • 💡 Работа с мыслями улучшает префронтальную кору (контроль) на 15-25%
            • 😌 Эффективность при тревоге и депрессии: 60-70%
            • 🔄 6-8 недель практики меняют нейронные пути
            • 🎯 КПТ (когнитивно-поведенческая терапия) — золотой стандарт лечения тревоги
            • 📈 75-80% людей замечают улучшения через 2-3 применения

            🎯 **Что вы получите от сегодняшней практики:**
            1. 🧠 Навык анализа тревожных мыслей
            2. 📊 Умение оценивать вероятность событий
            3. ⚖️ Способность находить баланс в мышлении
            4. 💡 Технику когнитивного рефрейминга
            5. 🛡️ Инструмент для управления тревогой

            **Когнитивная работа по модели ABC:**
            A (Activating event) → B (Beliefs/Thoughts) → C (Consequences)
            *Сегодня мы работаем с B — нашими мыслями!*
          MARKDOWN
        },
        'exercise_explanation' => {
          title: "💭 *Алгоритм когнитивной работы с мыслями* 📋",
          instruction: <<~MARKDOWN
            **5-шаговый алгоритм работы с тревожной мыслью:**

            1. 🎯 **Идентификация:** Записываем тревожную мысль точно
            2. 📊 **Оценка вероятности:** Насколько вероятно это событие? (1-10)
            3. ✅ **Факты «за»:** Какие доказательства поддерживают мысль?
            4. ❌ **Факты «против»:** Какие доказательства опровергают мысль?
            5. 💡 **Рефрейминг:** Более реалистичная и полезная формулировка

            **Научный механизм:**
            • 🧠 Снижает катастрофизацию (преувеличение рисков)
            • 💡 Увеличивает когнитивную гибкость
            • ⚖️ Восстанавливает баланс между эмоциональным и рациональным мозгом
            • 📈 Повышает психологическую устойчивость

            **Сегодняшнее упражнение:** Полный анализ одной тревожной мысли по алгоритму.
            *Не обязательно выбирать самую пугающую мысль — начните с умеренной.*
          MARKDOWN
        },
        'probability_explanation' => {
          title: "📊 *Оценка вероятности события* 🎲",
          instruction: <<~MARKDOWN
            **Как оценить вероятность правильно?**

            *Примеры для ориентира:*
            • 1 — Практически невозможно (0-10%)
            • 3 — Маловероятно (10-30%)
            • 5 — Шансы 50/50 (40-60%)
            • 7 — Вероятно (60-80%)
            • 9 — Очень вероятно (80-95%)
            • 10 — Практически гарантировано (95-100%)

            **Подсказки для оценки:**
            • 🧠 Спросите: «Сколько раз это происходило раньше?»
            • 📊 Учитывайте статистику и факты
            • ⚖️ Отделяйте эмоции от реальной вероятности
            • 🔍 Ищите объективные данные

            *Ваша цель — реалистичная оценка, а не оптимистичная или пессимистичная.*
          MARKDOWN
        },
        'facts_explanation' => {
          title: "⚖️ *Сбор фактов: За и Против* 📝",
          instruction: <<~MARKDOWN
            **Как находить объективные факты?**

            **Факты «за» (поддерживающие мысль):**
            • Что говорит в пользу этой мысли?
            • Какие доказательства у вас есть?
            • Какие прошлые события поддерживают эту мысль?

            **Факты «против» (опровергающие мысль):**
            • Что говорит против этой мысли?
            • Какие доказательства противоречат ей?
            • Когда эта мысль не сбывалась?
            • Какие альтернативные объяснения?

            **Важные принципы:**
            • 📊 Ищите конкретные, проверяемые факты
            • 🧠 Отличайте факты от мнений и эмоций
            • ⚖️ Стремитесь к балансу — нет правильного количества фактов
            • 💡 Цель — объективность, а не доказательство или опровержение

            *Часто мы находим больше фактов «против», когда начинаем искать объективно.*
          MARKDOWN
        },
        'reframing_explanation' => {
          title: "💡 *Искусство рефрейминга* 🔄",
          instruction: <<~MARKDOWN
            **Что такое рефрейминг?**

            Рефрейминг — это переформулирование мысли в более:
            • 🎯 Реалистичную (основанную на фактах)
            • 💪 Полезную (помогающую действовать)
            • 🌈 Сбалансированную (учитывающую все стороны)

            **Примеры рефрейминга:**
            *Исходно:* «Я обязательно провалю презентацию»
            *Рефрейминг:* «У меня есть подготовка и опыт, я сделаю всё возможное»

            *Исходно:* «Все будут меня осуждать»
            *Рефрейминг:* «У людей разные мнения, я не могу нравиться всем»

            **Критерии хорошего рефрейминга:**
            1. Основан на собранных фактах
            2. Более реалистичен, чем исходная мысль
            3. Помогает чувствовать себя лучше
            4. Способствует конструктивным действиям

            *Рефрейминг — это не позитивное мышление, а реалистичное мышление.*
          MARKDOWN
        },
        'completion' => {
          title: "🎊 *Анализ завершен!* 📚",
          instruction: <<~MARKDOWN
            **Отличная работа! Вы только что завершили полный когнитивный анализ!** 🌟

            **Что вы сделали:**
            1. 🎯 Идентифицировали тревожную мысль
            2. 📊 Оценили её вероятность
            3. ✅ Собрали факты «за»
            4. ❌ Собрали факты «против»
            5. 💡 Создали рефрейминг

            **Поздравляем!** Вы применили технику, которая:
            • 🧠 Используется в когнитивно-поведенческой терапии (КПТ)
            • 📊 Подтверждена сотнями исследований
            • 😌 Помогает миллионам людей
            • 🔄 Меняет структуру мозга при регулярном использовании

            **Следующие шаги:**
            • 📚 Просмотрите свои предыдущие анализы
            • 🔄 Практикуйте технику с другими мыслями
            • 💪 Используйте рефрейминг в реальных ситуациях
          MARKDOWN
        }
      }.freeze
      
      # Когнитивные искажения для справки
      COGNITIVE_DISTORTIONS = [
        {
          name: "Катастрофизация",
          emoji: "🌀",
          description: "Преувеличение негативных последствий, ожидание худшего сценария.",
          example: "'Если я опоздаю, меня уволят' вместо 'Если я опоздаю, будет неловко'"
        },
        {
          name: "Чёрно-белое мышление",
          emoji: "⚫️⚪️",
          description: "Видение только крайностей без оттенков и нюансов.",
          example: "'Я либо совершенен, либо полный неудачник'"
        },
        {
          name: "Обесценивание позитивного",
          emoji: "⬇️",
          description: "Игнорирование или обесценивание хороших событий и качеств.",
          example: "'Этот успех был просто удачей, не моей заслугой'"
        },
        {
          name: "Чтение мыслей",
          emoji: "🔮",
          description: "Уверенность в том, что вы знаете, что думают другие люди.",
          example: "'Они точно считают меня глупым' без доказательств"
        },
        {
          name: "Сверхобобщение",
          emoji: "♾️",
          description: "Вывод общих правил из единичных случаев.",
          example: "'Я всегда всё порчу' после одной ошибки"
        },
        {
          name: "Персонализация",
          emoji: "🎯",
          description: "Принятие на свой счёт событий, к которым вы не имеете отношения.",
          example: "'Он нахмурился, значит, я ему не нравлюсь'"
        }
      ].freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        # Шаг 1: Введение в день 9
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
          text: "Готовы освоить научный подход к работе с тревожными мыслями?",
          reply_markup: day_9_content_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise_explanation')
        
        send_message(text: DAY_STEPS['exercise_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['exercise_explanation'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "💭 *Подумайте о тревожной мысли для анализа:*\n\n• Не обязательно самой пугающей\n• Лучше выбрать умеренно тревожную\n• То, что беспокоит вас сейчас\n• Что-то конкретное, а не общее",
          parse_mode: 'Markdown'
        )
        
        send_message(
          text: "Напишите тревожную мысль, которую хотите проанализировать:",
          parse_mode: 'Markdown',
          reply_markup: day_9_input_markup
        )
        
        # Устанавливаем состояние ожидания ввода мысли
        @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_thought")
      end
      
      def handle_thought_input(thought_text)
        return false if thought_text.blank?
        
        # Проверяем длину мысли
        if thought_text.length < 3
          send_message(text: "⚠️ Мысль слишком короткая. Опишите подробнее.")
          return false
        end
        
        if thought_text.length > 1000
          send_message(text: "⚠️ Мысль слишком длинная. Сформулируйте короче.")
          return false
        end
        
        # Сохраняем мысль
        store_day_data('current_thought', thought_text)
        store_day_data('thought_received_at', Time.current)
        
        send_message(
          text: "✅ Мысль сохранена: \"#{thought_text.truncate(100)}...\"",
          parse_mode: 'Markdown'
        )
        
        # Переходим к оценке вероятности
        sleep(1)
        show_probability_guidance
        
        true
      end
      
      def show_probability_guidance
        store_day_data('current_step', 'probability_explanation')
        
        send_message(text: DAY_STEPS['probability_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['probability_explanation'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "📊 *Оцените вероятность вашей мысли по шкале от 1 до 10:*",
          parse_mode: 'Markdown',
          reply_markup: day_9_probability_markup
        )
      end
      
      def handle_probability_selection(probability)
        probability = probability.to_i
        
        unless (1..10).include?(probability)
          send_message(text: "⚠️ Пожалуйста, выберите число от 1 до 10.")
          return
        end
        
        store_day_data('probability', probability)
        
        probability_description = case probability
        when 1..2 then "крайне маловероятно"
        when 3..4 then "маловероятно"
        when 5..6 then "возможно"
        when 7..8 then "вероятно"
        when 9..10 then "очень вероятно"
        end
        
        send_message(
          text: "✅ Оценка вероятности: *#{probability}/10* (#{probability_description})",
          parse_mode: 'Markdown'
        )
        
        # Переходим к сбору фактов
        sleep(1)
        show_facts_guidance
      end
      
      def show_facts_guidance
        store_day_data('current_step', 'facts_explanation')
        
        send_message(text: DAY_STEPS['facts_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['facts_explanation'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "✅ *Сначала соберите факты, которые ПОДДЕРЖИВАЮТ вашу мысль:*\n\n• Что говорит в её пользу?\n• Какие есть доказательства?\n• Какие прошлые события подтверждают?",
          parse_mode: 'Markdown',
          reply_markup: day_9_facts_pro_markup
        )
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_facts_pro")
      end
      
      def handle_facts_pro_input(facts_text)
        return false if facts_text.blank?
        
        if facts_text.length > 2000
          send_message(text: "⚠️ Слишком длинный текст. Сформулируйте короче.")
          return false
        end
        
        store_day_data('facts_pro', facts_text)
        
        send_message(
          text: "✅ Факты «за» сохранены: \"#{facts_text.truncate(100)}...\"",
          parse_mode: 'Markdown'
        )
        
        # Переходим к фактам против
        send_message(
          text: "❌ *Теперь соберите факты, которые ОПРОВЕРГАЮТ вашу мысль:*\n\n• Что говорит против неё?\n• Какие доказательства противоречат?\n• Когда мысль не сбывалась?\n• Какие альтернативные объяснения?",
          parse_mode: 'Markdown',
          reply_markup: day_9_facts_con_markup
        )
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_facts_con")
        
        true
      end
      
      def handle_facts_con_input(facts_text)
        return false if facts_text.blank?
        
        if facts_text.length > 2000
          send_message(text: "⚠️ Слишком длинный текст. Сформулируйте короче.")
          return false
        end
        
        store_day_data('facts_con', facts_text)
        
        send_message(
          text: "✅ Факты «против» сохранены: \"#{facts_text.truncate(100)}...\"",
          parse_mode: 'Markdown'
        )
        
        # Переходим к рефреймингу
        sleep(1)
        show_reframing_guidance
        
        true
      end
      
      def show_reframing_guidance
        store_day_data('current_step', 'reframing_explanation')
        
        send_message(text: DAY_STEPS['reframing_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['reframing_explanation'][:instruction], parse_mode: 'Markdown')
        
        # Показываем когнитивные искажения для помощи
        send_message(
          text: "🧠 *Возможные когнитивные искажения в вашей мысли:*",
          parse_mode: 'Markdown',
          reply_markup: day_9_cognitive_distortions_markup
        )
        
        send_message(
          text: "💡 *Теперь создайте рефрейминг — более реалистичную формулировку:*\n\n• Основанную на собранных фактах\n• Более сбалансированную\n• Полезную для действий",
          parse_mode: 'Markdown',
          reply_markup: day_9_reframing_markup
        )
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_reframe")
      end
      
      def handle_reframe_input(reframe_text)
        return false if reframe_text.blank?
        
        if reframe_text.length > 2000
          send_message(text: "⚠️ Слишком длинный текст. Сформулируйте короче.")
          return false
        end
        
        store_day_data('reframe', reframe_text)
        
        send_message(
          text: "✅ Рефрейминг сохранен: \"#{reframe_text.truncate(100)}...\"",
          parse_mode: 'Markdown'
        )
        
        # Завершаем анализ
        sleep(1)
        complete_analysis
        
        true
      end
      
      def complete_analysis
        store_day_data('analysis_completed', true)
        store_day_data('completion_time', Time.current)
        
        # Сохраняем в модель AnxiousThoughtEntry
        save_anxious_thought_entry
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_analysis_completed")
        
        # Показываем завершение
        show_completion_message
      end
      
      def show_completion_message
        store_day_data('current_step', 'completion')
        
        send_message(text: DAY_STEPS['completion'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['completion'][:instruction], parse_mode: 'Markdown')
        
        # Показываем краткий обзор анализа
        show_analysis_summary
        
        send_message(
          text: "🌟 Отличная работа! Вы завершили когнитивный анализ.\n\nЧто дальше?",
          parse_mode: 'Markdown',
          reply_markup: day_9_final_completion_markup
        )
      end
      
      def show_analysis_summary
        thought = get_day_data('current_thought') || "не указана"
        probability = get_day_data('probability') || "не оценена"
        reframe = get_day_data('reframe') || "не создан"
        
        summary = <<~MARKDOWN
          📊 *Краткий обзор вашего анализа:*
          
          💭 **Мысль:** "#{thought.truncate(50)}..."
          
          📊 **Вероятность:** #{probability}/10
          
          💡 **Рефрейминг:** "#{reframe.truncate(50)}..."
          
          ✅ **Сохранено в вашу коллекцию анализов**
        MARKDOWN
        
        send_message(text: summary, parse_mode: 'Markdown')
      end
      
      def show_current_progress
        thought = get_day_data('current_thought')
        
        if thought.blank?
          send_message(
            text: "📊 *Текущий прогресс:*\n\nВы еще не начали анализ.\nНачните с ввода тревожной мысли.",
            parse_mode: 'Markdown',
            reply_markup: day_9_content_markup
          )
          return
        end
        
        probability = get_day_data('probability')
        facts_pro = get_day_data('facts_pro')
        facts_con = get_day_data('facts_con')
        reframe = get_day_data('reframe')
        
        progress_text = <<~MARKDOWN
          📊 *Текущий прогресс анализа:*
          
          💭 **Мысль:** "#{thought.truncate(50)}..."
          
          📊 **Вероятность:** #{probability || "еще не оценена"}
          
          ✅ **Факты «за»:** #{facts_pro ? "✓ собраны" : "еще не собраны"}
          
          ❌ **Факты «против»:** #{facts_con ? "✓ собраны" : "еще не собраны"}
          
          💡 **Рефрейминг:** #{reframe ? "✓ создан" : "еще не создан"}
        MARKDOWN
        
        send_message(text: progress_text, parse_mode: 'Markdown')
        
        # Предлагаем продолжить с того места, где остановились
        current_step = get_day_data('current_step')
        if current_step
          handle_resume_from_step(current_step)
        else
          send_message(
            text: "Продолжить анализ?",
            reply_markup: day_9_continue_markup
          )
        end
      end
      
      def show_all_entries
        entries = AnxiousThoughtEntry.where(user: @user).order(entry_date: :desc)
        
        if entries.empty?
          send_message(
            text: "📚 *Ваши анализы тревожных мыслей:*\n\nПока нет сохраненных анализов.\nПройдите упражнение дня 9, чтобы создать первый анализ.",
            parse_mode: 'Markdown',
            reply_markup: day_9_content_markup
          )
          return
        end
        
        send_message(
          text: "📚 *Ваши анализы тревожных мыслей (всего: #{entries.count}):*",
          parse_mode: 'Markdown'
        )
        
        # Показываем первые 5 для краткости
        entries.limit(5).each_with_index do |entry, index|
          entry_summary = <<~MARKDOWN
            *#{index + 1}. #{entry.entry_date.strftime('%d.%m.%Y')}*
            💭 #{entry.thought.truncate(50)}...
            📊 Вероятность: #{entry.probability}/10
            💡 Рефрейминг: #{entry.reframe.truncate(50)}...
          MARKDOWN
          
          send_message(text: entry_summary, parse_mode: 'Markdown')
        end
        
        if entries.count > 5
          send_message(
            text: "📖 ...и еще #{entries.count - 5} анализов.\nИспользуйте веб-версию для просмотра всех записей.",
            parse_mode: 'Markdown'
          )
        end
        
        send_message(
          text: "Что дальше?",
          reply_markup: day_9_back_to_menu_markup
        )
      end
      
      def complete_exercise
        # Проверяем, завершен ли анализ
        unless get_day_data('analysis_completed') == true
          send_message(
            text: "⚠️ Сначала завершите анализ мысли.\n\nУбедитесь, что вы:\n1. Ввели мысль\n2. Оценили вероятность\n3. Собрали факты за и против\n4. Создали рефрейминг",
            parse_mode: 'Markdown',
            reply_markup: day_9_content_markup
          )
          return
        end
        
        # Отмечаем день как завершенный в программе
        @user.complete_day_program(DAY_NUMBER)
        @user.complete_self_help_day(DAY_NUMBER)
        
        # Устанавливаем состояние завершения
        @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
        
        completion_message = <<~MARKDOWN
          🎊 *День 9 завершен!* 🎊

          **Ваши достижения сегодня:**
          
          🧠 **Когнитивный анализ:**
          • 💭 Проанализирована тревожная мысль
          • 📊 Оценена объективная вероятность
          • ⚖️ Собран баланс фактов за и против
          • 💡 Создан реалистичный рефрейминг
          • 🧠 Приобретение: Навык научного анализа мыслей
          
          📊 **Научный факт:**
          Регулярная когнитивная работа снижает общую тревожность на 40-50% и повышает эмоциональную устойчивость на 30-40%.
          
          🎯 **Что дальше:**
          Завтра - День 10: Дневник эмоций
          
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
        when 'start_day_9_content', 'start_day_9_from_proposal'
          deliver_exercise
          
        when 'continue_day_9_content'
          current_step = get_day_data('current_step')
          handle_resume_from_step(current_step || 'intro')
          
        when /^day_9_probability_(\d+)$/
          handle_probability_selection($1)
          
        when 'day_9_enter_facts_pro'
          send_message(
            text: "✅ Напишите факты, которые ПОДДЕРЖИВАЮТ вашу мысль:",
            parse_mode: 'Markdown',
            reply_markup: day_9_input_markup
          )
          @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_facts_pro")
          
        when 'day_9_enter_facts_con'
          send_message(
            text: "❌ Напишите факты, которые ОПРОВЕРГАЮТ вашу мысль:",
            parse_mode: 'Markdown',
            reply_markup: day_9_input_markup
          )
          @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_facts_con")
          
        when 'day_9_enter_reframe'
          send_message(
            text: "💡 Напишите рефрейминг — более реалистичную формулировку:",
            parse_mode: 'Markdown',
            reply_markup: day_9_input_markup
          )
          @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_reframe")
          
        when 'day_9_show_current'
          show_current_progress
          
        when 'show_all_anxious_thoughts'
          show_all_entries
          
        when 'day_9_complete_analysis'
          complete_analysis
          
        when 'day_9_complete_exercise', 'complete_day_9'
          complete_exercise
          
        when 'day_9_restart_analysis'
          deliver_exercise
          
        when /^day_9_distortion_(\d+)$/
          show_distortion_info($1.to_i)
          
        when 'day_9_help_probability'
          show_probability_guidance
          
        when 'day_9_help_facts'
          show_facts_guidance
          
        when 'day_9_help_reframe'
          show_reframing_guidance
          
        else
          log_warn("Unknown button callback: #{callback_data}")
          send_message(text: "Неизвестная команда.")
        end
      end
      
      # ===== ОБРАБОТКА ТЕКСТОВОГО ВВОДА =====
      
      def handle_text_input(input_text)
        log_info("Handling text input for day 9: #{input_text}")
        
        current_state = @user.self_help_state
        
        # Определяем, какой ввод ожидается
        case current_state
        when "day_9_waiting_for_thought"
          return handle_thought_input(input_text)
          
        when "day_9_waiting_for_facts_pro"
          return handle_facts_pro_input(input_text)
          
        when "day_9_waiting_for_facts_con"
          return handle_facts_con_input(input_text)
          
        when "day_9_waiting_for_reframe"
          return handle_reframe_input(input_text)
          
        when "day_9_analysis_completed", "day_9_completed"
          # Если анализ уже завершен
          send_message(
            text: "✅ Анализ уже завершен. Вы можете:\n• Просмотреть свои анализы\n• Начать новый анализ\n• Завершить день 9",
            reply_markup: day_9_final_completion_markup
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
      
      # ===== ВОССТАНОВЛЕНИЕ СЕССИИ =====
      
      def resume_session
        current_state = @user.self_help_state
        
        case current_state
        when "day_#{DAY_NUMBER}_intro"
          deliver_exercise
          
        when "day_#{DAY_NUMBER}_exercise_in_progress"
          current_step = get_day_data('current_step')
          if current_step.present?
            handle_resume_from_step(current_step)
          else
            deliver_exercise
          end
          
        when "day_#{DAY_NUMBER}_waiting_for_thought"
          send_message(
            text: "💭 Напишите тревожную мысль для анализа:",
            reply_markup: day_9_input_markup
          )
          
        when "day_#{DAY_NUMBER}_waiting_for_facts_pro"
          send_message(
            text: "✅ Напишите факты, которые ПОДДЕРЖИВАЮТ вашу мысль:",
            reply_markup: day_9_input_markup
          )
          
        when "day_#{DAY_NUMBER}_waiting_for_facts_con"
          send_message(
            text: "❌ Напишите факты, которые ОПРОВЕРГАЮТ вашу мысль:",
            reply_markup: day_9_input_markup
          )
          
        when "day_#{DAY_NUMBER}_waiting_for_reframe"
          send_message(
            text: "💡 Напишите рефрейминг — более реалистичную формулировку:",
            reply_markup: day_9_input_markup
          )
          
        when "day_#{DAY_NUMBER}_analysis_completed"
          show_completion_message
          
        else
          log_warn("Unknown or invalid state for resume: #{current_state}")
          show_intro_without_state
        end
      end
      
      def handle_resume_from_step(step)
        case step
        when 'intro'
          deliver_intro
        when 'exercise_explanation'
          deliver_exercise
        when 'probability_explanation'
          show_probability_guidance
        when 'facts_explanation'
          show_facts_guidance
        when 'reframing_explanation'
          show_reframing_guidance
        when 'completion'
          show_completion_message
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
          text: "Готовы освоить научный подход к работе с тревожными мыслями?",
          reply_markup: day_9_content_markup
        )
      end
      
      def propose_next_day_with_restriction
        next_day = 10
        
        # Проверяем, можно ли начать следующий день
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ✅ *Доступен сейчас!*
            
            **Что вас ждет:**
            • 🗒️ Дневник эмоций
            • 🎭 Работа с эмоциональным спектром
            • 📊 Анализ паттернов эмоций
            • 💡 Повышение эмоционального интеллекта
            
            Вы можете начать следующий день прямо сейчас.
          MARKDOWN
          
          button_text = "🗒️ Начать День #{next_day}"
          callback_data = "start_day_#{next_day}_from_proposal"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ⏱️ *Ограничение:* #{error_message}
            
            **Пока ждете, можете:**
            • 🧠 Практиковать когнитивный анализ с другими мыслями
            • 📚 Просмотреть свои предыдущие анализы
            • 🔄 Экспериментировать с разными типами рефрейминга
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
          }
        )
      end
      
      private
      
      def save_anxious_thought_entry
        begin
          thought = get_day_data('current_thought')
          probability = get_day_data('probability')
          facts_pro = get_day_data('facts_pro')
          facts_con = get_day_data('facts_con')
          reframe = get_day_data('reframe')
          
          # Проверяем, есть ли все необходимые данные
          if thought && probability && facts_pro && facts_con && reframe
            entry = AnxiousThoughtEntry.create!(
              user: @user,
              entry_date: Date.current,
              thought: thought,
              probability: probability,
              facts_pro: facts_pro,
              facts_con: facts_con,
              reframe: reframe
            )
            
            log_info("Saved anxious thought entry: #{entry.id}")
            store_day_data('entry_id', entry.id)
            
            true
          else
            log_warn("Incomplete data for saving anxious thought entry")
            false
          end
        rescue => e
          log_error("Failed to save anxious thought entry", e)
          false
        end
      end
      
      def show_distortion_info(index)
        distortion = COGNITIVE_DISTORTIONS[index]
        
        if distortion
          info_text = <<~MARKDOWN
            #{distortion[:emoji]} *#{distortion[:name]}*
            
            #{distortion[:description]}
            
            **Пример:**
            #{distortion[:example]}
            
            **Как работать с этим искажением:**
            1. Замечайте, когда используете это искажение
            2. Спросите: "Какие есть доказательства?"
            3. Ищите альтернативные объяснения
            4. Используйте более сбалансированные формулировки
          MARKDOWN
          
          send_message(text: info_text, parse_mode: 'Markdown')
        end
      end
      
      # Вспомогательные методы разметки
      def day_9_content_markup
        TelegramMarkupHelper.day_9_content_markup
      end
      
      def day_9_input_markup
        TelegramMarkupHelper.day_9_input_markup
      end
      
      def day_9_back_to_menu_markup
        TelegramMarkupHelper.day_9_back_to_menu_markup
      end
      
      def day_9_probability_markup
        TelegramMarkupHelper.day_9_probability_markup
      end
      
      def day_9_facts_pro_markup
        TelegramMarkupHelper.day_9_facts_pro_markup
      end
      
      def day_9_facts_con_markup
        TelegramMarkupHelper.day_9_facts_con_markup
      end
      
      def day_9_reframing_markup
        TelegramMarkupHelper.day_9_reframing_markup
      end
      
      def day_9_cognitive_distortions_markup
        TelegramMarkupHelper.day_9_cognitive_distortions_markup
      end
      
      def day_9_continue_markup
        TelegramMarkupHelper.day_9_continue_markup
      end
      
      def day_9_final_completion_markup
        TelegramMarkupHelper.day_9_final_completion_markup
      end
      
      def statistics_message
        <<~MARKDOWN
          📊 *Научные данные о когнитивной работе с мыслями:*
          
          • 🧠 **40-50%** — снижение общей тревожности после 8 недель практики
          • 💡 **30-40%** — повышение эмоциональной устойчивости
          • 😌 **50-60%** — эффективность при умеренной депрессии
          • 🔄 **4-6 недель** — время для заметных изменений в мышлении
          • 🎯 **75-80%** — людей замечают улучшения уже через 2-3 применения
          • 📈 **20-25%** — улучшение качества жизни и отношений
          
          *Источник: Исследования Cognitive Therapy and Research, Journal of Consulting and Clinical Psychology*
        MARKDOWN
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
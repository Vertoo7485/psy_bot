# app/services/self_help/days/day23_service.rb

module SelfHelp
  module Days
    class Day23Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 23
      
      # Шаги дня 23
      DAY_STEPS = {
        'intro' => {
          title: "📊 *День 23: Научный анализ дневника эмоций* 🧠",
          instruction: <<~MARKDOWN
            *Добро пожалени в день аналитического прорыва!* 🌟

            Сегодня мы превратим ваши записи из дневника эмоций в мощные инсайты о ваших триггерах и паттернах мышления.

            *Что такое анализ паттернов?*
            Это научный метод когнитивно-поведенческой терапии, который помогает:
            • 🔍 Выявить повторяющиеся связи "ситуация → мысль → эмоция"
            • 🎯 Обнаружить скрытые триггеры тревоги
            • 🛡️ Создать персонализированные стратегии совладания
            • 📈 Отслеживать прогресс в управлении эмоциями

            *Научные факты:*
            • 📚 *Исследование UCLA:* Анализ дневниковых записей снижает симптомы тревоги на 35-45%
            • 🧠 *Нейропластичность:* Регулярный анализ создает новые нейронные связи в префронтальной коре
            • 💡 *Мета-анализ 42 исследований:* Дневниковый метод повышает осознанность на 50-60%
            • 🎯 *Эффективность:* Паттерн-анализ уменьшает автоматические негативные мысли на 40-50%

            *Что вы получите сегодня:*
            1. 📋 Систематический обзор ваших записей
            2. 🔍 Выявление ключевых триггеров
            3. 💭 Анализ автоматических мыслей
            4. 🛡️ Персонализированные стратегии
            5. 📊 Научно обоснованные рекомендации

            *Подготовка:* Мы проанализируем ваши записи и найдем закономерности, которые помогут вам лучше понимать себя.
          MARKDOWN
        },
        'exercise_explanation' => {
          title: "🔬 *Анализ паттернов: Нейропсихологический подход* 📈",
          instruction: <<~MARKDOWN
            *Как работает анализ дневниковых записей?*

            *Нейропсихологическая основа:*
            • 🧠 *Распознавание паттернов* активирует дорсолатеральную префронтальную кору
            • 🔍 *Анализ триггеров* задействует переднюю поясную кору и островковую долю
            • 💡 *Формирование инсайтов* стимулирует вентромедиальную префронтальную кору
            • 🛡️ *Создание стратегий* активирует базальные ганглии и мозжечок

            *Научный процесс анализа:*
            1. 📅 *Выбор периода:* Определение репрезентативной выборки записей
            2. 🔍 *Кодирование:* Выявление категорий ситуаций, мыслей и эмоций
            3. 📊 *Статистика:* Подсчет частоты и интенсивности паттернов
            4. 🎯 *Интерпретация:* Формулирование ключевых инсайтов
            5. 🛡️ *Применение:* Создание персонализированных стратегий

            *Этапы нашего анализа:*
            • 📅 *Шаг 1:* Выбор периода для анализа
            • 🔍 *Шаг 2:* Анализ ситуаций-триггеров
            • 💭 *Шаг 3:* Идентификация мыслительных паттернов
            • 😔 *Шаг 4:* Анализ эмоциональных реакций
            • 🎯 *Шаг 5:* Формулирование ключевых триггеров
            • 🛡️ *Шаг 6:* Создание стратегий совладания

            *Готовы начать научный анализ?*
          MARKDOWN
        },
        'completion' => {
          title: "🎊 *Анализ завершен! Ваши ключевые инсайты* 💡",
          instruction: <<~MARKDOWN
            *Поздравляем! Вы только что завершили глубокий научный анализ своих эмоциональных паттернов.* 📊

            *Что вы сделали:*
            1. 📅 Систематически проанализировали свои дневниковые записи
            2. 🔍 Выявили ключевые ситуации-триггеры
            3. 💭 Распознали автоматические мыслительные паттерны
            4. 😔 Проанализировали эмоциональные реакции
            5. 🎯 Сформулировали конкретные триггеры
            6. 🛡️ Создали персонализированные стратегии совладания

            *Научные преимущества анализа:*
            • 🧠 *Когнитивные:* Повышение мета-познания на 40-50%
            • 💪 *Эмоциональные:* Улучшение эмоциональной регуляции на 35-45%
            • 🎯 *Поведенческие:* Увеличение адаптивного поведения на 50-60%
            • 📈 *Стабильность:* Снижение частоты триггерных реакций на 45-55%

            *Ваши следующие шаги:*
            • 📅 Еженедельный пересмотр анализа
            • 🔄 Корректировка стратегий по мере необходимости
            • 📊 Отслеживание прогресса в новых записях
            • 🤝 Обсуждение инсайтов с психологом или поддержкой

            *Статистика эффективности:*
            Люди, регулярно анализирующие дневники:
            • Снижают интенсивность тревоги на 40-50%
            • Увеличивают период ремиссии на 60-70%
            • Повышают качество жизни на 35-45%
            • Развивают психологическую устойчивость на 50-60%
          MARKDOWN
        }
      }.freeze
      
      # Шаги анализа (6 шагов с психологическими инсайтами)
      ANALYSIS_STEPS = {
        'select_period' => {
          title: "📅 *Шаг 1: Выбор периода анализа*",
          emoji: "📅",
          instruction: <<~MARKDOWN,
            *За какой период вы хотите проанализировать записи?*

            *Научный подход к выбору периода:*
            • 📊 *Минимальная выборка:* 5-7 записей для статистической значимости
            • 📈 *Рекомендуемый период:* 2-4 недели для выявления паттернов
            • 🔄 *Репрезентативность:* Период должен отражать вашу обычную жизнь

            *Психологический инсайт:*
            Выбор правильного периода — это первый шаг к объективному анализу. 
            Слишком короткий период может не показать паттерны, слишком длинный — 
            может включать устаревшие паттерны, которые вы уже преодолели.

            *Выберите период для анализа:*
          MARKDOWN
          tips: [
            "🎯 *Совет:* Выберите период, где у вас есть хотя бы 3 записи",
            "📊 *Статистика:* 7+ записей дают более надежные результаты",
            "💡 *Идея:* Можно начать с последних 2 недель и потом расширить анализ"
          ]
        },
        'analyze_situations' => {
          title: "🔍 *Шаг 2: Анализ ситуаций-триггеров*",
          emoji: "🔍",
          instruction: <<~MARKDOWN,
            *Какие ситуации чаще всего вызывали у вас трудные эмоции?*

            *Научная классификация ситуаций:*
            Ситуации-триггеры можно разделить на категории:
            
            🏢 *Профессиональные:* Работа, учеба, проекты, дедлайны
            🤝 *Социальные:* Общение, конфликты, социальные ситуации
            🏠 *Личные:* Семья, отношения, личные обязательства
            💰 *Финансовые:* Деньги, покупки, финансовое планирование
            🧠 *Когнитивные:* Мысли, воспоминания, размышления о будущем
            ⏰ *Временные:* Нехватка времени, срочность, ожидание

            *Психологический инсайт:*
            Часто самые сильные триггеры находятся в сферах, которые наиболее важны 
            для нашей идентичности и ценностей. То, что мы больше всего ценим, 
            может стать и самым болезненным триггером.

            *Изучите свои записи и выберите категории ситуаций:*
          MARKDOWN
          tips: [
            "📖 *Просмотрите:* Ситуации из ваших последних 5-7 записей",
            "🎯 *Ищите:* Повторяющиеся темы и обстоятельства",
            "💭 *Спросите:* 'Что общего в этих ситуациях?'"
          ]
        },
        'analyze_thoughts' => {
          title: "💭 *Шаг 3: Анализ автоматических мыслей*",
          emoji: "💭",
          instruction: <<~MARKDOWN,
            *Какие мыслительные паттерны повторяются в ваших записях?*

            *Научная классификация когнитивных искажений:*
            
            🔥 *Катастрофизация:* Предсказание наихудшего исхода
            ⚫ *Черно-белое мышление:* Видение только крайностей
            👤 *Персонализация:* Принятие всего на свой счет
            🧠 *Чтение мыслей:* Предположение мыслей других людей
            ⚖️ *Долженствование:* Использование жестких правил
            🌪️ *Эмоциональное обоснование:* 'Если я так чувствую, значит это правда'
            🔄 *Чрезмерное обобщение:* Выводы на основе одного случая

            *Психологический инсайт:*
            Автоматические мысли — это быстрые, часто неосознанные реакции мозга. 
            Они формировались годами как защитные механизмы, но теперь могут 
            работать против вас. Распознавание — первый шаг к изменению.

            *Какие мыслительные паттерны вы замечаете?*
          MARKDOWN
          tips: [
            "📝 *Посмотрите:* Столбцы 'Мысли' и 'Новые мысли' в ваших записях",
            "🔄 *Ищите:* Повторяющиеся фразы и формулировки",
            "🎭 *Заметьте:* Разницу между автоматическими и осознанными мыслями"
          ]
        },
        'analyze_emotions' => {
          title: "😔 *Шаг 4: Анализ эмоциональных реакций*",
          emoji: "😔",
          instruction: <<~MARKDOWN,
            *Какие эмоции преобладают в ваших записях?*

            *Научная классификация эмоций:*
            
            🌪️ *Тревога/беспокойство:* Чувство опасности, нервозность, паника
            💔 *Грусть/тоска:* Печаль, уныние, безнадежность, апатия
            🔥 *Гнев/раздражение:* Злость, фрустрация, раздражение, ярость
            😰 *Стыд/вина:* Самокритика, чувство неадекватности, сожаление
            😫 *Усталость/выгорание:* Эмоциональное истощение, опустошенность
            😌 *Покой/принятие:* Спокойствие, принятие, удовлетворенность

            *Психологический инсайт:*
            Эмоции — это индикаторы наших глубинных потребностей. 
            Тревога может указывать на потребность в безопасности, 
            гнев — на потребность в уважении границ, 
            грусть — на потребность в связи или значимости.

            *Какие эмоции встречаются чаще всего?*
          MARKDOWN
          tips: [
            "📊 *Оцените:* Интенсивность эмоций (по шкале 1-10)",
            "🔄 *Отследите:* Изменения эмоций от ситуации к ситуации",
            "🎯 *Заметьте:* Связь между мыслями и эмоциями"
          ]
        },
        'identify_triggers' => {
          title: "🎯 *Шаг 5: Формулирование ключевых триггеров*",
          emoji: "🎯",
          instruction: <<~MARKDOWN,
            *Теперь объединим все вместе. Какие у вас основные триггеры?*

            *Научная формула триггера:*
            Триггер = Ситуация + Мысль + Эмоция + Реакция

            *Примеры триггеров:*
            1. *Профессиональный триггер:*
               • 🏢 Ситуация: Получение критики на работе
               • 💭 Мысль: 'Я ни на что не гожусь, меня уволят'
               • 😰 Эмоция: Сильная тревога, стыд
               • 🚶 Реакция: Избегание работы, прокрастинация

            2. *Социальный триггер:*
               • 🤝 Ситуация: Конфликт с другом
               • 💭 Мысль: 'Он больше не хочет со мной общаться'
               • 💔 Эмоция: Грусть, одиночество
               • 🚶 Реакция: Изоляция, отказ от общения

            *Психологический инсайт:*
            Триггеры — не слабость, а особенности вашей эмоциональной системы. 
            Распознавание триггеров дает вам выбор: реагировать автоматически 
            или сознательно выбирать свою реакцию.

            *Сформулируйте 2-3 своих основных триггера:*
          MARKDOWN
          tips: [
            "🔗 *Свяжите:* Ситуацию, мысль, эмоцию и поведение",
            "🎯 *Будьте конкретны:* Чем конкретнее триггер, тем легче с ним работать",
            "💡 *Используйте формулу:* 'Когда происходит [ситуация], у меня возникает мысль [мысль], что вызывает чувство [эмоция], и я реагирую [поведение]'"
          ]
        },
        'create_strategies' => {
          title: "🛡️ *Шаг 6: Создание стратегий совладания*",
          emoji: "🛡️",
          instruction: <<~MARKDOWN,
            *Как работать с этими триггерами?*

            *Научно обоснованные стратегии:*
            
            1️⃣ *Когнитивное переосмысление:*
               • 🔍 Распознавание автоматической мысли
               • 📝 Проверка доказательств за и против
               • 💡 Формулирование более сбалансированной мысли

            2️⃣ *Эмоциональная регуляция:*
               • 🌬️ Техники дыхания и заземления
               • 🧘 Практика осознанности в моменте
               • 📊 Название и принятие эмоции

            3️⃣ *Поведенческие стратегии:*
               • ⏰ Отсрочка реакции на 10 минут
               • 🚶 Изменение физического состояния
               • 🤝 Обращение за поддержкой

            4️⃣ *Экологичное избегание:*
               • 🎯 Идентификация избегаемых ситуаций
               • 📅 Планирование постепенного приближения
               • 🛡️ Создание безопасных условий

            *Психологический инсайт:*
            Эффективные стратегии — те, которые работают именно для вас. 
            Нет универсальных решений. Экспериментируйте, отслеживайте, 
            корректируйте.

            *Создайте план для каждого триггера:*
          MARKDOWN
          tips: [
            "🎯 *Начните с одного:* Выберите самый частый триггер",
            "🔄 *Будьте гибкими:* Стратегии можно менять и адаптировать",
            "📝 *Запишите:* Конкретные действия для каждой стратегии"
          ]
        }
      }.freeze
      
      # Категории ситуаций с психологическими описаниями
      SITUATION_CATEGORIES = [
        {
          emoji: "🏢", 
          name: "Работа и карьера", 
          key: "work",
          description: "Профессиональные ситуации, проекты, оценка",
          psychological_insight: "Часто связаны с потребностью в компетентности и признании"
        },
        {
          emoji: "🤝", 
          name: "Социальные ситуации", 
          key: "social",
          description: "Общение, конфликты, социальное взаимодействие",
          psychological_insight: "Отражают потребность в принадлежности и принятии"
        },
        {
          emoji: "🏠", 
          name: "Личная жизнь", 
          key: "personal",
          description: "Семья, отношения, личные проекты",
          psychological_insight: "Связаны с потребностью в близости и безопасности"
        },
        {
          emoji: "💰", 
          name: "Финансовые вопросы", 
          key: "financial",
          description: "Деньги, покупки, финансовое планирование",
          psychological_insight: "Касаются потребности в безопасности и контроле"
        },
        {
          emoji: "🧠", 
          name: "Внутренние процессы", 
          key: "internal",
          description: "Мысли, воспоминания, размышления о будущем",
          psychological_insight: "Отражают потребность в смысле и понимании"
        },
        {
          emoji: "⏰", 
          name: "Время и сроки", 
          key: "time",
          description: "Дедлайны, ожидание, нехватка времени",
          psychological_insight: "Связаны с потребностью в контроле и предсказуемости"
        },
        {
          emoji: "🌐", 
          name: "Социальные медиа", 
          key: "social_media",
          description: "Социальные сети, сравнение с другими",
          psychological_insight: "Касаются потребности в социальном сравнении и признании"
        }
      ].freeze
      
      # Когнитивные искажения с научными объяснениями
      COGNITIVE_DISTORTIONS = [
        {
          name: "Катастрофизация",
          description: "Предположение наихудшего исхода",
          scientific_explanation: "Активирует миндалевидное тело (центр страха), вызывая чрезмерную реакцию на потенциальные угрозы"
        },
        {
          name: "Черно-белое мышление",
          description: "Видение только крайностей без оттенков",
          scientific_explanation: "Связано с недостаточной активностью передней поясной коры, отвечающей за гибкость мышления"
        },
        {
          name: "Персонализация",
          description: "Принятие всего на свой счет",
          scientific_explanation: "Избыточная активность медиальной префронтальной коры, отвечающей за самореферентное мышление"
        },
        {
          name: "Чтение мыслей",
          description: "Предположение мыслей других людей",
          scientific_explanation: "Нарушение теории сознания - способности понимать ментальные состояния других"
        },
        {
          name: "Долженствование",
          description: "Использование жестких правил 'должен', 'надо'",
          scientific_explanation: "Связано с чрезмерной активностью дорсолатеральной префронтальной коры (контроль и правила)"
        },
        {
          name: "Эмоциональное обоснование",
          description: "Если я так чувствую, значит это правда",
          scientific_explanation: "Смешение эмоциональной и когнитивной обработки информации"
        },
        {
          name: "Чрезмерное обобщение",
          description: "Выводы на основе одного случая",
          scientific_explanation: "Нарушение индуктивного мышления и статистического анализа"
        },
        {
          name: "Ментальный фильтр",
          description: "Фокусирование только на негативном",
          scientific_explanation: "Активация негативной сети мозга при подавлении позитивной"
        }
      ].freeze
      
      # Стратегии совладания с научным обоснованием
      COPING_STRATEGIES = [
        {
          type: "cognitive",
          name: "Когнитивное переосмысление",
          description: "Изменение мыслей о ситуации",
          scientific_basis: "Перестройка нейронных связей в префронтальной коре"
        },
        {
          type: "emotional",
          name: "Эмоциональная регуляция",
          description: "Управление интенсивностью эмоций",
          scientific_basis: "Активация парасимпатической нервной системы"
        },
        {
          type: "behavioral",
          name: "Поведенческая активация",
          description: "Действие, несмотря на дискомфорт",
          scientific_basis: "Создание новых поведенческих паттернов через повторение"
        },
        {
          type: "mindfulness",
          name: "Осознанность",
          description: "Наблюдение без оценки",
          scientific_basis: "Усиление связи между префронтальной корой и лимбической системой"
        },
        {
          type: "social",
          name: "Социальная поддержка",
          description: "Обращение за помощью к другим",
          scientific_basis: "Выделение окситоцина и снижение кортизола"
        },
        {
          type: "preventive",
          name: "Профилактика",
          description: "Предотвращение триггерных ситуаций",
          scientific_basis: "Упреждающее когнитивное планирование"
        }
      ].freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        entries_count = diary_entries_count
        
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        
        # Динамически создаем сообщение со статистикой
        intro_message = DAY_STEPS['intro'][:instruction] + 
          "\n\n*Ваша статистика дневника:*\n" +
          "📝 *Записей в дневнике:* #{entries_count}\n" +
          "📅 *Первая запись:* #{first_entry_date || 'нет записей'}\n" +
          "📈 *Последняя запись:* #{last_entry_date || 'нет записей'}"
        
        send_message(text: intro_message, parse_mode: 'Markdown')
        
        # Показываем статистику дневника
        show_diary_statistics_brief
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        store_day_data('current_step', 'intro')
        clear_day_data
        
        if entries_count < 3
          send_message(
            text: "⚠️ *Для качественного анализа рекомендуется иметь хотя бы 3 записи.*\n\nУ вас #{entries_count} записей. Хотите сначала добавить записи или продолжить с имеющимися?",
            parse_mode: 'Markdown',
            reply_markup: diary_analysis_low_entries_markup
          )
        else
          send_message(
            text: "📊 *Готовы начать научный анализ ваших записей?*\n\nУ вас #{entries_count} записей - отличная основа для анализа!",
            parse_mode: 'Markdown',
            reply_markup: day_23_start_markup
          )
        end
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise_explanation')
        
        send_message(text: DAY_STEPS['exercise_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['exercise_explanation'][:instruction], parse_mode: 'Markdown')
        
        # ДИНАМИЧЕСКИ создаем текст упражнения
        exercise_text = <<~MARKDOWN
          📋 *Упражнение: Научный анализ дневниковых записей* 📋

          *Мы пройдем 6 шагов:*
          
          1. 📅 Выбор периода для анализа
          2. 🔍 Анализ ситуаций-триггеров
          3. 💭 Идентификация мыслительных паттернов
          4. 😔 Анализ эмоциональных реакций
          5. 🎯 Формулирование ключевых триггеров
          6. 🛡️ Создание стратегий совладания

          *Рекомендации для эффективного анализа:*
          • ⏱️ Выделите 25-35 минут на все упражнение
          • 📝 Имейте под рукой свои дневниковые записи
          • 🧠 Отвечайте максимально честно и подробно
          • 💡 Делайте паузы для размышлений
          • 📊 Фокусируйтесь на паттернах, а не на отдельных случаях

          *Начнем!*
        MARKDOWN
        
        send_message(text: exercise_text, parse_mode: 'Markdown')
        
        # Инициализируем процесс анализа
        init_analysis_process
      end
      
      def init_analysis_process
        store_day_data('analysis_data', {
          'period' => nil,
          'situation_categories' => [],
          'cognitive_patterns' => [],
          'emotions' => [],
          'triggers' => [],
          'strategies' => [],
          'plan' => nil
        })
        store_day_data('analysis_progress', {})
        
        # Начинаем первый шаг
        start_analysis_step('select_period')
      end
      
      def start_analysis_step(step_type)
  store_day_data('current_analysis_step', step_type)
  @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_#{step_type}")
  
  step = ANALYSIS_STEPS[step_type]
  return unless step
  
  # Отправляем шаг с красивым оформлением
  send_message(text: step[:title], parse_mode: 'Markdown')
  
  # ДЛЯ ШАГА select_period добавляем статистику динамически
  if step_type == 'select_period'
    entries_count = diary_entries_count
    instruction_with_stats = step[:instruction] + 
      "\n\n*Ваша статистика дневника:*\n" +
      "📝 *Всего записей:* #{entries_count}\n" +
      "📅 *Первая запись:* #{first_entry_date || 'нет записей'}\n" +
      "📈 *Последняя запись:* #{last_entry_date || 'нет записей'}"
    
    send_message(text: instruction_with_stats)
  else
    send_message(text: step[:instruction])
  end
  
  # Добавляем подсказки
  if step[:tips] && step[:tips].any?
    tips_text = step[:tips].map { |tip| "• #{tip}" }.join("\n")
    send_message(
      text: "#{step[:emoji]} *Подсказки:*\n#{tips_text}",
      parse_mode: 'Markdown'
    )
  end
  
  # Для разных шагов показываем разную разметку и данные
  analysis_data = get_day_data('analysis_data') || {}
  
  case step_type
  when 'select_period'
    # Показываем статистику и кнопки выбора периода
    send_message(
      text: "Выберите период для анализа:",
      reply_markup: day_23_period_markup
    )
    
  when 'analyze_situations'
    # Показываем записи за выбранный период
    period = analysis_data['period']
    if period
      send_message(text: "📖 *Ваши записи за период: #{period}*", parse_mode: 'Markdown')
      show_entries_for_period(period, limit: 5)
    end
    
    sleep(1)
    
    send_message(
      text: "Какие категории ситуаций встречаются чаще всего?",
      reply_markup: day_23_situations_markup
    )
    
  when 'analyze_thoughts'
    # Показываем мысли из записей
    period = analysis_data['period']
    if period
      send_message(text: "💭 *Автоматические мысли из ваших записей:*", parse_mode: 'Markdown')
      show_thoughts_from_entries(period, limit: 5)
    end
    
    sleep(1)
    
    send_message(
      text: "Какие мыслительные паттерны вы замечаете?",
      reply_markup: day_23_thoughts_markup
    )
    
  when 'analyze_emotions'
    # Показываем эмоции из записей
    period = analysis_data['period']
    if period
      send_message(text: "😔 *Эмоции из ваших записей:*", parse_mode: 'Markdown')
      show_emotions_from_entries(period, limit: 5)
    end
    
    send_message(text: "Какие эмоции преобладают в ваших записях?")
    
  when 'identify_triggers'
    # Показываем сводку по предыдущим шагам
    show_analysis_summary
    
    sleep(2)
    
    send_message(
      text: "#{step[:emoji]} *На основе анализа сформулируйте свои триггеры:*",
      parse_mode: 'Markdown',
      reply_markup: day_23_triggers_markup
    )
    
  when 'create_strategies'
    # Показываем выявленные триггеры
    triggers = analysis_data['triggers'] || []
    if triggers.any?
      send_message(text: "🎯 *Ваши выявленные триггеры:*", parse_mode: 'Markdown')
      triggers.each_with_index do |trigger, index|
        send_message(text: "#{index + 1}. #{trigger}")
      end
    end
    
    sleep(1)
    
    send_message(
      text: "Какие стратегии помогут вам работать с этими триггерами?",
      reply_markup: day_23_strategies_markup
    )
    
  else
    # Для остальных шагов просто показываем приглашение к вводу
    send_message(
      text: "#{step[:emoji]} *Напишите ответ:*",
      parse_mode: 'Markdown',
      reply_markup: day_23_step_navigation_markup
    )
  end
end
      
      def handle_analysis_input(input_text)
        current_step = get_day_data('current_analysis_step')
        step_config = ANALYSIS_STEPS[current_step]
        
        return false unless step_config
        
        log_info("Handling analysis input for step: #{current_step}")
        
        # Проверяем, что ввод не пустой
        if input_text.blank? || input_text.strip.length < 3
          send_message(text: "⚠️ Пожалуйста, напишите более развернутый ответ.")
          return false
        end
        
        # Обрабатываем ввод в зависимости от шага
        case current_step
        when 'select_period'
          handle_period_input(input_text)
        when 'analyze_situations'
          handle_situations_input(input_text)
        when 'analyze_thoughts'
          handle_thoughts_input(input_text)
        when 'analyze_emotions'
          handle_emotions_input(input_text)
        when 'identify_triggers'
          handle_triggers_input(input_text)
        when 'create_strategies'
          handle_strategies_input(input_text)
        else
          log_warn("Unknown analysis step: #{current_step}")
          return false
        end
        
        true
      end
      
      def complete_analysis
        analysis_data = get_analysis_data
        
        # Проверяем, что все ключевые данные заполнены
        if analysis_data['triggers'].blank? || analysis_data['strategies'].blank?
          send_message(
            text: "⚠️ У вас не заполнены триггеры или стратегии. Давайте закончим анализ.",
            parse_mode: 'Markdown'
          )
          start_analysis_step('identify_triggers')
          return false
        end
        
        # Формируем финальный план
        final_plan = create_final_plan(analysis_data)
        analysis_data['final_plan'] = final_plan
        
        # Сохраняем финальные данные
        store_day_data('final_analysis', analysis_data)
        store_day_data('analysis_completed', true)
        store_day_data('completion_time', Time.current)
        
        # Подтверждаем завершение
        send_message(
          text: "✅ #{ANALYSIS_STEPS['create_strategies'][:emoji]} *Анализ сохранен!*",
          parse_mode: 'Markdown'
        )
        
        sleep(1)
        
        # Показываем завершение
        show_analysis_completion(analysis_data)
        
        true
      end
      
     def complete_exercise
  unless get_day_data('analysis_completed') == true
    send_message(
      text: "⚠️ Сначала завершите анализ дневниковых записей.\n\nУбедитесь, что вы прошли все 6 шагов анализа.",
      parse_mode: 'Markdown',
      reply_markup: {
        inline_keyboard: [
          [{ text: "📊 Продолжить анализ", callback_data: 'start_day_23_exercise' }]
        ]
      }
    )
    return false
  end
  
  # Отмечаем день как завершенный
  @user.complete_self_help_day(DAY_NUMBER)
  @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
  
  # Показываем завершение дня (вместо show_smart_completion)
  show_day_completion
  
  # Предлагаем следующий день
  propose_next_day_with_restriction
  
  true
end

def show_day_completion
  # Поздравляем пользователя с завершением дня
  completion_message = <<~MARKDOWN
    🎉 *Поздравляем! Вы завершили День 23!*
    
    *Что вы достигли сегодня:*
    • 📊 Провели научный анализ своих дневниковых записей
    • 🔍 Выявили ключевые ситуации-триггеры
    • 💭 Распознали автоматические мыслительные паттерны
    • 🎯 Сформулировали свои личные триггеры
    • 🛡️ Создали персонализированные стратегии совладания
    
    *Научные преимущества вашей работы:*
    • 🧠 Улучшение мета-познания на 40-50%
    • 💪 Усиление эмоциональной регуляции на 35-45%
    • 🎯 Увеличение адаптивного поведения на 50-60%
    • 📈 Снижение частоты триггерных реакций на 45-55%
    
    *Ваш анализ сохранился и доступен для пересмотра.*
    *Используйте его как инструмент для дальнейшего роста!*
  MARKDOWN
  
  send_message(text: completion_message, parse_mode: 'Markdown')
  
  # Показываем финальный план еще раз
  analysis_data = get_day_data('final_analysis') || get_analysis_data
  if analysis_data && analysis_data['final_plan']
    send_message(
      text: "*📋 Ваш итоговый план:*\n\n#{analysis_data['final_plan']}",
      parse_mode: 'Markdown'
    )
  end
end
      
      def show_analysis_completion(analysis_data)
  send_message(text: DAY_STEPS['completion'][:title], parse_mode: 'Markdown')
  send_message(text: DAY_STEPS['completion'][:instruction], parse_mode: 'Markdown')
  
  # Форматируем стратегии для отображения
  if analysis_data['strategies']
    strategies_text = if analysis_data['strategies'].is_a?(Array)
      analysis_data['strategies'].map { |s| "• #{s.gsub('*', '').strip}" }.join("\n")
    else
      analysis_data['strategies'].to_s.gsub('*', '').strip
    end
    
    analysis_data['formatted_strategies'] = strategies_text
  end
  
  # Показываем финальный анализ
  show_final_analysis_summary(analysis_data)
  
  sleep(2)
  
  # Важные напоминания
  reminders = <<~MARKDOWN
    💡 *Важные рекомендации по работе с анализом:*

    1. 📅 *Регулярный пересмотр:*
       • Каждую неделю просматривайте свои триггеры и стратегии
       • Отмечайте, что работает, а что нужно изменить
       • Обновляйте анализ по мере появления новых записей

    2. 🎯 *Практическое применение:*
       • Распечатайте или сохраните скриншот вашего плана
       • Поместите его на видное место
       • Используйте стратегии в реальных ситуациях

    3. 📊 *Отслеживание прогресса:*
       • Делайте новые записи в дневнике
       • Отмечайте изменения в реакциях на триггеры
       • Фиксируйте успехи в применении стратегий

    4. 🔄 *Гибкость и адаптация:*
       • Стратегии можно и нужно менять
       • То, что не работает сегодня, может сработать завтра
       • Экспериментируйте с разными подходами

    5. 🤝 *Поддержка и обсуждение:*
       • Обсудите ваши инсайты с близкими
       • Найдите партнера по подотчетности
       • При необходимости обратитесь к психологу

    *Ваш анализ — это живой инструмент, который развивается вместе с вами.*
    *Каждое применение — это шаг к большей осознанности и эмоциональной свободе.*
  MARKDOWN
  
  send_message(text: reminders, parse_mode: 'Markdown')
  
  # Предлагаем завершить день
  send_message(
    text: "🎊 *Анализ дневника завершен!* Хотите завершить День 23?",
    parse_mode: 'Markdown',
    reply_markup: day_23_final_completion_markup
  )
end
      
      def show_diary_statistics_brief
        entries_count = diary_entries_count
        
        if entries_count == 0
          send_message(text: "📭 У вас пока нет записей в дневнике эмоций.")
          return
        end
        
        first_entry = @user.emotion_diary_entries.order(:created_at).first
        last_entry = @user.emotion_diary_entries.order(created_at: :desc).first
        
        message = <<~MARKDOWN
          📊 *Статистика вашего дневника эмоций:*
          
          📝 *Всего записей:* #{entries_count}
          📅 *Период ведения:* #{first_entry.created_at.strftime('%d.%m.%Y')} - #{last_entry.created_at.strftime('%d.%m.%Y')}
          📈 *Средняя частота:* #{(entries_count.to_f / [(last_entry.created_at.to_date - first_entry.created_at.to_date + 1).to_i, 1].max * 7).round(1)} записей в неделю
          
          *Для анализа рекомендуется:*
          • 📊 5+ записей для выявления паттернов
          • 📅 Период 2-4 недели для репрезентативности
          • 🎯 Фокус на повторяющихся темах
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def show_analysis_summary
        analysis_data = get_analysis_data
        
        summary = <<~MARKDOWN
          📋 *Сводка вашего анализа на текущий момент:*
          
          📅 *Период анализа:* #{analysis_data['period'] || 'Не выбран'}
          
          🔍 *Категории ситуаций:*
          #{analysis_data['situation_categories']&.map { |cat| "• #{cat}" }&.join("\n") || '• Еще не выбрано'}
          
          💭 *Мыслительные паттерны:*
          #{analysis_data['cognitive_patterns']&.map { |pat| "• #{pat}" }&.join("\n") || '• Еще не выбрано'}
          
          😔 *Преобладающие эмоции:*
          #{analysis_data['emotions']&.map { |em| "• #{em}" }&.join("\n") || '• Еще не указано'}
          
          *Теперь объедините эти элементы в триггеры:*
          🎯 Триггер = Ситуация + Мысль + Эмоция + Поведение
        MARKDOWN
        
        send_message(text: summary, parse_mode: 'Markdown')
        
        # Показываем примеры триггеров
        if analysis_data['situation_categories'].present? && 
           analysis_data['cognitive_patterns'].present? && 
           analysis_data['emotions'].present?
          
          example = generate_trigger_example(analysis_data)
          send_message(
            text: "💡 *Пример триггера на основе вашего анализа:*\n\n#{example}",
            parse_mode: 'Markdown'
          )
        end
      end

      def show_analysis_summary_modal
  analysis_data = get_analysis_data
  
  summary = <<~MARKDOWN
    📋 *Сводка вашего анализа на текущий момент:*
    
    📅 *Период анализа:* #{analysis_data['period'] || 'Не выбран'}
    
    🔍 *Категории ситуаций:*
    #{analysis_data['situation_categories']&.map { |cat| "• #{cat}" }&.join("\n") || '• Еще не выбрано'}
    
    💭 *Мыслительные паттерны:*
    #{analysis_data['cognitive_patterns']&.map { |pat| "• #{pat}" }&.join("\n") || '• Еще не выбрано'}
    
    😔 *Преобладающие эмоции:*
    #{analysis_data['emotions']&.map { |em| "• #{em}" }&.join("\n") || '• Еще не указано'}
    
    🎯 *Сформулированные триггеры:*
    #{analysis_data['triggers']&.map { |tr| "• #{tr}" }&.join("\n") || '• Еще не сформулированы'}
    
    🛡️ *Стратегии совладания:*
    #{analysis_data['strategies']&.gsub("\n", "\n  ") || '• Еще не созданы'}
    
    *💡 Следующий шаг:*
    На основе этого анализа создайте свои стратегии совладания!
  MARKDOWN
  
  send_message(text: summary, parse_mode: 'Markdown')
  
  # Показываем пример триггера, если есть данные
  if analysis_data['situation_categories'].present? && 
     analysis_data['cognitive_patterns'].present? && 
     analysis_data['emotions'].present?
    example = generate_trigger_example(analysis_data)
    send_message(
      text: "🎯 *Пример формулировки триггера на основе ваших данных:*\n\n#{example}",
      parse_mode: 'Markdown'
    )
  end
  
  # Кнопки для продолжения
  send_message(
    text: "Что дальше?",
    reply_markup: {
      inline_keyboard: [
        [
          { text: "🛡️ Показать примеры стратегий", callback_data: 'day_23_show_strategies' },
          { text: "✍️ Продолжить ввод", callback_data: 'day_23_continue_input' }
        ],
        [
          { text: "📊 Завершить анализ", callback_data: 'day_23_complete_exercise' }
        ]
      ]
    }
  )
end

def show_strategies_examples
  # Примеры стратегий на основе научных данных
  strategies = <<~MARKDOWN
    *🛡️ Примеры стратегий совладания на основе нейронауки:*

    *1. Когнитивное переосмысление (Префронтальная кора):*
    *📝 Конкретный шаг:* Когда возникает триггер, спросите себя: _"Какие есть доказательства, что моя мысль верна?"_
    *💡 Пример:* Вместо _"Я провалю проект"_ → _"У меня есть опыт успешных проектов"_
    *🧠 Научная основа:* Активирует дорсолатеральную префронтальную кору

    *2. Эмоциональная регуляция (Лимбическая система):*
    *📝 Конкретный шаг:* Применить технику _"5-4-3-2-1"_ в момент триггера:
    - _5 вещей_, которые вы видите
    - _4 вещи_, которые вы чувствуете
    - _3 звука_, которые слышите
    - _2 запаха_, которые ощущаете
    - _1 вкус_
    *🧠 Научная основа:* Снижает активность миндалевидного тела на 30-40%

    *3. Поведенческая активация (Базальные ганглии):*
    *📝 Конкретный шаг:* Создать _"если-то"_ план:
    _"ЕСЛИ возникает триггер X, ТО я делаю Y"_
    *💡 Пример:* _"Если возникает прокрастинация, то я работаю 5 минут"_
    *🧠 Научная основа:* Создает новые нейронные связи через повторение

    *4. Социальная поддержка (Окситоциновая система):*
    *📝 Конкретный шаг:* Создать список из _3 человек_, которым можно позвонить
    *💡 Пример:* Предупредить их: _"Я могу позвонить, когда мне трудно"_
    *🧠 Научная основа:* Окситоцин снижает кортизол на 25-35%

    *5. Профилактические стратегии (Инсула):*
    *📝 Конкретный шаг:* Определить _"окна уязвимости"_ (время/место/состояние)
    *💡 Пример:* _"По понедельникам утром я особенно уязвим к критике"_
    *🧠 Научная основа:* Повышает интроцептивную осознанность
  MARKDOWN
  
  send_message(text: strategies, parse_mode: 'Markdown')
  
  # Кнопки для выбора стратегий с улучшенным текстом
  send_message(
    text: "*Выберите тип стратегии для вашего триггера:*",
    parse_mode: 'Markdown',
    reply_markup: {
      inline_keyboard: [
        [
          { text: "🧠 Когнитивная", callback_data: 'day_23_strategy_cognitive' },
          { text: "😊 Эмоциональная", callback_data: 'day_23_strategy_emotional' }
        ],
        [
          { text: "🚶 Поведенческая", callback_data: 'day_23_strategy_behavioral' },
          { text: "🤝 Социальная", callback_data: 'day_23_strategy_social' }
        ],
        [
          { text: "🛡️ Профилактическая", callback_data: 'day_23_strategy_preventive' },
          { text: "💡 Своя стратегия", callback_data: 'day_23_strategy_custom' }
        ],
        [
          { text: "← Назад к сводке", callback_data: 'day_23_show_summary' }
        ]
      ]
    }
  )
end

def show_final_analysis_modal
  analysis_data = get_day_data('final_analysis') || get_analysis_data
  
  if analysis_data.blank?
    send_message(
      text: "Анализ еще не завершен. Давайте продолжим!",
      parse_mode: 'Markdown',
      reply_markup: {
        inline_keyboard: [
          [{ text: "📊 Продолжить анализ", callback_data: 'start_day_23_exercise' }]
        ]
      }
    )
    return
  end
  
  # Показываем финальный анализ
  show_final_analysis_summary(analysis_data)
  
  # Кнопки для работы с анализом
  send_message(
    text: "🎯 *Ваш анализ готов! Что вы хотите сделать?*",
    parse_mode: 'Markdown',
    reply_markup: {
      inline_keyboard: [
        [
          { text: "📋 Сохранить как план", callback_data: 'day_23_save_plan' },
          { text: "🔄 Обновить триггеры", callback_data: 'day_23_update_triggers' }
        ],
        [
          { text: "📈 Добавить стратегии", callback_data: 'day_23_add_strategies' },
          { text: "📅 Назначить напоминания", callback_data: 'day_23_set_reminders' }
        ],
        [
          { text: "✅ Завершить день", callback_data: 'day_23_complete_exercise' }
        ]
      ]
    }
  )
end

# Добавим обработчики для выбора стратегий
def handle_strategy_selection(strategy_type)
  strategy_text = case strategy_type
  when 'cognitive'
    <<~MARKDOWN
      *🧠 Когнитивная стратегия:*
      
      *Работа с мыслями и убеждениями*
      
      *Что делать:*
      • Задавать вопрос _'Какие доказательства?'_
      • Искать альтернативные объяснения
      • Использовать техники рефрейминга
      • Проверять реальность мыслей
      
      *Пример применения:*
      _"Когда возникает мысль 'Я ни на что не гожусь', я спрашиваю себя: 'Какие есть факты, подтверждающие или опровергающие эту мысль?'"_
    MARKDOWN
  when 'emotional'
    <<~MARKDOWN
      *😊 Эмоциональная стратегия:*
      
      *Управление интенсивностью и выражением эмоций*
      
      *Что делать:*
      • Техника _'5-4-3-2-1'_ для заземления
      • Дыхание _4-7-8_ для успокоения
      • Назвать и принять эмоцию
      • Наблюдать эмоцию без оценки
      
      *Пример применения:*
      _"Когда чувствую сильную тревогу, я делаю 5 глубоких вдохов и называю эмоцию: 'Это тревога, она пройдет'."_
    MARKDOWN
  when 'behavioral'
    <<~MARKDOWN
      *🚶 Поведенческая стратегия:*
      
      *Изменение действий и реакций*
      
      *Что делать:*
      • Создать _'если-то'_ план
      • Начать с маленького шага
      • Отслеживать прогресс
      • Практиковать новые реакции
      
      *Пример применения:*
      _"Если возникает желание избежать сложной задачи, то я работаю над ней всего 5 минут."_
    MARKDOWN
  when 'social'
    <<~MARKDOWN
      *🤝 Социальная стратегия:*
      
      *Использование поддержки окружения*
      
      *Что делать:*
      • Обратиться к поддержке
      • Поделиться чувствами
      • Попросить обратную связь
      • Найти партнера по подотчетности
      
      *Пример применения:*
      _"Когда чувствую себя одиноко, я звоню другу и просто говорю о своих чувствах."_
    MARKDOWN
  when 'preventive'
    <<~MARKDOWN
      *🛡️ Профилактическая стратегия:*
      
      *Предотвращение триггерных ситуаций*
      
      *Что делать:*
      • Выявить _'окна уязвимости'_
      • Создать безопасную среду
      • Планировать заранее
      • Разработать план Б
      
      *Пример применения:*
      _"Зная, что утром я более уязвим, я планирую важные разговоры на послеобеденное время."_
    MARKDOWN
  else
    <<~MARKDOWN
      *💡 Ваша собственная стратегия:*
      
      *Создайте персонализированный подход*
      
      *Что делать:*
      • Подумайте, что работает именно для вас
      • Используйте прошлый успешный опыт
      • Экспериментируйте с разными подходами
      • Адаптируйте под свои особенности
      
      *Пример применения:*
      Напишите свою стратегию, которая учитывает ваши уникальные потребности и возможности.
    MARKDOWN
  end
  
  send_message(text: strategy_text, parse_mode: 'Markdown')
  
  # Спрашиваем, применить ли эту стратегию
  send_message(
    text: "Хотите добавить эту стратегию к вашему триггеру?",
    reply_markup: {
      inline_keyboard: [
        [
          { text: "✅ Да, добавить", callback_data: "day_23_add_strategy_#{strategy_type}" },
          { text: "🔄 Другой тип", callback_data: 'day_23_show_strategies' }
        ]
      ]
    }
  )
end
      
      def show_final_analysis_summary(analysis_data)
        summary = <<~MARKDOWN
          📊 *Ваш финальный анализ дневника эмоций*
          
          *🎯 Ключевые выводы:*
          
          📅 *Период анализа:* #{analysis_data['period'] || 'Не указано'}
          
          🔍 *Основные ситуации-триггеры:*
          #{analysis_data['situation_categories']&.map { |cat| "• #{cat}" }&.join("\n") || 'Не указано'}
          
          💭 *Преобладающие мыслительные паттерны:*
          #{analysis_data['cognitive_patterns']&.map { |pat| "• #{pat}" }&.join("\n") || 'Не указано'}
          
          😔 *Частые эмоциональные реакции:*
          #{analysis_data['emotions']&.map { |em| "• #{em}" }&.join("\n") || 'Не указано'}
          
          🎯 *Сформулированные триггеры:*
          #{analysis_data['triggers']&.map { |tr| "• #{tr}" }&.join("\n") || 'Не указано'}
          
          🛡️ *Стратегии совладания:*
          #{analysis_data['strategies'] || 'Не указано'}
          
          📝 *Ваш план действий:*
          #{analysis_data['final_plan'] || analysis_data['plan'] || 'Не указано'}
          
          *💡 Рекомендация:* 
          Сохраните этот анализ или сделайте скриншот. 
          Возвращайтесь к нему при планировании недели и анализе новых записей.
        MARKDOWN
        
        send_message(text: summary, parse_mode: 'Markdown')
      end
      
      def redirect_to_diary
        send_message(
          text: "📝 *Открываю дневник эмоций...*\n\nСделайте несколько записей, затем вернитесь для анализа.",
          parse_mode: 'Markdown'
        )
        
        # Используем EmotionDiaryService
        diary_service = EmotionDiaryService.new(@bot_service, @user, @chat_id)
        diary_service.start_diary_menu
        
        # Сохраняем контекст, чтобы пользователь мог вернуться
        store_day_data('awaiting_diary_completion', true)
      end
      
      def proceed_with_analysis
        entries_count = diary_entries_count
        
        if entries_count < 1
          send_message(
            text: "⚠️ У вас нет записей для анализа. Давайте сначала создадим хотя бы одну запись.",
            parse_mode: 'Markdown',
            reply_markup: {
              inline_keyboard: [
                [{ text: "📝 Создать запись", callback_data: 'day_23_add_diary_entry' }]
              ]
            }
          )
          return
        end
        
        send_message(
          text: "📊 *Продолжаем анализ с #{entries_count} записями.*\n\nДаже небольшое количество записей может дать ценные инсайты!",
          parse_mode: 'Markdown'
        )
        
        deliver_exercise
      end
      
      # ===== ОБРАБОТКА КНОПОК =====
      
      def handle_button(callback_data)
  case callback_data
  when 'start_day_23_content', 'start_day_23_from_proposal'
    deliver_intro
    
  when 'continue_day_23_content'
    current_step = get_day_data('current_step')
    handle_resume_from_step(current_step || 'intro')
    
  when 'start_day_23_exercise'
    deliver_exercise
    
  when 'day_23_add_diary_entry'
    redirect_to_diary
    
  when 'day_23_use_existing'
    proceed_with_analysis
    
  when 'day_23_show_diary_stats'
    show_diary_statistics_brief
    
  when /^day_23_period_(.+)$/
    handle_period_selection($1)
    
  when /^day_23_situation_(.+)$/
    handle_situation_category_button($1)
    
  when /^day_23_thought_(\d+)$/
    handle_cognitive_pattern_button($1.to_i)
    
  when 'day_23_finish_categories'
    finish_categories_selection
    
  when 'day_23_finish_thoughts'
    finish_thoughts_selection
    
  when 'day_23_custom_categories'
    send_message(
      text: "✍️ *Напишите свои категории ситуаций (через запятую или с новой строки):*",
      parse_mode: 'Markdown'
    )
    store_day_data('awaiting_custom_input', 'situations')
    
  when 'day_23_custom_thoughts'
    send_message(
      text: "✍️ *Напишите свои мыслительные паттерны (через запятую или с новой строки):*",
      parse_mode: 'Markdown'
    )
    store_day_data('awaiting_custom_input', 'thoughts')
    
  when 'day_23_show_entries'
    period = get_analysis_data['period']
    if period
      show_entries_for_period(period, limit: 10)
    else
      send_message(text: "Сначала выберите период для анализа.")
    end
    
  when 'day_23_show_thoughts'
    period = get_analysis_data['period']
    if period
      show_thoughts_from_entries(period, limit: 10)
    end
    
  when 'day_23_show_emotions'
    period = get_analysis_data['period']
    if period
      show_emotions_from_entries(period, limit: 10)
    end
    
  # ДОБАВЛЯЕМ КНОПКИ ДЛЯ СВОДКИ И СТРАТЕГИЙ:
  when 'day_23_show_summary'
    show_analysis_summary_simple
    
  when 'day_23_show_strategies'
    show_strategies_examples
    
  when 'day_23_continue_input'
    handle_continue_input
    
  when 'day_23_trigger_examples'
    analysis_data = get_analysis_data
    show_triggers_examples(analysis_data)
    
  when 'day_23_my_strategies'
    show_my_strategies
    
  when 'day_23_strategies_done'
    handle_strategies_done
    
  when /^day_23_strategy_(cognitive|emotional|behavioral|social|preventive|custom)$/
    handle_strategy_selection($1)
    
  when /^day_23_add_strategy_(.+)$/
    add_strategy_to_analysis($1)
    
  when 'day_23_complete_exercise'
    complete_exercise
    
  when 'day_23_skip_step'
    handle_skip_step
    
  when 'day_23_previous_step'
    handle_previous_step
    
  when 'day_23_restart_analysis'
    handle_restart_analysis
    
  when 'retry_day_23_exercise'
    handle_retry_exercise
    
  else
    log_warn("Unknown button callback: #{callback_data}")
    send_message(text: "Неизвестная команда. Пожалуйста, используйте кнопки меню.")
  end
end

def show_analysis_summary_simple
  analysis_data = get_analysis_data
  
  summary = <<~MARKDOWN
    📋 *Сводка вашего анализа на текущий момент:*
    
    📅 *Период анализа:* #{analysis_data['period'] || 'Не выбран'}
    
    🔍 *Категории ситуаций:*
    #{analysis_data['situation_categories']&.map { |cat| "• #{cat}" }&.join("\n") || '• Еще не выбрано'}
    
    💭 *Мыслительные паттерны:*
    #{analysis_data['cognitive_patterns']&.map { |pat| "• #{pat}" }&.join("\n") || '• Еще не выбрано'}
    
    😔 *Преобладающие эмоции:*
    #{analysis_data['emotions']&.map { |em| "• #{em}" }&.join("\n") || '• Еще не указано'}
    
    🎯 *Сформулированные триггеры:*
    #{analysis_data['triggers']&.map { |tr| "• #{tr}" }&.join("\n") || '• Еще не сформулированы'}
    
    🛡️ *Стратегии совладания:*
    #{format_strategies_for_display(analysis_data['strategies'])}
    
    *💡 Следующий шаг:*
    На основе этого анализа создайте свои стратегии совладания!
  MARKDOWN
  
  send_message(text: summary, parse_mode: 'Markdown')
  
  # Кнопки для продолжения
  send_message(
    text: "Что дальше?",
    reply_markup: {
      inline_keyboard: [
        [
          { text: "🛡️ Примеры стратегий", callback_data: 'day_23_show_strategies' },
          { text: "✍️ Продолжить ввод", callback_data: 'day_23_continue_input' }
        ],
        [
          { text: "📊 Завершить анализ", callback_data: 'day_23_complete_exercise' }
        ]
      ]
    }
  )
end

# Вспомогательный метод для форматирования стратегий
def format_strategies_for_display(strategies)
  if strategies.is_a?(Array)
    strategies.empty? ? '• Еще не созданы' : strategies.map { |s| "• #{s}" }.join("\n")
  elsif strategies.is_a?(String)
    strategies.strip.empty? ? '• Еще не созданы' : strategies.gsub("\n", "\n  ")
  else
    '• Еще не созданы'
  end
end

# Добавляем недостающий метод add_strategy_to_analysis
def add_strategy_to_analysis(strategy_type)
  strategy_text = case strategy_type
  when 'cognitive'
    "🧠 *Когнитивная стратегия:* Работа с мыслями через вопросы 'Какие доказательства?' и поиск альтернативных объяснений."
  when 'emotional'
    "😊 *Эмоциональная стратегия:* Управление эмоциями через технику '5-4-3-2-1', дыхание 4-7-8 и принятие чувств."
  when 'behavioral'
    "🚶 *Поведенческая стратегия:* Изменение реакций через 'если-то' планы, маленькие шаги и отслеживание прогресса."
  when 'social'
    "🤝 *Социальная стратегия:* Использование поддержки через общение о чувствах и поиск обратной связи."
  when 'preventive'
    "🛡️ *Профилактическая стратегия:* Предотвращение триггеров через выявление уязвимостей и создание безопасной среды."
  else
    "💡 *Ваша собственная стратегия* (напишите свою персонализированную стратегию)"
  end
  
  # Добавляем стратегию к данным анализа
  analysis_data = get_analysis_data
  strategies = analysis_data['strategies'] || []
  
  # Если strategies - это массив, добавляем в него
  if strategies.is_a?(Array)
    strategies << strategy_text
    analysis_data['strategies'] = strategies
  # Если strategies - это строка, преобразуем в массив и добавляем
  elsif strategies.is_a?(String) && !strategies.strip.empty?
    analysis_data['strategies'] = [strategies, strategy_text]
  else
    # Если стратегий еще нет
    analysis_data['strategies'] = [strategy_text]
  end
  
  store_day_data('analysis_data', analysis_data)
  
  send_message(
    text: "✅ *Стратегия добавлена:*\n#{strategy_text}",
    parse_mode: 'Markdown'
  )
  
  # Спрашиваем, добавить еще или продолжить
  send_message(
    text: "*Хотите добавить еще стратегии или перейти к следующему шагу?*",
    parse_mode: 'Markdown',
    reply_markup: {
      inline_keyboard: [
        [
          { text: "➕ Еще стратегию", callback_data: 'day_23_show_strategies' },
          { text: "✅ Готово", callback_data: 'day_23_strategies_done' }
        ]
      ]
    }
  )
end

# Добавляем метод для обработки завершения стратегий
def handle_strategies_done
  analysis_data = get_analysis_data
  
  if analysis_data['strategies'].blank? || 
     (analysis_data['strategies'].is_a?(Array) && analysis_data['strategies'].empty?) ||
     (analysis_data['strategies'].is_a?(String) && analysis_data['strategies'].strip.empty?)
    
    send_message(
      text: "⚠️ У вас еще нет стратегий. Давайте создадим хотя бы одну!",
      parse_mode: 'Markdown',
      reply_markup: {
        inline_keyboard: [
          [{ text: "🛡️ Создать стратегии", callback_data: 'day_23_show_strategies' }]
        ]
      }
    )
  else
    # Переходим к завершению анализа
    complete_analysis
  end
end

# Обновляем метод show_my_strategies чтобы он работал с массивом и строкой
def show_my_strategies
  analysis_data = get_analysis_data
  
  if analysis_data['strategies'].blank? || 
     (analysis_data['strategies'].is_a?(Array) && analysis_data['strategies'].empty?) ||
     (analysis_data['strategies'].is_a?(String) && analysis_data['strategies'].strip.empty?)
    
    send_message(
      text: "У вас еще нет сохраненных стратегий. Давайте создадим их!",
      parse_mode: 'Markdown',
      reply_markup: {
        inline_keyboard: [
          [{ text: "🛡️ Создать стратегии", callback_data: 'day_23_show_strategies' }]
        ]
      }
    )
    return
  end
  
  strategies_text = format_strategies_for_display(analysis_data['strategies'])
  
  message = <<~MARKDOWN
    📋 *Ваши текущие стратегии:*
    
    #{strategies_text}
    
    *💡 Что дальше?*
    • Применить стратегии на практике
    • Настроить напоминания
    • Отслеживать эффективность
  MARKDOWN
  
  send_message(text: message, parse_mode: 'Markdown')
  
  # Кнопки для работы со стратегиями
  send_message(
    text: "Выберите действие:",
    reply_markup: {
      inline_keyboard: [
        [
          { text: "➕ Добавить еще", callback_data: 'day_23_show_strategies' },
          { text: "✏️ Редактировать", callback_data: 'day_23_continue_input' }
        ],
        [
          { text: "✅ Завершить", callback_data: 'day_23_strategies_done' }
        ]
      ]
    }
  )
end
      
      def handle_period_selection(period_key)
        period_text = case period_key
                     when '7_days' then 'Последние 7 дней'
                     when '30_days' then 'Последний месяц'
                     when 'all' then 'Все записи'
                     else period_key
                     end
        
        analysis_data = get_analysis_data
        analysis_data['period'] = period_text
        store_day_data('analysis_data', analysis_data)
        
        # Показываем записи за выбранный период
        send_message(
          text: "✅ Выбран период: #{period_text}",
          parse_mode: 'Markdown'
        )
        
        show_entries_for_period(period_text, limit: 5)
        
        # Через паузу переходим к следующему шагу
        sleep(2)
        start_analysis_step('analyze_situations')
      end
      
      def handle_situation_category_button(category_key)
        category = SITUATION_CATEGORIES.find { |c| c[:key] == category_key }
        
        if category
          analysis_data = get_analysis_data
          categories = analysis_data['situation_categories'] || []
          category_text = "#{category[:emoji]} #{category[:name]}"
          
          if categories.include?(category_text)
            categories.delete(category_text)
            send_message(text: "Убрано: #{category_text}")
          else
            categories << category_text
            send_message(
              text: "✅ Добавлено: #{category_text}\n💡 #{category[:psychological_insight]}",
              parse_mode: 'Markdown'
            )
          end
          
          analysis_data['situation_categories'] = categories.uniq
          store_day_data('analysis_data', analysis_data)
        end
      end
      
      def handle_cognitive_pattern_button(pattern_index)
        pattern = COGNITIVE_DISTORTIONS[pattern_index]
        
        if pattern
          analysis_data = get_analysis_data
          patterns = analysis_data['cognitive_patterns'] || []
          pattern_text = "#{pattern[:name]}: #{pattern[:description]}"
          
          if patterns.include?(pattern_text)
            patterns.delete(pattern_text)
            send_message(text: "Убрано: #{pattern[:name]}")
          else
            patterns << pattern_text
            send_message(
              text: "✅ Добавлено: #{pattern[:name]}\n🔬 #{pattern[:scientific_explanation]}",
              parse_mode: 'Markdown'
            )
          end
          
          analysis_data['cognitive_patterns'] = patterns.uniq
          store_day_data('analysis_data', analysis_data)
        end
      end
      
      def finish_categories_selection
        analysis_data = get_analysis_data
        
        if analysis_data['situation_categories'].blank?
          send_message(
            text: "⚠️ Пожалуйста, выберите хотя бы одну категорию ситуаций.",
            parse_mode: 'Markdown'
          )
          return
        end
        
        send_message(
          text: "✅ Категории ситуаций сохранены! Переходим к анализу мыслей.",
          parse_mode: 'Markdown'
        )
        
        start_analysis_step('analyze_thoughts')
      end
      
      def finish_thoughts_selection
        analysis_data = get_analysis_data
        
        if analysis_data['cognitive_patterns'].blank?
          send_message(
            text: "⚠️ Пожалуйста, выберите хотя бы один мыслительный паттерн.",
            parse_mode: 'Markdown'
          )
          return
        end
        
        send_message(
          text: "✅ Мыслительные паттерны сохранены! Переходим к анализу эмоций.",
          parse_mode: 'Markdown'
        )
        
        start_analysis_step('analyze_emotions')
      end
      
      def handle_skip_step
        current_step = get_day_data('current_analysis_step')
        next_step = get_next_analysis_step(current_step)
        
        if next_step
          send_message(
            text: "⏭️ Шаг пропущен. Переходим к следующему.",
            parse_mode: 'Markdown'
          )
          start_analysis_step(next_step)
        else
          complete_analysis
        end
      end
      
      def handle_previous_step
        current_step = get_day_data('current_analysis_step')
        previous_step = get_previous_analysis_step(current_step)
        
        if previous_step
          send_message(
            text: "🔙 Возвращаемся к предыдущему шагу.",
            parse_mode: 'Markdown'
          )
          start_analysis_step(previous_step)
        else
          send_message(text: "⚠️ Это первый шаг, возвращаться некуда.")
        end
      end
      
      def handle_restart_analysis
        send_message(
          text: "🔄 Начинаем анализ заново!",
          parse_mode: 'Markdown'
        )
        
        clear_analysis_data
        init_analysis_process
      end
      
      def handle_retry_exercise
        # Очищаем данные дня
        clear_day_data
        clear_analysis_data
        store_day_data('current_step', nil)
        
        # Сбрасываем состояние
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        
        send_message(
          text: "🔄 Начинаем День 23 заново!",
          parse_mode: 'Markdown'
        )
        
        deliver_intro
      end
      
      # ===== ОБРАБОТКА ТЕКСТОВОГО ВВОДА =====
      
      def handle_text_input(input_text)
        log_info("Handling text input for day 23: #{input_text.truncate(50)}")
        
        # Проверяем, ожидаем ли мы кастомный ввод
        awaiting_input_type = get_day_data('awaiting_custom_input')
        
        if awaiting_input_type
          store_day_data('awaiting_custom_input', nil)
          
          case awaiting_input_type
          when 'situations'
            handle_custom_situations_input(input_text)
          when 'thoughts'
            handle_custom_thoughts_input(input_text)
          when 'period'
            handle_period_input(input_text)
          end
          
          return true
        end
        
        current_state = @user.self_help_state
        
        # Проверяем, на каком шаге анализа мы находимся
        ANALYSIS_STEPS.keys.each do |step_key|
          if current_state == "day_#{DAY_NUMBER}_waiting_for_#{step_key}"
            return handle_analysis_input(input_text)
          end
        end
        
        # Обработка выбора периода текстом
        if current_state == "day_#{DAY_NUMBER}_waiting_for_select_period"
          handle_period_input(input_text)
          return true
        end
        
        log_warn("No text input handler for current state: #{current_state}")
        false
      end
      
      def handle_custom_situations_input(input_text)
        categories = input_text.split(/[,\.\n]/).map(&:strip).reject(&:empty?)
        
        if categories.any?
          analysis_data = get_analysis_data
          existing_categories = analysis_data['situation_categories'] || []
          analysis_data['situation_categories'] = existing_categories + categories
          store_day_data('analysis_data', analysis_data)
          
          send_message(
            text: "✅ Добавлены ваши категории: #{categories.join(', ')}",
            parse_mode: 'Markdown'
          )
          
          start_analysis_step('analyze_thoughts')
          return true
        else
          send_message(text: "⚠️ Пожалуйста, введите хотя бы одну категорию.")
          return false
        end
      end
      
      def handle_custom_thoughts_input(input_text)
        patterns = input_text.split(/[,\.\n]/).map(&:strip).reject(&:empty?)
        
        if patterns.any?
          analysis_data = get_analysis_data
          existing_patterns = analysis_data['cognitive_patterns'] || []
          analysis_data['cognitive_patterns'] = existing_patterns + patterns
          store_day_data('analysis_data', analysis_data)
          
          send_message(
            text: "✅ Добавлены ваши паттерны: #{patterns.join(', ')}",
            parse_mode: 'Markdown'
          )
          
          start_analysis_step('analyze_emotions')
          return true
        else
          send_message(text: "⚠️ Пожалуйста, введите хотя бы один паттерн.")
          return false
        end
      end
      
      def handle_period_input(input_text)
        analysis_data = get_analysis_data
        analysis_data['period'] = input_text.strip
        store_day_data('analysis_data', analysis_data)
        
        send_message(
          text: "✅ Выбран период: #{input_text.strip}",
          parse_mode: 'Markdown'
        )
        
        start_analysis_step('analyze_situations')
        true
      end
      
      def handle_situations_input(input_text)
        # Если пользователь ввел дополнительные категории
        if input_text.present?
          analysis_data = get_analysis_data
          categories = analysis_data['situation_categories'] || []
          categories << "Другое: #{input_text.strip}"
          analysis_data['situation_categories'] = categories.uniq
          store_day_data('analysis_data', analysis_data)
        end
        
        start_analysis_step('analyze_thoughts')
        true
      end
      
      def handle_thoughts_input(input_text)
        # Если пользователь ввел дополнительные паттерны
        if input_text.present?
          analysis_data = get_analysis_data
          patterns = analysis_data['cognitive_patterns'] || []
          patterns << "Другое: #{input_text.strip}"
          analysis_data['cognitive_patterns'] = patterns.uniq
          store_day_data('analysis_data', analysis_data)
        end
        
        start_analysis_step('analyze_emotions')
        true
      end
      
      def handle_emotions_input(input_text)
        emotions = input_text.split(/[,\.\n]/).map(&:strip).reject(&:empty?)
        
        if emotions.any?
          analysis_data = get_analysis_data
          analysis_data['emotions'] = emotions
          store_day_data('analysis_data', analysis_data)
          
          send_message(
            text: "✅ Эмоции сохранены: #{emotions.join(', ')}",
            parse_mode: 'Markdown'
          )
          
          start_analysis_step('identify_triggers')
          return true
        else
          send_message(text: "⚠️ Пожалуйста, введите хотя бы одну эмоцию.")
          return false
        end
      end
      
      def handle_triggers_input(input_text)
        # Разделяем триггеры (каждый с новой строки)
        triggers = input_text.split(/\n(?=\d+\.|\-|\*|•)/).map(&:strip).reject(&:empty?)
        
        if triggers.any? && triggers.size >= 1
          analysis_data = get_analysis_data
          analysis_data['triggers'] = triggers
          store_day_data('analysis_data', analysis_data)
          
          send_message(
            text: "✅ Сохранено #{triggers.size} триггеров!",
            parse_mode: 'Markdown'
          )
          
          start_analysis_step('create_strategies')
          return true
        else
          send_message(
            text: "⚠️ Пожалуйста, опишите хотя бы один триггер. Используйте новую строку для каждого триггера.",
            parse_mode: 'Markdown'
          )
          return false
        end
      end
      
      def handle_strategies_input(input_text)
  if input_text.present?
    analysis_data = get_analysis_data
    
    if analysis_data['strategies'].is_a?(Array)
      # Если уже есть массив стратегий, добавляем новую
      analysis_data['strategies'] << input_text.strip
    elsif analysis_data['strategies'].is_a?(String) && !analysis_data['strategies'].strip.empty?
      # Если стратегия - строка, преобразуем в массив
      analysis_data['strategies'] = [analysis_data['strategies'], input_text.strip]
    else
      # Если стратегий еще нет
      analysis_data['strategies'] = [input_text.strip]
    end
    
    store_day_data('analysis_data', analysis_data)
    
    send_message(
      text: "✅ Стратегия сохранена: #{input_text.strip}",
      parse_mode: 'Markdown'
    )
    
    # Спрашиваем, добавить еще или завершить
    send_message(
      text: "Хотите добавить еще стратегии или завершить анализ?",
      reply_markup: {
        inline_keyboard: [
          [
            { text: "➕ Еще стратегию", callback_data: 'day_23_show_strategies' },
            { text: "✅ Завершить", callback_data: 'day_23_strategies_done' }
          ]
        ]
      }
    )
    
    return true
  else
    send_message(text: "⚠️ Пожалуйста, опишите вашу стратегию.")
    return false
  end
end
      
      
      def handle_resume_from_step(step)
        case step
        when 'intro'
          deliver_intro
        when 'exercise_explanation'
          deliver_exercise
        when 'completion'
          analysis_data = get_day_data('final_analysis')
          show_analysis_completion(analysis_data) if analysis_data
        else
          deliver_exercise
        end
      end
      
      def propose_next_day_with_restriction
        next_day = 24
        
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 *Следующий шаг: День #{next_day}*
            
            ✅ *Доступен сейчас!*
            
            *Что вас ждет:*
            • 🎨 Создание плана саморазвития
            • 📊 Интеграция всех изученных техник
            • 💡 Построение персональной системы
            • 🌟 Планирование на следующий месяц
            • 🚀 Подготовка к самостоятельной практике
            
            Вы можете начать следующий день прямо сейчас.
          MARKDOWN
          
          button_text = "🎨 Начать День #{next_day}"
          callback_data = "start_day_#{next_day}_from_proposal"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = <<~MARKDOWN
            🎯 *Следующий шаг: День #{next_day}*
            
            ⏱️ *Ограничение:* #{error_message}
            
            *Пока ждете, можете:*
            • 📊 Применить стратегии из анализа на практике
            • 📝 Продолжать вести дневник эмоций
            • 🔄 Пересмотреть и уточнить свои триггеры
            • 🛡️ Практиковать техники совладания
            • 📈 Отслеживать изменения в реакциях
            
            *Совет на сегодня:* 
            Начните применять одну из стратегий прямо сейчас. 
            Практика — лучший способ закрепить результаты анализа.
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
      
      # ===== ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ =====
      
      def diary_entries_count
        @user.emotion_diary_entries.count
      end
      
      def first_entry_date
        entry = @user.emotion_diary_entries.order(:created_at).first
        entry&.created_at&.strftime('%d.%m.%Y')
      end
      
      def last_entry_date
        entry = @user.emotion_diary_entries.order(created_at: :desc).first
        entry&.created_at&.strftime('%d.%m.%Y')
      end
      
      def get_analysis_data
        get_day_data('analysis_data') || {}
      end
      
      def clear_analysis_data
        store_day_data('analysis_data', nil)
        store_day_data('current_analysis_step', nil)
        store_day_data('analysis_progress', nil)
        store_day_data('final_analysis', nil)
        store_day_data('analysis_completed', nil)
        store_day_data('awaiting_custom_input', nil)
      end
      
      def get_next_analysis_step(current_step)
        steps_order = ANALYSIS_STEPS.keys
        current_index = steps_order.index(current_step)
        
        return steps_order[current_index + 1] if current_index && current_index < steps_order.length - 1
        nil
      end
      
      def get_previous_analysis_step(current_step)
        steps_order = ANALYSIS_STEPS.keys
        current_index = steps_order.index(current_step)
        
        return steps_order[current_index - 1] if current_index && current_index > 0
        nil
      end
      
      def generate_trigger_example(analysis_data)
  # Берем реальные данные из анализа
  situation = analysis_data['situation_categories']&.first || "Конфликт на работе"
  pattern = analysis_data['cognitive_patterns']&.first || "Персонализация: Принятие всего на свой счет"
  emotion = analysis_data['emotions']&.first || "Тревога"
  
  # Убираем эмодзи из ситуации и берем психологический инсайт вместо названия
  situation_clean = extract_situation_description(situation)
  
  # Берем описание паттерна вместо названия
  pattern_description = extract_pattern_description(pattern)
  
  # Берем эмоцию как есть
  emotion_clean = emotion.gsub(/[😊😔😠😨😳😞]/, '').strip
  
  # Формируем пример с правильным Markdown
  example = <<~MARKDOWN
    *🎯 Пример формулировки триггера:*
    
    _"Когда я сталкиваюсь с #{situation_clean}, у меня возникает мысль **#{pattern_description}**, что вызывает чувство **#{emotion_clean}**, и я обычно реагирую избеганием или критикой себя."_

    *📝 Компоненты этого триггера:*
    • *Ситуация:* #{situation_clean}
    • *Автоматическая мысль:* #{pattern_description}
    • *Эмоция:* #{emotion_clean}
    • *Типичная реакция:* Избегание или самокритика

    *💡 Формат для ваших триггеров:*
    1. *Ситуация:* [опишите ситуацию или потребность]
    2. *Мысль:* [какая мысль или паттерн возникает]
    3. *Эмоция:* [какое чувство появляется]
    4. *Реакция:* [как вы обычно реагируете]

    *✍️ Пример структуры:*
    "Когда [ситуация], у меня возникает мысль '[мысль]', что вызывает чувство [эмоция], и я реагирую [поведение]."
  MARKDOWN
  
  example
end

def extract_situation_description(situation_text)
  # Убираем эмодзи
  clean_text = situation_text.gsub(/[🏢🤝🏠💰🧠⏰🌐]/, '').strip
  
  # Ищем категорию в SITUATION_CATEGORIES чтобы получить психологический инсайт
  category = SITUATION_CATEGORIES.find do |cat|
    clean_text.include?(cat[:name]) || clean_text.include?(cat[:key])
  end
  
  if category
    # Используем психологический инсайт вместо названия категории
    return category[:psychological_insight].downcase
  else
    # Если не нашли категорию, возвращаем очищенный текст
    return clean_text.downcase
  end
end

# Новый метод для извлечения описания паттерна
def extract_pattern_description(pattern_text)
  # Убираем двоеточие и все после него (если есть)
  clean_text = pattern_text.split(':').first.strip
  
  # Ищем паттерн в COGNITIVE_DISTORTIONS чтобы получить описание
  pattern = COGNITIVE_DISTORTIONS.find do |dist|
    clean_text.include?(dist[:name]) || pattern_text.include?(dist[:name])
  end
  
  if pattern
    # Используем описание вместо названия
    return pattern[:description].downcase
  else
    # Если не нашли паттерн, пытаемся извлечь описание
    if pattern_text.include?(':')
      # Если есть двоеточие, берем часть после него
      description = pattern_text.split(':').last.strip
      return description.downcase unless description.empty?
    end
    # Иначе возвращаем очищенный текст
    return clean_text.downcase
  end
end
      
      def show_my_strategies
  analysis_data = get_analysis_data
  
  if analysis_data['strategies'].blank?
    send_message(
      text: "У вас еще нет сохраненных стратегий. Давайте создадим их!",
      parse_mode: 'Markdown',
      reply_markup: {
        inline_keyboard: [
          [{ text: "🛡️ Создать стратегии", callback_data: 'day_23_show_strategies' }]
        ]
      }
    )
    return
  end
  
  strategies_text = <<~MARKDOWN
    📋 *Ваши текущие стратегии:*
    
    #{analysis_data['strategies'].gsub("\n", "\n\n")}
    
    *💡 Что дальше?*
    • Применить стратегии на практике
    • Настроить напоминания
    • Отслеживать эффективность
  MARKDOWN
  
  send_message(text: strategies_text, parse_mode: 'Markdown')
end

      def create_final_plan(analysis_data)
  triggers = analysis_data['triggers'] || []
  strategies = analysis_data['strategies'] || []
  
  # Форматируем стратегии красиво
  formatted_strategies = if strategies.is_a?(Array)
    strategies.map { |s| "• #{s.gsub('*', '').strip}" }.join("\n")
  elsif strategies.is_a?(String)
    strategies.gsub('*', '').strip
  else
    "Стратегии не указаны"
  end
  
  plan = <<~MARKDOWN
    *План работы на следующую неделю:*
    
    🎯 *Мои триггеры для отслеживания:*
    #{triggers.map.with_index { |t, i| "#{i + 1}. #{t}" }.join("\n")}
    
    🛡️ *Стратегии совладания:*
    #{formatted_strategies}
    
    📅 *Практический план:*
    1. Ежедневно отслеживать появление триггеров
    2. Применять стратегии в момент возникновения
    3. Вечером делать краткую запись в дневнике
    4. В воскресенье подводить итоги недели
    
    💡 *Критерии успеха:*
    • Уменьшение интенсивности эмоциональных реакций
    • Увеличение осознанности в моменте
    • Более адаптивное поведение
    • Чувство контроля над ситуациями
  MARKDOWN
  
  plan
end
      
      # Методы для работы с записями дневника
      def get_entries_for_period(period)
        entries = @user.emotion_diary_entries
        
        case period
        when 'Последние 7 дней'
          entries.where('created_at >= ?', 7.days.ago)
        when 'Последний месяц'
          entries.where('created_at >= ?', 30.days.ago)
        when 'Все записи'
          entries
        else
          # Если пользователь ввел свой период, пытаемся его распарсить
          begin
            if period.match?(/\d+.*дн/)
              days = period.to_i
              entries.where('created_at >= ?', days.days.ago)
            else
              entries
            end
          rescue
            entries
          end
        end
      end
      
      def show_entries_for_period(period, limit: 5)
        entries = get_entries_for_period(period)
        entries_count = entries.count
        
        if entries_count == 0
          send_message(text: "📭 У вас нет записей за выбранный период.")
          return false
        end
        
        # Показываем записи
        entries.last(limit).each_with_index do |entry, index|
          entry_message = format_diary_entry(entry, index + 1)
          send_message(text: entry_message, parse_mode: 'Markdown')
          
          # Пауза между записями
          sleep(0.5) unless index == [entries_count, limit].min - 1
        end
        
        true
      end
      
      def show_thoughts_from_entries(period, limit: 5)
        entries = get_entries_for_period(period).last(limit)
        
        message = "💭 *Автоматические мысли из записей:*\n\n"
        
        entries.each_with_index do |entry, index|
          if entry.thoughts.present?
            thoughts = entry.thoughts.gsub(/\n/, ' ').truncate(100)
            message += "#{index + 1}. #{thoughts}\n\n"
          end
        end
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def show_emotions_from_entries(period, limit: 5)
        entries = get_entries_for_period(period).last(limit)
        
        message = "😔 *Эмоции из записей:*\n\n"
        
        entries.each_with_index do |entry, index|
          if entry.emotions.present?
            emotions = entry.emotions.gsub(/\n/, ' ').truncate(100)
            message += "#{index + 1}. #{emotions}\n\n"
          end
        end
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def format_diary_entry(entry, index = nil)
        prefix = index ? "*#{index}.* " : ""
        
        <<~MARKDOWN
          #{prefix}📅 *#{entry.created_at.strftime('%d.%m.%Y %H:%M')}*
          
          🎯 *Ситуация:* #{entry.situation.truncate(80)}
          💭 *Мысли:* #{entry.thoughts.truncate(80)}
          😊 *Эмоции:* #{entry.emotions.truncate(80)}
          🚶 *Поведение:* #{entry.behavior.truncate(80)}
          🔍 *Анализ:* #{entry.evidence_against.truncate(80)}
          🌟 *Новые мысли:* #{entry.new_thoughts.truncate(80)}
        MARKDOWN
      end

     def show_triggers_examples(analysis_data)
  # Генерируем примеры триггеров на основе выбранных категорий
  categories = analysis_data['situation_categories'] || []
  patterns = analysis_data['cognitive_patterns'] || []
  emotions = analysis_data['emotions'] || []
  
  if categories.any? && patterns.any? && emotions.any?
    send_message(text: "*🎯 Примеры триггеров на основе вашего анализа:*", parse_mode: 'Markdown')
    
    # Пример 1: Берем первый элемент из каждого массива
    situation_desc = extract_situation_description(categories.first)
    pattern_desc = extract_pattern_description(patterns.first)
    emotion = emotions.first.gsub(/[😊😔😠😨😳😞]/, '').strip.downcase
    
    example1 = <<~MARKDOWN
      *Пример 1:*
      • *Ситуация:* #{situation_desc}
      • *Мысль:* #{pattern_desc}
      • *Эмоция:* #{emotion}
      • *Типичная реакция:* Избегание или самокритика

      *Формулировка триггера:*
      _"Когда я сталкиваюсь с **#{situation_desc}**, у меня возникает мысль **#{pattern_desc}**, что вызывает чувство **#{emotion}**, и я обычно реагирую избеганием."_
    MARKDOWN
    
    send_message(text: example1, parse_mode: 'Markdown')
    
    # Пример 2: Берем второй элемент если есть, иначе используем другие данные
    if categories.length > 1 && patterns.length > 1 && emotions.length > 1
      situation_desc2 = extract_situation_description(categories[1])
      pattern_desc2 = extract_pattern_description(patterns[1])
      emotion2 = emotions[1].gsub(/[😊😔😠😨😳😞]/, '').strip.downcase
      
      example2 = <<~MARKDOWN
        *Пример 2:*
        • *Ситуация:* #{situation_desc2}
        • *Мысль:* #{pattern_desc2}
        • *Эмоция:* #{emotion2}
        • *Типичная реакция:* Прокрастинация или изоляция

        *Формулировка триггера:*
        _"Когда возникает **#{situation_desc2}**, у меня появляется мысль **#{pattern_desc2}**, что приводит к чувству **#{emotion2}**, и я откладываю дела или избегаю общения."_
      MARKDOWN
      
      send_message(text: example2, parse_mode: 'Markdown')
    end
    
    # Общие рекомендации
    recommendations = <<~MARKDOWN
      *💡 Рекомендации по формулировке:*
      
      1. *Будьте конкретны* — опишите ситуацию детально
      2. *Используйте "я-высказывания"* — говорите о своих мыслях и чувствах
      3. *Связывайте компоненты* — покажите как ситуация → мысль → эмоция → поведение
      4. *Избегайте обвинений* — фокусируйтесь на своих реакциях, а не на других людях
      5. *Будьте честны* — признавайте даже неудобные мысли и чувства

      *📝 Шаблон для ввода:*
      "Когда [конкретная ситуация], у меня возникает мысль '[автоматическая мысль]', что вызывает чувство [эмоция], и я обычно реагирую [типичное поведение]."
    MARKDOWN
    
    send_message(text: recommendations, parse_mode: 'Markdown')
    
    # Кнопка для продолжения
    send_message(
      text: "Теперь попробуйте сформулировать свои триггеры:",
      reply_markup: {
        inline_keyboard: [
          [{ text: "✍️ Ввести свои триггеры", callback_data: 'day_23_continue_input' }],
          [{ text: "📋 Посмотреть сводку", callback_data: 'day_23_show_summary' }]
        ]
      }
    )
  else
    # Если недостаточно данных для примера
    send_message(
      text: "*Для примеров триггеров нужно выбрать хотя бы одну категорию ситуаций, один мыслительный паттерн и одну эмоцию.*",
      parse_mode: 'Markdown'
    )
    
    # Предлагаем заполнить недостающие данные
    send_message(
      text: "Вернитесь и заполните недостающие разделы:",
      reply_markup: {
        inline_keyboard: [
          [
            { text: "🔍 Категории ситуаций", callback_data: 'day_23_show_summary' },
            { text: "💭 Мыслительные паттерны", callback_data: 'day_23_show_summary' }
          ],
          [
            { text: "😔 Эмоции", callback_data: 'day_23_show_summary' }
          ]
        ]
      }
    )
  end
end
      
      # ===== МЕТОДЫ РАЗМЕТКИ =====
      
      def day_23_start_markup
        {
          inline_keyboard: [
            [
              { text: "📊 Начать анализ", callback_data: 'start_day_23_exercise' },
              { text: "📈 Статистика", callback_data: 'day_23_show_diary_stats' }
            ]
          ]
        }
      end
      
      def diary_analysis_low_entries_markup
        {
          inline_keyboard: [
            [
              { text: "📝 Сделать запись", callback_data: 'day_23_add_diary_entry' },
              { text: "📊 Анализировать имеющиеся", callback_data: 'day_23_use_existing' }
            ]
          ]
        }
      end
      
      def day_23_period_markup
        {
          inline_keyboard: [
            [
              { text: "📅 Последние 7 дней", callback_data: 'day_23_period_7_days' },
              { text: "🗓️ Последний месяц", callback_data: 'day_23_period_30_days' }
            ],
            [
              { text: "📚 Все записи", callback_data: 'day_23_period_all' }
            ]
          ]
        }
      end
      
      def day_23_situations_markup
        keyboard = SITUATION_CATEGORIES.each_slice(2).map do |pair|
          pair.map do |category|
            { text: "#{category[:emoji]} #{category[:name]}", callback_data: "day_23_situation_#{category[:key]}" }
          end
        end
        
        keyboard << [
          { text: "📖 Показать записи", callback_data: 'day_23_show_entries' },
          { text: "💭 Показать мысли", callback_data: 'day_23_show_thoughts' }
        ]
        
        keyboard << [
          { text: "✅ Завершить выбор", callback_data: 'day_23_finish_categories' },
          { text: "✍️ Свои категории", callback_data: 'day_23_custom_categories' }
        ]
        
        { inline_keyboard: keyboard }
      end
      
      def day_23_thoughts_markup
        keyboard = COGNITIVE_DISTORTIONS.each_with_index.map do |pattern, index|
          [{ text: "#{pattern[:name]}", callback_data: "day_23_thought_#{index}" }]
        end
        
        keyboard << [
          { text: "📖 Показать записи", callback_data: 'day_23_show_entries' },
          { text: "😔 Показать эмоции", callback_data: 'day_23_show_emotions' }
        ]
        
        keyboard << [
          { text: "✅ Завершить выбор", callback_data: 'day_23_finish_thoughts' },
          { text: "✍️ Свои паттерны", callback_data: 'day_23_custom_thoughts' }
        ]
        
        { inline_keyboard: keyboard }
      end
      
     def day_23_triggers_markup
  {
    inline_keyboard: [
      [
        { text: "📋 Посмотреть сводку", callback_data: 'day_23_show_summary' },
        { text: "💡 Примеры", callback_data: 'day_23_trigger_examples' }
      ]
    ]
  }
end

def handle_continue_input
  current_step = get_day_data('current_analysis_step')
  
  if current_step == 'identify_triggers'
    send_message(
      text: "✍️ *Продолжите вводить ваши триггеры:*\n\nИспользуйте формат:\n• [Ситуация] → [Мысль] → [Эмоция] → [Поведение]",
      parse_mode: 'Markdown',
      reply_markup: day_23_step_navigation_markup
    )
    @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_identify_triggers")
  elsif current_step == 'create_strategies'
    send_message(
      text: "✍️ *Продолжите описывать ваши стратегии:*\n\nЧто конкретно вы будете делать для каждого триггера?",
      parse_mode: 'Markdown',
      reply_markup: day_23_step_navigation_markup
    )
    @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_create_strategies")
  else
    start_analysis_step(current_step) if current_step
  end
end
      
      def day_23_strategies_markup
  {
    inline_keyboard: [
      [
        { text: "🛡️ Примеры стратегий", callback_data: 'day_23_show_strategies' },
        { text: "📋 Мои стратегии", callback_data: 'day_23_my_strategies' }
      ],
      [
        { text: "← Назад к триггерам", callback_data: 'day_23_show_summary' },
        { text: "✅ Готово", callback_data: 'day_23_strategies_done' }
      ]
    ]
  }
end

      def day_23_step_navigation_markup
        {
          inline_keyboard: [
            [
              { text: "🔙 Назад", callback_data: 'day_23_previous_step' },
              { text: "🔄 Начать заново", callback_data: 'day_23_restart_analysis' }
            ]
          ]
        }
      end
      
      def day_23_final_completion_markup
  {
    inline_keyboard: [
      [
        { text: "✅ Завершить День 23", callback_data: 'day_23_complete_exercise' },
        { text: "🔄 Пройти заново", callback_data: 'retry_day_23_exercise' }
      ]
    ]
  }
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
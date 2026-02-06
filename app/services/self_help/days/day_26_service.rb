# app/services/self_help/days/day_26_service.rb
module SelfHelp
  module Days
    class Day26Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 26
      
      # Шаги дня 26
      DAY_STEPS = {
        'intro' => {
          title: "🔗 *День 26: КПТ 'Цепочка ценностей' (Values Chain)* 🔗",
          instruction: <<~MARKDOWN
            **Добро пожаловать в мир глубинных смыслов и осознанной мотивации!** ✨

            Сегодня вы освоите одну из самых мощных техник ACT (Acceptance and Commitment Therapy) — способность находить и усиливать связь между вашими повседневными действиями и глубинными жизненными ценностями.

            📊 **Научные факты о связи действий и ценностей:**
            • 🧠 Действия, связанные с ценностями, активируют дофаминовую систему на 35-50% сильнее
            • 😌 Осознание связи с ценностями снижает выгорание на 40-60%
            • 🎯 Люди, живущие в соответствии с ценностями, имеют на 45% выше удовлетворённость жизнью
            • ⏳ Упражнение "Цепочка ценностей" повышает мотивацию на 65% за счёт создания смысловых мостов
            • 🔄 ACT-терапия с фокусом на ценности снижает депрессию на 50% и тревогу на 40%
            • 💡 87% людей, практикующих технику, отмечают повышение осмысленности повседневных действий
            • 🌱 Нейропластичность: регулярная практика создаёт новые нейронные пути между действиями и системами вознаграждения

            🎯 **Что вы получите от сегодняшней практики:**
            1. 🔗 Способность находить смысл в обычных действиях
            2. 💪 Мощный инструмент борьбы с выгоранием и рутиной
            3. 🧭 Чёткое понимание ваших истинных ценностей
            4. 🌉 Навык создания "мостов" между действиями и смыслами
            5. 🎭 Технику превращения рутины в осознанные ритуалы
            6. 📈 Увеличение мотивации через переосмысление ежедневных задач
          MARKDOWN
        },
        'exercise_explanation' => {
          title: "⚙️ *Упражнение: Архитектура смысла* 🏗️",
          instruction: <<~MARKDOWN
            **Почему именно 'Цепочка ценностей'?** 🤔

            Когда мы осознаём связь между нашими действиями и глубинными ценностями, происходит мощная трансформация:

            • 🧠 **Нейробиологический эффект:** Активируются префронтальная кора и система вознаграждения
            • 💪 **Мотивационный прорыв:** Действия получают эмоциональную "подпитку" от ценностей
            • 🔄 **Когнитивная переоценка:** Рутина превращается в путь к важным целям
            • 😌 **Эмоциональное облегчение:** Исчезает чувство бессмысленности действий
            • 🌱 **Экзистенциальное наполнение:** Повседневность обретает глубину и значимость

            **Как работает техника ACT:**
            1. 🔧 Выбираем конкретное регулярное действие
            2. 🎯 Последовательно раскручиваем 6 уровней смысла
            3. 🔍 Находим и анализируем "разрывы" в цепочке
            4. 🌉 Создаём "мосты" для усиления связи
            5. 🎭 Превращаем действие в осознанный ритуал

            **Сегодняшнее упражнение:** Глубинный анализ одного действия через 6 уровней — от конкретного поступка до экзистенциального смысла.
            Цель — не изменить действие, а изменить ваше отношение к нему через осознание его связи с тем, что для вас действительно важно.
          MARKDOWN
        },
        'practice_guidance' => {
          title: "📋 *Подготовка к археологии смыслов* 🧭",
          instruction: <<~MARKDOWN
            **Оптимальные условия для практики:**

            🧠 **Ментальная подготовка:**
            • Выберите время, когда можете сосредоточиться 20-25 минут
            • Отложите все отвлекающие факторы
            • Настройтесь на исследовательский лад
            • Будьте открыты инсайтам и открытиям

            📝 **Инструментальная подготовка:**
            • Можете делать заметки на бумаге или в приложении
            • Готовьтесь к честному диалогу с собой
            • Разрешите себе мыслить масштабно и глубоко
            • Помните: нет "правильных" или "неправильных" ответов

            🎯 **Установка на практику:**
            • Будьте любопытны, как археолог, раскапывающий древний артефакт
            • Не спешите — каждый уровень требует осмысления
            • Если возникают сомнения — это нормально, просто продолжайте
            • Помните: эта техника используется в терапии уже 30 лет!

            **Важно:** 'Цепочка ценностей' — это навык, который развивается через практику. Чем чаще вы её применяете, тем легче находите смыслы.
          MARKDOWN
        },
        'post_practice_reflection' => {
          title: "📝 *Рефлексия после раскопок смыслов* 💎",
          instruction: <<~MARKDOWN
            **Потрясающая работа! Вы только что завершили археологическую экспедицию к вашим глубинным ценностям!** 🌟

            **Вопросы для рефлексии:**

            🔗 **1. Об изменении перспективы:**
            • Как изменилось ваше восприятие выбранного действия от начала до конца?
            • На каком уровне вы почувствовали наибольший прорыв в понимании?
            • Какие инсайты о ваших ценностях пришли к вам?
            • Как изменилась "значимость" этого действия после анализа?

            🧠 **2. Об уме и эмоциях:**
            • Какие мысли или сопротивления возникали во время практики?
            • Как менялось ваше эмоциональное состояние при переходе на более глубокие уровни?
            • Были ли моменты удивления или озарения?
            • Как повлияло осознание связи с ценностями на мотивацию?

            😌 **3. О состоянии после практики:**
            • Как изменилось ваше отношение к этому действию?
            • Чувствуете ли вы больше смысла и осознанности?
            • Готовы ли вы применять эту технику к другим действиям?
            • Какое влияние может оказать эта практика на вашу жизнь в целом?
          MARKDOWN
        }
      }.freeze
      
      # Категории для выбора действия
      ACTION_CATEGORIES = [
        {
          name: "Работа/учеба",
          emoji: "💼",
          description: "Профессиональные задачи, проекты, обучение, карьерное развитие.",
          examples: ["Подготовка ежедневного отчёта", "Участие в совещании", "Изучение нового навыка", "Работа над проектом"],
          recommended_for: "Когда работа кажется рутиной или теряет смысл"
        },
        {
          name: "Бытовые дела",
          emoji: "🏠",
          description: "Повседневные домашние обязанности, уход за пространством.",
          examples: ["Уборка квартиры", "Приготовление еды", "Поход в магазин", "Оплата счетов"],
          recommended_for: "Когда домашние дела кажутся бесконечной и бессмысленной рутиной"
        },
        {
          name: "Социальное взаимодействие",
          emoji: "👥",
          description: "Общение с людьми, поддержание отношений, социальные обязательства.",
          examples: ["Разговор с коллегой", "Встреча с другом", "Семейный обед", "Социальное мероприятие"],
          recommended_for: "Когда общение становится формальным или энергозатратным"
        },
        {
          name: "Здоровье",
          emoji: "🏃",
          description: "Забота о физическом и ментальном здоровье, профилактика.",
          examples: ["Утренняя зарядка", "Приготовление здоровой еды", "Медитация", "Визит к врачу"],
          recommended_for: "Когда забота о себе кажется обузой или дополнительной задачей"
        },
        {
          name: "Финансовые задачи",
          emoji: "💰",
          description: "Управление деньгами, планирование бюджета, финансовые обязательства.",
          examples: ["Составление бюджета", "Оплата коммунальных услуг", "Инвестирование", "Финансовое планирование"],
          recommended_for: "Когда финансовые вопросы вызывают стресс или кажутся бессмысленными"
        },
        {
          name: "Творчество и хобби",
          emoji: "🎨",
          description: "Творческая деятельность, увлечения, личные проекты.",
          examples: ["Рисование", "Игра на музыкальном инструменте", "Писательство", "Рукоделие"],
          recommended_for: "Когда творчество становится обязательством или теряет радость"
        }
      ].freeze
      
      # Уровни раскрутки ценностей
      VALUE_LEVELS = [
        {
          name: "level1_action",
          emoji: "🔧",
          title: "Конкретное действие",
          instruction: <<~MARKDOWN,
            **Опишите ваше действие максимально конкретно и детально.** 🎯

            **Формат описания:**
            • 🏷️ **Что именно:** [Конкретное физическое действие]
            • 🕰️ **Когда:** [Время/условия выполнения]
            • 📅 **Как часто:** [Регулярность/повторяемость]
            • 👥 **С кем:** [Если применимо — другие участники]
            • 🌍 **Где:** [Место выполнения]

            **Пример качественного описания:**
            "Каждый будний день в 17:00 я составляю детальный отчёт о продажах за день. Делаю это за рабочим столом в офисе, используя Excel и CRM-систему. Процесс занимает около 45 минут. Работаю один."

            **Чем конкретнее описание — тем глубже анализ.**
            
            **Ваше действие:** 📝
          MARKDOWN
          prompt: "Опишите ваше действие максимально конкретно:"
        },
        {
          name: "level2_immediate_goal",
          emoji: "🎯",
          title: "Непосредственная цель",
          instruction: <<~MARKDOWN,
            **Теперь задайте ключевой вопрос: *Зачем?*** 🤔

            **Какая ближайшая, конкретная цель у этого действия?**
            
            **Примеры непосредственных целей:**
            • "Чтобы отчитаться перед руководителем о результатах дня"
            • "Чтобы дом был чистым и готовым к приёму гостей"
            • "Чтобы подготовить материалы для завтрашней презентации"
            • "Чтобы выполнить взятое на себя обязательство"

            **Критерии хорошей цели:**
            • ✅ **Конкретная:** Можно проверить, достигнута ли
            • ⏳ **Ограниченная во времени:** Имеет срок выполнения
            • 🎯 **Измеримая:** Можно оценить степень выполнения
            • 🧠 **Рациональная:** Имеет логическое обоснование

            **Какая непосредственная цель у вашего действия?**
            
            **Опишите цель:** 📝
          MARKDOWN
          prompt: "Какая непосредственная цель у этого действия?"
        },
        {
          name: "level3_functional_value",
          emoji: "⚙️",
          title: "Функциональная ценность",
          instruction: <<~MARKDOWN,
            **Поднимаемся выше: *Что даёт достижение этой цели?*** 🚀

            **Какая практическая польза или функция выполняется?**
            
            **Примеры функциональных ценностей:**
            • 💰 "Сохранить работу / получить зарплату / премию"
            • 🏠 "Поддерживать гигиену и порядок в жилом пространстве"
            • 📊 "Быть подготовленным и эффективным в работе"
            • 🛡️ "Избежать проблем, штрафов или негативных последствий"
            • ⏰ "Сэкономить время в будущем через планирование"

            **Функциональная ценность** — это практический результат, который:
            • Улучшает вашу жизнь или ситуацию
            • Решает конкретные проблемы
            • Создаёт ресурсы или возможности
            • Предотвращает трудности

            **Какая функциональная ценность у этой цели?**
            
            **Опишите практическую пользу:** 📝
          MARKDOWN
          prompt: "Какая практическая польза или функция выполняется?"
        },
        {
          name: "level4_personal_value",
          emoji: "❤️",
          title: "Личная ценность",
          instruction: <<~MARKDOWN,
            **Переходим к личности: *Какие ваши качества проявляются?*** 💖

            **Какие личные ценности или принципы вы выражаете через это действие?**
            
            **Примеры личных ценностей:**
            • 🛡️ **Ответственность** — выполнять взятые обязательства
            • 🌱 **Забота** — поддерживать своё здоровье и благополучие
            • ⭐ **Профессионализм** — делать работу качественно и добросовестно
            • 🤝 **Честность** — выполнять обещания и быть прозрачным
            • 🧠 **Любознательность** — учиться и развиваться

            **Личные ценности** — это:
            • Принципы, которые направляют ваши решения
            • Качества характера, которые вы проявляете
            • То, что вы считаете важным в себе как личности
            • Ваш внутренний моральный компас

            **Какие личные ценности вы выражаете через это действие?**
            
            **Опишите ваши ценности:** 📝
          MARKDOWN
          prompt: "Какие личные ценности или качества вы проявляете?"
        },
        {
          name: "level5_relational_value",
          emoji: "🤝",
          title: "Относительная ценность",
          instruction: <<~MARKDOWN,
            **Расширяем перспективу: *Как это связано с другими?*** 🌍

            **Как это действие связано с вашей ролью в отношениях или сообществе?**
            
            **Примеры относительных ценностей:**
            • 👨‍👩‍👧 **"Быть заботливым родителем"** — через приготовление здоровой еды
            • 💼 **"Быть надёжным сотрудником"** — через своевременную сдачу отчётов
            • 🤝 **"Быть хорошим другом"** — через поддержку в трудную минуту
            • 🏘️ **"Быть ответственным гражданином"** — через участие в общественной жизни
            • 👥 **"Быть частью команды"** — через вклад в общий проект

            **Относительные ценности** определяют:
            • Вашу роль в отношениях с другими людьми
            • Ваше место в сообществах и группах
            • Вклад, который вы делаете в жизнь других
            • Связь ваших действий с социальным контекстом

            **Как это действие связано с вашими отношениями или ролью?**
            
            **Опишите социальный контекст:** 📝
          MARKDOWN
          prompt: "Как это действие связано с вашей ролью среди других людей?"
        },
        {
          name: "level6_existential_value",
          emoji: "🌟",
          title: "Экзистенциальная ценность",
          instruction: <<~MARKDOWN,
            **Финальный уровень: *Какой самый глубокий смысл?*** 🪐

            **Как это действие связано с тем, что вы считаете действительно важным в жизни?**
            
            **Примеры экзистенциальных ценностей:**
            • 🌱 **"Вносить вклад в развитие и прогресс"**
            • 🎭 **"Выражать свою уникальность и творческий потенциал"**
            • 🤲 **"Создавать красоту, порядок или гармонию"**
            • 👥 **"Помогать другим расти и становиться лучше"**
            • 🧭 **"Жить в соответствии со своими глубинными принципами"**
            • 🌍 **"Оставлять позитивный след в мире"**

            **Экзистенциальные ценности** — это:
            • Самые глубокие смыслы, которые делают жизнь значимой
            • То, ради чего стоит просыпаться каждый день
            • Ваш личный ответ на вопрос "Зачем я живу?"
            • Источник вдохновения и устойчивости в трудные времена

            **Какой самый глубокий смысл вы находите в этом действии?**
            
            **Опишите экзистенциальный смысл:** 📝
          MARKDOWN
          prompt: "Какой самый глубокий смысл или значение имеет это действие?"
        }
      ].freeze
      
      # Элементы для создания осознанных ритуалов
      RITUAL_ELEMENTS = [
        {
          name: "Зажжение свечи",
          emoji: "🕯️",
          description: "Зажечь свечу как символическое начало осознанного действия",
          duration: "10 секунд",
          benefits: "Создаёт сакральное пространство и намерение"
        },
        {
          name: "Особая музыка",
          emoji: "🎵",
          description: "Включить специальный плейлист для этого действия",
          duration: "На время действия",
          benefits: "Создаёт настроение и ассоциативную связь"
        },
        {
          name: "Мантра намерения",
          emoji: "📿",
          description: "Повторить про себя значимую фразу перед началом",
          duration: "15-30 секунд",
          benefits: "Фокусирует внимание на глубинной цели"
        },
        {
          name: "Минута благодарности",
          emoji: "🙏",
          description: "Поблагодарить себя или обстоятельства после завершения",
          duration: "1 минута",
          benefits: "Закрепляет позитивную ассоциацию с действием"
        },
        {
          name: "Физический символ",
          emoji: "💎",
          description: "Использовать маленький предмет как напоминание о ценности",
          duration: "Постоянно",
          benefits: "Создаёт физическую связь с абстрактной ценностью"
        },
        {
          name: "Дыхательный переход",
          emoji: "🌬️",
          description: "Сделать 3 осознанных вдоха-выдоха перед началом",
          duration: "30 секунд",
          benefits: "Помогает перейти из автоматического режима в осознанный"
        }
      ].freeze
      
      # Типичные трудности в практике "Цепочки ценностей"
      COMMON_CHALLENGES = [
        {
          challenge: "Не могу найти ценность в действии",
          emoji: "🌀",
          solution: "Начните с простого: какая самая базовая функция? Даже 'избежать проблем' — уже ценность. Постепенно углубляйтесь."
        },
        {
          challenge: "Кажется, что придумываю смыслы",
          emoji: "🤔",
          solution: "Это нормально! Ценности часто осознаются через рефлексию. Важно не 'найти правильный ответ', а создать осмысленную связь."
        },
        {
          challenge: "Действие кажется действительно бессмысленным",
          emoji: "😞",
          solution: "Возможно, это сигнал к изменениям. Анализ может показать, что действие действительно не соответствует ценностям — это ценный инсайт!"
        },
        {
          challenge: "Слишком много уровней, теряюсь",
          emoji: "🧭",
          solution: "Делайте паузы между уровнями. Можно растянуть практику на несколько подходов. Главное — не скорость, а глубина."
        },
        {
          challenge: "Не вижу разрывов в цепочке",
          emoji: "🔍",
          solution: "Спросите: 'Если бы я мог(ла) изменить одно в этом действии, чтобы оно лучше соответствовало моим ценностям, что бы это было?'"
        }
      ].freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ (ИЗ DayBaseService) =====
      
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
          text: "Готовы превратить повседневность в путь к вашим глубинным ценностям?",
          reply_markup: day_26_content_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise_explanation')
        
        send_message(text: DAY_STEPS['exercise_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['exercise_explanation'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: DAY_STEPS['practice_guidance'][:title],
          parse_mode: 'Markdown'
        )
        send_message(text: DAY_STEPS['practice_guidance'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "🔧 **Выберите действие для глубинного анализа ценностей:**",
          parse_mode: 'Markdown',
          reply_markup: day_26_action_categories_markup
        )
      end
      
      
      def complete_exercise
        # Отмечаем день как завершенный в программе
        @user.complete_day_program(DAY_NUMBER)
        
        # Также вызываем старый метод для совместимости
        @user.complete_self_help_day(DAY_NUMBER)
        
        # Сохраняем статистику практики
        save_value_chain_stats
        
        # Показываем завершение дня
        show_day_completion
      end
      
      def show_day_completion
        # Получаем данные через read_attribute или []
        day_data = @user.read_attribute(:self_help_program_data) || @user[:self_help_program_data] || {}
        
        exercise_data = day_data["day_#{DAY_NUMBER}_exercise_data"] || {}
        action = exercise_data['action'] || "Не указано"
        action_description = exercise_data['action_description'] || "Не указано"
        ritual = exercise_data['ritual'] || "Не создан"
        
        completion_message = <<~MARKDOWN
          🎊 *День 26 завершен!* 🎊

          **Ваши достижения сегодня:**
          
          🔗 **Создание 'Цепочки ценностей':**
          • 🔧 Анализируемое действие: #{action}
          • 🎯 Раскручено: 6 уровней глубинного смысла
          • 🔍 Обнаружены разрывы: #{exercise_data['gaps_found'] ? 'Да' : 'Нет указано'}
          • 🌉 Созданные мосты: #{exercise_data['bridges_created'] ? 'Да' : 'Нет'}
          • 🎭 Осознанный ритуал: #{ritual.truncate(100)}
          • 🧠 Приобретение: Навык находить смысл в повседневности
          
          📊 **Научный факт:**
          Люди, регулярно практикующие связь действий с ценностями, испытывают на 65% меньше выгорания и на 50% выше удовлетворённость повседневными задачами.
          
          *"Не спрашивай, что мир нуждается в тебе. Спроси, что зажигает тебя изнутри, и делай это. Потому что мир нуждается в людях, которые зажглись."*
          — Говард Тёрман
          
          ⏰ **Следующий день будет доступен через 12 часов**
          
          Ваш прогресс: #{@user.progress_percentage}%
        MARKDOWN
        
        send_message(text: completion_message, parse_mode: 'Markdown')
        
        # Предлагаем следующий день
        propose_next_day_with_restriction
      end
      
      def propose_next_day_with_restriction
        next_day = 27
        
        # Проверяем, можно ли начать следующий день
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ✅ *Доступен сейчас!*
            
            **Что вас ждет:**
            • 🧠 Нейрохакинг радости
            • ✨ Научные методы усиления позитивных эмоций
            • 🎭 Техники перепрограммирования мозга на счастье
            • 🌈 Создание устойчивых нейронных путей радости
            
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
            • 🔗 Применить 'Цепочку ценностей' к другим действиям
            • 🎭 Практиковать созданные ритуалы с осознанностью
            • 📝 Записывать инсайты о ваших истинных ценностях
            • 📊 Посмотреть статистику (/progress)
            
            *Следующий день будет автоматически доступен, когда пройдет достаточно времени.*
          MARKDOWN
          
          # Если день недоступен, НЕ отправляем активную кнопку
          button_text = "⏱️ Проверить доступность Дня #{next_day}"
          callback_data = "start_day_#{next_day}_from_proposal"  # Оставляем ту же, но Day27Handler проверит
        end
        
        # Отправляем сообщение
        send_message(text: message, parse_mode: 'Markdown')
        
        # Отправляем кнопку ВСЕГДА, но Day27Handler проверит доступность
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
      
      # ===== ОБРАБОТКА КНОПОК =====
      
      def handle_button(callback_data)
        case callback_data
        when 'start_day_26_content', 'start_day_26_from_proposal'
          deliver_exercise
          
        when 'continue_day_26_content'
          # Проверяем, на каком шаге остановился пользователь
          current_step = get_day_data('current_step')
          handle_resume_from_step(current_step || 'intro')
          
        when /^day_26_action_(\d+)$/
          handle_action_selection($1)
          
        when 'day_26_action_custom'
          send_message(text: "✍️ *Опишите ваше действие максимально конкретно:*", parse_mode: 'Markdown')
          store_day_data('awaiting_action_description', true)
          
        when 'day_26_start_values_chain'
          start_values_chain_journey
          
        when /^day_26_level_(\d+)$/
          handle_level_button($1)
          
        when 'day_26_skip_level'
          handle_skip_level
          
        when 'day_26_restart_level'
          handle_restart_level
          
        when 'day_26_chain_complete'
          complete_values_chain
          
        when /^day_26_ritual_(\d+)$/
          handle_ritual_selection($1)
          
        when 'day_26_ritual_custom'
          send_message(text: "🎭 *Опишите ваш уникальный ритуал:*", parse_mode: 'Markdown')
          store_day_data('awaiting_ritual_description', true)
          
        when 'day_26_complete_exercise', 'day_26_exercise_completed'
          complete_exercise
          
        when 'day_26_restart_chain', 'day_26_new_action'
          restart_exercise
          
        when 'day_26_practice_quick'
          practice_quick_version
          
        when 'day_26_make_note'
          send_message(
            text: "📝 *Напишите заметку о вашей сегодняшней практике:*\n• Какие уровни были самыми откровенными?\n• Как изменилось восприятие действия?\n• Как вы будете применять эту технику в жизни?",
            parse_mode: 'Markdown'
          )
          store_day_data('awaiting_practice_note', true)
          
        when 'day_26_help_choose_action'
          send_message(
            text: "🎯 **Рекомендация по выбору действия:**\n\n• Работа/учеба → Найти смысл в профессиональных задачах\n• Бытовые дела → Превратить рутину в осознанную практику\n• Социальное → Углубить смысл взаимодействий\n• Здоровье → Связать заботу о себе с ценностями\n• Финансы → Найти смысл в финансовой дисциплине\n• Творчество → Восстановить радость в увлечениях",
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
  when get_day_data('awaiting_action_description')
    store_day_data('awaiting_action_description', false)
    return handle_action_description_input(input_text)
    
  when get_day_data('awaiting_gaps_description')
    store_day_data('awaiting_gaps_description', false)
    return handle_gaps_input(input_text)
    
  when get_day_data('awaiting_bridges_description')
    store_day_data('awaiting_bridges_description', false)
    return handle_bridges_input(input_text)
    
  when get_day_data('awaiting_ritual_description')
    store_day_data('awaiting_ritual_description', false)
    return handle_ritual_input(input_text)
    
  when get_day_data('awaiting_reflection')
    store_day_data('awaiting_reflection', false)
    return handle_reflection_input(input_text)
    
  else
    # Обработка по текущему шагу
    case current_step
    when 'intro'
      handle_intro_input(input_text)
    when 'select_action'
      handle_action_input(input_text)
    when /^level\d+_/
      handle_level_input(current_step, input_text)
    when 'identify_gaps'
      # Должно быть обработано выше через awaiting_gaps_description
      handle_gaps_input(input_text)
    when 'bridge_gaps'
      # Должно быть обработано выше через awaiting_bridges_description
      handle_bridges_input(input_text)
    when 'create_ritual'
      # Должно быть обработано выше через awaiting_ritual_description
      handle_ritual_input(input_text)
    when 'summary'
      handle_summary_input(input_text)
    else
      log_warn("Unknown step for text input: #{current_step}")
      send_message(text: "Пожалуйста, следуйте инструкциям на экране.")
      false
    end
  end
end

def start_exercise_step(step_type)
  store_day_data('current_step', step_type)
  
  step = DAY_STEPS[step_type] || EXERCISE_STEPS[step_type]
  return unless step
  
  send_message(text: step[:title], parse_mode: 'Markdown') if step[:title]
  
  if step_type == 'summary'
    instruction = format_summary_instruction(step[:instruction])
  else
    instruction = step[:instruction]
  end
  
  send_message(text: instruction) if instruction
  
  # Показываем дополнительные элементы для определенных шагов
  case step_type
  when 'select_action'
    send_message(
      text: "Выберите категорию или опишите своё действие:",
      reply_markup: day_26_action_categories_markup
    )
    
  when /^level\d+_/
    # Показываем прогресс по уровням
    show_level_progress(step_type)
    
  when 'identify_gaps'
    # Показываем всю цепочку для анализа
    show_current_chain
    
  when 'bridge_gaps'
    send_message(
      text: "Нужны идеи для мостов?",
      reply_markup: day_26_bridges_markup
    )
    
  when 'create_ritual'
    send_message(
      text: "Элементы для ритуала:",
      reply_markup: day_26_ritual_elements_markup
    )
    
  when 'summary'
    send_message(
      text: "Ваша 'Цепочка ценностей' готова!",
      reply_markup: day_26_completion_markup
    )
  end
end
      
      # ===== ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ =====
      
      private
      
      def init_exercise_data
        store_day_data('exercise_data', {
          'action_category' => nil,
          'action_description' => nil,
          'levels' => {},
          'current_level_index' => 0,
          'gaps_found' => false,
          'gaps_description' => nil,
          'bridges_created' => false,
          'bridges_description' => nil,
          'ritual' => nil,
          'ritual_description' => nil,
          'reflection' => nil,
          'completed' => false,
          'completed_at' => nil
        })
      end
      
      def clear_exercise_data
        day_data_keys = @user.self_help_program_data.keys.select { |k| k.start_with?('day_26_') }
        day_data_keys.each do |key|
          @user.self_help_program_data.delete(key)
        end
        @user.save
        log_info("Cleared exercise data for day 26")
      end
      
      def handle_action_selection(action_index)
        index = action_index.to_i
        
        if index < 0 || index >= ACTION_CATEGORIES.length
          log_warn("Invalid action index: #{index}")
          send_message(text: "⚠️ Неизвестная категория. Пожалуйста, выберите из предложенных.")
          return
        end
        
        action_category = ACTION_CATEGORIES[index]
        
        if action_category
          exercise_data = get_exercise_data || {}
          exercise_data['action_category'] = action_category
          exercise_data['action_description'] = action_category[:examples].sample
          store_day_data('exercise_data', exercise_data)
          
          send_message(
            text: "✅ Выбрана категория: #{action_category[:emoji]} *#{action_category[:name]}*",
            parse_mode: 'Markdown'
          )
          
          send_message(
            text: "#{action_category[:emoji]} **Описание:** #{action_category[:description]}\n**Рекомендуется:** #{action_category[:recommended_for]}",
            parse_mode: 'Markdown'
          )
          
          send_message(
            text: "💡 **Пример действия:** #{action_category[:examples].sample}",
            parse_mode: 'Markdown'
          )
          
          sleep(1)
          send_message(
            text: "✍️ *Теперь уточните или опишите ваше конкретное действие:*",
            parse_mode: 'Markdown',
            reply_markup: day_26_action_details_markup
          )
        else
          log_warn("Action category not found for index: #{index}")
          send_message(text: "⚠️ Неизвестная категория. Пожалуйста, выберите из предложенных.")
        end
      end
      
      def start_values_chain_journey
        store_day_data('current_step', 'values_chain')
        init_exercise_data unless get_exercise_data
        
        send_message(
          text: "🔗 *Начинаем путешествие по уровням ценностей!* ✨",
          parse_mode: 'Markdown'
        )
        
        send_message(
          text: "Мы пройдем 6 уровней глубинного анализа. На каждом уровне у вас будет время на осмысление и запись инсайтов.",
          parse_mode: 'Markdown'
        )
        
        # Начинаем с первого уровня
        start_level(0)
      end
      
      def start_level(level_index)
        level = VALUE_LEVELS[level_index]
        
        if level
          exercise_data = get_exercise_data
          exercise_data['current_level_index'] = level_index
          store_day_data('exercise_data', exercise_data)
          
          store_day_data('current_level_index', level_index)
          
          send_message(
            text: "🎯 **Уровень #{level_index + 1}/6: #{level[:emoji]} #{level[:title]}**",
            parse_mode: 'Markdown'
          )
          
          send_message(text: level[:instruction], parse_mode: 'Markdown')
          
          send_message(
            text: level[:prompt],
            parse_mode: 'Markdown'
          )
          
          store_day_data("awaiting_level_#{level_index}_input", true)
        end
      end
      
      def handle_level_input(level_index, input_text)
        level = VALUE_LEVELS[level_index.to_i]
        
        if level && input_text.present?
          exercise_data = get_exercise_data
          exercise_data['levels'] ||= {}
          exercise_data['levels'][level[:name]] = input_text
          store_day_data('exercise_data', exercise_data)
          
          store_day_data("awaiting_level_#{level_index}_input", false)
          
          send_message(
            text: "✅ Уровень #{level_index.to_i + 1} завершён! #{level[:emoji]}",
            parse_mode: 'Markdown'
          )
          
          # Показываем прогресс
          show_chain_progress(level_index.to_i)
          
          # Переходим к следующему уровню или завершаем цепочку
          if level_index.to_i < VALUE_LEVELS.size - 1
            sleep(1)
            start_level(level_index.to_i + 1)
          else
            sleep(1)
            complete_values_chain
          end
        else
          send_message(text: "⚠️ Пожалуйста, опишите ваши инсайты для этого уровня.")
        end
      end
      
      def handle_level_button(level_index)
        # Обработка кнопки для пропуска или повторения уровня
        current_level = get_day_data('current_level_index').to_i
        
        if level_index.to_i == current_level
          # Повтор текущего уровня
          start_level(current_level)
        elsif level_index.to_i < current_level
          # Возврат к предыдущему уровню
          start_level(level_index.to_i)
        else
          # Пропуск к следующему уровню
          start_level(level_index.to_i)
        end
      end
      
      def handle_skip_level
        current_level = get_day_data('current_level_index').to_i
        if current_level < VALUE_LEVELS.size - 1
          start_level(current_level + 1)
        else
          complete_values_chain
        end
      end
      
      def handle_restart_level
        current_level = get_day_data('current_level_index').to_i
        start_level(current_level)
      end
      
      def complete_values_chain
        exercise_data = get_exercise_data
        exercise_data['chain_completed'] = true
        exercise_data['chain_completed_at'] = Time.current
        store_day_data('exercise_data', exercise_data)
        
        send_message(
          text: "🌟 *Цепочка ценностей раскручена до самого глубокого уровня!* ✨",
          parse_mode: 'Markdown'
        )
        
        # Показываем всю цепочку
        show_complete_chain
        
        # Переходим к поиску разрывов
        sleep(2)
        identify_gaps_in_chain
      end
      
      def identify_gaps_in_chain
        store_day_data('current_step', 'identify_gaps')
        
        send_message(
          text: "🔍 *Шаг 2: Поиск разрывов в цепочке*",
          parse_mode: 'Markdown'
        )
        
        send_message(
          text: "Теперь проанализируем вашу цепочку. **Разрыв возникает, когда действие не ведёт к ценности или противоречит ей.**\n\n**Примеры разрывов:**\n• Действие: Работа сверхурочно\n• Ценность: Время с семьёй\n• Разрыв: Действие противоречит ценности\n\n**Вопросы для анализа:**\n1. Есть ли противоречия между действием и каким-либо уровнем ценностей?\n2. На каком уровне связь наиболее слабая?\n3. Что вы чувствуете, когда делаете это действие?\n\n**Опишите найденные разрывы:**",
          parse_mode: 'Markdown'
        )
        
        store_day_data('awaiting_gaps_description', true)
      end
      
      def handle_gaps_input(input_text)
        if input_text.present?
          exercise_data = get_exercise_data
          exercise_data['gaps_found'] = true
          exercise_data['gaps_description'] = input_text
          store_day_data('exercise_data', exercise_data)
          
          store_day_data('awaiting_gaps_description', false)
          
          send_message(text: "✅ Разрывы обнаружены и сохранены!")
          sleep(1)
          create_bridges_in_chain
        else
          send_message(text: "⚠️ Если разрывов нет, просто напишите 'Разрывов не обнаружено'.")
        end
      end
      
      def create_bridges_in_chain
  store_day_data('current_step', 'bridge_gaps')
  
  send_message(
    text: "🌉 *Шаг 3: Создание мостов через разрывы*",
    parse_mode: 'Markdown'
  )
  
  send_message(
    text: "**Как можно 'починить' разрывы или усилить связь с ценностями?**\n\n**Стратегии создания мостов:**\n1. 🔄 **Изменение действия:** Сделать его более осмысленным\n2. 🎯 **Переформулирование цели:** Связать с более глубокой ценностью\n3. 🎭 **Добавление ритуала:** Соединить с приятным или значимым\n4. 💡 **Нахождение нового значения:** Посмотреть на действие под другим углом\n\n**Пример моста:**\n'Вместо \"просто убираться\" → \"создавать пространство для творчества и отдыха\"'\n\n**Какие мосты вы можете создать?**",
    parse_mode: 'Markdown'
  )
  
  store_day_data('awaiting_bridges_description', true)
end
      
      def handle_bridges_input(input_text)
  if input_text.present?
    exercise_data = get_exercise_data
    exercise_data['bridges_created'] = true
    exercise_data['bridges_description'] = input_text
    store_day_data('exercise_data', exercise_data)
    
    store_day_data('awaiting_bridges_description', false)
    
    send_message(text: "✅ Мосты созданы!")
    sleep(1)
    create_conscious_ritual
    return true
  else
    send_message(text: "⚠️ Пожалуйста, опишите хотя бы одну идею для моста.")
    return false
  end
end

def handle_ritual_input(input_text)
  log_info("handle_ritual_input called with: #{input_text}")
  
  exercise_data = get_exercise_data
  
  # Если ритуал уже выбран, просто сохраняем описание
  if exercise_data['ritual'].present? && input_text.present?
    exercise_data['ritual_description'] = input_text
    store_day_data('exercise_data', exercise_data)
    
    send_message(text: "✅ Описание ритуала сохранено!")
    sleep(1)
    
    # Переходим к summary - выводим напрямую
    show_summary_step
    return true
  else
    send_message(text: "⚠️ Пожалуйста, сначала выберите ритуал или опишите его.")
    return false
  end
end

def show_summary_step
  store_day_data('current_step', 'summary')
  
  # Показываем итоговый отчет
  show_final_report(get_exercise_data)
  
  send_message(
    text: "🎉 Ваша 'Цепочка ценностей' завершена!",
    reply_markup: day_26_completion_markup
  )
end

def show_final_report(exercise_data)
  message = <<~MARKDOWN
    🎉 *Ваша "Цепочка ценностей" создана!* 🎉

    🔗 **Глубинный анализ завершён**

    🔧 **Исходное действие:**
    #{exercise_data['action_description'] || 'Не указано'}

    🎯 **Раскрученная цепочка:**
    1. **🔧 Действие:** #{exercise_data['levels']&.dig('level1_action')&.truncate(80) || '...'}
    2. **🎯 Цель:** #{exercise_data['levels']&.dig('level2_immediate_goal')&.truncate(80) || '...'}
    3. **⚙️ Функция:** #{exercise_data['levels']&.dig('level3_functional_value')&.truncate(80) || '...'}
    4. **❤️ Личное:** #{exercise_data['levels']&.dig('level4_personal_value')&.truncate(80) || '...'}
    5. **🤝 Отношения:** #{exercise_data['levels']&.dig('level5_relational_value')&.truncate(80) || '...'}
    6. **🌟 Смысл:** #{exercise_data['levels']&.dig('level6_existential_value')&.truncate(80) || '...'}

    🔍 **Обнаруженные разрывы:**
    #{exercise_data['gaps_description'] || 'Не указано'}

    🌉 **Созданные мосты:**
    #{exercise_data['bridges_description'] || 'Не указано'}

    🎭 **Ваш осознанный ритуал:**
    #{exercise_data['ritual'] || 'Не указано'} — #{exercise_data['ritual_description'] || 'Не указано'}

    **Как применять этот инструмент:**

    1. 🕰️ **Перед действием:** Вспомните всю цепочку
    2. 🧘 **Во время действия:** Выполняйте как ритуал
    3. 🙏 **После действия:** Поблагодарите себя за связь с ценностями
    4. 🔄 **При выгорании:** Вернитесь к этой карте смыслов

    **Быстрая практика (1 минута):**
    1. **Перед:** "Я делаю [действие], чтобы [самая глубокая ценность]"
    2. **Во время:** Осознанное присутствие
    3. **После:** "Я проявил(а) [личная ценность]"

    **Психологическая мудрость:**
    > *"Ценности — это компас, который показывает направление, даже когда карта не помогает."*
    > — Стивен Хейес (основатель ACT)

    Теперь у вас есть ключ к осмысленной жизни через обычные действия!
  MARKDOWN
  
  send_message(text: message, parse_mode: 'Markdown')
end
      
      def create_conscious_ritual
        store_day_data('current_step', 'create_ritual')
        
        send_message(
          text: "🎭 *Шаг 4: Превращение действия в осознанный ритуал*",
          parse_mode: 'Markdown'
        )
        
        send_message(
          text: "**Осознанный ритуал — это действие, наполненное смыслом и присутствием.**\n\n**Элементы ритуала:**\n• 🧠 **Намерение:** Перед действием вспомнить его связь с ценностью\n• 🎯 **Присутствие:** Делать осознанно, не на автопилоте\n• 🙏 **Благодарность:** После действия отметить его значение\n• 💎 **Символ:** Добавить маленький напоминатель о ценности\n\n**Выберите элементы для вашего ритуала:**",
          parse_mode: 'Markdown',
          reply_markup: day_26_ritual_elements_markup
        )
      end
      
      def handle_ritual_selection(ritual_index)
        index = ritual_index.to_i
        
        if index < 0 || index >= RITUAL_ELEMENTS.length
          log_warn("Invalid ritual index: #{index}")
          send_message(text: "⚠️ Неизвестный элемент ритуала.")
          return
        end
        
        ritual_element = RITUAL_ELEMENTS[index]
        
        if ritual_element
          exercise_data = get_exercise_data
          exercise_data['ritual'] = ritual_element[:name]
          exercise_data['ritual_description'] = ritual_element[:description]
          store_day_data('exercise_data', exercise_data)
          
          send_message(
            text: "✅ Выбран элемент ритуала: #{ritual_element[:emoji]} *#{ritual_element[:name]}*",
            parse_mode: 'Markdown'
          )
          
          send_message(
            text: "#{ritual_element[:emoji]} **Как использовать:** #{ritual_element[:description]}\n**Время:** #{ritual_element[:duration]}\n**Польза:** #{ritual_element[:benefits]}",
            parse_mode: 'Markdown'
          )
          
          send_message(
            text: "🎭 *Теперь создайте полное описание вашего осознанного ритуала, включая все выбранные элементы:*",
            parse_mode: 'Markdown'
          )
          
          store_day_data('awaiting_ritual_description', true)
        else
          log_warn("Ritual element not found for index: #{index}")
          send_message(text: "⚠️ Неизвестный элемент ритуала.")
        end
      end
      
      def show_chain_progress(current_level)
        progress_message = "📊 *Прогресс раскрутки ценностей:* "
        
        VALUE_LEVELS.each_with_index do |level, index|
          if index < current_level
            progress_message += "✅"
          elsif index == current_level
            progress_message += "⏳"
          else
            progress_message += "⚪️"
          end
          progress_message += " "
        end
        
        progress_message += "\n\n"
        progress_message += "🔗 **Пройдено уровней:** #{current_level + 1}/6\n"
        progress_message += "✨ **Осталось:** #{6 - current_level - 1}\n"
        
        if current_level > 0
          previous_level = VALUE_LEVELS[current_level - 1]
          progress_message += "⬆️ *Только что:* #{previous_level[:emoji]} #{previous_level[:title]}"
        end
        
        send_message(text: progress_message, parse_mode: 'Markdown')
      end
      
      def show_complete_chain
        exercise_data = get_exercise_data
        levels = exercise_data['levels'] || {}
        
        return if levels.empty?
        
        message = "🔗 *Ваша раскрученная цепочка ценностей:*\n\n"
        
        VALUE_LEVELS.each do |level|
          if levels[level[:name]]
            message += "**#{level[:emoji]} #{level[:title]}:**\n#{levels[level[:name]].truncate(150)}\n\n"
          end
        end
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def handle_reflection_input(input_text)
        if input_text.present?
          exercise_data = get_exercise_data
          exercise_data['reflection'] = input_text
          store_day_data('exercise_data', exercise_data)
          
          send_message(text: "✅ Рефлексия сохранена!")
          
          # Показываем рефлексию из DAY_STEPS
          show_post_practice_reflection
        else
          send_message(text: "⚠️ Пожалуйста, поделитесь вашими инсайтами.")
        end
      end
      
      def show_post_practice_reflection
        store_day_data('current_step', 'post_practice_reflection')
        
        send_message(text: DAY_STEPS['post_practice_reflection'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['post_practice_reflection'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "💎 *Какие основные инсайты о ваших ценностях вы получили от этого путешествия?*",
          parse_mode: 'Markdown',
          reply_markup: day_26_reflection_markup
        )
      end
      
      def restart_exercise
        clear_exercise_data
        deliver_exercise
      end
      
      def practice_quick_version
        exercise_data = get_exercise_data
        
        message = <<~MARKDOWN
          🔗 *Быстрая практика "Цепочка ценностей" (2 минуты)*

          **Перед любым действием:**
          
          1. 🧠 **Спросите себя:** "Зачем я это делаю?"
          2. 🎯 **Вспомните цель:** "Какую конкретную цель достигаю?"
          3. ❤️ **Свяжите с ценностью:** "Какую мою ценность это выражает?"
          4. 🌟 **Найдите смысл:** "Какой глубинный смысл в этом действии?"

          **Формула быстрой практики:**
          "Я [действие], чтобы [цель], что позволяет мне проявить [ценность] и двигаться к [смысл]."

          *Практикуйте перед 3 разными действиями в день для закрепления навыка.*
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def show_intro_without_state
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        send_message(
          text: statistics_message,
          parse_mode: 'Markdown'
        )
        send_message(
          text: "Готовы превратить повседневность в путь к вашим глубинным ценностям?",
          reply_markup: day_26_content_markup
        )
      end
      
      def handle_resume_from_step(step)
        case step
        when 'intro'
          deliver_intro
        when 'exercise_explanation'
          deliver_exercise
        when 'values_chain'
          current_level_index = get_day_data('current_level_index').to_i
          if current_level_index > 0
            start_level(current_level_index)
          else
            start_values_chain_journey
          end
        when 'identify_gaps'
          identify_gaps_in_chain
        when 'create_bridges'
          create_bridges_in_chain
        when 'create_ritual'
          create_conscious_ritual
        when 'post_practice_reflection'
          show_post_practice_reflection
        else
          deliver_intro
        end
      end
      
      # ===== МЕТОДЫ РАЗМЕТКИ =====
      
      def day_26_content_markup
        {
          inline_keyboard: [
            [
              { text: "🔗 Начать анализ ценностей", callback_data: 'start_day_26_content' }
            ],
            [
              { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
            ]
          ]
        }.to_json
      end
      
      def day_26_action_categories_markup
        keyboard = []
        
        # Первые 3 категории
        keyboard << [
          { text: "#{ACTION_CATEGORIES[0][:emoji]} #{ACTION_CATEGORIES[0][:name]}", callback_data: "day_26_action_0" },
          { text: "#{ACTION_CATEGORIES[1][:emoji]} #{ACTION_CATEGORIES[1][:name]}", callback_data: "day_26_action_1" },
          { text: "#{ACTION_CATEGORIES[2][:emoji]} #{ACTION_CATEGORIES[2][:name]}", callback_data: "day_26_action_2" }
        ]
        
        # Следующие 3 категории
        keyboard << [
          { text: "#{ACTION_CATEGORIES[3][:emoji]} #{ACTION_CATEGORIES[3][:name]}", callback_data: "day_26_action_3" },
          { text: "#{ACTION_CATEGORIES[4][:emoji]} #{ACTION_CATEGORIES[4][:name]}", callback_data: "day_26_action_4" },
          { text: "#{ACTION_CATEGORIES[5][:emoji]} #{ACTION_CATEGORIES[5][:name]}", callback_data: "day_26_action_5" }
        ]
        
        keyboard << [
          { text: "✍️ Своё действие", callback_data: 'day_26_action_custom' }
        ]
        
        keyboard << [
          { text: "❓ Помогите выбрать", callback_data: 'day_26_help_choose_action' }
        ]
        
        { inline_keyboard: keyboard }.to_json
      end
      
      def day_26_action_details_markup
        {
          inline_keyboard: [
            [
              { text: "✍️ Уточнить действие", callback_data: 'day_26_action_custom' },
              { text: "✅ Начать анализ", callback_data: 'day_26_start_values_chain' }
            ]
          ]
        }.to_json
      end
      
      def day_26_reflection_markup
        {
          inline_keyboard: [
            [
              { text: "💎 Написать инсайты", callback_data: 'day_26_write_reflection' },
              { text: "⏭️ Пропустить", callback_data: 'day_26_skip_reflection' }
            ]
          ]
        }.to_json
      end
      
      def day_26_ritual_elements_markup
        keyboard = []
        
        RITUAL_ELEMENTS.each_with_index do |element, index|
          keyboard << [
            { 
              text: "#{element[:emoji]} #{element[:name]}", 
              callback_data: "day_26_ritual_#{index}" 
            }
          ]
        end
        
        keyboard << [
          { text: "✨ Свой ритуал", callback_data: 'day_26_ritual_custom' }
        ]
        
        { inline_keyboard: keyboard }.to_json
      end
      
      def day_26_completion_markup
        {
          inline_keyboard: [
            [
              { text: "✅ Завершить День 26", callback_data: 'day_26_complete_exercise' },
              { text: "🔗 Быстрая практика", callback_data: 'day_26_practice_quick' }
            ]
          ]
        }.to_json
      end
      
      def statistics_message
        <<~MARKDOWN
          📊 *Почему 'Цепочка ценностей' так эффективна:*
          
          • 💪 **65%** — увеличение мотивации после осознания связи с ценностями
          • 😌 **40-60%** — снижение выгорания при регулярной практике
          • 🧠 **45%** — активация префронтальной коры (осознанное принятие решений)
          • 🎯 **50%** — повышение удовлетворённости повседневными задачами
          • 🔄 **30 лет** — техника проверена в ACT-терапии (Acceptance and Commitment Therapy)
          • 🌱 **87%** — пользователей отмечают повышение осмысленности жизни
          • 💡 **Нейропластичность** — регулярная практика создаёт устойчивые нейронные пути между действиями и системами вознаграждения
          
          *Источник: Journal of Contextual Behavioral Science, исследования ACT-терапии, нейробиология мотивации*
        MARKDOWN
      end
      
      def save_value_chain_stats
        begin
          exercise_data = get_exercise_data
          
          store_day_data('value_chain_stats', {
            date: Date.current.to_s,
            action_category: exercise_data['action_category']&.dig(:name),
            action_description: exercise_data['action_description'],
            levels_completed: VALUE_LEVELS.size,
            gaps_found: exercise_data['gaps_found'],
            bridges_created: exercise_data['bridges_created'],
            ritual_created: exercise_data['ritual'].present?,
            reflection: exercise_data['reflection'],
            completed: true
          })
        rescue => e
          log_error("Failed to save value chain stats", e)
        end
      end
      
      def get_exercise_data
        get_day_data('exercise_data') || {}
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
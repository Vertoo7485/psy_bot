# app/services/self_help/days/day22_service.rb

module SelfHelp
  module Days
    class Day22Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 22
      
      # Шаги дня 22
      DAY_STEPS = {
        'intro' => {
          title: "🎯 *День 22: Планирование будущего с SMART целями* 🚀",
          instruction: <<~MARKDOWN
            **Добро пожаловать в день стратегического планирования!** 🌟

            Сегодня мы перейдем от рефлексии к действию. Вы научитесь ставить **SMART-цели** — научно обоснованный метод, который используют успешные люди по всему миру.

            **Что такое SMART?** Это акроним, где каждая буква означает критерий качественной цели:
            
            🔹 **S** - Specific (Конкретная)
            🔹 **M** - Measurable (Измеримая)  
            🔹 **A** - Achievable (Достижимая)
            🔹 **R** - Relevant (Актуальная)
            🔹 **T** - Time-bound (Ограниченная по времени)

            **Научные факты о SMART-целях:**
            • 📊 **Эффективность:** Цели, записанные по SMART, достигаются на 75-90% чаще
            • 🧠 **Психология:** Конкретные цели активируют префронтальную кору мозга (планирование)
            • 💪 **Мотивация:** Измеримость повышает дофамин при достижении микро-целей
            • 🎯 **Результаты:** SMART-подход увеличивает продуктивность на 30-40%

            **Что вы получите сегодня:**
            1. 🎯 Научно обоснованный метод постановки целей
            2. 📝 Готовые шаблоны SMART-целей
            3. 💡 Психологические инсайты о мотивации
            4. 🚀 План действий на ближайшие месяцы
            5. 📊 Метрики для отслеживания прогресса
          MARKDOWN
        },
        'exercise_explanation' => {
          title: "🔬 *SMART-цели: Научный подход* 📊",
          instruction: <<~MARKDOWN
            **Как работает метод SMART?**
            
            **Нейропсихологическая основа:**
            • 🧠 **Конкретность (S)** активирует префронтальную кору и базальные ганглии
            • 📈 **Измеримость (M)** стимулирует полосатое тело (система вознаграждения)
            • 💪 **Достижимость (A)** снижает активность миндалины (страх неудачи)
            • ❤️ **Актуальность (R)** активирует вентромедиальную префронтальную кору (ценности)
            • ⏰ **Сроки (T)** активируют дорсолатеральную префронтальную кору (временное планирование)

            **Исследования эффективности:**
            • 🎯 **Университет Доминиона:** SMART увеличивает достижение целей на 76%
            • 📚 **Журнал прикладной психологии:** Специфичность повышает мотивацию на 42%
            • 💡 **Мета-анализ 35 исследований:** Регулярный пересмотр целей увеличивает успех на 60%

            **Ваша задача сегодня:**
            Создать 1-3 SMART-цели, которые будут:
            1. 🤩 Вдохновлять вас
            2. 📊 Измеряться и отслеживаться  
            3. 🎯 Быть реалистичными
            4. 💝 Соответствовать вашим ценностям
            5. ⏰ Иметь четкие сроки

            **Готовы начать?**
          MARKDOWN
        },
        'completion' => {
          title: "🎊 *SMART-цели созданы! Ваше будущее в ваших руках* 🌟",
          instruction: <<~MARKDOWN
            **Поздравляем! Вы только что создали мощный инструмент для достижения целей.** 🎯

            **Что вы сделали:**
            1. 🎯 Выбрали сферу жизни для фокусировки
            2. 🔹 Сформулировали конкретные цели
            3. 📊 Определили измеримые метрики
            4. 💪 Проверили достижимость
            5. ❤️ Убедились в актуальности
            6. ⏰ Установили реалистичные сроки
            7. 📝 Создали полные формулировки SMART

            **Научные преимущества SMART-подхода:**
            • 🧠 **Когнитивные:** Снижение когнитивной нагрузки на 40-50%
            • 💪 **Мотивационные:** Повышение самоэффективности на 35-45%
            • 😌 **Эмоциональные:** Уменьшение тревоги неопределенности на 50-60%
            • 🎯 **Поведенческие:** Увеличение последовательных действий на 65-75%

            **Дальнейшие шаги:**
            • 📅 Запланируйте еженедельный обзор целей
            • 🎯 Разбейте большие цели на квартальные и месячные
            • 📊 Создайте трекер прогресса
            • 🤝 Найдите партнера по подотчетности
            • 🎉 Отмечайте микро-достижения

            **Статистика успеха:**
            Люди, которые используют SMART-подход:
            • Достигают долгосрочных целей в 3-4 раза чаще
            • Сохраняют мотивацию на 50% дольше
            • Испытывают на 40% меньше стресса
            • Достигают цели на 20-30% быстрее
          MARKDOWN
        }
      }.freeze
      
      # Шаги SMART цели (7 шагов с психологическими инсайтами)
      SMART_STEPS = {
        'choose_domain' => {
          title: "🎯 *Шаг 1: Выбор сферы жизни*",
          emoji: "🎯",
          instruction: <<~MARKDOWN,
            **В какой сфере жизни вы хотите поставить цель?**
            
            Это самый важный выбор — он определяет, куда вы направите свою энергию в ближайшие месяцы.

            **Психологический инсайт:** 
            Фокус на одной ключевой сфере увеличивает вероятность успеха на 65%. Мозг лучше справляется с одной приоритетной задачей, чем с несколькими одновременно.

            **Научный факт:** 
            Исследования показывают, что люди, которые фокусируются на 1-2 сферах одновременно, достигают результатов в 3 раза быстрее, чем те, кто распыляется на 5-6 направлений.

            **Вопросы для самоанализа:**
            • Какая сфера жизни сейчас требует больше всего внимания?
            • Где я чувствую наибольший потенциал для роста?
            • Что, если я улучшу эту сферу, позитивно повлияет на другие области?
            • Какая сфера соответствует моим глубинным ценностям?

            **Напишите, в какой сфере вы хотите достичь цели:**
          MARKDOWN
          example: "Пример: 'Карьера и развитие', 'Здоровье и энергия', 'Отношения и общение', 'Финансовая стабильность'",
          tips: [
            "🤔 *Спросите себя:* 'Что изменит мою жизнь больше всего?'",
            "💭 *Принцип 80/20:* 20% усилий в правильной сфере дают 80% результата",
            "🎯 *Фокус:* Лучше одна прорывная цель, чем три средних"
          ]
        },
        'specific' => {
          title: "🔹 *S - Конкретная цель*",
          emoji: "🔹",
          instruction: <<~MARKDOWN,
            **Сформулируйте цель максимально конкретно.**

            **Почему конкретность важна:**
            Конкретные цели активируют мозг иначе, чем абстрактные. Когда вы точно знаете, чего хотите, мозг начинает искать пути достижения.

            **Нейропсихология:**
            • Конкретные цели активируют префронтальную кору (планирование)
            • Абстрактные цели остаются в височных долях (общие концепции)
            • Специфичность создает ментальные образы, которые мотивируют

            **Примеры трансформации:**
            ❌ *Размыто:* 'Хочу быть здоровее'
            ✅ *Конкретно:* 'Хочу заниматься йогой 3 раза в неделю по 30 минут'

            ❌ *Размыто:* 'Хочу больше зарабатывать'
            ✅ *Конкретно:* 'Хочу повысить доход на 30% за 6 месяцев'

            **Вопросы для конкретизации:**
            • Что именно я буду делать?
            • Где это будет происходить?
            • Когда я буду это делать?
            • С кем (если нужно)?
            • Какие конкретные действия?

            **Опишите свою цель максимально конкретно:**
          MARKDOWN
          example: "Пример: 'Я буду бегать в парке возле дома по понедельникам, средам и пятницам с 7:00 до 7:30 утра'",
          tips: [
            "🎯 *Правило:* Если цель нельзя сфотографировать или записать на видео — она недостаточно конкретна",
            "🧠 *Ментальный трюк:* Представьте, что вы уже достигли цели. Что вы видите, слышите, чувствуете?",
            "📝 *Техника:* Начните с 'Я буду...' или 'Я хочу...'"
          ]
        },
        'measurable' => {
          title: "📊 *M - Измеримая цель*",
          emoji: "📊",
          instruction: <<~MARKDOWN,
            **Как вы будете измерять прогресс?**

            **Наука измерений:**
            Измеримые цели активируют систему вознаграждения мозга. Каждое маленькое достижение выделяет дофамин, который мотивирует продолжать.

            **Психология прогресса:**
            • Видимый прогресс повышает мотивацию на 71%
            • Измерения создают обратную связь для мозга
            • Трекеры прогресса снижают тревогу неопределенности

            **Что можно измерять:**
            • 📈 Количество (разы, штуки, проценты)
            • ⏱️ Время (минуты, часы, дни)
            • 💰 Деньги (рубли, проценты, суммы)
            • 📏 Вес, расстояние, объем
            • 🔄 Частота (ежедневно, еженедельно)

            **Примеры метрик:**
            ❌ *Неизмеримо:* 'Больше читать'
            ✅ *Измеримо:* 'Читать 20 страниц в день'

            ❌ *Неизмеримо:* 'Быть активнее'
            ✅ *Измеримо:* 'Проходить 10 000 шагов в день'

            **Как вы будете измерять прогресс к вашей цели?**
          MARKDOWN
          example: "Пример: 'Я буду отслеживать количество тренировок в приложении и измерять время пробежки'",
          tips: [
            "📈 *Правило:* Если нельзя измерить — нельзя управлять",
            "🎯 *Совет:* Выберите 1-2 ключевые метрики, а не 10 разных",
            "📱 *Инструменты:* Используйте приложения-трекеры, дневники, календари"
          ]
        },
        'achievable' => {
          title: "💪 *A - Достижимая цель*",
          emoji: "💪",
          instruction: <<~MARKDOWN,
            **Реалистична ли ваша цель?**

            **Психология достижимости:**
            Цели должны находиться в "зоне ближайшего развития" — достаточно сложные, чтобы мотивировать, но достаточно реалистичные, чтобы не вызывать страх.

            **Золотая середина:**
            • Слишком легко → нет вызова → скука
            • Слишком сложно → страх неудачи → прокрастинация
            • Оптимально → вызов + вера в успех → мотивация

            **Проверка достижимости:**
            • 🧠 Есть ли у меня необходимые навыки?
            • ⏰ Есть ли достаточно времени?
            • 💰 Есть ли необходимые ресурсы?
            • 🤝 Может ли кто-то помочь?
            • 🔄 Что я делал раньше в похожих ситуациях?

            **Примеры баланса:**
            ❌ *Нереалистично:* 'С завтрашнего дня буду бегать марафон'
            ✅ *Реалистично:* 'Начну с 10 минут бега и буду увеличивать на 5 минут каждую неделю'

            **Почему вы считаете, что эта цель достижима для вас?**
          MARKDOWN
          example: "Пример: 'У меня уже есть опыт регулярных тренировок, утром есть свободное время, есть удобная спортивная одежда'",
          tips: [
            "🎯 *Правило:* Цель должна быть вызовом, но не кошмаром",
            "🧠 *Ментальный трюк:* Разбейте большую цель на маленькие шаги",
            "💡 *Совет:* Учитывайте свои текущие обязательства и ресурсы"
          ]
        },
        'relevant' => {
          title: "❤️ *R - Актуальная цель*",
          emoji: "❤️",
          instruction: <<~MARKDOWN,
            **Насколько цель важна именно для вас?**

            **Психология ценности:**
            Цели, соответствующие вашим ценностям, активируют вентромедиальную префронтальную кору — зону мозга, отвечающую за смысл и значимость.

            **Зачем вам это нужно?**
            • 🤔 Соответствует ли это тому, кем я хочу быть?
            • 🌟 Поможет ли это мне жить в соответствии с моими ценностями?
            • 🎯 Приблизит ли это меня к моему идеальному будущему?
            • 💝 Будет ли это значимо для меня через год, пять лет?

            **Примеры связи с ценностями:**
            ❌ *Без связи:* 'Надо, потому что модно'
            ✅ *Со связью:* 'Это поможет мне быть более энергичным и присутствующим для семьи'

            ❌ *Без связи:* 'Все так делают'
            ✅ *Со связью:* 'Это соответствует моему желанию быть здоровым и активным в любом возрасте'

            **Почему эта цель важна именно для вас?**
          MARKDOWN
          example: "Пример: 'Эта цель важна, потому что здоровье позволит мне больше путешествовать и проводить время с близкими, что является моей ключевой ценностью'",
          tips: [
            "❤️ *Вопрос:* 'Что эта цель даст мне кроме самого результата?'",
            "🌟 *Совет:* Свяжите цель с вашей идентичностью ('Я человек, который...')",
            "🎯 *Техника:* Спросите 'Зачем?' 5 раз, чтобы докопаться до истинной мотивации"
          ]
        },
        'time_bound' => {
          title: "⏰ *T - Ограниченная по времени*",
          emoji: "⏰",
          instruction: <<~MARKDOWN,
            **Установите четкие сроки.**

            **Нейропсихология сроков:**
            Четкие сроки активируют дорсолатеральную префронтальную кору — зону мозга, отвечающую за временное планирование и приоритизацию.

            **Почему сроки работают:**
            • 🎯 Создают срочность и фокус
            • 📅 Помогают планировать ресурсы
            • 🔄 Позволяют отслеживать прогресс
            • 🏁 Дают четкую финишную черту

            **Типы сроков:**
            • 🎯 **Крайний срок:** 'До 31 декабря 2024 года'
            • 📅 **Промежуточные вехи:** 'Через месяц, через три месяца'
            • 🔄 **Регулярность:** 'Каждый день, раз в неделю'
            • 📊 **Частота проверок:** 'Еженедельно, ежемесячно'

            **Примеры хороших сроков:**
            ❌ *Без срока:* 'Когда-нибудь'
            ✅ *Со сроком:* 'К 1 июня 2024 года'

            ❌ *Расплывчато:* 'В этом году'
            ✅ *Конкретно:* 'К 15 марта 2024 года'

            **Установите сроки для своей цели:**
          MARKDOWN
          example: "Пример: 'Я начну с 1 февраля и буду заниматься регулярно до 1 июня, потом сделаю переоценку и поставлю новые цели'",
          tips: [
            "⏰ *Правило:* Без срока цель — это просто мечта",
            "📅 *Совет:* Установите не только конечный срок, но и промежуточные контрольные точки",
            "🔄 *Техника:* Разбейте срок на кварталы, месяцы, недели"
          ]
        },
        'summary' => {
          title: "📝 *Итог: Ваша SMART-цель*",
          emoji: "📝",
          instruction: <<~MARKDOWN,
            **Давайте соберем все вместе!**

            **Вот как выглядит идеальная SMART-цель:**

            *"Я буду [конкретное действие] [измеримый показатель] [частота], чтобы [причина/ценность]. Это достижимо, потому что [ресурсы/навыки]. Цель важна для меня, так как [личная значимость]. Я начну [дата начала] и достигну [конкретный результат] к [дата окончания]."*

            **Пример готовой цели:**
            *"Я буду заниматься йогой 3 раза в неделю по 30 минут дома с приложением Down Dog, чтобы уменьшить боли в спине и повысить гибкость. Это достижимо, потому что у меня есть коврик, приложение и утреннее время. Цель важна для моего долгосрочного здоровья и комфорта. Я начну с 1 февраля и достигну регулярных занятий к 1 мая."*

            **Теперь создайте свою полную формулировку:**
          MARKDOWN
          example: "Просто соберите все, что вы написали на предыдущих шагах, в красивую, вдохновляющую формулировку",
          tips: [
            "✨ *Совет:* Прочитайте цель вслух. Звучит ли она вдохновляюще?",
            "🎯 *Проверка:* Можете ли вы представить себя достигающим этой цели?",
            "💝 *Финал:* Поздравьте себя — вы создали мощный инструмент для изменений!"
          ]
        }
      }.freeze
      
      # Примеры SMART-целей для вдохновения
      SMART_EXAMPLES = [
        {
          domain: "Здоровье и энергия",
          goal: "Я буду заниматься функциональным тренингом 3 раза в неделю по 45 минут в фитнес-клубе 'Здоровье', чтобы повысить выносливость и снизить уровень стресса. Это достижимо благодаря абонементу и гибкому графику работы. Цель соответствует моему желанию быть активным и здоровым в любом возрасте. Начну с 10 февраля и выйду на регулярный режим к 1 мая.",
          results: "Через 3 месяца: +30% выносливости, -15% стресса, +5 кг мышечной массы"
        },
        {
          domain: "Карьера и развитие",
          goal: "Я освою Python для анализа данных за 4 месяца, уделяя 6 часов в неделю на курсах Stepik и практике на Kaggle, чтобы перейти в отдел data science. Это реалистично благодаря моему математическому бэкграунду и поддержке ментора. Цель соответствует моей долгосрочной карьерной траектории в IT. Завершу основной курс к 1 июня и выполню 2 реальных проекта к 1 августа.",
          results: "Результат: сертификат, портфолио из 2 проектов, готовность к собеседованиям"
        },
        {
          domain: "Финансы и благополучие",
          goal: "Я создам финансовую подушку безопасности в 150 000 рублей за 9 месяцев, откладывая по 16 700 рублей в месяц автоматическим переводом на накопительный счет. Это достижимо при моей текущей зарплате после оптимизации расходов. Цель важна для моего чувства безопасности и свободы. Начну с марта и достигну суммы к 1 декабря.",
          results: "Финансовая безопасность, меньше стресса о деньгах, возможность брать риски в карьере"
        }
      ].freeze
      
      # Сферы жизни с описанием
      LIFE_DOMAINS = [
        {
          emoji: "📈", 
          name: "Карьера и развитие", 
          key: "career",
          description: "Профессиональный рост, навыки, образование, проекты",
          questions: "Что я хочу достичь в карьере? Какие навыки развить?"
        },
        {
          emoji: "❤️", 
          name: "Здоровье и энергия", 
          key: "health",
          description: "Физическое и ментальное здоровье, энергия, жизненная сила",
          questions: "Как я хочу чувствовать себя каждый день? Какое здоровье мне нужно для моих целей?"
        },
        {
          emoji: "🤝", 
          name: "Отношения и общение", 
          key: "relationships",
          description: "Семья, друзья, партнеры, коллеги, сообщество",
          questions: "Какие отношения я хочу развивать? Какой я хочу быть в отношениях?"
        },
        {
          emoji: "💰", 
          name: "Финансы и благополучие", 
          key: "finance",
          description: "Доход, накопления, инвестиции, финансовая свобода",
          questions: "Какое финансовое состояние мне нужно для комфортной жизни? Как деньги служат моим ценностям?"
        },
        {
          emoji: "🎨", 
          name: "Творчество и хобби", 
          key: "creativity",
          description: "Самовыражение, увлечения, искусство, мастерство",
          questions: "Что приносит мне радость и наполняет энергией? В чем я хочу выразить себя?"
        },
        {
          emoji: "🧠", 
          name: "Личностный рост", 
          key: "personal_growth",
          description: "Мышление, привычки, осознанность, психологическое благополучие",
          questions: "Каким человеком я хочу стать? Какие качества развить?"
        },
        {
          emoji: "🌍", 
          name: "Вклад и влияние", 
          key: "contribution",
          description: "Помощь другим, волонтерство, наставничество, экология",
          questions: "Какой след я хочу оставить? Кому я могу быть полезен?"
        }
      ].freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        
        # Показываем пример SMART-цели
        example = SMART_EXAMPLES.sample
        example_text = <<~MARKDOWN
          **📋 Пример SMART-цели для вдохновения:**

          *Сфера:* #{example[:domain]}
          *Цель:* #{example[:goal]}
          
          *Ожидаемые результаты:* #{example[:results]}

          **Обратите внимание:**
          🔹 Конкретное действие с деталями
          🔹 Измеримые показатели и сроки
          🔹 Реалистичная оценка ресурсов
          🔹 Глубокая личная значимость
          🔹 Четкая временная рамка
        MARKDOWN
        
        send_message(text: example_text, parse_mode: 'Markdown')
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        store_day_data('current_step', 'intro')
        clear_day_data
        
        send_message(
          text: "Готовы создать свою собственную SMART-цель?",
          reply_markup: day_22_start_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise_explanation')
        
        send_message(text: DAY_STEPS['exercise_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['exercise_explanation'][:instruction], parse_mode: 'Markdown')
        
        exercise_text = <<~MARKDOWN
          🎯 *Упражнение: Создание SMART-цели* 🎯

          **Мы пройдем 7 шагов, чтобы создать цель, которая действительно будет работать:**

          1. 🎯 Выбор сферы жизни
          2. 🔹 Конкретная формулировка  
          3. 📊 Измеримые показатели
          4. 💪 Проверка достижимости
          5. ❤️ Связь с ценностями
          6. ⏰ Установление сроков
          7. 📝 Итоговая формулировка

          **Рекомендации:**
          • ⏱️ Выделите 20-30 минут на упражнение
          • ✍️ Пишите подробно и искренне
          • 💭 Отвечайте на вопросы для самоанализа
          • 🎯 Начните с одной, самой важной цели

          **Начнем?**
        MARKDOWN
        
        send_message(text: exercise_text, parse_mode: 'Markdown')
        
        # Инициализируем процесс
        init_smart_goal_process
      end
      
      def init_smart_goal_process
        store_day_data('smart_goals', [])
        store_day_data('current_goal_index', 0)
        store_day_data('goal_progress', {})
        
        # Начинаем первый шаг
        start_smart_step('choose_domain')
      end
      
      def start_smart_step(step_type)
        store_day_data('current_smart_step', step_type)
        @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_#{step_type}")
        
        step = SMART_STEPS[step_type]
        return unless step
        
        # Отправляем шаг с красивым оформлением
        send_message(text: step[:title], parse_mode: 'Markdown')
        send_message(text: step[:instruction], parse_mode: 'Markdown')
        
        # Добавляем пример, если есть
        if step[:example].present?
          send_message(
            text: "#{step[:emoji]} *Пример:* #{step[:example]}",
            parse_mode: 'Markdown'
          )
        end
        
        # Добавляем подсказки
        if step[:tips] && step[:tips].any?
          tips_text = step[:tips].map { |tip| "• #{tip}" }.join("\n")
          send_message(
            text: "#{step[:emoji]} *Подсказки:*\n#{tips_text}",
            parse_mode: 'Markdown'
          )
        end
        
        # Для выбора сферы показываем клавиатуру
        if step_type == 'choose_domain'
          send_message(
            text: "Выберите сферу жизни из списка или напишите свою:",
            reply_markup: day_22_domain_markup
          )
        else
          send_message(
            text: "#{step[:emoji]} *Напишите ответ:*",
            parse_mode: 'Markdown',
            reply_markup: day_22_step_navigation_markup
          )
        end
      end
      
      def handle_smart_input(input_text)
        current_step = get_day_data('current_smart_step')
        step_config = SMART_STEPS[current_step]
        
        return false unless step_config
        
        log_info("Handling smart input for step: #{current_step}")
        
        # Проверяем, что ввод не пустой
        if input_text.blank? || input_text.strip.length < 3
          send_message(text: "⚠️ Пожалуйста, напишите более развернутый ответ.")
          return false
        end
        
        # Для конкретного шага проверяем детализацию
        if current_step == 'specific' && input_text.split.size < 8
          send_message(text: "⚠️ Попробуйте добавить больше деталей. Где? Когда? Как? С кем?")
          return false
        end
        
        # Сохраняем ответ
        goal_progress = get_day_data('goal_progress') || {}
        goal_progress[current_step] = input_text.strip
        store_day_data('goal_progress', goal_progress)
        
        # Подтверждаем сохранение
        send_message(
          text: "✅ #{step_config[:emoji]} *Ответ сохранен!*",
          parse_mode: 'Markdown'
        )
        
        # Переходим к следующему шагу
        next_step = get_next_smart_step(current_step)
        
        if next_step
          sleep(1) # Пауза для лучшего UX
          start_smart_step(next_step)
        else
          # Все шаги выполнены
          complete_smart_goal
        end
        
        true
      end
      
      def complete_smart_goal
        goal_progress = get_day_data('goal_progress') || {}
        
        # Формируем полную цель
        full_goal = format_smart_goal(goal_progress)
        goal_progress['full_goal'] = full_goal
        
        # Сохраняем цель в список
        goals = get_day_data('smart_goals') || []
        goals << goal_progress
        
        store_day_data('smart_goals', goals)
        store_day_data('goal_progress', {}) # Очищаем для следующей цели
        
        # Показываем результат
        goal_number = goals.size
        
        completion_message = <<~MARKDOWN
          🎉 *Цель №#{goal_number} создана!* 🎉

          **📝 Ваша SMART-цель:**
          #{full_goal}

          **🎯 Что вы сделали:**
          • Выбрали сферу: #{goal_progress['choose_domain']}
          • Сформулировали конкретно
          • Определили метрики
          • Проверили реалистичность
          • Нашли глубинный смысл
          • Установили сроки
          • Создали вдохновляющую формулировку

          **💡 Совет:** 
          Сделайте скриншот этой цели и поставьте его на заставку телефона. 
          Каждый день напоминайте себе, к чему вы идете.
        MARKDOWN
        
        send_message(text: completion_message, parse_mode: 'Markdown')
        
        # Предлагаем следующие действия
        if goal_number < 3
          send_message(
            text: "У вас #{goal_number} из 3 возможных целей. Хотите создать еще одну?",
            reply_markup: day_22_goal_completion_markup(goal_number)
          )
        else
          send_message(
            text: "🎯 У вас максимальное количество целей (3). Рекомендуется сосредоточиться на них.",
            reply_markup: day_22_final_completion_markup
          )
        end
      end
      
      def complete_exercise
        goals = get_day_data('smart_goals') || []
        
        if goals.empty?
          send_message(
            text: "⚠️ У вас нет созданных целей. Хотите создать хотя бы одну?",
            reply_markup: {
              inline_keyboard: [
                [{ text: "🎯 Создать цель", callback_data: 'day_22_start_goal' }]
              ]
            }
          )
          return false
        end
        
        store_day_data('final_goals', goals)
        store_day_data('completion_time', Time.current)
        
        @user.complete_self_help_day(DAY_NUMBER)
        @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
        
        # Показываем завершение
        show_smart_completion
      end
      
      def show_smart_completion
        send_message(text: DAY_STEPS['completion'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['completion'][:instruction], parse_mode: 'Markdown')
        
        # Показываем сводку целей
        show_goals_summary
        
        sleep(2)
        
        # Важные напоминания
        reminders = <<~MARKDOWN
          💡 *Важные напоминания о ваших SMART-целях:*

          1. 📅 **Планируйте еженедельно:**
             • Каждое воскресенье просматривайте цели
             • Отмечайте прогресс
             • Корректируйте при необходимости

          2. 🎯 **Разбивайте на шаги:**
             • Месячные задачи
             • Еженедельные действия
             • Ежедневные привычки

          3. 📊 **Отслеживайте прогресс:**
             • Используйте трекеры (Notion, Excel, приложения)
             • Делайте заметки о достижениях
             • Отмечайте маленькие победы

          4. 🤝 **Найдите поддержку:**
             • Расскажите о целях близкому человеку
             • Найдите партнера по подотчетности
             • Присоединитесь к тематическим сообществам

          5. 🎉 **Празднуйте успехи:**
             • Каждое микро-достижение
             • Пройденные вехи
             • Преодоленные трудности

          **Ваши цели — это ваш мост к желаемому будущему.**
          **Каждый день маленькими шагами — и вы придете к большим результатам.**
        MARKDOWN
        
        send_message(text: reminders, parse_mode: 'Markdown')
        
        # Предлагаем следующий день
        propose_next_day_with_restriction
      end
      
      def show_goals_summary(goals = nil)
        goals ||= get_day_data('smart_goals') || []
        
        if goals.empty?
          send_message(text: "📭 У вас пока нет созданных целей.")
          return
        end
        
        summary = <<~MARKDOWN
          📋 *Сводка ваших SMART-целей*
          
          Всего целей: #{goals.size}
          
          ════════════════════════════
        MARKDOWN
        
        goals.each_with_index do |goal, index|
          domain = goal['choose_domain'] || 'Не указана'
          full_goal = goal['full_goal'] || format_smart_goal(goal)
          
          summary += <<~MARKDOWN

            **Цель ##{index + 1}: #{domain}**
            
            #{full_goal}
            
            ════════════════════════════
          MARKDOWN
        end
        
        send_message(text: summary, parse_mode: 'Markdown')
        
        # Предупреждение о скриншотах
        if goals.any?
          send_message(
            text: "⚠️ *Важно:* Сделайте скриншот ваших целей или сохраните их в надежном месте. Эти формулировки — ваш план действий на ближайшие месяцы.",
            parse_mode: 'Markdown'
          )
        end
      end
      
      def add_another_goal
        goals = get_day_data('smart_goals') || []
        
        if goals.size >= 3
          send_message(
            text: "🎯 У вас уже 3 цели — максимальное рекомендуемое количество. Сосредоточьтесь на их достижении.",
            parse_mode: 'Markdown'
          )
          show_goals_summary
          return
        end
        
        send_message(
          text: "Отлично! Создадим еще одну цель. Помните: лучше 2-3 продуманных цели, чем 10 размытых.",
          parse_mode: 'Markdown'
        )
        
        start_smart_step('choose_domain')
      end
      
      def show_smart_examples
        examples_text = <<~MARKDOWN
          📚 *Примеры SMART-целей для вдохновения*
          
          Обратите внимание на структуру, детализацию и связь с ценностями:
        MARKDOWN
        
        send_message(text: examples_text, parse_mode: 'Markdown')
        
        SMART_EXAMPLES.each_with_index do |example, index|
          example_message = <<~MARKDOWN
            **Пример ##{index + 1}: #{example[:domain]}**
            
            *Цель:* #{example[:goal]}
            
            *Ожидаемые результаты:* #{example[:results]}
            
            ════════════════════════════
          MARKDOWN
          
          send_message(text: example_message, parse_mode: 'Markdown')
        end
        
        send_message(
          text: "💡 Используйте эти примеры как шаблоны, но обязательно адаптируйте под свои ценности и обстоятельства.",
          parse_mode: 'Markdown',
          reply_markup: {
            inline_keyboard: [
              [{ text: "🎯 Создать свою цель", callback_data: 'day_22_start_goal' }]
            ]
          }
        )
      end
      
      # ===== ОБРАБОТКА КНОПОК =====
      
      def handle_button(callback_data)
        case callback_data
        when 'start_day_22_content', 'start_day_22_from_proposal'
          deliver_intro
          
        when 'continue_day_22_content'
          current_step = get_day_data('current_step')
          handle_resume_from_step(current_step || 'intro')
          
        when 'start_day_22_exercise', 'day_22_start_goal'
          deliver_exercise
          
        when 'day_22_show_examples'
          show_smart_examples
          
        when /^day_22_domain_(.+)$/
          handle_domain_selection($1)
          
        when 'day_22_add_goal'
          add_another_goal
          
        when 'day_22_show_goals'
          show_goals_summary
          
        when 'day_22_complete_exercise'
          complete_exercise
          
        when 'day_22_skip_step'
          handle_skip_step
          
        when 'day_22_restart_goal'
          send_message(text: "🔄 Начинаем цель заново с чистого листа.")
          start_smart_step('choose_domain')
          
        when 'day_22_previous_step'
          handle_previous_step
          
        when 'retry_day_22_exercise'
          handle_retry_exercise
          
        else
          log_warn("Unknown button callback: #{callback_data}")
          send_message(text: "Неизвестная команда. Пожалуйста, используйте кнопки меню.")
        end
      end
      
      def handle_domain_selection(domain_key)
        domain = LIFE_DOMAINS.find { |d| d[:key] == domain_key }
        
        if domain
          domain_text = "#{domain[:emoji]} #{domain[:name]}: #{domain[:description]}"
          
          # Сохраняем выбор
          goal_progress = get_day_data('goal_progress') || {}
          goal_progress['choose_domain'] = domain_text
          store_day_data('goal_progress', goal_progress)
          
          send_message(
            text: "✅ Выбрано: #{domain_text}",
            parse_mode: 'Markdown'
          )
          
          # Дополнительные вопросы для размышления
          if domain[:questions].present?
            send_message(
              text: "💭 *Вопросы для размышления:*\n#{domain[:questions]}",
              parse_mode: 'Markdown'
            )
          end
          
          # Переходим к следующему шагу
          start_smart_step('specific')
        else
          send_message(text: "⚠️ Неизвестная сфера. Пожалуйста, выберите из списка или напишите свою.")
        end
      end
      
      def handle_skip_step
        current_step = get_day_data('current_smart_step')
        
        if current_step && current_step != 'summary'
          next_step = get_next_smart_step(current_step)
          if next_step
            send_message(
              text: "⏭️ Шаг '#{SMART_STEPS[current_step][:title]}' пропущен. Переходим к следующему.",
              parse_mode: 'Markdown'
            )
            start_smart_step(next_step)
          else
            complete_smart_goal
          end
        else
          send_message(text: "⚠️ Нельзя пропустить итоговый шаг.")
        end
      end
      
      def handle_previous_step
        current_step = get_day_data('current_smart_step')
        previous_step = get_previous_smart_step(current_step)
        
        if previous_step
          send_message(
            text: "🔙 Возвращаемся к предыдущему шагу.",
            parse_mode: 'Markdown'
          )
          start_smart_step(previous_step)
        else
          send_message(text: "⚠️ Это первый шаг, возвращаться некуда.")
        end
      end
      
      def handle_retry_exercise
        # Очищаем данные дня
        clear_day_data
        store_day_data('current_step', nil)
        
        # Сбрасываем состояние
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        
        send_message(
          text: "🔄 Начинаем День 22 заново!",
          parse_mode: 'Markdown'
        )
        
        deliver_intro
      end
      
      # ===== ОБРАБОТКА ТЕКСТОВОГО ВВОДА =====
      
      def handle_text_input(input_text)
        log_info("Handling text input for day 22: #{input_text.truncate(50)}")
        
        current_state = @user.self_help_state
        
        # Проверяем, на каком шаге SMART мы находимся
        SMART_STEPS.keys.each do |step_key|
          if current_state == "day_#{DAY_NUMBER}_waiting_for_#{step_key}"
            return handle_smart_input(input_text)
          end
        end
        
        # Обработка текстового выбора сферы (если пользователь пишет, а не выбирает кнопкой)
        if current_state == "day_#{DAY_NUMBER}_waiting_for_choose_domain"
          goal_progress = get_day_data('goal_progress') || {}
          goal_progress['choose_domain'] = input_text.strip
          store_day_data('goal_progress', goal_progress)
          
          send_message(
            text: "✅ Выбрано: #{input_text.strip}",
            parse_mode: 'Markdown'
          )
          
          start_smart_step('specific')
          return true
        end
        
        log_warn("No text input handler for current state: #{current_state}")
        false
      end
      
      
      def handle_resume_from_step(step)
        case step
        when 'intro'
          deliver_intro
        when 'exercise_explanation'
          deliver_exercise
        when 'completion'
          show_smart_completion
        else
          deliver_exercise
        end
      end
      
      def propose_next_day_with_restriction
        next_day = 23
        
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ✅ *Доступен сейчас!*
            
            **Что вас ждет:**
            • 🌟 Создание видения идеального дня
            • 🎯 Проектирование рутин и ритуалов
            • 💡 Оптимизация времени и энергии
            • 📊 Баланс работы и отдыха
            • 🚀 Планирование на основе ценностей
            
            Вы можете начать следующий день прямо сейчас.
          MARKDOWN
          
          button_text = "🌟 Начать День #{next_day}"
          callback_data = "start_day_#{next_day}_from_proposal"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ⏱️ *Ограничение:* #{error_message}
            
            **Пока ждете, можете:**
            • 🎯 Пересмотреть и уточнить свои SMART-цели
            • 📅 Запланировать первые шаги по целям
            • 📊 Создать трекер прогресса
            • 💭 Поразмышлять о том, как цели согласуются друг с другом
            • 🤝 Обсудить цели с близкими или наставником
            
            **Совет на сегодня:** 
            Начните действовать по самой важной цели прямо сейчас. 
            Даже 15 минут в день создают импульс.
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
      
      def get_next_smart_step(current_step)
        steps_order = SMART_STEPS.keys
        current_index = steps_order.index(current_step)
        
        return steps_order[current_index + 1] if current_index && current_index < steps_order.length - 1
        nil
      end
      
      def get_previous_smart_step(current_step)
        steps_order = SMART_STEPS.keys
        current_index = steps_order.index(current_step)
        
        return steps_order[current_index - 1] if current_index && current_index > 0
        nil
      end
      
      def format_smart_goal(goal_progress)
        domain = goal_progress['choose_domain'] || 'Выбранная сфера'
        specific = goal_progress['specific'] || 'Конкретное действие'
        measurable = goal_progress['measurable'] || 'Измеримый показатель'
        achievable = goal_progress['achievable'] || 'Реалистичность'
        relevant = goal_progress['relevant'] || 'Личная значимость'
        time_bound = goal_progress['time_bound'] || 'Сроки'
        
        <<~GOAL
          Я буду #{specific.downcase}, чтобы #{measurable.downcase}. 
          Это достижимо, потому что #{achievable.downcase}. 
          Цель важна для меня, так как #{relevant.downcase}. 
          Я начну действовать и достигну результата к #{time_bound.downcase}.
        GOAL
          .strip
          .gsub(/\s+/, ' ')
      end
      
      def clear_day_data
        SMART_STEPS.keys.each do |step|
          store_day_data("#{step}_response", nil)
        end
        store_day_data('current_smart_step', nil)
        store_day_data('smart_goals', nil)
        store_day_data('goal_progress', nil)
        store_day_data('final_goals', nil)
        store_day_data('completion_time', nil)
      end
      
      # Методы разметки
      def day_22_start_markup
        {
          inline_keyboard: [
            [
              { text: "🎯 Начать создание целей", callback_data: 'start_day_22_exercise' },
              { text: "📚 Посмотреть примеры", callback_data: 'day_22_show_examples' }
            ]
          ]
        }
      end
      
      def day_22_domain_markup
        keyboard = LIFE_DOMAINS.each_slice(2).map do |pair|
          pair.map do |domain|
            { text: "#{domain[:emoji]} #{domain[:name]}", callback_data: "day_22_domain_#{domain[:key]}" }
          end
        end
        
        # Добавляем кнопку "Другое"
        keyboard << [{ text: "✍️ Другая сфера (опишу)", callback_data: "day_22_domain_other" }]
        
        { inline_keyboard: keyboard }
      end
      
      def day_22_step_navigation_markup
        {
          inline_keyboard: [
            [
              { text: "🔙 Назад", callback_data: 'day_22_previous_step' },
              { text: "⏩ Пропустить", callback_data: 'day_22_skip_step' },
              { text: "🔄 Начать заново", callback_data: 'day_22_restart_goal' }
            ]
          ]
        }
      end
      
      def day_22_goal_completion_markup(goal_count)
        keyboard = []
        
        if goal_count < 3
          keyboard << [
            { text: "➕ Добавить еще цель", callback_data: 'day_22_add_goal' },
            { text: "✅ Завершить создание", callback_data: 'day_22_complete_exercise' }
          ]
        else
          keyboard << [
            { text: "✅ Завершить создание", callback_data: 'day_22_complete_exercise' }
          ]
        end
        
        keyboard << [
          { text: "📋 Посмотреть все цели", callback_data: 'day_22_show_goals' }
        ]
        
        { inline_keyboard: keyboard }
      end
      
      def day_22_final_completion_markup
        {
          inline_keyboard: [
            [
              { text: "📋 Показать все цели", callback_data: 'day_22_show_goals' },
              { text: "🔄 Пройти заново", callback_data: 'retry_day_22_exercise' }
            ],
            [
              { text: "✅ Завершить День 22", callback_data: 'day_22_complete_exercise' }
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
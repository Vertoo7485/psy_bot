# app/services/self_help/days/day_25_service.rb
module SelfHelp
  module Days
    class Day25Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 25
      
      # Шаги дня 25
      DAY_STEPS = {
        'intro' => {
          title: "🌌 *День 25: Стоический 'Вид сверху' (View from Above)* 🌌",
          instruction: <<~MARKDOWN
            **Добро пожаловать в мир стоической мудрости и космической перспективы!** ✨

            Сегодня вы освоите одну из самых мощных техник стоицизма — способность видеть любую ситуацию с высоты вселенной.

            📊 **Научные факты о смене перспективы:**
            • 🧠 Изменение перспективы активирует префронтальную кору мозга на 40-60%, улучшая рациональное мышление
            • 😌 Техника "вида сверху" снижает уровень тревоги на 35-50% за счет активации парасимпатической нервной системы
            • 🌍 Космонавты, видевшие Землю из космоса, испытывают "эффект обзора" — глубокое изменение сознания
            • ⏳ Временная перспектива снижает стресс от проблем на 60%, делая их менее значимыми
            • 🎯 Широкий взгляд улучшает качество решений на 45% за счет большей объективности
            • 🔄 Техника использовалась Марком Аврелием и Сенекой для сохранения мудрости в сложных ситуациях

            🎯 **Что вы получите от сегодняшней практики:**
            1. 🌌 Способность видеть ситуацию с космической перспективы
            2. 😌 Глубокое спокойствие и объективность
            3. 🎯 Улучшение принятия решений
            4. ⏳ Понимание временного масштаба жизни
            5. ✨ Чувство связи со вселенной и своей ролью в ней
          MARKDOWN
        },
        'exercise_explanation' => {
          title: "🌍 *Упражнение: Космическое восхождение* 🚀",
          instruction: <<~MARKDOWN
            **Почему именно "Вид сверху"?** 🤔

            Когда мы смотрим на ситуацию с разных уровней масштаба, происходит мощная трансформация сознания:

            • 🧠 **Нейробиологический эффект:** Активируются зоны мозга, ответственные за объективное мышление
            • 😌 **Эмоциональный баланс:** Снижается активность миндалины (центра страха)
            • 🌍 **Когнитивная переоценка:** Проблемы уменьшаются в масштабе вселенной
            • ⏳ **Временная мудрость:** Понимание мимолетности всех событий
            • ✨ **Экзистенциальное спокойствие:** Осознание себя частью космоса

            **Как работает техника стоиков:**
            1. 🎯 Выбираем конкретную ситуацию или мысль
            2. 🚀 Постепенно "поднимаемся" через 7 уровней перспективы
            3. 🌍 От комнаты до космоса — полное изменение ракурса
            4. 🔄 Возвращаемся с новой мудростью
            5. 🎯 Создаем "якорь" для быстрого доступа к этой перспективе

            **Сегодняшнее упражнение:** Мысленное путешествие через 7 уровней перспективы — от вашей комнаты до края вселенной.
            Цель — не "убежать" от проблемы, а увидеть её истинные масштабы.
          MARKDOWN
        },
        'practice_guidance' => {
          title: "📋 *Подготовка к космическому путешествию* 🛰️",
          instruction: <<~MARKDOWN
            **Оптимальные условия для практики:**

            🏠 **Пространство и атмосфера:**
            • Тихое, спокойное место
            • Комфортное положение сидя или лежа
            • Приглушенный свет
            • Минимум отвлекающих факторов

            🧠 **Ментальная подготовка:**
            • Отложите все гаджеты и уведомления
            • Расслабьте тело и сознание
            • Настройтесь на путешествие
            • Разрешите себе мыслить масштабно

            🚀 **Установка на практику:**
            • Будьте открыты новому опыту
            • Не спешите — каждый уровень требует осмысления
            • Если ум отвлекается → мягко возвращайтесь к визуализации
            • Помните: стоики использовали эту технику 2000 лет назад!

            **Важно:** "Вид сверху" — это навык, который развивается через практику. Чем чаще вы его используете, тем быстрее он будет работать.
          MARKDOWN
        },
        'post_practice_reflection' => {
          title: "📝 *Рефлексия после космического путешествия* 🌠",
          instruction: <<~MARKDOWN
            **Потрясающая работа! Вы только что завершили путешествие стоической мудрости!** 🌟

            **Вопросы для рефлексии:**

            🌌 **1. Об изменении перспективы:**
            • Как изменилось ваше восприятие ситуации от начала до конца?
            • На каком уровне вы почувствовали наибольшее облегчение?
            • Какие инсайты пришли к вам во время путешествия?
            • Как изменилась "важность" проблемы в масштабе вселенной?

            🧠 **2. Об уме и эмоциях:**
            • Удавалось ли удерживать фокус на визуализации?
            • Какие мысли или сомнения возникали?
            • Как менялось эмоциональное состояние на разных уровнях?
            • Были ли моменты настоящего "прорыва" в понимании?

            😌 **3. О состоянии после практики:**
            • Как изменилось ваше настроение?
            • Чувствуете ли вы больше спокойствия и мудрости?
            • Что произошло с уровнем тревоги или беспокойства?
            • Готовы ли вы применять этот навык в жизни?
          MARKDOWN
        }
      }.freeze
      
      # Категории для выбора фокуса
      FOCUS_CATEGORIES = [
        {
          name: "Тревожная мысль",
          emoji: "🤔",
          description: "Мысли о будущем, которые вызывают беспокойство и тревогу.",
          examples: ["Я не справлюсь с проектом", "Всё плохо и будет хуже", "Меня осудят или отвергнут"],
          recommended_for: "Когда мысли крутятся по кругу и вызывают тревогу"
        },
        {
          name: "Конфликт",
          emoji: "😠",
          description: "Ситуации разногласий, споров или непонимания с другими.",
          examples: ["Спор с коллегой", "Непонимание в отношениях", "Семейный разлад"],
          recommended_for: "Когда эмоции мешают увидеть ситуацию объективно"
        },
        {
          name: "Сожаление",
          emoji: "😞",
          description: "Мысли о прошлых решениях, ошибках или упущенных возможностях.",
          examples: ["О прошлом решении", "Об упущенной возможности", "О сказанных словах"],
          recommended_for: "Когда прошлое тяготит и не даёт двигаться вперёд"
        },
        {
          name: "Сложная цель",
          emoji: "🎯",
          description: "Большие задачи, проекты или решения, которые кажутся неподъёмными.",
          examples: ["Большой проект на работе", "Важное жизненное решение", "Изменение привычки"],
          recommended_for: "Когда цель кажется слишком большой и пугающей"
        },
        {
          name: "Беспокойство о здоровье",
          emoji: "😰",
          description: "Опасения, страхи или тревога, связанные со здоровьем.",
          examples: ["О своём здоровье", "О здоровье близких", "О будущих медицинских процедурах"],
          recommended_for: "Когда страх за здоровье захватывает сознание"
        },
        {
          name: "Рабочая ситуация",
          emoji: "💼",
          description: "Сложности на работе, дедлайны, презентации или карьерные вопросы.",
          examples: ["Сложный дедлайн", "Важная презентация", "Конфликт на работе", "Карьерный выбор"],
          recommended_for: "Когда работа кажется центром вселенной"
        }
      ].freeze
      
      # Уровни перспективы
      PERSPECTIVE_LEVELS = [
        {
          name: "level1_room",
          emoji: "🚪",
          title: "Ваша комната",
          instruction: <<~MARKDOWN,
            **Закройте глаза на 30 секунд.** 🧘

            Представьте, что вы *парите под потолком своей комнаты* и смотрите на себя со стороны.

            **Что вы видите с этой высоты?** 👁️

            • 🪑 Где вы сидите или стоите?
            • 📱 Что вас окружает в комнате?
            • 🧍 Как выглядит ваша поза, выражение лица?
            • 💭 Какие мысли крутятся в голове у этого человека?

            **С этой высоты ваша ситуация выглядит больше или меньше?**
            
            **Напишите свои наблюдения:** 📝
          MARKDOWN
          prompt: "Опишите, что вы видите, глядя на себя из-под потолка:"
        },
        {
          name: "level2_building",
          emoji: "🏢",
          title: "Ваше здание/дом",
          instruction: <<~MARKDOWN,
            **Теперь поднимаемся выше — *над крышей вашего дома или здания*.** 🚀

            Смотрите **с высоты птичьего полёта**:
            • 🏠 Ваш дом среди других домов
            • 🚶 Люди на улицах — крошечные фигурки
            • 🚗 Машины — как игрушечные
            • 🌳 Деревья, дворы, детские площадки

            **Ваша комната теперь** — лишь маленькая точка в этом здании.
            **Ваши мысли и переживания** — лишь часть всего, что происходит в этом доме.

            **Что меняется в восприятии ситуации с этой высоты?**
            
            **Опишите свои наблюдения:** 📝
          MARKDOWN
          prompt: "Что вы видите и чувствуете, глядя на свой дом с высоты птичьего полёта:"
        },
        {
          name: "level3_city",
          emoji: "🌆",
          title: "Ваш город",
          instruction: <<~MARKDOWN,
            **Поднимаемся ещё выше — *над всем городом*.** 🛰️

            **Смотрите как со спутника:**
            • 🗺️ Районы, парки, реки
            • 🏭 Заводы, предприятия, школы
            • 🏥 Больницы, где рождаются и умирают
            • 👥 Тысячи людей, каждый со своей жизнью

            **Ваш дом теперь** — одна из тысяч точек на карте.
            **В городе прямо сейчас:**
            • 🎉 Кто-то празднует рождение
            • 😢 Кто-то горюет об утрате
            • 💼 Кто-то строит бизнес
            • ❤️ Кто-то влюбляется

            **Ваша ситуация в масштабе города:**
            
            **Опишите свои мысли:** 📝
          MARKDOWN
          prompt: "Как выглядит ваша ситуация в масштабе всего города:"
        },
        {
          name: "level4_country",
          emoji: "🗺️",
          title: "Ваша страна",
          instruction: <<~MARKDOWN,
            **Продолжаем восхождение — *над всей страной*.** 🌄

            **Видите контуры государства:**
            • 🌄 Горы, равнины, реки, озёра
            • 🏙️ Мегаполисы и маленькие деревни
            • 🛣️ Транспортные артерии
            • 🌾 Поля, леса, моря

            **Ваш город** — лишь точка на карте страны.
            **В стране живут миллионы людей**, у каждого свои:
            • 🎯 Мечты и цели
            • 😔 Разочарования и потери
            • 💪 Победы и достижения
            • 📖 Уникальные истории жизни

            **Что чувствуете, глядя так широко?**
            
            **Опишите ощущения:** 📝
          MARKDOWN
          prompt: "Что вы чувствуете, видя свою страну с высоты:"
        },
        {
          name: "level5_planet",
          emoji: "🪐",
          title: "Планета Земля",
          instruction: <<~MARKDOWN,
            **Теперь — *в космосе*, глядя на голубой шар Земли.** 🌍

            **Знаменитый 'Blue Marble' вид:**
            • 🌍 Континенты, океаны без границ
            • ☁️ Облачные вихри и погодные системы
            • 🌅 Смена дня и ночи
            • 🌋 Природные явления

            **Ваша страна** — часть мозаики континентов.
            **На планете:**
            • 8 миллиардов уникальных жизней
            • 🏔️ Тысячи культур и языков
            • 🦁 Миллионы видов живых существ
            • 💫 Невероятное разнообразие опыта

            **Ваша ситуация в масштабе планеты:**
            
            **Опишите свои мысли:** 📝
          MARKDOWN
          prompt: "Как выглядит ваша ситуация на фоне всей планеты Земля:"
        },
        {
          name: "level6_time",
          emoji: "⏳",
          title: "Шкала времени",
          instruction: <<~MARKDOWN,
            **Теперь добавим *временную перспективу*.** 🕰️

            **Представьте временную шкалу:**
            • 📜 **100 лет назад:** Ваших проблем ещё не существовало
            • 🔮 **100 лет вперед:** О них уже никто не вспомнит
            • 🦕 **Динозавры жили** 65 миллионов лет назад
            • 🌟 **Солнце будет светить** ещё 5 миллиардов лет
            • 💫 **Вселенная существует** 13.8 миллиардов лет

            **Ваша жизнь** — мгновение в этой временной шкале.
            **Ваши переживания** — мимолетные волны на поверхности океана времени.

            **Как это влияет на значимость ситуации?**
            
            **Опишите свои ощущения:** 📝
          MARKDOWN
          prompt: "Как меняется значимость ситуации на шкале времени:"
        },
        {
          name: "level7_cosmic",
          emoji: "✨",
          title: "Космическая перспектива",
          instruction: <<~MARKDOWN,
            **Финальное восхождение — *к самой широкой возможной перспективе*.** 🌌

            **Представьте масштабы вселенной:**
            • 🌠 **Наша галактика** Млечный Путь: 100 миллиардов звёзд
            • 🌀 **Вселенная:** 2 триллиона галактик
            • ⚛️ **Вы сделаны из звёздной пыли** — атомов, родившихся в звёздах
            • 🔄 **Всё постоянно меняется** — звёзды рождаются и умирают
            • 🤝 **Вы связаны со всем** — теми же атомами, что и в далёких звёздах

            **С этой перспективы:**
            • 🌱 Вы — часть невероятной космической истории
            • 🎭 Ваша ситуация — один из бесчисленных космических процессов
            • 💖 Ваша способность переживать — чудо сознания во вселенной

            **Какие чувства и мысли возникают?**
            
            **Опишите финальные инсайты:** 📝
          MARKDOWN
          prompt: "Ваши финальные мысли с космической перспективы:"
        }
      ].freeze
      
      # Якорные жесты для быстрого доступа
      ANCHOR_GESTURES = [
  {
    name: "Взгляд вверх",
    emoji: "👁️",
    description: "Поднять глаза к небу или потолку, как будто смотрите в космос",
    duration: "3-5 секунд",
    benefits: "Быстрый доступ к космической перспективе"
  },
  {
    name: "Глубокий космический вдох",
    emoji: "🌬️",
    description: "Сделать три глубоких медленных вдоха, представляя, как вдыхаете космос",
    duration: "10-15 секунд",
    benefits: "Успокоение нервной системы, возвращение в настоящее"
  },
  {
    name: "Открытые ладони",
    emoji: "🤲",
    description: "Раскрыть ладони вверх, как бы принимая мудрость вселенной",
    duration: "5-7 секунд",
    benefits: "Ощущение принятия и отпускания"
  },
  {
    name: "Разведение рук",
    emoji: "👐",
    description: "Развести руки в стороны, как обнимая всё пространство вокруг",
    duration: "5 секунд",
    benefits: "Расширение перспективы, снятие ограничений"
  },
  {
    name: "Звёздное вращение",
    emoji: "🔄",
    description: "Медленно повернуть голову по кругу, представляя вращение галактик",
    duration: "7-10 секунд",
    benefits: "Изменение точки зрения, выход из зацикленности"
  },
  {
    name: "Сердце вселенной",
    emoji: "💫",
    description: "Положить руку на сердце и представить связь со всей вселенной",
    duration: "5 секунд",
    benefits: "Эмоциональная связь, чувство принадлежности"
  }
].freeze
      
      # Типичные трудности в практике "вида сверху"
      COMMON_CHALLENGES = [
        {
          challenge: "Не могу визуализировать",
          emoji: "🌀",
          solution: "Начните с простого: представьте свою комнату. Не нужно деталей — достаточно общего образа. Практика улучшает способность к визуализации."
        },
        {
          challenge: "Кажется глупым или странным",
          emoji: "😳",
          solution: "Помните: стоики использовали эту технику 2000 лет назад! Это проверенный временем инструмент мудрости. Дайте себе разрешение экспериментировать."
        },
        {
          challenge: "Мысли возвращаются к проблеме",
          emoji: "💭",
          solution: "Это нормально! Просто замечайте это и мягко возвращайтесь к визуализации. Каждое возвращение — это тренировка осознанности."
        },
        {
          challenge: "Не чувствую изменений",
          emoji: "🤷",
          solution: "Попробуйте сделать паузу между уровнями. Дайте себе время осмыслить каждый шаг. Эффект часто приходит после завершения практики."
        },
        {
          challenge: "Нет времени на 7 уровней",
          emoji: "⏰",
          solution: "Начните с быстрой версии: выберите только 3 уровня (комната, планета, космос) или создайте свой упрощённый вариант."
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
          text: "Готовы к космическому путешествию стоической мудрости?",
          reply_markup: day_25_content_markup
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
          text: "🎯 **Выберите ситуацию для трансформации перспективы:**",
          parse_mode: 'Markdown',
          reply_markup: day_25_focus_categories_markup
        )
      end
      
      # Обработка выбора категории фокуса
      def handle_focus_selection(focus_index)
        focus_category = FOCUS_CATEGORIES[focus_index.to_i]
        
        if focus_category
          store_day_data('selected_focus', focus_category)
          
          send_message(
            text: "✅ Выбрана категория: #{focus_category[:emoji]} *#{focus_category[:name]}*",
            parse_mode: 'Markdown'
          )
          
          send_message(
            text: "#{focus_category[:emoji]} **Описание:** #{focus_category[:description]}\n**Рекомендуется:** #{focus_category[:recommended_for]}",
            parse_mode: 'Markdown'
          )
          
          send_message(
            text: "💡 **Пример ситуации:** #{focus_category[:examples].sample}",
            parse_mode: 'Markdown'
          )
          
          sleep(1)
          send_message(
            text: "📝 *Теперь опишите вашу конкретную ситуацию или мысль:*",
            parse_mode: 'Markdown'
          )
          store_day_data('awaiting_situation_description', true)
        else
          send_message(text: "⚠️ Неизвестная категория. Пожалуйста, выберите из предложенных.")
        end
      end
      
      def start_perspective_journey
        store_day_data('current_step', 'perspective_journey')
        
        send_message(
          text: "🚀 *Начинаем космическое восхождение!* ✨",
          parse_mode: 'Markdown'
        )
        
        send_message(
          text: "Мы пройдем 7 уровней перспективы. На каждом уровне у вас будет время на визуализацию и запись наблюдений.",
          parse_mode: 'Markdown'
        )
        
        # Начинаем с первого уровня
        start_level(0)
      end
      
      def start_level(level_index)
        level = PERSPECTIVE_LEVELS[level_index]
        
        if level
          store_day_data('current_level', level_index)
          store_day_data('current_level_name', level[:name])
          
          send_message(
            text: "🎯 **Уровень #{level_index + 1}/7: #{level[:emoji]} #{level[:title]}**",
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
        level = PERSPECTIVE_LEVELS[level_index.to_i]
        
        if level && input_text.present?
          store_day_data("level_#{level_index}_observation", input_text)
          store_day_data("awaiting_level_#{level_index}_input", false)
          
          send_message(
            text: "✅ Уровень #{level_index.to_i + 1} завершён! #{level[:emoji]}",
            parse_mode: 'Markdown'
          )
          
          # Показываем прогресс
          show_journey_progress(level_index.to_i)
          
          # Переходим к следующему уровню или завершаем
          if level_index.to_i < PERSPECTIVE_LEVELS.size - 1
            sleep(1)
            start_level(level_index.to_i + 1)
          else
            sleep(1)
            complete_journey
          end
        else
          send_message(text: "⚠️ Пожалуйста, опишите ваши наблюдения для этого уровня.")
        end
      end
      
      def complete_journey
        store_day_data('journey_completed', true)
        store_day_data('completion_time', Time.current)
        
        send_message(
          text: "🌟 *Восхождение завершено! Вы достигли космической перспективы!* ✨",
          parse_mode: 'Markdown'
        )
        
        # Показываем рефлексию
        show_post_practice_reflection
      end
      
      def show_post_practice_reflection
        store_day_data('current_step', 'post_practice_reflection')
        
        send_message(text: DAY_STEPS['post_practice_reflection'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['post_practice_reflection'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "🌠 *Какие основные инсайты вы получили от этого путешествия?*",
          parse_mode: 'Markdown',
          reply_markup: day_25_reflection_markup
        )
      end
      
      def handle_reflection_input(input_text)
        if input_text.present?
          store_day_data('key_insights', input_text)
          
          send_message(
            text: "✅ Инсайты сохранены! Теперь создадим 'якорь' для быстрого доступа к этой перспективе.",
            parse_mode: 'Markdown'
          )
          
          sleep(1)
          show_anchor_selection
        else
          send_message(text: "⚠️ Пожалуйста, поделитесь вашими инсайтами.")
        end
      end
      
      def show_anchor_selection
        store_day_data('current_step', 'anchor_selection')
        
        send_message(
          text: "🎯 **Создание стоического 'якоря'**",
          parse_mode: 'Markdown'
        )
        
        send_message(
          text: "Якорь — это быстрый способ вернуться к состоянию 'вида сверху' в любой момент.\n\nВыберите физический жест, который будет вашим ключом к космической перспективе:",
          parse_mode: 'Markdown'
        )
        
        send_message(
          text: "🤲 **Выберите ваш якорный жест:**",
          parse_mode: 'Markdown',
          reply_markup: day_25_anchor_gestures_markup
        )
      end
      
      def handle_anchor_selection(anchor_index)
  log_info("Handling anchor selection: #{anchor_index}")
  
  index = anchor_index.to_i
  
  # Проверяем границы массива
  if index < 0 || index >= ANCHOR_GESTURES.length
    log_warn("Invalid anchor index: #{index}, max: #{ANCHOR_GESTURES.length - 1}")
    send_message(text: "⚠️ Неизвестный якорь. Пожалуйста, выберите из предложенных.")
    return
  end
  
  anchor = ANCHOR_GESTURES[index]
  
  if anchor
    store_day_data('selected_anchor', anchor)
    
    send_message(
      text: "✅ Выбран якорь: #{anchor[:emoji]} *#{anchor[:name]}*",
      parse_mode: 'Markdown'
    )
    
    send_message(
      text: "#{anchor[:emoji]} **Как делать:** #{anchor[:description]}\n**Время:** #{anchor[:duration]}\n**Польза:** #{anchor[:benefits]}",
      parse_mode: 'Markdown'
    )
    
    send_message(
      text: "💭 *Теперь придумайте короткую фразу-напоминание для этого жеста (например: 'Вид сверху', 'Космическая перспектива', 'Всё проходит'):*",
      parse_mode: 'Markdown'
    )
    
    store_day_data('awaiting_anchor_phrase', true)
  else
    log_warn("Anchor not found for index: #{index}")
    send_message(text: "⚠️ Неизвестный якорь. Пожалуйста, выберите из предложенных.")
  end
end
      
      def complete_exercise
        # Отмечаем день как завершенный в программе
        @user.complete_day_program(DAY_NUMBER)
        
        # Также вызываем старый метод для совместимости
        @user.complete_self_help_day(DAY_NUMBER)
        
        # Сохраняем статистику практики
        save_view_from_above_stats
        
        # Показываем завершение дня
        show_day_completion
      end
      
     def show_day_completion
  # Получаем данные через read_attribute или []
  day_data = @user.read_attribute(:self_help_program_data) || @user[:self_help_program_data] || {}
  
  selected_focus = day_data["day_#{DAY_NUMBER}_selected_focus"] || {}
  selected_anchor = day_data["day_#{DAY_NUMBER}_selected_anchor"] || {}
  anchor_phrase = day_data["day_#{DAY_NUMBER}_anchor_phrase"] || "Не указано"
  key_insights = day_data["day_#{DAY_NUMBER}_key_insights"] || "Не указано"
  
  # Проверяем, что selected_focus и selected_anchor - хэши, а не строки
  selected_focus = JSON.parse(selected_focus) if selected_focus.is_a?(String)
  selected_anchor = JSON.parse(selected_anchor) if selected_anchor.is_a?(String)
  
  # Извлекаем имена
  focus_name = if selected_focus.is_a?(Hash)
    selected_focus['name'] || selected_focus[:name] || "Не указан"
  else
    "Не указан"
  end
  
  anchor_name = if selected_anchor.is_a?(Hash)
    selected_anchor['name'] || selected_anchor[:name]
  end
  
  # Формируем строку якоря
  anchor_text = if anchor_name && anchor_phrase != "Не указано"
    "#{anchor_name} + '#{anchor_phrase}'"
  elsif anchor_name
    "#{anchor_name} (без фразы)"
  else
    "Не создан"
  end
  
  completion_message = <<~MARKDOWN
    🎊 *День 25 завершен!* 🎊

    **Ваши достижения сегодня:**
    
    🌌 **Освоение стоического 'Вид сверху':**
    • 🎯 Фокус: #{focus_name}
    • 🚀 Пройдено: 7 уровней космической перспективы
    • 💡 Ключевые инсайты: #{key_insights.to_s.truncate(100)}
    • 🎯 Якорь: #{anchor_text}
    • 🧠 Приобретение: Навык космической перспективы
    
    📊 **Научный факт:**
    Регулярная практика смены перспективы повышает эмоциональную устойчивость на 40% и улучшает качество решений на 35%.
    
    *"Широкий взгляд усмиряет душу."*
    — Марк Аврелий
    
    ⏰ **Следующий день будет доступен через 12 часов**
    
    Ваш прогресс: #{@user.progress_percentage}%
  MARKDOWN
  
  send_message(text: completion_message, parse_mode: 'Markdown')
  
  # Предлагаем следующий день
  propose_next_day_with_restriction
end
      
      def propose_next_day_with_restriction
        next_day = 26
        
        # Проверяем, можно ли начать следующий день
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ✅ *Доступен сейчас!*
            
            **Что вас ждет:**
            • 🔗 Цепочка ценностей
            • 🧠 Глубокое понимание ваших истинных приоритетов
            • 🎯 Создание личной системы ценностей
            • 🌟 Интеграция всех накопленных знаний
            
            Вы можете начать следующий день прямо сейчас.
          MARKDOWN
          
          button_text = "🔗 Начать День #{next_day}"
          callback_data = "start_day_#{next_day}_from_proposal"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ⏱️ *Ограничение:* #{error_message}
            
            **Пока ждете, можете:**
            • 🌌 Практиковать "Вид сверху" с разными ситуациями
            • 📝 Экспериментировать с разными якорными жестами
            • 🧠 Наблюдать, как меняется ваше восприятие проблем
            • 📊 Посмотреть статистику (/progress)
            
            *Следующий день будет автоматически доступен, когда пройдет достаточно времени.*
          MARKDOWN
          
          # Если день недоступен, НЕ отправляем активную кнопку
          button_text = "⏱️ Проверить доступность Дня #{next_day}"
          callback_data = "start_day_#{next_day}_from_proposal"  # Оставляем ту же, но Day26Handler проверит
        end
        
        # Отправляем сообщение
        send_message(text: message, parse_mode: 'Markdown')
        
        # Отправляем кнопку ВСЕГДА, но Day26Handler проверит доступность
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
        when 'start_day_25_content', 'start_day_25_from_proposal'
          deliver_exercise
          
        when 'continue_day_25_content'
          # Проверяем, на каком шаге остановился пользователь
          current_step = get_day_data('current_step')
          handle_resume_from_step(current_step || 'intro')
          
        when /^day_25_focus_(\d+)$/
          handle_focus_selection($1)
          
        when 'day_25_focus_custom'
          send_message(text: "📝 Опишите вашу ситуацию или мысль для работы:")
          store_day_data('awaiting_custom_focus', true)

        when 'day_25_write_reflection'
          handle_write_reflection_button
          
        when 'day_25_skip_reflection'
          handle_skip_reflection_button
          
        when /^day_25_level_(\d+)$/
          handle_level_input($1)
          
        when 'day_25_skip_level'
          current_level = get_day_data('current_level').to_i
          if current_level < PERSPECTIVE_LEVELS.size - 1
            start_level(current_level + 1)
          else
            complete_journey
          end
          
        when 'day_25_restart_level'
          current_level = get_day_data('current_level').to_i
          start_level(current_level)
          
        when 'day_25_journey_complete'
          complete_journey
          
        when /^day_25_anchor_(\d+)$/
          handle_anchor_selection($1)
          
        when 'day_25_anchor_custom'
          send_message(text: "✨ Придумайте свой уникальный якорный жест и опишите его:")
          store_day_data('awaiting_custom_anchor', true)
          
        when 'day_25_complete_exercise', 'day_25_exercise_completed'
          complete_exercise
          
        when 'day_25_restart_journey', 'day_25_new_situation'
          deliver_exercise
          
        when 'day_25_practice_quick'
          practice_quick_version
          
        when 'day_25_make_note'
          send_message(
            text: "📝 Напишите заметку о вашей сегодняшней практике:\n• Какие уровни были самыми мощными?\n• Как изменилось ваше восприятие?\n• Как вы будете использовать этот навык в жизни?"
          )
          store_day_data('awaiting_practice_note', true)
          
        when 'day_25_help_choose_focus'
          send_message(
            text: "🎯 **Рекомендация по выбору фокуса:**\n\n• Тревожные мысли → 'Вид сверху' помогает увидеть их временность\n• Конфликты → Показывает, что это часть человеческого опыта\n• Сожаления → В масштабе времени всё становится уроком\n• Сложные цели → Делает их достижимыми в контексте вселенной\n• Беспокойство о здоровье → Помогает обрести спокойствие\n• Рабочие ситуации → Показывает их истинное место в жизни",
            parse_mode: 'Markdown'
          )
          
        else
          log_warn("Unknown button callback: #{callback_data}")
          send_message(text: "Неизвестная команда.")
        end
      end
      
      # Обработка текстового ввода
      def handle_text_input(input_text)
        log_info("Day #{DAY_NUMBER}: Handling text input: #{input_text.truncate(50)}")
        
        # Обработка описания ситуации
        if get_day_data('awaiting_situation_description')
          store_day_data('awaiting_situation_description', false)
          
          if input_text.present?
            store_day_data('situation_description', input_text)
            
            send_message(text: "✅ Ситуация сохранена: #{input_text.truncate(100)}")
            sleep(1)
            start_perspective_journey
            return true
          else
            send_message(text: "⚠️ Пожалуйста, опишите вашу ситуацию.")
            return false
          end
        end

        if get_day_data('awaiting_reflection')
          store_day_data('awaiting_reflection', false)
          
          if input_text.present?
            store_day_data('key_insights', input_text)
            send_message(text: "✅ Инсайты сохранены!")
            sleep(1)
            show_anchor_selection
            return true
          else
            send_message(text: "⚠️ Пожалуйста, поделитесь вашими инсайтами.")
            return false
          end
        end
        
        # Обработка кастомного фокуса
        if get_day_data('awaiting_custom_focus')
          store_day_data('awaiting_custom_focus', false)
          
          if input_text.present?
            store_day_data('custom_focus', input_text)
            send_message(text: "✅ Ваш фокус сохранен!")
            start_perspective_journey
            return true
          else
            send_message(text: "⚠️ Пожалуйста, опишите фокус.")
            return false
          end
        end
        
        # Обработка ввода для уровня
        current_level = get_day_data('current_level')
        if current_level && get_day_data("awaiting_level_#{current_level}_input")
          return handle_level_input(current_level, input_text)
        end
        
        # Обработка рефлексии
        if get_day_data('awaiting_reflection')
          store_day_data('awaiting_reflection', false)
          return handle_reflection_input(input_text)
        end
        
        # Обработка фразы для якоря
        if get_day_data('awaiting_anchor_phrase')
          store_day_data('awaiting_anchor_phrase', false)
          
          if input_text.present?
            store_day_data('anchor_phrase', input_text)
            send_message(text: "✅ Фраза-якорь сохранена: '#{input_text}'")
            complete_exercise
            return true
          else
            send_message(text: "⚠️ Пожалуйста, придумайте фразу для якоря.")
            return false
          end
        end
        
        # Обработка кастомного якоря
        if get_day_data('awaiting_custom_anchor')
          store_day_data('awaiting_custom_anchor', false)
          
          if input_text.present?
            store_day_data('custom_anchor', input_text)
            send_message(text: "✅ Ваш якорь сохранен!")
            send_message(text: "💭 Теперь придумайте фразу для этого якоря:")
            store_day_data('awaiting_anchor_phrase', true)
            return true
          else
            send_message(text: "⚠️ Пожалуйста, опишите ваш якорь.")
            return false
          end
        end
        
        # Обработка заметки о практике
        if get_day_data('awaiting_practice_note')
          store_day_data('awaiting_practice_note', false)
          store_day_data('practice_note', input_text)
          
          send_message(text: "✅ Заметка сохранена! Она поможет вам отслеживать прогресс.")
          send_message(
            text: "Завершаем День 25?",
            reply_markup: day_25_completion_markup
          )
          return true
        end
        
        false
      end

      def handle_write_reflection_button
        store_day_data('awaiting_reflection', true)
        send_message(
          text: "📝 *Напишите ваши основные инсайты от космического путешествия:*\n\n• Что вы поняли о своей ситуации?\n• Как изменилось ваше восприятие?\n• Какая мудрость осталась с вами?",
          parse_mode: 'Markdown'
        )
      end

      def handle_skip_reflection_button
        store_day_data('key_insights', "Пользователь пропустил рефлексию")
        show_anchor_selection
      end
      
      private
      
      # Вспомогательные методы разметки
      def day_25_content_markup
        {
          inline_keyboard: [
            [
              { text: "🚀 Начать космическое путешествие", callback_data: 'start_day_25_content' }
            ],
            [
              { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
            ]
          ]
        }.to_json
      end
      
      def day_25_focus_categories_markup
        keyboard = []
        
        # Первые 3 категории в одну строку
        keyboard << [
          { text: "#{FOCUS_CATEGORIES[0][:emoji]} #{FOCUS_CATEGORIES[0][:name]}", callback_data: "day_25_focus_0" },
          { text: "#{FOCUS_CATEGORIES[1][:emoji]} #{FOCUS_CATEGORIES[1][:name]}", callback_data: "day_25_focus_1" },
          { text: "#{FOCUS_CATEGORIES[2][:emoji]} #{FOCUS_CATEGORIES[2][:name]}", callback_data: "day_25_focus_2" }
        ]
        
        # Следующие 3 категории
        keyboard << [
          { text: "#{FOCUS_CATEGORIES[3][:emoji]} #{FOCUS_CATEGORIES[3][:name]}", callback_data: "day_25_focus_3" },
          { text: "#{FOCUS_CATEGORIES[4][:emoji]} #{FOCUS_CATEGORIES[4][:name]}", callback_data: "day_25_focus_4" },
          { text: "#{FOCUS_CATEGORIES[5][:emoji]} #{FOCUS_CATEGORIES[5][:name]}", callback_data: "day_25_focus_5" }
        ]
        
        keyboard << [
          { text: "✍️ Своя ситуация", callback_data: 'day_25_focus_custom' }
        ]
        
        keyboard << [
          { text: "❓ Помогите выбрать", callback_data: 'day_25_help_choose_focus' }
        ]
        
        { inline_keyboard: keyboard }.to_json
      end
      
      def day_25_reflection_markup
      {
        inline_keyboard: [
          [
            { text: "📝 Написать инсайты", callback_data: 'day_25_write_reflection' },
            { text: "⏭️ Пропустить", callback_data: 'day_25_skip_reflection' }
          ]
        ]
      }.to_json
    end
      
      def day_25_anchor_gestures_markup
  keyboard = []
  
  # Вариант 1: Все в одной колонке (проще для отладки)
  ANCHOR_GESTURES.each_with_index do |gesture, index|
    keyboard << [
      { 
        text: "#{gesture[:emoji]} #{gesture[:name]}", 
        callback_data: "day_25_anchor_#{index}" 
      }
    ]
  end
  
  keyboard << [
    { text: "✨ Свой якорь", callback_data: 'day_25_anchor_custom' }
  ]
  
  { inline_keyboard: keyboard }.to_json
end
      
      def day_25_completion_markup
        {
          inline_keyboard: [
            [
              { text: "✅ Завершить День 25", callback_data: 'day_25_complete_exercise' },
              { text: "🔄 Новое путешествие", callback_data: 'day_25_new_situation' }
            ],
            [
              { text: "📝 Сделать заметку", callback_data: 'day_25_make_note' },
              { text: "🚀 Быстрая практика", callback_data: 'day_25_practice_quick' }
            ]
          ]
        }.to_json
      end
      
      def show_intro_without_state
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        send_message(
          text: statistics_message,
          parse_mode: 'Markdown'
        )
        send_message(
          text: "Готовы к космическому путешествию стоической мудрости?",
          reply_markup: day_25_content_markup
        )
      end
      
      def handle_resume_from_step(step)
        case step
        when 'intro'
          deliver_intro
        when 'exercise_explanation'
          deliver_exercise
        when 'perspective_journey'
          current_level = get_day_data('current_level').to_i
          if current_level > 0
            start_level(current_level)
          else
            start_perspective_journey
          end
        when 'post_practice_reflection'
          show_post_practice_reflection
        when 'anchor_selection'
          show_anchor_selection
        else
          deliver_intro
        end
      end
      
      def statistics_message
        <<~MARKDOWN
          📊 *Почему "Вид сверху" так эффективен:*
          
          • 😌 **35-50%** — снижение уровня тревоги после практики
          • 🧠 **40-60%** — активация префронтальной коры (рациональное мышление)
          • 🎯 **45%** — улучшение качества принимаемых решений
          • 🌍 **Эффект обзора** — 100% астронавтов сообщают о глубоком изменении сознания
          • ⏳ **60%** — снижение значимости проблем при временной перспективе
          • 🔄 **2000 лет** — техника проверена стоиками Марком Аврелием и Сенекой
          
          *Источник: NASA исследования, Journal of Cognitive Neuroscience, стоическая философия*
        MARKDOWN
      end
      
      def show_journey_progress(current_level)
        progress_message = "📊 *Прогресс космического восхождения:* "
        
        PERSPECTIVE_LEVELS.each_with_index do |level, index|
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
        progress_message += "🚀 **Пройдено уровней:** #{current_level + 1}/7\n"
        progress_message += "✨ **Осталось:** #{7 - current_level - 1}\n"
        
        if current_level > 0
          previous_level = PERSPECTIVE_LEVELS[current_level - 1]
          progress_message += "⬆️ *Только что:* #{previous_level[:emoji]} #{previous_level[:title]}"
        end
        
        send_message(text: progress_message, parse_mode: 'Markdown')
      end
      
      def save_view_from_above_stats
        begin
          # Сохраняем данные практики для отслеживания прогресса
          store_day_data('view_from_above_stats', {
            date: Date.current.to_s,
            focus_category: get_day_data('selected_focus')&.dig(:name),
            situation_description: get_day_data('situation_description'),
            levels_completed: 7,
            key_insights: get_day_data('key_insights'),
            anchor: get_day_data('selected_anchor')&.dig(:name),
            anchor_phrase: get_day_data('anchor_phrase'),
            completed: true
          })
        rescue => e
          log_error("Failed to save view from above stats", e)
        end
      end
      
      def practice_quick_version
        selected_anchor = get_day_data('selected_anchor') || {}
        anchor_phrase = get_day_data('anchor_phrase') || "Вид сверху"
        
        message = <<~MARKDOWN
          🚀 *Быстрая практика "Вид сверху" (30 секунд)*

          1. **Остановитесь** на мгновение
          2. **#{selected_anchor[:name]&.split(' ')&.last || 'Сделайте ваш якорный жест'}**
          3. **Произнесите про себя:** "#{anchor_phrase}"
          4. **Представьте:** Земля из космоса, крошечная голубая точка
          5. **Вспомните:** Ваша ситуация — миг в истории вселенной
          6. **Вернитесь** с мудростью стоиков

          *Практикуйте 3 раза в день для закрепления навыка.*
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def log_info(message)
        Rails.logger.info "[Day#{DAY_NUMBER}Service] #{message} - User: #{@user.telegram_id}"
      end
      
      def log_error(message, error = nil)
        Rails.logger.error "[Day#{DAY_NUMBER}Service] #{message} - User: #{@user.telegram_id}"
        Rails.logger.error error.message if error
      end
      
      def log_warn(message)
        Rails.logger.warn "[Day#{DAY_NUMBER}Service] #{message} - User: #{@user.telegram_id}"
      end
    end
  end
end
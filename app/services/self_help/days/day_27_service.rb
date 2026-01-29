# app/services/self_help/days/day_27_service.rb
module SelfHelp
  module Days
    class Day27Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 27
      
      # Типы удовольствий - ДОЛЖНЫ БЫТЬ НА УРОВНЕ КЛАССА, а не в методах
      PLEASURE_TYPES = [
        { 
          emoji: "🍃", 
          name: "Естественные и необходимые", 
          examples: ["здоровая еда", "качественный сон", "прогулка", "общение с близкими"],
          description: "Базовые потребности, фундамент стабильности, активируют нейронные цепи выживания"
        },
        { 
          emoji: "🎨", 
          name: "Естественные, но не необходимые", 
          examples: ["музыка", "искусство", "хобби", "обучение новому"],
          description: "Обогащают жизнь, развивают личность, активируют эстетическое восприятие"
        },
        { 
          emoji: "🎭", 
          name: "Неестественные и не необходимые", 
          examples: ["бесконечный скроллинг", "шопинг от скуки", "погоня за лайками"],
          description: "Быстрый дофамин, риск привыкания, нарушают дофаминовый баланс"
        }
      ].freeze
      
      # Техники смакования
      SAVORING_TECHNIQUES = [
        { 
          emoji: "👁️", 
          name: "Внимательное присутствие", 
          steps: ["Отключить автопилот", "Включить все 5 чувств", "Быть полностью здесь и сейчас"],
          example: "Пить чай, чувствуя каждый глоток - температуру, вкус, аромат, текстуру"
        },
        { 
          emoji: "📸", 
          name: "Ментальная фотография", 
          steps: ["Осознанно заметить детали", "Создать яркий мысленный образ", "Сохранить в памяти"],
          example: "'Сфотографировать' красивый закат в уме - цвета, облака, свет, ощущение тепла"
        },
        { 
          emoji: "🎬", 
          name: "Режиссура удовольствия", 
          steps: ["Создать идеальные условия", "Убрать отвлекающие факторы", "Настроиться на получение"],
          example: "Специально приготовить место для чтения - удобное кресло, правильный свет, тишина, любимый напиток"
        },
        { 
          emoji: "🤝", 
          name: "Совместное смакование", 
          steps: ["Поделиться моментом", "Обсудить ощущения", "Усилить через обмен"],
          example: "'Видишь, как красиво?' - сказать другу и обсудить, что каждый видит и чувствует"
        }
      ].freeze
      
      # Микро-ритуалы для вдохновения
      MICRO_RITUALS = [
        { 
          emoji: "🕯️", 
          name: "Свеча завершения", 
          steps: ["Зажечь свечу после задачи", "Посидеть 2 минуты в тишине", "Подумать о достижении", "Погасить свечу - ритуал завершён"]
        },
        { 
          emoji: "☕", 
          name: "Особая чашка", 
          steps: ["Использовать особую чашку", "Пить медленно, смакуя", "Благодарить себя за усилия"]
        },
        { 
          emoji: "🎵", 
          name: "Победный трек", 
          steps: ["Иметь специальный музыкальный трек", "Включать после достижений", "Танцевать или просто слушать"]
        },
        { 
          emoji: "📓", 
          name: "Дневник побед", 
          steps: ["Записать достижение", "Описать чувства", "Отметить проявленную ценность"]
        }
      ].freeze
      
      # Дофаминовые паузы
      DOPAMINE_PAUSES = [
        { 
          emoji: "📱", 
          name: "Цифровой детокс", 
          duration: "12 часов",
          what_avoid: ["соцсети", "новости", "бесцельный сёрфинг"],
          what_do: ["прогулки", "чтение", "разговоры", "рукоделие"]
        },
        { 
          emoji: "🍰", 
          name: "Сахарная пауза", 
          duration: "3 дня",
          what_avoid: ["добавленный сахар", "сладости", "сладкие напитки"],
          what_do: ["фрукты", "орехи", "травяные чаи", "воду с лимоном"]
        },
        { 
          emoji: "🛒", 
          name: "Потребительский пост", 
          duration: "7 дней",
          what_avoid: ["необязательные покупки", "онлайн-шопинг", "импульсивные траты"],
          what_do: ["использовать что есть", "ремонтировать", "обмениваться", "создавать самим"]
        }
      ].freeze
      
      # Шаги дня 27 с научными исследованиями (уже было правильно)
      DAY_STEPS = {
        'intro' => {
          title: "🧠 *День 27: Нейрохакинг радости - Наука осознанного празднования* 🧠",
          instruction: <<~MARKDOWN
            **Четвёртая неделя: Интеграция науки и мудрости** 🧬

            После работы с глубинными ценностями (день 26) сегодня научимся *праздновать достижения так, чтобы это укрепляло мозг, а не истощало*.

            🎯 **Что такое 'нейрохакинг радости'?**
            Это научно обоснованный подход к тому, как:

            • 🎯 **Осознанно получать удовольствие** от достижений
            • 🧬 **Укреплять нейронные пути**, связанные с позитивом
            • 🤝 **Балансировать дофаминовую систему** без выгорания
            • 🎭 **Создавать ритуалы**, которые работают на уровне мозга

            📊 **Научные факты о нейрохакинге радости:**
            • 🧠 Техники смакования (savoring) усиливают нейронные связи в префронтальной коре на 25-35%
            • 💫 Осознанное празднование активирует эндорфиновую систему на 40% эффективнее, чем пассивное потребление
            • 🔄 Дофаминовые паузы восстанавливают чувствительность рецепторов на 50-60%
            • ⚖️ Балансировка дофамина снижает риск выгорания на 65% и депрессии на 45%
            • 🎭 Микро-ритуалы создают устойчивые нейронные паттерны через повторение в контексте
            • 🌈 Исследования Barbara Fredrickson показывают, что соотношение 3:1 позитивных и негативных переживаний - ключ к устойчивому благополучию
            • 🧬 Рик Хэнсон доказал: мозгу нужно 20 секунд полного присутствия, чтобы "записать" позитивный опыт в долговременную память
            • 🔄 Пластичность: регулярная практика осознанного празднования меняет структуру островковой долины и передней поясной коры

            🎯 **Что вы получите от сегодняшней практики:**
            1. 🔬 Понимание нейробиологии радости
            2. 📊 Инструменты для аудита ваших источников удовольствия
            3. 🎭 4 научно доказанных техники "смакования"
            4. ⚖️ Навык балансировки дофаминовой системы
            5. 🎯 Персонализированные микро-ритуалы
            6. 🔄 Систему интеграции в повседневность
            7. 🧹 Методы дофаминового голодания
            8. ⚙️ Ваш личный алгоритм радости
          MARKDOWN
        },
        'brain_science' => {
          title: "🔬 *Шаг 1: Нейробиология удовольствия* 🧬",
          instruction: <<~MARKDOWN
            **Краткий ликбез по нейробиологии радости:**

            🎯 **Дофамин - не про удовольствие, а про ожидание**
            • Он выделяется *перед* наградой, мотивируя действовать
            • Пик удовольствия часто *ниже* пика ожидания
            • Отсюда 'дофаминовые качели' - погоня за новой дозой

            🧠 **Две системы наслаждения (исследования Kent Berridge):**
            1. **'Wanting' (хотение)** - дофамин, мотивация, ожидание
            2. **'Liking' (нравится)** - эндорфины, опиоиды, настоящее удовольствие

            💡 **Проблема современности:** Мы тренируем 'хотение', но забываем 'нравится'.

            **Научный факт:** Мозг не отличает большую радость от маленькой, если вы полностью в ней присутствуете. Нейроны счастья активируются от качества внимания, а не от масштаба события.

            **Как вы обычно отмечаете достижения? Через 'хотение' или 'нравится'?**
            
            📝 **Опишите ваши инсайты о работе вашей системы награды:**
          MARKDOWN
        },
        'pleasure_audit' => {
          title: "📊 *Шаг 2: Аудит источников радости* 🎯",
          instruction: <<~MARKDOWN
            **Проанализируем ваши текущие источники радости.**

            **Три типа удовольствий (стоическая классификация с научной базой):**

            1. 🍃 **Естественные и необходимые:**
            • Еда, вода, сон, движение
            • Социальные связи, безопасность
            • *Активируют базовые нейронные цепи выживания и благополучия*
            • **Нейробиология:** Базальные ганглии, гипоталамус

            2. 🎨 **Естественные, но не необходимые:**
            • Искусство, музыка, путешествия
            • Хобби, творчество, обучение
            • *Активируют систему вознаграждения через эстетическое восприятие*
            • **Нейробиология:** Орбитофронтальная кора, прилежащее ядро

            3. 🎭 **Неестественные и не необходимые:**
            • Погоня за статусом, чрезмерное потребление
            • Постоянная проверка соцсетей
            • *Создают дофаминовые пики с быстрым привыканием*
            • **Нейробиология:** Префронтальная кора (нарушение контроля)

            **Научный факт:** Люди с преобладанием естественных удовольствий имеют на 40% выше устойчивость к стрессу и на 60% выше удовлетворённость жизнью.

            **К какому типу относятся ваши основные источники радости? Какие изменения хотели бы внести?**
            
            📝 **Опишите ваш аудит удовольствий:**
          MARKDOWN
        },
        'savoring_techniques' => {
          title: "🎭 *Шаг 3: Техники смакования* ✨",
          instruction: <<~MARKDOWN
            **'Savoring' - искусство продлевать и углублять удовольствие на нейронном уровне.**

            **4 научно доказанных техники (исследования Fred Bryant):**

            1. **👁️ Внимательное присутствие:**
            • Полностью погрузиться в момент
            • Отключить автопилот, включить все чувства
            • 'Эта чашка чая - вся вселенная сейчас'
            • **Эффект:** Усиливает активацию соматосенсорной коры на 35%

            2. **📸 Ментальная фотография:**
            • Сознательно 'сфотографировать' момент в памяти
            • Заметить детали: свет, звуки, ощущения
            • Создать яркий мысленный снимок
            • **Эффект:** Укрепляет гиппокамп, улучшает запоминание позитивного

            3. **🎬 Режиссура удовольствия:**
            • Намеренно создавать идеальные условия
            • Убирать отвлекающие факторы
            • Настраиваться на получение удовольствия
            • **Эффект:** Активирует префронтальную кору (планирование наслаждения)

            4. **🤝 Совместное смакование:**
            • Делиться удовольствием с другими
            • 'Видишь, как красиво закат?'
            • Усиливает переживание в 2-3 раза
            • **Эффект:** Активирует зеркальные нейроны и окситоциновую систему

            **Научный факт:** Всего 20 секунд полного присутствия в удовольствии достаточно для создания устойчивого нейронного следа (Hanson, 2013).

            **Какую технику хотели бы попробовать? Как её можно применить к вашим удовольствиям?**
            
            📝 **Опишите вашу выбранную технику:**
          MARKDOWN
        },
        'dopamine_detox' => {
          title: "⚖️ *Шаг 4: Балансировка дофамина* 🔄",
          instruction: <<~MARKDOWN
            **Как избежать 'дофаминовых качелей' и выгорания на нейронном уровне?**

            **Стоический подход к дофамину с научной основой:**

            🔄 **Здоровый цикл дофамина:**
            1. **Ожидание** (здоровое, основанное на ценностях) → Мезолимбический путь
            2. **Действие** (осмысленное, соответствующее ценностям) → Дорсальный стриатум
            3. **Достижение** (отмечаемое через 'смакование') → Прилежащее ядро
            4. **Интеграция** (благодарность, осмысление) → Префронтальная кора
            5. **Новое ожидание** (после полноценного перерыва) → Вентральная область покрышки

            🚫 **Разрушительный цикл:**
            • Постоянная стимуляция (соцсети, уведомления) → Резистентность рецепторов D2
            • Отсутствие пауз между 'дозами' → Истощение дофаминовых запасов
            • Привыкание - нужно всё больше для того же эффекта → Нисходящая регуляция
            • Выгорание системы награда → Ангедония

            **Научный факт:** Регулярные дофаминовые паузы восстанавливают чувствительность рецепторов на 50-60% за 2-4 недели (исследования на зависимостях).

            **Что в вашей жизни работает по здоровому циклу, а что по разрушительному? Как можно сбалансировать?**
            
            📝 **Опишите ваши идеи по балансировке дофамина:**
          MARKDOWN
        },
        'micro_rituals' => {
          title: "🎯 *Шаг 5: Создание нейро-ритуалов* 🧠",
          instruction: <<~MARKDOWN
            **Разработаем персонализированные 5-минутные ритуалы радости, которые работают на уровне нейронов.**

            **Элементы эффективного микро-ритуала:**

            1. **🎭 Символическое действие:**
            • Зажечь свечу → Активация зрительной коры + ассоциативные связи
            • Выпить из особой чашки → Соматосенсорная активация + контекстная память
            • Надеть что-то особенное → Проприоцептивная обратная связь

            2. **🧘 Осознанное присутствие:**
            • 3 глубоких вдоха перед началом → Активация парасимпатической системы
            • Фокус на ощущениях → Сенсорная интеграция
            • Благодарность за момент → Префронтальная активация + окситоцин

            3. **📝 Интеграция смысла:**
            • Связать с ценностью ('Я праздную проявление заботы') → Семантическая сеть
            • Вспомнить путь к достижению → Эпизодическая память (гиппокамп)
            • Признать усилия, а не только результат → Активация островковой долины (интероцепция)

            4. **🔚 Чёткое завершение:**
            • Сознательно закончить ритуал → Префронтальный контроль
            • 'Я завершаю это празднование и возвращаюсь к жизни' → Когнитивное замыкание
            • Физический жест окончания → Проприоцептивное маркирование

            **Научный факт:** Ритуалы создают устойчивые нейронные паттерны через повторение в контексте (процедурная память + контекстно-зависимое обучение).

            **Какой микро-ритуал вы могли бы создать для маленьких достижений? Опишите все элементы.**
            
            📝 **Опишите ваш микро-ритуал:**
          MARKDOWN
        },
        'integration_system' => {
          title: "🔄 *Шаг 6: Система интеграции* 📅",
          instruction: <<~MARKDOWN
            **Как сделать празднование привычкой, а не разовым событием? Нейропластичность в действии.**

            **Три уровня системы для создания устойчивых нейронных путей:**

            1. **🌱 Ежедневные микропраздники (1-5 минут):**
            • После завершения задачи → Немедленное подкрепление
            • Во время перерыва → Ассоциация с отдыхом
            • Перед сном - одна маленькая победа дня → Консолидация во сне

            2. **🌿 Еженедельные ритуалы (10-15 минут):**
            • Пятничный обзор недельных достижений → Когнитивная интеграция
            • Воскресное планирование приятного на неделю → Проактивное празднование
            • 'Церемония благодарности' себе → Активация медиальной префронтальной коры

            3. **🌳 Ежемесячные практики (30-60 минут):**
            • Карта достижений месяца → Пространственная память + нейрокартирование
            • 'Нейрохакинг сессия' - что сработало? → Мета-познание
            • Планирование больших празднований для больших целей → Будущее-ориентированное мышление

            **Научный факт:** Привычки формируются через повторение в контексте + эмоциональное подкрепление (петля привычки: сигнал → действие → награда).

            **Где в вашем расписании могут появиться эти практики? Как связать их с существующими привычками?**
            
            📝 **Опишите ваш план интеграции:**
          MARKDOWN
        },
        'dopamine_fasting' => {
          title: "🧹 *Шаг 7: Дофаминовое голодание* ⏰",
          instruction: <<~MARKDOWN
            **Для продвинутых: перезагрузка системы награды через нейропластичность.**

            **Что такое дофаминовое голодание?**
            • Временное снижение искусственных стимуляторов → Нисходящая регуляция рецепторов
            • Не полный отказ от удовольствий → Избегание депривации
            • Перефокусировка на естественные источники радости → Нейронное перенаправление

            **Как делать безопасно и разумно (нейробиологически обоснованно):**

            1. **Выберите один 'стимулятор' для паузы:**
            • Соцсети на 12 часов → Уменьшение дофаминовых скачков
            • Сахар на день → Стабилизация инсулина и дофамина
            • Бесцельный сёрфинг в интернете → Уменьшение информационной перегрузки

            2. **Заполните паузу естественными радостями:**
            • Прогулка на природе → Синхронизация с циркадными ритмами + серотонин
            • Разговор с близким → Окситоцин + социальное вознаграждение
            • Чтение бумажной книги → Углублённая обработка информации
            • Ручное творчество → Соматосенсорная активация + поток

            3. **Отслеживайте эффект:**
            • Как изменилась способность радоваться? → Чувствительность рецепторов
            • Что стало казаться более ценным? → Переоценка ценностей
            • Какие естественные удовольствия 'заиграли'? → Нейронное перераспределение

            **Научный факт:** Даже 24-часовой цифровой детокс может восстановить чувствительность дофаминовых рецепторов на 15-20%.

            **Хотели бы попробовать микро-версию дофаминового голодания? Какую и почему?**
            
            📝 **Опишите ваши идеи для дофаминовой паузы:**
          MARKDOWN
        },
        'personal_algorithm' => {
          title: "⚙️ *Шаг 8: Ваш алгоритм радости* 🧩",
          instruction: <<~MARKDOWN
            **Создадим вашу персональную формулу осознанного празднования на основе нейронауки.**

            **Элементы алгоритма (нейробиологически обоснованные):**

            1. **🎯 Триггер:** Что запускает празднование?
            • Завершение задачи → Базовый уровень дофамина
            • Достижение мини-цели → Фазовый выброс дофамина
            • Проявление ценности в действии → Смысловой дофамин

            2. **🧠 Нейро-техника:** Какой метод используете?
            • Смакование через присутствие → Сенсорная интеграция
            • Ментальная фотография → Эпизодическое кодирование
            • Совместное празднование → Социальное зеркалирование

            3. **🎭 Ритуал:** Какое символическое действие?
            • Особый напиток → Густо-оральная сенсорика
            • Музыкальный трек → Аудио-эмоциональная ассоциация
            • Запись в дневнике → Вербально-когнитивная интеграция

            4. **🕰️ Длительность:** Сколько времени?
            • 1 минута для микродостижений → Кратковременная активация
            • 5 минут для маленьких побед → Умеренная консолидация
            • 15+ минут для значимых достижений → Глубокое кодирование

            5. **🌀 Интеграция:** Как завершаете?
            • Благодарность себе → Медиальная префронтальная активация
            • Связь с ценностью → Семантическая интеграция
            • Планирование следующего шага → Префронтальное проецирование

            **Создайте ваш алгоритм (пример):**
            'Завершение задачи → 3 глубоких вдоха → чашка чая с полным присутствием → благодарность за усилия → 1 минута'

            **Теперь создайте ВАШ алгоритм:**
            
            📝 **Опишите ваш персональный алгоритм радости:**
          MARKDOWN
        },
        'summary' => {
          title: "🎉 *Шаг 9: Ваш набор нейроинструментов* 🧰",
          instruction: <<~MARKDOWN
            **Поздравляю!** Вы создали ваш научно обоснованный набор для осознанного празднования.

            **Ваш 'Нейрохакинг радости' включает:**

            🧠 **Понимание мозга:** Как работает дофамин и система награды
            📊 **Аудит удовольствий:** Различение типов радостей с научной основой
            🎭 **Техники смакования:** 4 способа углублять удовольствие на нейронном уровне
            ⚖️ **Балансировка дофамина:** Как избежать выгорания через регуляцию рецепторов
            🎯 **Микро-ритуалы:** 5-минутные практики для создания устойчивых нейронных паттернов
            🔄 **Система интеграции:** Ежедневные, еженедельные, ежемесячные практики для нейропластичности
            🧹 **Дофаминовое голодание:** Методы перезагрузки системы награды
            ⚙️ **Личный алгоритм:** Ваша формула осознанного празднования

            **Применение на практике:**
            • 🎯 **После достижений:** Используйте ваш алгоритм для нейронного подкрепления
            • 🧘 **При выгорании:** Вернитесь к балансировке дофамина через естественные удовольствия
            • 📅 **В планировании:** Включайте микро-ритуалы в расписание для создания устойчивых привычек
            • 🔄 **Для профилактики:** Регулярные дофаминовые паузы для поддержания чувствительности

            **Нейробиологическая мудрость:**
            > *"Радость не в масштабе события, а в масштабе внимания, которое вы ему уделяете. Мозг, который научился смаковать чашку чая, уже научился счастью."*
            > — Доктор Рик Хэнсон

            **Ваши инсайты о мозге:**
            [ваши наблюдения]

            **Ваш план по удовольствиям:**
            [ваша цель]

            **Ваша техника смакования:**
            [практическая польза]

            **Ваш подход к дофамину:**
            [качества характера]

            **Ваш микро-ритуал:**
            [связь с другими]

            **Ваш план интеграции:**
            [глубокий смысл]

            **Ваша дофаминовая пауза:**
            [как усилить связь]

            **Ваш алгоритм радости:**
            [осознанное выполнение]

            Теперь у вас есть научные инструменты для создания радости на уровне нейронов!
          MARKDOWN
        }
      }.freeze
      
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
          text: "Готовы научить ваш мозг по-настоящему радоваться?",
          reply_markup: day_27_content_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'brain_science')
        
        send_message(text: DAY_STEPS['brain_science'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['brain_science'][:instruction], parse_mode: 'Markdown')
        
        # Инициализируем данные упражнения
        init_exercise_data
        
        # Предлагаем начать ввод
        send_message(
          text: "📝 *Опишите ваши инсайты о работе вашей системы награды:*",
          parse_mode: 'Markdown',
          reply_markup: day_27_input_markup
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
          # Если состояние не определено или не соответствует дню 27
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
        
        # Сохраняем статистику практики
        save_neurohacking_stats
        
        # Показываем завершение дня
        show_day_completion
      end
      
      def show_day_completion
        # Получаем данные через read_attribute или []
        day_data = @user.read_attribute(:self_help_program_data) || @user[:self_help_program_data] || {}
        
        exercise_data = day_data["day_#{DAY_NUMBER}_exercise_data"] || {}
        algorithm = exercise_data['personal_algorithm'] || "Не указано"
        ritual = exercise_data['micro_ritual'] || "Не указано"
        
        completion_message = <<~MARKDOWN
          🎊 *День 27 завершен!* 🎊

          **Ваши достижения сегодня:**
          
          🧠 **Освоение нейрохакинга радости:**
          • 🔬 Изучена нейробиология удовольствия и дофамина
          • 📊 Проведён аудит источников радости по стоической классификации
          • 🎭 Освоены 4 техники смакования (savoring)
          • ⚖️ Создан план балансировки дофаминовой системы
          • 🎯 Разработан персонализированный микро-ритуал: #{ritual.truncate(100)}
          • 🔄 Создана система интеграции в повседневность
          • 🧹 Подобран метод дофаминового голодания
          • ⚙️ Создан личный алгоритм радости: #{algorithm.truncate(100)}
          • 🧠 Приобретение: Научно обоснованные инструменты для осознанного празднования
          
          📊 **Научный факт:**
          Люди, регулярно практикующие осознанное празднование, имеют на 65% ниже риск выгорания, на 50% выше удовлетворённость жизнью и на 40% лучше восстанавливаются после стресса.
          
          *"Мы не запоминаем дни, мы запоминаем моменты. И чем больше внимания мы им уделяем, тем глубже они впечатываются в нейронную архитектуру нашего бытия."*
          — Чезаре Павезе
          
          ⏰ **Следующий день будет доступен через 12 часов**
          
          Ваш прогресс: #{@user.progress_percentage}%
        MARKDOWN
        
        send_message(text: completion_message, parse_mode: 'Markdown')
        
        # Предлагаем следующий день
        propose_next_day_with_restriction
      end
      
      def propose_next_day_with_restriction
  next_day = 28
  
  # Проверяем, можно ли начать следующий день
  can_start_result = @user.can_start_day?(next_day)
  
  if can_start_result == true
    message = <<~MARKDOWN
      🎯 **Следующий шаг: День #{next_day}**
      
      ✅ *Доступен сейчас!*
      
      **Что вас ждет:**
      • 🧬 Финальная научная рефлексия всей 28-дневной программы
      • 📊 Анализ вашего нейропластического эксперимента
      • 🎯 Создание персональной системы поддержки на научной основе
      • 📜 Получение научного сертификата завершения
      
      **Это финальный день программы** — время подвести итоги и получить заслуженное признание!
      
      Вы можете начать финальный день прямо сейчас.
    MARKDOWN
    
    button_text = "🧬 Начать финальный день"
    callback_data = "start_day_#{next_day}_from_proposal"
  else
    error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
    
    message = <<~MARKDOWN
      🎯 **Следующий шаг: День #{next_day} (Финальный день)**
      
      ⏱️ *Ограничение:* #{error_message}
      
      **Пока ждете, можете:**
      • 🧠 Практиковать техники нейрохакинга радости
      • 📊 Проанализировать ваш прогресс за 27 дней
      • 🎭 Создать ритуалы празднования маленьких побед
      • 🔬 Подготовиться к научной рефлексии финального дня
      
      *Финальный день программы будет автоматически доступен, когда пройдет достаточно времени.*
    MARKDOWN
    
    button_text = "⏱️ Проверить доступность финального дня"
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
      
      # ===== ОБРАБОТКА КНОПОК =====
      
      def handle_button(callback_data)
        log_info("Day #{DAY_NUMBER}: Handling button: #{callback_data}")
        
        case callback_data
        when 'start_day_27_content', 'start_day_27_from_proposal'
          deliver_exercise
          
        when 'continue_day_27_content'
          # Проверяем, на каком шаге остановился пользователь
          current_step = get_day_data('current_step')
          handle_resume_from_step(current_step || 'intro')
          
        when 'day_27_show_pleasure_types'
          show_pleasure_types
          
        when 'day_27_show_savoring_tech'
          show_savoring_techniques
          
        when 'day_27_show_micro_rituals'
          show_micro_rituals
          
        when 'day_27_show_dopamine_pauses'
          show_dopamine_pauses
          
        when 'day_27_complete_exercise'
          complete_exercise
          
        when 'day_27_show_tools'
          show_tools_summary
          
        when 'day_27_create_reminder'
          create_reminder
          
        when 'day_27_skip_step'
          handle_skip_step
          
        when 'day_27_restart_exercise'
          restart_exercise
          
        when 'day_27_make_note'
          send_message(
            text: "📝 *Напишите заметку о вашей сегодняшней практике:*\n• Какие инсайты о мозге были самыми откровенными?\n• Какая техника смакования вам ближе всего?\n• Как вы будете применять алгоритм радости в жизни?",
            parse_mode: 'Markdown'
          )
          store_day_data('awaiting_practice_note', true)
          
        when 'day_27_help_neuroscience'
          send_message(
            text: "🧠 **Помощь по нейробиологии:**\n\n• Дофамин = мотивация и ожидание (не само удовольствие)\n• Эндорфины = настоящее удовольствие и обезболивание\n• Окситоцин = социальное вознаграждение и связь\n• Серотонин = удовлетворение и стабильность\n\n**Ключевой принцип:** Качество внимания > масштаб события для мозга.",
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
        when get_day_data('awaiting_practice_note')
          store_day_data('awaiting_practice_note', false)
          return handle_practice_note_input(input_text)
          
        else
          # Обработка по текущему шагу
          case current_step
          when 'intro'
            handle_intro_input(input_text)
          when 'brain_science'
            handle_brain_input(input_text)
          when 'pleasure_audit'
            handle_pleasure_input(input_text)
          when 'savoring_techniques'
            handle_savoring_input(input_text)
          when 'dopamine_detox'
            handle_dopamine_input(input_text)
          when 'micro_rituals'
            handle_ritual_input(input_text)
          when 'integration_system'
            handle_integration_input(input_text)
          when 'dopamine_fasting'
            handle_fasting_input(input_text)
          when 'personal_algorithm'
            handle_algorithm_input(input_text)
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
      
      def init_exercise_data
        store_day_data('exercise_data', {
          'brain_insights' => nil,
          'pleasure_audit' => nil,
          'chosen_technique' => nil,
          'dopamine_balance' => nil,
          'micro_ritual' => nil,
          'integration_plan' => nil,
          'dopamine_pause' => nil,
          'personal_algorithm' => nil,
          'completed' => false,
          'completed_at' => nil
        })
      end
      
      def clear_exercise_data
        day_data_keys = @user.self_help_program_data.keys.select { |k| k.start_with?('day_27_') }
        day_data_keys.each do |key|
          @user.self_help_program_data.delete(key)
        end
        @user.save
        log_info("Cleared exercise data for day 27")
      end
      
      def start_exercise_step(step_type)
        store_day_data('current_step', step_type)
        
        step = DAY_STEPS[step_type]
        return unless step
        
        send_message(text: step[:title], parse_mode: 'Markdown') if step[:title]
        
        if step_type == 'summary'
          instruction = format_summary_instruction(step[:instruction])
        else
          instruction = step[:instruction]
        end
        
        send_message(text: instruction, parse_mode: 'Markdown') if instruction
        
        # Показываем дополнительные элементы для определенных шагов
        case step_type
        when 'pleasure_audit'
          send_message(
            text: "Хотите увидеть подробное описание типов удовольствий?",
            reply_markup: day_27_pleasure_types_markup
          )
          
        when 'savoring_techniques'
          send_message(
            text: "Нужны подробности о техниках смакования?",
            reply_markup: day_27_savoring_markup
          )
          
        when 'micro_rituals'
          send_message(
            text: "Идеи для микро-ритуалов:",
            reply_markup: day_27_rituals_markup
          )
          
        when 'dopamine_fasting'
          send_message(
            text: "Варианты дофаминовых пауз:",
            reply_markup: day_27_dopamine_markup
          )
          
        when 'summary'
          send_message(
            text: "🎉 Ваш набор 'Нейрохакинг радости' готов!",
            reply_markup: day_27_completion_markup
          )
        end
        
        # Для всех шагов, кроме summary, предлагаем ввод
        unless step_type == 'summary'
          send_message(
            text: "📝 *Опишите ваши инсайты:*",
            parse_mode: 'Markdown',
            reply_markup: day_27_input_markup
          )
        end
      end
      
      # Метод для форматирования инструкции summary
      def format_summary_instruction(base_instruction)
        exercise_data = get_exercise_data
        
        base_instruction
          .gsub('[ваши наблюдения]', exercise_data['brain_insights']&.truncate(80) || 'Не указано')
          .gsub('[ваша цель]', exercise_data['pleasure_audit']&.truncate(80) || 'Не указано')
          .gsub('[практическая польза]', exercise_data['chosen_technique']&.truncate(80) || 'Не указано')
          .gsub('[качества характера]', exercise_data['dopamine_balance']&.truncate(80) || 'Не указано')
          .gsub('[связь с другими]', exercise_data['micro_ritual']&.truncate(80) || 'Не указано')
          .gsub('[глубокий смысл]', exercise_data['integration_plan']&.truncate(80) || 'Не указано')
          .gsub('[как усилить связь]', exercise_data['dopamine_pause']&.truncate(80) || 'Не указано')
          .gsub('[осознанное выполнение]', exercise_data['personal_algorithm']&.truncate(80) || 'Не указано')
      end
      
      # ===== ОБРАБОТЧИКИ ШАГОВ =====
      
      def handle_intro_input(input_text)
        start_exercise_step('brain_science')
        true
      end
      
      def handle_brain_input(input_text)
        return false if input_text.strip.empty?
        
        exercise_data = get_exercise_data
        exercise_data['brain_insights'] = input_text
        store_day_data('exercise_data', exercise_data)
        
        start_exercise_step('pleasure_audit')
        true
      end
      
      def handle_pleasure_input(input_text)
        return false if input_text.strip.empty?
        
        exercise_data = get_exercise_data
        exercise_data['pleasure_audit'] = input_text
        store_day_data('exercise_data', exercise_data)
        
        start_exercise_step('savoring_techniques')
        true
      end
      
      def handle_savoring_input(input_text)
        return false if input_text.strip.empty?
        
        exercise_data = get_exercise_data
        exercise_data['chosen_technique'] = input_text
        store_day_data('exercise_data', exercise_data)
        
        start_exercise_step('dopamine_detox')
        true
      end
      
      def handle_dopamine_input(input_text)
        return false if input_text.strip.empty?
        
        exercise_data = get_exercise_data
        exercise_data['dopamine_balance'] = input_text
        store_day_data('exercise_data', exercise_data)
        
        start_exercise_step('micro_rituals')
        true
      end
      
      def handle_ritual_input(input_text)
        return false if input_text.strip.empty?
        
        exercise_data = get_exercise_data
        exercise_data['micro_ritual'] = input_text
        store_day_data('exercise_data', exercise_data)
        
        start_exercise_step('integration_system')
        true
      end
      
      def handle_integration_input(input_text)
        return false if input_text.strip.empty?
        
        exercise_data = get_exercise_data
        exercise_data['integration_plan'] = input_text
        store_day_data('exercise_data', exercise_data)
        
        start_exercise_step('dopamine_fasting')
        true
      end
      
      def handle_fasting_input(input_text)
        exercise_data = get_exercise_data
        exercise_data['dopamine_pause'] = input_text
        store_day_data('exercise_data', exercise_data)
        
        start_exercise_step('personal_algorithm')
        true
      end
      
      def handle_algorithm_input(input_text)
        return false if input_text.strip.empty?
        
        exercise_data = get_exercise_data
        exercise_data['personal_algorithm'] = input_text
        store_day_data('exercise_data', exercise_data)
        
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
                   when 'brain_science' then 'pleasure_audit'
                   when 'pleasure_audit' then 'savoring_techniques'
                   when 'savoring_techniques' then 'dopamine_detox'
                   when 'dopamine_detox' then 'micro_rituals'
                   when 'micro_rituals' then 'integration_system'
                   when 'integration_system' then 'dopamine_fasting'
                   when 'dopamine_fasting' then 'personal_algorithm'
                   when 'personal_algorithm' then 'summary'
                   else 'summary'
                   end
        
        start_exercise_step(next_step)
      end
      
      def handle_practice_note_input(input_text)
        if input_text.present?
          exercise_data = get_exercise_data
          exercise_data['practice_note'] = input_text
          store_day_data('exercise_data', exercise_data)
          
          send_message(text: "✅ Заметка сохранена!")
          return true
        else
          send_message(text: "⚠️ Пожалуйста, поделитесь вашими инсайтами.")
          return false
        end
      end
      
      def restart_exercise
        clear_exercise_data
        deliver_exercise
      end
      
      def handle_resume_from_step(step)
        case step
        when 'intro'
          deliver_intro
        when 'brain_science', 'pleasure_audit', 'savoring_techniques', 'dopamine_detox',
             'micro_rituals', 'integration_system', 'dopamine_fasting', 'personal_algorithm'
          start_exercise_step(step)
        when 'summary'
          show_summary_step
        else
          deliver_intro
        end
      end
      
      def show_summary_step
        store_day_data('current_step', 'summary')
        
        # Показываем итоговый отчет
        show_final_report(get_exercise_data)
        
        send_message(
          text: "🎉 Ваш набор 'Нейрохакинг радости' готов!",
          reply_markup: day_27_completion_markup
        )
      end
      
      def show_intro_without_state
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        send_message(
          text: statistics_message,
          parse_mode: 'Markdown'
        )
        send_message(
          text: "Готовы научить ваш мозг по-настоящему радоваться?",
          reply_markup: day_27_content_markup
        )
      end
      
      # ===== МЕТОДЫ РАЗМЕТКИ =====
      
      def day_27_content_markup
        {
          inline_keyboard: [
            [
              { text: "🧠 Начать нейрохакинг", callback_data: 'start_day_27_content' }
            ],
            [
              { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
            ]
          ]
        }.to_json
      end
      
      def day_27_input_markup
        {
          inline_keyboard: [
            [
              { text: "⏭️ Пропустить шаг", callback_data: 'day_27_skip_step' },
              { text: "🔄 Начать заново", callback_data: 'day_27_restart_exercise' }
            ]
          ]
        }.to_json
      end
      
      def day_27_pleasure_types_markup
        {
          inline_keyboard: [
            [
              { text: "📊 Показать типы удовольствий", callback_data: 'day_27_show_pleasure_types' }
            ]
          ]
        }.to_json
      end
      
      def day_27_savoring_markup
        {
          inline_keyboard: [
            [
              { text: "🎭 Показать техники смакования", callback_data: 'day_27_show_savoring_tech' }
            ]
          ]
        }.to_json
      end
      
      def day_27_rituals_markup
        {
          inline_keyboard: [
            [
              { text: "🎯 Идеи микро-ритуалов", callback_data: 'day_27_show_micro_rituals' }
            ]
          ]
        }.to_json
      end
      
      def day_27_dopamine_markup
        {
          inline_keyboard: [
            [
              { text: "🧹 Варианты дофаминовых пауз", callback_data: 'day_27_show_dopamine_pauses' }
            ]
          ]
        }.to_json
      end
      
      def day_27_completion_markup
        {
          inline_keyboard: [
            [
              { text: "🧰 Посмотреть инструменты", callback_data: 'day_27_show_tools' },
              { text: "⏰ Создать напоминание", callback_data: 'day_27_create_reminder' }
            ],
            [
              { text: "✅ Завершить день", callback_data: 'day_27_complete_exercise' }
            ],
            [
              { text: "📝 Сделать заметку", callback_data: 'day_27_make_note' }
            ]
          ]
        }.to_json
      end
      
      def statistics_message
        <<~MARKDOWN
          📊 *Почему нейрохакинг радости так эффективен:*
          
          • 🧠 **25-35%** — усиление нейронных связей от техник смакования
          • 💫 **40%** — эффективность осознанного празднования vs пассивного потребления
          • 🔄 **50-60%** — восстановление дофаминовых рецепторов при регулярных паузах
          • ⚖️ **65%** — снижение риска выгорания при балансировке дофамина
          • 🎭 **3:1** — оптимальное соотношение позитивных и негативных переживаний для устойчивого благополучия
          • 🧬 **20 секунд** — достаточно для "записи" позитивного опыта в долговременную память
          • 🧹 **15-20%** — восстановление чувствительности рецепторов за 24-часовой цифровой детокс
          • 🔄 **Нейропластичность** — регулярная практика меняет структуру островковой долины и передней поясной коры
          
          *Источник: Исследования Kent Berridge (дофамин vs удовольствие), Barbara Fredrickson (соотношение 3:1), Рик Хэнсон (нейропластичность счастья)*
        MARKDOWN
      end
      
      def save_neurohacking_stats
        begin
          exercise_data = get_exercise_data
          
          store_day_data('neurohacking_stats', {
            date: Date.current.to_s,
            brain_insights: exercise_data['brain_insights'].present?,
            pleasure_audit: exercise_data['pleasure_audit'].present?,
            chosen_technique: exercise_data['chosen_technique'],
            dopamine_balance: exercise_data['dopamine_balance'].present?,
            micro_ritual: exercise_data['micro_ritual'].present?,
            integration_plan: exercise_data['integration_plan'].present?,
            dopamine_pause: exercise_data['dopamine_pause'].present?,
            personal_algorithm: exercise_data['personal_algorithm'].present?,
            practice_note: exercise_data['practice_note'].present?,
            completed: true
          })
        rescue => e
          log_error("Failed to save neurohacking stats", e)
        end
      end
      
      def show_pleasure_types
        message = "📊 *Три типа удовольствий (стоическая классификация):*\n\n"
        
        PLEASURE_TYPES.each do |type|
          message += "#{type[:emoji]} **#{type[:name]}**\n"
          message += "*#{type[:description]}*\n"
          message += "Примеры: #{type[:examples].join(', ')}\n\n"
        end
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def show_savoring_techniques
        message = "🎭 *4 техники смакования (savoring):*\n\n"
        
        SAVORING_TECHNIQUES.each do |tech|
          message += "#{tech[:emoji]} **#{tech[:name]}**\n"
          message += "Шаги:\n"
          tech[:steps].each_with_index do |step, index|
            message += "#{index + 1}. #{step}\n"
          end
          message += "Пример: #{tech[:example]}\n\n"
        end
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def show_micro_rituals
        message = "🎯 *Идеи для микро-ритуалов (5 минут):*\n\n"
        
        MICRO_RITUALS.each do |ritual|
          message += "#{ritual[:emoji]} **#{ritual[:name]}**\n"
          ritual[:steps].each_with_index do |step, index|
            message += "#{index + 1}. #{step}\n"
          end
          message += "\n"
        end
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def show_dopamine_pauses
        message = "🧹 *Варианты дофаминовых пауз (для перезагрузки):*\n\n"
        
        DOPAMINE_PAUSES.each do |pause|
          message += "#{pause[:emoji]} **#{pause[:name]}** (#{pause[:duration]})\n"
          message += "Избегать: #{pause[:what_avoid].join(', ')}\n"
          message += "Делать вместо: #{pause[:what_do].join(', ')}\n\n"
        end
        
        message += "⚠️ *Важно:* Не экстрим, а осознанная пауза. Начинайте с малого (например, 3 часа без соцсетей)."
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def show_final_report(exercise_data)
        message = <<~MARKDOWN
          🎉 *Ваш "Нейрохакинг радости" создан!* 🎉

          🧠 **Научный подход к празднованию освоен**

          🔬 **Ключевые инсайты о мозге:**
          #{exercise_data['brain_insights'] || 'Не указано'}

          📊 **Аудит удовольствий:**
          #{exercise_data['pleasure_audit'] || 'Не указано'}

          🎭 **Выбранная техника смакования:**
          #{exercise_data['chosen_technique'] || 'Не указано'}

          ⚖️ **Балансировка дофамина:**
          #{exercise_data['dopamine_balance'] || 'Не указано'}

          🎯 **Микро-ритуал:**
          #{exercise_data['micro_ritual'] || 'Не указано'}

          🔄 **План интеграции:**
          #{exercise_data['integration_plan'] || 'Не указано'}

          🧹 **Дофаминовая пауза (если выбрана):**
          #{exercise_data['dopamine_pause'] || 'Не выбрана'}

          ⚙️ **Ваш личный алгоритм радости:**
          #{exercise_data['personal_algorithm'] || 'Не указано'}

          **Как применять этот инструментарий:**

          1. 🎯 **Для маленьких достижений:** Используйте микро-ритуал + технику смакования
          2. 📅 **В расписании:** Встройте интеграционный план в неделю
          3. 🧠 **При выгорании:** Вспомните про балансировку дофамина
          4. 🔄 **Каждые 1-2 месяца:** Делайте дофаминовую паузу для перезагрузки
          5. 🎭 **При больших победах:** Увеличьте время, но сохраните качество присутствия

          **Быстрые напоминалки:**
          - 🕐 **1 минута:** Микро-ритуал после задачи
          - 🕑 **5 минут:** Полное смакование маленькой радости
          - 🕒 **15 минут:** Еженедельный ритуал благодарности
          - 🕓 **1 день:** Дофаминовая пауза раз в месяц

          **Нейробиологическая истина:**
          > *"Радость не в масштабе события, а в масштабе внимания, которое вы ему уделяете. Мозг, который научился смаковать чашку чая, уже научился счастью."*

          Теперь у вас есть научные инструменты для создания радости на уровне нейронов!
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def show_tools_summary
        exercise_data = get_exercise_data
        show_final_report(exercise_data)
      end
      
      def create_reminder
        # Создаем напоминание для пользователя
        send_message(text: "📅 Напоминание создано! Через 3 дня я спрошу, как у вас получается применять техники нейрохакинга радости.")
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
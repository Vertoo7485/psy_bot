# app/services/self_help/days/day_2_service.rb
module SelfHelp
  module Days
    class Day2Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 2
      
      # Шаги дня 2
      DAY_STEPS = {
        'intro' => {
          title: "🎯 *День 2: Связь с телом через сканирование* 🎯",
          instruction: <<~MARKDOWN
            **Откройте для себя язык своего тела**
            
            Сегодня мы будем учиться слушать и понимать сигналы тела через технику *сканирования тела* (body scan).

            🧠 **Научная основа:**
            • Исследования показывают, что 70% стресса проявляется сначала в теле
            • Сканирование тела снижает активность миндалевидного тела (центра страха)
            • Увеличивает связь между префронтальной корой и соматосенсорными зонами
            • Уменьшает хронические боли и мышечные зажимы у 60% практикующих

            💪 **Что вы получите сегодня:**
            1. 🔍 Навык раннего обнаружения стресса
            2. 😌 Снижение хронического мышечного напряжения
            3. 🧭 Улучшение связи «мозг-тело»
            4. 🛡️ Инструмент мгновенного заземления

            ⏱️ **Время практики:** 10-15 минут
            🎯 **Сложность:** Подходит для начинающих
          MARKDOWN
        },
        'preparation' => {
          title: "🛋️ *Подготовка к сканированию тела* 🛋️",
          instruction: <<~MARKDOWN
            **Оптимальные условия для практики:**

            🪑 **Положение тела:**
            • Лягте на спину (на коврик, кровать или пол)
            • Руки вдоль тела, ладонями вверх или вниз
            • Ноги на ширине плеч, расслаблены
            • Можно использовать подушку под голову и колени

            ⏰ **Время и место:**
            • Выберите время, когда вас не побеспокоят 10-15 минут
            • Отключите уведомления на телефоне
            • Убедитесь в комфортной температуре (можно укрыться пледом)
            • Приглушенный свет или темнота помогают концентрации

            🧘 **Дыхание перед началом:**
            1. Сделайте 3 глубоких вдоха и выдоха
            2. Почувствуйте контакт тела с поверхностью
            3. Отпустите все ожидания от практики
            4. Примите установку наблюдателя: «Я просто замечаю, что есть»

            **Важно:** Нет «правильной» или «неправильной» практики. Даже если ум часто отвлекается — это нормально!
          MARKDOWN
        },
        'instruction' => {
          title: "🧭 *Как выполнять сканирование тела* 🧭",
          instruction: <<~MARKDOWN
            **Пошаговое руководство:**

            🎯 **Принцип:** Медленное движение внимания по всему телу, часть за частью.

            🔄 **Маршрут сканирования:**
            1. Макушка головы → лоб → лицо
            2. Шея → плечи → верхняя часть спины
            3. Руки (плечи → локти → запястья → кисти → пальцы)
            4. Грудная клетка → живот → поясница
            5. Таз → ягодицы → бедра → колени
            6. Голени → лодыжки → стопы → пальцы ног

            🎨 **Что замечать в каждой части:**
            • 🌡️ Температура (тепло/холод/нейтрально)
            • 💪 Напряжение/расслабление
            • ⚖️ Вес/легкость
            • 🌊 Пульсация/вибрация/покалывание
            • 🕳️ Ощущение пустоты/наполненности

            🧠 **Установка ума:**
            • Не пытайтесь что-то изменить
            • Не оценивайте ощущения как «хорошие» или «плохие»
            • Если ум отвлекся — мягко верните внимание к телу
            • Каждое возвращение внимания — это успех практики!
          MARKDOWN
        },
        'reflection' => {
          title: "📝 *Рефлексия после практики* 📝",
          instruction: <<~MARKDOWN
            **Отличная работа! Вы только что завершили сканирование тела!** 🌟

            **Вопросы для самоанализа:**

            🌡️ **1. О телесных ощущениях:**
            • Какие части тела ощущались наиболее ясно?
            • Были ли зоны неожиданного напряжения или расслабления?
            • Заметили ли вы разницу температуры в разных частях тела?

            🧠 **2. Об уме и внимании:**
            • Как часто ум отвлекался от тела?
            • Куда чаще всего убегали мысли?
            • Как быстро вы замечали, что отвлеклись?

            ⚡ **3. О сложностях и открытиях:**
            • Что было самым легким в практике?
            • Что оказалось самым сложным?
            • Как изменилось ваше состояние от начала к концу?

            💭 **4. Для интеграции в жизнь:**
            • В какие моменты дня могло бы помочь быстрое сканирование?
            • Какие сигналы тела вы хотели бы замечать чаще?
            • Какую одну часть тела вы бы взяли «на мониторинг» завтра?

            **Запомните:** Ответы нужны только вам. Нет правильных или неправильных ощущений!
          MARKDOWN
        }
      }.freeze
      
      # Типичные трудности в сканировании тела
      COMMON_CHALLENGES = [
        {
          challenge: "Засыпаю во время практики",
          emoji: "😴",
          solution: "Это нормально! Тело расслабляется. Попробуйте практиковать сидя или в более активное время суток."
        },
        {
          challenge: "Не чувствую некоторых частей тела",
          emoji: "🌫️",
          solution: "Просто заметьте это отсутствие ощущений. Иногда тело «молчит» — это тоже информация."
        },
        {
          challenge: "Возникают неприятные ощущения или боль",
          emoji: "😣",
          solution: "Не усиливайте внимание на боли. Просто признайте её наличие и мягко переходите к следующей части тела."
        },
        {
          challenge: "Ум постоянно анализирует, а не ощущает",
          emoji: "💭",
          solution: "Переключитесь с мыслей «что это?» на простой вопрос «как это ощущается?». Язык ощущений, а не анализа."
        }
      ].freeze
      
      # Советы для повседневного использования
      DAILY_TIPS = [
        {
          tip: "Микро-сканирование",
          emoji: "⚡",
          description: "3 раза в день на 1 минуту: стопы → живот → лицо. Быстрая проверка состояния."
        },
        {
          tip: "Перед сложным разговором",
          emoji: "💬",
          description: "30 секунд на плечи и живот. Снижает реактивность."
        },
        {
          tip: "При тревоге",
          emoji: "🌀",
          description: "Сосредоточьтесь на ощущениях в стопах и ладонях. Помогает заземлиться."
        },
        {
          tip: "Для улучшения сна",
          emoji: "🌙",
          description: "Лежа в постели, медленно просканируйте тело от ног к голове."
        }
      ].freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        store_day_data('current_step', 'intro')
        
        send_message(
          text: "Готовы подготовиться к сканированию тела?",
          reply_markup: {
            inline_keyboard: [
              [{ text: "✅ Да, продолжаем", callback_data: "continue_day_2_content" }]
            ]
          }
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'preparation')
        
        send_message(text: DAY_STEPS['preparation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['preparation'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "📋 **Проверьте готовность:**",
          parse_mode: 'Markdown',
          reply_markup: {
            inline_keyboard: [
              [{ text: "✅ Всё готово", callback_data: "day_2_ready_for_instruction" }],
              [{ text: "⏸️ Нужно подготовиться", callback_data: "day_2_need_more_time" }]
            ]
          }
        )
      end
      
      def show_instruction
        store_day_data('current_step', 'instruction')
        
        send_message(text: DAY_STEPS['instruction'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['instruction'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "🎧 **Выберите формат практики:**",
          parse_mode: 'Markdown',
          reply_markup: {
            inline_keyboard: [
              [
                { text: "🎵 Аудио-медитация", callback_data: "day_2_audio_meditation" },
                { text: "📝 Текстовая версия", callback_data: "day_2_text_version" }
              ],
              [
                { text: "❓ Сначала советы", callback_data: "day_2_show_tips_first" }
              ]
            ]
          }
        )
      end
      
      def start_audio_meditation
        store_day_data('practice_format', 'audio')
        
        # Пробуем отправить аудио
        audio_sent = send_body_scan_audio
        
        if audio_sent
          send_message(
            text: "🎵 *Аудио-медитация отправлена!* 🎵\n\nСледуйте инструкциям в аудио. Практика займет 10-15 минут.",
            parse_mode: 'Markdown'
          )
        else
          send_message(
            text: "⚠️ *Не удалось отправить аудио* ⚠️\n\nИспользуем текстовую версию:",
            parse_mode: 'Markdown'
          )
          show_text_meditation
          return
        end
        
        send_message(
          text: "Когда закончите медитацию, нажмите:",
          reply_markup: {
            inline_keyboard: [
              [{ text: "✅ Завершил(а) практику", callback_data: "day_2_practice_complete" }],
              [{ text: "🔄 Повторить инструкцию", callback_data: "day_2_repeat_instruction" }]
            ]
          }
        )
      end
      
      def show_text_meditation
        store_day_data('practice_format', 'text')
        
        text_instruction = <<~MARKDOWN
          🧘 *Текстовая версия сканирования тела* 🧘

          **Начинаем практику (10-15 минут):**

          1. 🛌 Лягте удобно, закройте глаза
          2. 🌬️ 3 глубоких вдоха и выдоха
          3. ⏳ Начинаем сканирование...

          **Медленно перемещайте внимание:**
          
          👉 **ГОЛОВА (2 минуты):**
          • Макушка → лоб → брови → глаза
          • Щеки → нос → губы → подбородок
          • Уши → затылок → вся голова целиком
          
          👉 **ШЕЯ И ПЛЕЧИ (2 минуты):**
          • Передняя часть шеи → задняя
          • Левое плечо → правое плечо
          • Верхняя часть спины между лопаток
          
          👉 **РУКИ (3 минуты):**
          • Плечи → локти → предплечья
          • Запястья → ладони → пальцы
          • Обратите внимание: левая и правая рука могут ощущаться по-разному
          
          👉 **ТОРС (2 минуты):**
          • Грудная клетка → живот
          • Поясница → бока
          • Дыхание: как движется тело при вдохе и выдохе?
          
          👉 **НОГИ (3 минуты):**
          • Бедра → колени → голени
          • Лодыжки → стопы → пальцы ног
          • Вес ног на поверхности
          
          👉 **ЗАВЕРШЕНИЕ (1 минута):**
          • Все тело целиком как единое целое
          • Общее ощущение присутствия
          • Медленно откройте глаза

          ⏱️ **Не торопитесь!** Лучше медленнее, но с осознанием.
        MARKDOWN
        
        send_message(text: text_instruction, parse_mode: 'Markdown')
        
        send_message(
          text: "Когда закончите практику, нажмите:",
          reply_markup: {
            inline_keyboard: [
              [{ text: "✅ Завершил(а) практику", callback_data: "day_2_practice_complete" }],
              [{ text: "⏰ Установить таймер", callback_data: "day_2_set_timer" }]
            ]
          }
        )
      end
      
      def show_reflection
        store_day_data('current_step', 'reflection')
        
        send_message(text: DAY_STEPS['reflection'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['reflection'][:instruction], parse_mode: 'Markdown')
        
        # Генерируем кнопки для трудностей динамически
        challenge_buttons = COMMON_CHALLENGES.each_with_index.map do |challenge, index|
          [{ text: "#{challenge[:emoji]} #{challenge[:challenge]}", callback_data: "day_2_challenge_#{index}" }]
        end
        
        challenge_buttons << [{ text: "✅ Никаких трудностей", callback_data: "day_2_no_challenges" }]
        
        send_message(
          text: "🤔 *С какими трудностями столкнулись?*",
          parse_mode: 'Markdown',
          reply_markup: { inline_keyboard: challenge_buttons }
        )
      end
      
      def handle_challenge_selection(challenge_index)
        challenge = COMMON_CHALLENGES[challenge_index.to_i]
        
        if challenge
          send_message(
            text: "💡 **#{challenge[:challenge]}**\n\n#{challenge[:solution]}",
            parse_mode: 'Markdown'
          )
        end
        
        show_daily_tips
      end
      
      def show_daily_tips
        tips_text = <<~MARKDOWN
          🎯 *Как использовать сканирование тела в повседневной жизни:*

          Вот простые способы интегрировать практику в ваш день:
        MARKDOWN
        
        send_message(text: tips_text, parse_mode: 'Markdown')
        
        DAILY_TIPS.each do |tip|
          send_message(
            text: "#{tip[:emoji]} **#{tip[:tip]}**\n#{tip[:description]}",
            parse_mode: 'Markdown'
          )
        end
        
        send_message(
          text: "🌟 Отлично! Вы завершили День 2!\n\nЗавершаем день?",
          reply_markup: {
            inline_keyboard: [
              [{ text: "✅ Завершить День 2", callback_data: "day_2_complete_exercise" }],
              [{ text: "📝 Сделать заметку", callback_data: "day_2_make_note" }],
              [{ text: "🔄 Повторить практику", callback_data: "day_2_restart_practice" }]
            ]
          }
        )
      end
      
      def complete_exercise
        # Отмечаем день как завершенный
        @user.complete_self_help_day(DAY_NUMBER)
        
        completion_message = <<~MARKDOWN
          🎉 *День 2 завершен!* 🎉

          **Вы освоили:**
          • 🧘 Технику сканирования тела
          • 🔍 Навык осознания телесных сигналов
          • 😌 Инструмент для мгновенного расслабления
          
          ⏰ **Следующий день будет доступен через 12 часов**
          
          *Совет:* Попробуйте сегодня вечером перед сном быстрый 3-минутный вариант сканирования.
        MARKDOWN
        
        send_message(text: completion_message, parse_mode: 'Markdown')
        
        # Предлагаем следующий день
        propose_next_day_with_restriction
      end
      
      # ===== ОБРАБОТКА КНОПОК =====
      
      def handle_button(callback_data)
        case callback_data
        when 'continue_day_2_content', 'start_day_2_from_proposal'
          deliver_exercise
          
        when 'day_2_skip_to_preparation'
          show_instruction
          
        when 'day_2_ready_for_instruction'
          show_instruction
          
        when 'day_2_need_more_time'
          send_message(
            text: "⏱️ *Возьмите время на подготовку*\n\nКогда будете готовы, нажмите кнопку:",
            parse_mode: 'Markdown',
            reply_markup: {
              inline_keyboard: [
                [{ text: "✅ Готов(а) продолжить", callback_data: "day_2_ready_for_instruction" }]
              ]
            }
          )
          
        when 'day_2_audio_meditation'
          start_audio_meditation
          
        when 'day_2_text_version'
          show_text_meditation
          
        when 'day_2_show_tips_first'
          show_common_tips
          
        when 'day_2_practice_complete'
          show_reflection
          
        when 'day_2_repeat_instruction'
          show_instruction
          
        when 'day_2_set_timer'
          send_message(
            text: "⏰ Установите таймер на 10-15 минут на телефоне или умных часах.",
            reply_markup: {
              inline_keyboard: [
                [{ text: "✅ Таймер установлен", callback_data: "day_2_timer_set" }]
              ]
            }
          )
          
        when 'day_2_timer_set'
          show_text_meditation
          
        when /^day_2_challenge_(\d+)$/
          handle_challenge_selection($1)
          
        when 'day_2_no_challenges'
          show_daily_tips
          
        when 'day_2_complete_exercise'
          complete_exercise
          
        when 'day_2_make_note'
          send_message(text: "📝 Напишите заметку о вашей практике (можно в свободной форме):")
          store_day_data('awaiting_practice_note', true)
          
        when 'day_2_restart_practice'
          deliver_exercise
          
        else
          log_warn("Unknown button callback: #{callback_data}")
          send_message(text: "Неизвестная команда. Используйте кнопки меню.")
        end
      end
      
      # Обработка текстового ввода (только для заметок)
      def handle_text_input(input_text)
        if get_day_data('awaiting_practice_note')
          store_day_data('awaiting_practice_note', false)
          
          send_message(text: "📝 *Заметка сохранена!*\n\nСпасибо за рефлексию.", parse_mode: 'Markdown')
          
          send_message(
            text: "Завершаем День 2?",
            reply_markup: {
              inline_keyboard: [
                [{ text: "✅ Завершить День 2", callback_data: "day_2_complete_exercise" }]
              ]
            }
          )
          return true
        end
        
        false
      end
      
      private
      
      def handle_resume_from_step(step)
        case step
        when 'intro'
          deliver_intro
        when 'preparation'
          deliver_exercise
        when 'instruction'
          show_instruction
        when 'reflection'
          show_reflection
        else
          deliver_intro
        end
      end
      
      def send_body_scan_audio
        audio_file_path = Rails.root.join('public', 'assets', 'audio', 'body_scan.mp3')
        
        # Проверяем существование файла
        unless File.exist?(audio_file_path)
          log_error("Audio file not found: #{audio_file_path}")
          return false
        end
        
        begin
          @bot_service.bot.send_audio(
            chat_id: @chat_id,
            audio: File.open(audio_file_path),
            caption: "🧘 *Сканирование тела (10-15 минут)* 🧘\n\nСледуйте инструкциям в аудио. Практикуйте в удобном положении.",
            parse_mode: 'Markdown'
          )
          true
        rescue => e
          log_error("Failed to send audio", e)
          false
        end
      end
      
      def show_common_tips
        tips = <<~MARKDOWN
          💡 *Советы для успешной практики:*

          1. 🕰️ **Не спешите** - лучше медленное осознанное движение, чем быстрая «пробежка»
          2. 🎯 **Без цели** - не стремитесь к расслаблению, просто замечайте что есть
          3. 🔄 **Доброта к себе** - если ум отвлекся 100 раз, верните внимание 100 раз
          4. 🌡️ **Комфорт прежде всего** - если положение неудобно, поменяйте его
          5. 🧠 **Исследователь, а не судья** - «интересно, что я чувствую» вместо «я должен чувствовать...»
        MARKDOWN
        
        send_message(text: tips, parse_mode: 'Markdown')
        
        send_message(
          text: "Готовы выбрать формат практики?",
          reply_markup: {
            inline_keyboard: [
              [
                { text: "🎵 Аудио-медитация", callback_data: "day_2_audio_meditation" },
                { text: "📝 Текстовая версия", callback_data: "day_2_text_version" }
              ]
            ]
          }
        )
      end
      
      def propose_next_day_with_restriction
        next_day = 3
        
        # Проверяем, можно ли начать следующий день
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ✅ *Доступен сейчас!*
            
            **Что вас ждет:**
            • 🙏 Практика благодарности
            • 📝 Ведение дневника благодарностей
            • 🧠 Научные основы влияния благодарности на мозг
            • 💫 Как благодарность меняет восприятие жизни
            
            Вы можете начать следующий день прямо сейчас.
          MARKDOWN
          
          button_text = "🚀 Начать День #{next_day}"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ⏱️ *Ограничение:* #{error_message}
            
            **Пока ждете, можете:**
            • 🧘 Повторить сканирование тела
            • 📝 Сделать заметку о сегодняшней практике
            • 📊 Посмотреть статистику (/progress)
            • 😌 Применить быстрый вариант сканирования (3 минуты)
          MARKDOWN
          
          button_text = "⏱️ Проверить доступность Дня #{next_day}"
        end
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Нажмите кнопку:",
          reply_markup: {
            inline_keyboard: [
              [
                { text: button_text, callback_data: "start_day_#{next_day}_from_proposal" }
              ]
            ]
          }
        )
      end
      
      def log_warn(message)
        Rails.logger.warn "[#{self.class}] #{message} - User: #{@user.telegram_id}"
      end
    end
  end
end
# app/services/self_help/days/day_3_service.rb
module SelfHelp
  module Days
    class Day3Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 3
      GRATITUDE_ITEMS_COUNT = 3
      MAX_GRATITUDE_TEXT_LENGTH = GratitudeEntry::MAX_ENTRY_TEXT_LENGTH
      
      # Шаги дня 3
      DAY_STEPS = {
        'intro' => {
          title: "🎯 *День 3: Сила благодарности* 🎯",
          instruction: <<~MARKDOWN
            **Превратите внимание в благодарность**
            
            Сегодня мы будем развивать навык замечать хорошее вокруг через технику *дневника благодарности*.

            🧠 **Научная основа:**
            • Регулярная практика благодарности увеличивает серое вещество в префронтальной коре
            • Снижает уровень кортизола (гормона стресса) на 23%
            • Увеличивает выработку дофамина и серотонина
            • Улучшает качество сна и укрепляет иммунную систему

            💫 **Что вы получите сегодня:**
            1. 🔍 Навык замечать позитивное в повседневности
            2. 😊 Повышение общего уровня счастья
            3. 🛡️ Устойчивость к стрессовым ситуациям
            4. 🤝 Улучшение отношений с окружающими

            ⏱️ **Время практики:** 5-10 минут
            🎯 **Сложность:** Подходит для всех
          MARKDOWN
        },
        'exercise' => {
          title: "📝 *Упражнение: Дневник благодарности* 📝",
          instruction: <<~MARKDOWN
            **Задание на сегодня:**

            Запишите **#{GRATITUDE_ITEMS_COUNT} вещи**, за которые вы чувствуете благодарность сегодня.

            🎯 **Категории для размышления:**

            👤 **Люди и отношения:**
            • Чья поддержка или присутствие важны для вас?
            • Кто сделал для вас что-то доброе недавно?
            • Чьи качества характера вас вдохновляют?

            🏡 **Материальное и комфорт:**
            • Что из вашего окружения делает жизнь удобнее?
            • Какие блага у вас есть (дом, еда, здоровье)?
            • Какие технологии или устройства помогают вам?

            🌟 **Личные достижения и опыт:**
            • Какие уроки вы извлекли недавно?
            • Какие возможности у вас появились?
            • Что из того, что вы умеете, ценно для вас?

            🌍 **Мир и природа:**
            • Что прекрасного вы видели сегодня?
            • Какие природные явления вас восхищают?
            • Какие простые удовольствия были в вашем дне?

            💭 **Важно:** Нет "правильных" или "неправильных" ответов. Даже маленькая благодарность за чашку горячего чая имеет значение!
          MARKDOWN
        },
        'reflection' => {
          title: "🤔 *Рефлексия после практики* 🤔",
          instruction: <<~MARKDOWN
            **Отличная работа! Вы только что завершили практику благодарности!** 🌟

            **Вопросы для самоанализа:**

            💖 **1. О чувстве благодарности:**
            • Какая из записанных благодарностей вызвала самые теплые чувства?
            • Как изменилось ваше состояние после написания списка?
            • Заметили ли вы что-то, за что раньше не благодарили?

            🧠 **2. О процессе:**
            • Как легко вам далось найти #{GRATITUDE_ITEMS_COUNT} пункта?
            • В каких категориях было проще всего найти благодарности?
            • Возникали ли трудности с формулировками?

            🔍 **3. Об открытиях:**
            • Что вас удивило в процессе?
            • Какие скрытые "сокровища" вы обнаружили в своей жизни?
            • Как эта практика может изменить ваше обычное восприятие дня?

            🌱 **4. Для интеграции в жизнь:**
            • В какое время дня удобнее всего практиковать благодарность?
            • Как можно сделать эту практику ежедневной привычкой?
            • С кем можно делиться благодарностями для усиления эффекта?

            **Запомните:** Благодарность — это мышца, которая крепнет с каждым днем практики!
          MARKDOWN
        }
      }.freeze
      
      # Типичные трудности в практике благодарности
      COMMON_CHALLENGES = [
        {
          challenge: "Не могу найти, за что быть благодарным",
          emoji: "😔",
          solution: "Начните с самого простого: крыша над головой, еда, здоровье, возможность дышать. Даже маленькие вещи имеют значение."
        },
        {
          challenge: "Чувствую, что это наигранно или формально",
          emoji: "🎭",
          solution: "Это нормально в начале. Не ждите сильных чувств. Просто констатируйте факты. Искренность придет с практикой."
        },
        {
          challenge: "Вспоминаю только одно и то же каждый день",
          emoji: "🔄",
          solution: "Попробуйте искать новые ракурсы. Вместо 'благодарен за семью' — 'благодарен за смех дочери сегодня утром'. Детали имеют значение."
        },
        {
          challenge: "Жизнь сложная, не до благодарностей",
          emoji: "🌧️",
          solution: "Именно в трудные моменты практика благодарности наиболее полезна. Она не отрицает проблемы, но добавляет баланс в восприятие."
        }
      ].freeze
      
      # Советы для повседневного использования
      DAILY_TIPS = [
        {
          tip: "Утренняя установка",
          emoji: "🌅",
          description: "Проснувшись, назовите 1 вещь, за которую благодарны. Это задает позитивный тон всему дню."
        },
        {
          tip: "Благодарность перед сном",
          emoji: "🌙",
          description: "Вечером вспомните 3 хороших события дня. Улучшает качество сна и снижает тревожность."
        },
        {
          tip: "Мгновенная благодарность",
          emoji: "⚡",
          description: "Когда случается что-то приятное, произнесите про себя 'спасибо'. Фиксируйте моменты радости сразу."
        },
        {
          tip: "Благодарность в отношениях",
          emoji: "🤝",
          description: "Раз в неделю напишите близкому человеку, за что вы ему благодарны. Укрепляет связь."
        },
        {
          tip: "Благодарность к себе",
          emoji: "💝",
          description: "Не забывайте благодарить себя за усилия, даже маленькие успехи. Самосострадание — ключ к росту."
        }
      ].freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        store_day_data('current_step', 'intro')
        
        send_message(
          text: "Готовы начать практику благодарности?",
          reply_markup: {
            inline_keyboard: [
              [{ text: "✅ Да, продолжаем", callback_data: "continue_day_3_content" }]
            ]
          }
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise')
        
        send_message(text: DAY_STEPS['exercise'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['exercise'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "📝 **Напишите ваши #{GRATITUDE_ITEMS_COUNT} благодарности одним сообщением:**\n\n*Ограничение:* #{MAX_GRATITUDE_TEXT_LENGTH} символов\n\n*Пример:*\n1. Благодарен за солнечное утро\n2. Благодарен за поддержку друга\n3. Благодарен за вкусный завтрак",
          parse_mode: 'Markdown',
          reply_markup: {
            inline_keyboard: [
              [{ text: "💡 Нужны идеи", callback_data: "day_3_show_ideas" }],
              [{ text: "📖 Мои записи", callback_data: "day_3_show_entries" }],
              [{ text: "⏸️ Напомнить позже", callback_data: "day_3_remind_later" }]
            ]
          }
        )
      end
      
      def show_gratitude_ideas
        ideas_text = <<~MARKDOWN
          💡 *Идеи для благодарности:*

          **Простые радости:**
          • Теплая постель утром
          • Вкусная еда
          • Комфортная погода
          • Любимая музыка

          **Люди:**
          • Семья, которая вас поддерживает
          • Друг, который выслушал
          • Коллега, который помог
          • Незнакомец, который улыбнулся

          **Личные качества:**
          • Умение слушать
          • Чувство юмора
          • Терпение
          • Способность учиться

          **Возможности:**
          • Доступ к знаниям (книги, интернет)
          • Возможность учиться и расти
          • Свобода выбора
          • Здоровье и энергия

          *Важно:* Даже если кажется, что благодарность слишком простая — она всё равно работает!
        MARKDOWN
        
        send_message(text: ideas_text, parse_mode: 'Markdown')
        
        send_message(
          text: "Теперь напишите ваши #{GRATITUDE_ITEMS_COUNT} благодарности:",
          reply_markup: {
            inline_keyboard: [
              [{ text: "✍️ Готов писать", callback_data: "day_3_ready_to_write" }]
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
          [{ text: "#{challenge[:emoji]} #{challenge[:challenge]}", callback_data: "day_3_challenge_#{index}" }]
        end
        
        challenge_buttons << [{ text: "✅ Никаких трудностей", callback_data: "day_3_no_challenges" }]
        
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
          🎯 *Как интегрировать благодарность в повседневную жизнь:*

          Вот простые способы сделать практику регулярной:
        MARKDOWN
        
        send_message(text: tips_text, parse_mode: 'Markdown')
        
        DAILY_TIPS.each do |tip|
          send_message(
            text: "#{tip[:emoji]} **#{tip[:tip]}**\n#{tip[:description]}",
            parse_mode: 'Markdown'
          )
        end
        
        send_message(
          text: "🌟 Отлично! Вы завершили День 3!\n\nЗавершаем день?",
          reply_markup: {
            inline_keyboard: [
              [{ text: "✅ Завершить День 3", callback_data: "day_3_complete_exercise" }],
              [{ text: "📝 Сделать заметку", callback_data: "day_3_make_note" }],
              [{ text: "🔄 Повторить практику", callback_data: "day_3_restart_practice" }]
            ]
          }
        )
      end
      
      def complete_exercise
        # Отмечаем день как завершенный
        @user.complete_self_help_day(DAY_NUMBER)
        
        completion_message = <<~MARKDOWN
          🎉 *День 3 завершен!* 🎉

          **Вы освоили:**
          • 📝 Технику ведения дневника благодарности
          • 🔍 Навык замечать позитивное в повседневности
          • 😊 Инструмент для повышения уровня счастья
          
          ⏰ **Следующий день будет доступен через 12 часов**
          
          *Совет:* Попробуйте сегодня вечером перед сном вспомнить 3 хороших события дня.
        MARKDOWN
        
        send_message(text: completion_message, parse_mode: 'Markdown')
        
        # Предлагаем следующий день
        propose_next_day_with_restriction
      end
      
      # ===== ОБРАБОТКА КНОПОК =====
      
      def handle_button(callback_data)
        case callback_data
        when 'continue_day_3_content', 'start_day_3_from_proposal'
          deliver_exercise
          
        when 'day_3_show_ideas'
          show_gratitude_ideas
          
        when 'day_3_show_entries'
          show_gratitude_entries
          
        when 'day_3_remind_later'
          send_message(
            text: "⏰ *Вернусь к вам через час*\n\nКогда будете готовы, нажмите:",
            parse_mode: 'Markdown',
            reply_markup: {
              inline_keyboard: [
                [{ text: "✅ Готов(а) продолжить", callback_data: "continue_day_3_content" }]
              ]
            }
          )
          
        when 'day_3_ready_to_write'
          send_message(
            text: "✍️ Напишите ваши #{GRATITUDE_ITEMS_COUNT} благодарности (до #{MAX_GRATITUDE_TEXT_LENGTH} символов):"
          )
          store_day_data('awaiting_gratitude_input', true)
          
        when /^day_3_challenge_(\d+)$/
          handle_challenge_selection($1)
          
        when 'day_3_no_challenges'
          show_daily_tips
          
        when 'day_3_complete_exercise'
          complete_exercise
          
        when 'day_3_make_note'
          send_message(text: "📝 Напишите заметку о вашей практике благодарности (можно в свободной форме):")
          store_day_data('awaiting_practice_note', true)
          
        when 'day_3_restart_practice'
          deliver_exercise
          
        when 'day_3_enter_gratitude'
          # Устаревшая кнопка, перенаправляем
          deliver_exercise
          
        else
          log_warn("Unknown button callback: #{callback_data}")
          send_message(text: "Неизвестная команда. Используйте кнопки меню.")
        end
      end
      
      # Обработка текстового ввода (для благодарностей и заметок)
      def handle_text_input(input_text)
        # Проверяем, ожидаем ли мы ввод благодарностей
        if get_day_data('awaiting_gratitude_input')
          return handle_gratitude_input(input_text)
        end
        
        # Проверяем, ожидаем ли мы заметку о практике
        if get_day_data('awaiting_practice_note')
          return handle_practice_note_input(input_text)
        end
        
        false
      end
      
      
      def handle_gratitude_input(input_text)
        return false if input_text.blank?
        
        # Проверяем длину текста
        if input_text.length > GratitudeEntry::MAX_ENTRY_TEXT_LENGTH
          send_message(
            text: "❌ *Слишком длинный текст*\n\nПожалуйста, сократите ваши благодарности до #{GratitudeEntry::MAX_ENTRY_TEXT_LENGTH} символов.",
            parse_mode: 'Markdown'
          )
          return true # Возвращаем true, потому что ввод обработан (хоть и с ошибкой)
        end
        
        # Сохраняем введенные благодарности в данные дня
        store_day_data('gratitude_entries', input_text)
        store_day_data('awaiting_gratitude_input', false)
        
        # Сохраняем в модель GratitudeEntry для истории
        save_gratitude_to_database(input_text)
        
        send_message(
          text: "✅ *Благодарности сохранены!*\n\nТеперь давайте поразмышляем о практике.",
          parse_mode: 'Markdown'
        )
        
        show_reflection
        true
      end

      def show_gratitude_entries
        entries = @user.gratitude_entries.recent.limit(5)
        
        if entries.empty?
          send_message(text: "📭 *У вас пока нет записей благодарности*\n\nНачните с практики Дня 3!", parse_mode: 'Markdown')
          return
        end
        
        message = "❤️ *Ваши последние записи благодарности* ❤️\n\n"
        
        entries.each_with_index do |entry, index|
          message += "*#{index + 1}. #{entry.entry_date.strftime('%d.%m.%Y')}*\n"
          message += "#{entry.entry_text}\n\n"
        end
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Хотите добавить новые благодарности?",
          reply_markup: {
            inline_keyboard: [
              [{ text: "📝 Добавить новые", callback_data: "day_3_ready_to_write" }],
              [{ text: "🏠 Главное меню", callback_data: "back_to_main_menu" }]
            ]
          }
        )
      end
      
      def handle_practice_note_input(input_text)
        store_day_data('practice_note', input_text)
        store_day_data('awaiting_practice_note', false)
        
        send_message(
          text: "📝 *Заметка сохранена!*\n\nСпасибо за рефлексию.",
          parse_mode: 'Markdown'
        )
        
        send_message(
          text: "Завершаем День 3?",
          reply_markup: {
            inline_keyboard: [
              [{ text: "✅ Завершить День 3", callback_data: "day_3_complete_exercise" }]
            ]
          }
        )
        true
      end
      
      private
      
      def fix_sequence_async
        # Фоновая задача для починки sequence
        return if Rails.env.test?
        
        Thread.new do
          begin
            max_id = GratitudeEntry.maximum(:id).to_i
            ActiveRecord::Base.connection.execute(
              "SELECT setval('gratitude_entries_id_seq', #{max_id + 1}, true)"
            )
            Rails.logger.info "Auto-fixed gratitude_entries sequence to #{max_id + 1}"
          rescue => e
            Rails.logger.error "Failed to auto-fix sequence: #{e.message}"
          end
        end
      end

      def handle_resume_from_step(step)
        case step
        when 'intro'
          deliver_intro
        when 'exercise'
          deliver_exercise
        when 'reflection'
          show_reflection
        else
          deliver_intro
        end
      end
      
      def save_gratitude_to_database(text)
        begin
          # Прямое сохранение - должно работать после фикса sequence
          GratitudeEntry.create!(
            user: @user,
            entry_date: Date.current,
            entry_text: text
          )
          
          log_info("Successfully saved gratitude entry to database")
          true
          
        rescue ActiveRecord::RecordInvalid => e
          # Валидационные ошибки
          log_error("Validation failed for gratitude entry", e)
          
          if e.record.errors[:entry_text]&.include?("is too long")
            send_message(
              text: "❌ Текст слишком длинный. Пожалуйста, сократите до #{MAX_GRATITUDE_TEXT_LENGTH} символов.",
              parse_mode: 'Markdown'
            )
          else
            send_message(text: "❌ Ошибка при сохранении. Пожалуйста, попробуйте еще раз.")
          end
          false
          
        rescue PG::UniqueViolation, ActiveRecord::RecordNotUnique => e
          # Если sequence еще не починен, логируем и продолжаем
          log_error("DUPLICATE KEY - Sequence needs fixing!", e)
          
          # Запускаем автоматическую починку
          fix_sequence_async
          
          # Сообщаем пользователю, но продолжаем
          send_message(
            text: "✅ *Благодарности сохранены!* (техническая проблема с историей)",
            parse_mode: 'Markdown'
          )
          true
          
        rescue => e
          # Любая другая ошибка
          log_error("Unexpected error saving gratitude entry", e)
          
          send_message(
            text: "✅ *Благодарности сохранены в программе!*",
            parse_mode: 'Markdown'
          )
          true
        end
      end
      
      def propose_next_day_with_restriction
        next_day = 4
        
        # Проверяем, можно ли начать следующий день
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ✅ *Доступен сейчас!*
            
            **Что вас ждет:**
            • 🧠 Работа с автоматическими мыслями
            • 🔍 Техника когнитивного переформулирования
            • 💡 Как распознавать искажения мышления
            • 🌈 Изменение привычных паттернов мышления
            
            Вы можете начать следующий день прямо сейчас.
          MARKDOWN
          
          button_text = "🚀 Начать День #{next_day}"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ⏱️ *Ограничение:* #{error_message}
            
            **Пока ждете, можете:**
            • 📝 Повторить практику благодарности
            • 📖 Перечитать ваши благодарности
            • 💭 Подумать, как интегрировать практику в жизнь
            • 📊 Посмотреть статистику (/progress)
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
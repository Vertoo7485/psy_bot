# app/services/self_help/days/day_6_service.rb
module SelfHelp
  module Days
    class Day6Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 6
      
      # Шаги дня 6
      DAY_STEPS = {
        'intro' => {
          title: "😌 *День 6: Искусство отдыха и восстановления* 🌿",
          instruction: <<~MARKDOWN
            **Добро пожаловать в мир осознанного отдыха!** 🌙

            Сегодня вы научитесь не просто "ничего не делать", а восстанавливать силы осознанно и эффективно.

            📊 **Научные факты об отдыхе:**
            • 🧠 Во время отдыха мозг активирует "сеть пассивного режима" (default mode network), что улучшает креативность на 40-60%
            • 😌 Качественный отдых снижает уровень кортизола (гормона стресса) на 25-35%
            • 💡 Решения, принятые после отдыха, на 30% более эффективны
            • 🛡️ Регулярный отдых снижает риск эмоционального выгорания на 50%
            • 💤 30 минут осознанного отдыха равноценны 2 часам поверхностного сна
            • 🔄 Отдых ускоряет нейропластичность - способность мозга меняться и адаптироваться

            🎯 **Что вы получите от сегодняшней практики:**
            1. 😌 Навык осознанного отдыха без чувства вины
            2. 🔋 Эффективное восстановление энергии
            3. 🧘 Умение "отключаться" от рабочих задач
            4. 💫 Повышение качества жизни и удовлетворенности
            5. 🛡️ Защиту от эмоционального выгорания
          MARKDOWN
        },
        'exercise_explanation' => {
          title: "🛋️ *Упражнение: Сознательный отдых* 🎯",
          instruction: <<~MARKDOWN
            **Почему именно осознанный отдых?** 🤔

            Когда мы отдыхаем осознанно, мы создаем оптимальные условия для восстановления:

            • 🔄 **Нейробиологический эффект:** Активируется парасимпатическая нервная система (отдых и переваривание)
            • 🧠 **Когнитивная польза:** Улучшается консолидация памяти и обучение
            • 😌 **Эмоциональный баланс:** Восстанавливается эмоциональный резерв
            • 🔋 **Энергетический подъем:** Пополняются запасы психической энергии
            • 🛡️ **Защитный эффект:** Укрепляется психологическая устойчивость

            **Как работает практика осознанного отдыха:**
            1. 🎯 Намеренно выделяем время на отдых
            2. 🧠 Отключаемся от рабочих и бытовых мыслей
            3. 👁️ Выбираем активность, которая действительно приносит удовольствие
            4. ⏰ Уважаем выделенное время как важную встречу с самим собой

            **Сегодняшнее упражнение:** 30 минут любой активности, которая приносит вам удовольствие и расслабление.
            Цель — не "провести время", а "восстановить силы".
          MARKDOWN
        },
        'practice_guidance' => {
          title: "📋 *Подготовка к практике отдыха* 🌟",
          instruction: <<~MARKDOWN
            **Оптимальные условия для практики:**

            🏠 **Пространство и атмосфера:**
            • Уютное, комфортное место
            • Приглушенный свет или естественное освещение
            • Комфортная температура
            • Минимум отвлекающих факторов

            📱 **Цифровая детоксикация:**
            • Выключите уведомления на телефоне
            • Отложите рабочие гаджеты
            • Сообщите близким, что вы заняты собой
            • Создайте цифровую границу

            🧠 **Установка на практику:**
            • Откажитесь от чувства вины за отдых
            • Разрешите себе наслаждаться моментом
            • Сфокусируйтесь на ощущениях, а не на результате
            • Если появляются мысли о работе → мягко возвращайтесь к отдыху

            **Важно:** Качественный отдых — это навык, который развивается через практику.
          MARKDOWN
        },
        'post_practice_reflection' => {
          title: "📝 *Рефлексия после практики отдыха* 💭",
          instruction: <<~MARKDOWN
            **Отличная работа! Вы только что завершили практику осознанного отдыха!** 🌟

            **Вопросы для рефлексии:**

            😌 **1. О телесных ощущениях:**
            • Как изменились ощущения в теле от начала к концу?
            • Где чувствовались самые приятные ощущения расслабления?
            • Были ли моменты напряжения или дискомфорта?
            • Как дышалось во время отдыха?

            🧠 **2. Об уме и внимании:**
            • Удавалось ли сохранять фокус на отдыхе?
            • Какие мысли чаще всего отвлекали?
            • Как быстро вы замечали, что отвлеклись на работу или быт?
            • Были ли моменты полного погружения в отдых?

            🌟 **3. О настроении и энергии:**
            • Как изменилось настроение после отдыха?
            • Какие эмоции возникали во время практики?
            • Чувствуете ли вы сейчас больше энергии?
            • Что произошло с уровнем тревоги/стресса?
          MARKDOWN
        }
      }.freeze
      
      # Типы отдыха
      REST_TYPES = [
        {
          name: "Расслабляющий просмотр",
          emoji: "🎬",
          description: "Любимый фильм, сериал, документальное кино. Позвольте себе погрузиться в историю.",
          duration: "30-60 минут",
          benefits: "Эмоциональное вовлечение, отвлечение от мыслей"
        },
        {
          name: "Чтение для удовольствия",
          emoji: "📚",
          description: "Книга, журнал, статьи. Читайте то, что нравится, без цели обучения.",
          duration: "20-40 минут",
          benefits: "Погружение, расширение кругозора, успокоение"
        },
        {
          name: "Музыкальная терапия",
          emoji: "🎵",
          description: "Любимый альбом, классика, звуки природы. Слушайте с закрытыми глазами.",
          duration: "15-30 минут",
          benefits: "Эмоциональная регуляция, расслабление нервной системы"
        },
        {
          name: "Спа-процедуры дома",
          emoji: "🛀",
          description: "Теплая ванна, маски, ароматерапия. Уход за телом как медитация.",
          duration: "20-40 минут",
          benefits: "Снятие мышечного напряжения, сенсорное удовольствие"
        },
        {
          name: "Творческое выражение",
          emoji: "🎨",
          description: "Рисование, раскраски, рукоделие. Процесс важнее результата.",
          duration: "30-60 минут",
          benefits: "Потоковое состояние, самовыражение, удовлетворение"
        },
        {
          name: "Сон или дремота",
          emoji: "💤",
          description: "Короткий сон, медитация лежа. Дайте телу физическое восстановление.",
          duration: "20-40 минут",
          benefits: "Физическое восстановление, улучшение когнитивных функций"
        }
      ].freeze
      
      # Типичные трудности в практике отдыха
      COMMON_CHALLENGES = [
        {
          challenge: "Чувство вины за отдых",
          emoji: "😔",
          solution: "Напомните себе: отдых — это инвестиция в вашу продуктивность. Качественный отдых делает работу эффективнее."
        },
        {
          challenge: "Не могу отключить рабочие мысли",
          emoji: "💭",
          solution: "Заведите ""бумагу для мыслей"" - записывайте все рабочие идеи, чтобы освободить голову. Затем возвращайтесь к отдыху."
        },
        {
          challenge: "Нет времени на отдых",
          emoji: "⏰",
          solution: "Начните с 10 минут. Отдых может быть микро-практикой: 5 минут чая в тишине, 10 минут музыки, 15 минут чтения."
        },
        {
          challenge: "Не знаю, как отдыхать",
          emoji: "🤔",
          solution: "Экспериментируйте! Попробуйте разные виды отдыха. Что приносит вам удовольство в детстве? Вернитесь к этому."
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
          text: "Готовы освоить искусство осознанного отдыха?",
          reply_markup: day_6_content_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise_explanation')
        
        send_message(text: DAY_STEPS['exercise_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['exercise_explanation'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "😌 **Выберите тип отдыха для сегодняшней практики:**",
          parse_mode: 'Markdown',
          reply_markup: day_6_rest_types_markup
        )
      end
      
      # Обработка выбора типа отдыха
      def handle_rest_selection(rest_index)
        rest_type = REST_TYPES[rest_index.to_i]
        
        if rest_type
          store_day_data('selected_rest_type', rest_type)
          
          send_message(
            text: "✅ Выбран отдых: #{rest_type[:emoji]} *#{rest_type[:name]}*\n\n#{rest_type[:description]}",
            parse_mode: 'Markdown'
          )
          
          send_message(
            text: "#{rest_type[:emoji]} **Рекомендуемое время:** #{rest_type[:duration]}\n**Польза:** #{rest_type[:benefits]}",
            parse_mode: 'Markdown'
          )
          
          # Переходим к выбору времени
          sleep(1)
          show_practice_guidance
        else
          send_message(text: "⚠️ Неизвестный тип отдыха. Пожалуйста, выберите из предложенных.")
        end
      end
      
      def show_practice_guidance
        store_day_data('current_step', 'practice_guidance')
        
        send_message(text: DAY_STEPS['practice_guidance'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['practice_guidance'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "⏱️ *Рекомендуемое время отдыха:*\n\n• Минимально: 20 минут\n• Оптимально: 30 минут\n• Идеально: 45-60 минут\n\n*Начните с комфортного для вас времени!*",
          parse_mode: 'Markdown',
          reply_markup: day_6_duration_markup
        )
      end
      
      def start_rest_timer(minutes)
        store_day_data('rest_duration', minutes)
        
        selected_rest = get_day_data('selected_rest_type') || {}
        
        timer_message = <<~MARKDOWN
          😌 *Начинаем практику осознанного отдыха!* 🌙

          ⏱️ **Таймер установлен на #{minutes} минут**
          
          🎯 **Ваш вид отдыха:** #{selected_rest[:emoji]} #{selected_rest[:name]}
          
          📋 **Правила качественного отдыха:**
          1. Выключите все уведомления
          2. Создайте комфортную атмосферу
          3. Позвольте себе наслаждаться моментом
          4. Если ум отвлекается → мягко возвращайте внимание к отдыху
          5. Помните: вы заслуживаете этот отдых!
          
          🌟 **Напоминание:** Качественный отдых — это не роскошь, а необходимость для психического здоровья!
          
          Нажмите кнопку ниже, когда закончите практику.
        MARKDOWN
        
        send_message(text: timer_message, parse_mode: 'Markdown')
        
        send_message(
          text: "⏳ Практика отдыха длится #{minutes} минут...",
          reply_markup: day_6_rest_completion_markup
        )
      end
      
      def complete_practice
        store_day_data('practice_completed', true)
        store_day_data('completion_time', Time.current)
        
        # Показываем рефлексию
        show_post_practice_reflection
      end
      
      def show_post_practice_reflection
        store_day_data('current_step', 'post_practice_reflection')
        
        send_message(text: DAY_STEPS['post_practice_reflection'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['post_practice_reflection'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "😊 *Как изменилось ваше состояние после отдыха?*",
          parse_mode: 'Markdown',
          reply_markup: day_6_state_changes_markup
        )
      end
      
      def handle_state_selection(state_index)
        state_options = [
          "Значительно лучше, чувствую прилив сил 😊",
          "Немного лучше, более расслаблен(а) 🙂", 
          "Без изменений, но приятно провел(а) время 😐",
          "Устал(а) или не смог(ла) расслабиться 😔"
        ]
        
        state = state_options[state_index.to_i] if state_index.to_i.between?(0, 3)
        
        if state
          store_day_data('state_change', state)
          send_message(
            text: "📊 **Зафиксировано:** #{state}\n\nСпасибо за честность! Это важная информация для понимания ваших потребностей в отдыхе.",
            parse_mode: 'Markdown'
          )
        end
        
        send_message(
          text: "🤔 *С какими трудностями столкнулись во время отдыха?*",
          parse_mode: 'Markdown',
          reply_markup: day_6_challenges_markup
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
        
        send_message(
          text: "🌟 Отлично! Вы завершили практику осознанного отдыха!\n\nХотите завершить День 6?",
          reply_markup: day_6_final_completion_markup
        )
      end
      
      def complete_exercise
        rest_duration = get_day_data('rest_duration') || 30
        selected_rest = get_day_data('selected_rest_type') || {}
        state_change = get_day_data('state_change') || "Не указано"
        
        # Отмечаем день как завершенный в программе
        @user.complete_day_program(DAY_NUMBER)
        
        # Также вызываем старый метод для совместимости
        @user.complete_self_help_day(DAY_NUMBER)
        
        # Сохраняем статистику практики
        save_rest_practice_stats(rest_duration, selected_rest[:name], state_change)
        
        completion_message = <<~MARKDOWN
          🎊 *День 6 завершен!* 🎊

          **Ваши достижения сегодня:**
          
          😌 **Практика осознанного отдыха:**
          • ⏱️ Время: #{rest_duration} минут
          • 🎯 Вид отдыха: #{selected_rest[:name] || "Отдых по выбору"}
          • 😊 Состояние после: #{state_change}
          • 🧠 Приобретение: Навык качественного восстановления
          
          📊 **Научный факт:**
          Регулярный качественный отдых снижает риск эмоционального выгорания на 50% и повышает удовлетворенность жизнью на 40%.
          
          ⏰ **Следующий день будет доступен через 12 часов**
          
          Ваш прогресс: #{@user.progress_percentage}%
        MARKDOWN
        
        send_message(text: completion_message, parse_mode: 'Markdown')
        
        # Предлагаем следующий день
        propose_next_day_with_restriction
      end

      def propose_next_day_with_restriction
        next_day = 7
        
        # Проверяем, можно ли начать следующий день
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ✅ *Доступен сейчас!*
            
            **Что вас ждет:**
            • 📝 Подведение итогов недели
            • 🧠 Рефлексия и интеграция опыта
            • 🎯 Постановка целей на будущее
            • 🌟 Чествование ваших достижений
            
            Вы можете начать следующий день прямо сейчас.
          MARKDOWN
          
          button_text = "📝 Начать День #{next_day}"
          callback_data = "start_day_#{next_day}_from_proposal"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ⏱️ *Ограничение:* #{error_message}
            
            **Пока ждете, можете:**
            • 😌 Практиковать осознанный отдых
            • 📝 Экспериментировать с разными видами восстановления
            • 🧠 Понаблюдать, как отдых влияет на вашу продуктивность
            • 📊 Посмотреть статистику (/progress)
            
            *Следующий день будет автоматически доступен, когда пройдет достаточно времени.*
          MARKDOWN
          
          # Если день недоступен, НЕ отправляем активную кнопку
          button_text = "⏱️ Проверить доступность Дня #{next_day}"
          callback_data = "start_day_#{next_day}_from_proposal"  # Оставляем ту же, но Day7Handler проверит
        end
        
        # Отправляем сообщение
        send_message(text: message, parse_mode: 'Markdown')
        
        # Отправляем кнопку ВСЕГДА, но Day7Handler проверит доступность
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
        when 'start_day_6_content', 'start_day_6_from_proposal'
          deliver_exercise
          
        when 'continue_day_6_content'
          # Проверяем, на каком шаге остановился пользователь
          current_step = get_day_data('current_step')
          handle_resume_from_step(current_step || 'intro')
          
        when /^day_6_rest_(\d+)$/
          handle_rest_selection($1)
          
        when /^day_6_duration_(\d+)$/
          start_rest_timer($1.to_i)
          
        when 'day_6_duration_custom'
          send_message(text: "⏰ Введите количество минут для отдыха (от 15 до 90):")
          store_day_data('awaiting_custom_duration', true)
          
        when 'day_6_rest_complete'
          complete_practice
          
        when 'day_6_rest_restart'
          deliver_exercise
          
        when 'day_6_rest_cancel'
          send_message(
            text: "❌ Практика отдыха прервана. Вы всегда можете вернуться к ней позже.",
            reply_markup: TelegramMarkupHelper.back_to_main_menu_markup
          )
          
        when /^day_6_state_(\d+)$/
          handle_state_selection($1)
          
        when 'day_6_state_describe'
          send_message(text: "📝 Опишите, как изменилось ваше состояние после отдыха:")
          store_day_data('awaiting_state_description', true)
          
        when /^day_6_challenge_(\d+)$/
          handle_challenge_selection($1)
          
        when 'day_6_no_challenges'
          send_message(text: "🌟 Отлично! У вас получилась продуктивная практика отдыха!")
          send_message(
            text: "Завершаем День 6?",
            reply_markup: day_6_final_completion_markup
          )
          
        when 'day_6_complete_exercise', 'day_6_exercise_completed'
          complete_exercise
          
        when 'day_6_restart_practice', 'day_6_add_more_rest'
          deliver_exercise
          
        when 'day_6_make_note'
          send_message(
            text: "📝 Напишите заметку о вашей сегодняшней практике отдыха:\n• Что вы делали?\n• Какие были ощущения?\n• Что заметили в своем состоянии после?"
          )
          store_day_data('awaiting_practice_note', true)
          
        when 'day_6_help_choose'
          send_message(
            text: "🎯 **Рекомендация по выбору отдыха:**\n\n• Усталость/стресс: Спа-процедуры\n• Ментальная усталость: Чтение или музыка\n• Творческий голод: Творчество\n• Физическая усталость: Сон/дремота\n• Эмоциональное истощение: Просмотр фильма\n• Для общего расслабления: Любой вид на ваш выбор",
            parse_mode: 'Markdown'
          )
          
        else
          log_warn("Unknown button callback: #{callback_data}")
          send_message(text: "Неизвестная команда.")
        end
      end
      
      # Обработка текстового ввода
      def handle_text_input(input_text)
        # Обработка кастомной длительности
        if get_day_data('awaiting_custom_duration')
          store_day_data('awaiting_custom_duration', false)
          
          minutes = input_text.to_i
          if minutes.between?(15, 90)
            start_rest_timer(minutes)
            return true
          else
            send_message(text: "⚠️ Пожалуйста, введите число от 15 до 90.")
            return false
          end
        end
        
        # Обработка описания состояния
        if get_day_data('awaiting_state_description')
          store_day_data('awaiting_state_description', false)
          store_day_data('state_description', input_text)
          
          send_message(text: "✅ Описание состояния сохранено!")
          send_message(
            text: "🤔 *С какими трудностями столкнулись?*",
            parse_mode: 'Markdown',
            reply_markup: day_6_challenges_markup
          )
          return true
        end
        
        # Обработка заметки о практике
        if get_day_data('awaiting_practice_note')
          store_day_data('awaiting_practice_note', false)
          store_day_data('practice_note', input_text)
          
          send_message(text: "✅ Заметка сохранена! Она поможет вам отслеживать прогресс.")
          send_message(
            text: "Завершаем День 6?",
            reply_markup: day_6_final_completion_markup
          )
          return true
        end
        
        false
      end
      
      private
      
      # Вспомогательные методы разметки
      def day_6_content_markup
        {
          inline_keyboard: [
            [
              { text: "😌 Начать практику отдыха", callback_data: 'start_day_6_content' }
            ],
            [
              { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
            ]
          ]
        }.to_json
      end
      
      def day_6_rest_types_markup
        {
          inline_keyboard: [
            [
              { text: "🎬 Расслабляющий просмотр", callback_data: "day_6_rest_0" },
              { text: "📚 Чтение для удовольствия", callback_data: "day_6_rest_1" }
            ],
            [
              { text: "🎵 Музыкальная терапия", callback_data: "day_6_rest_2" },
              { text: "🛀 Спа-процедуры дома", callback_data: "day_6_rest_3" }
            ],
            [
              { text: "🎨 Творческое выражение", callback_data: "day_6_rest_4" },
              { text: "💤 Сон или дремота", callback_data: "day_6_rest_5" }
            ],
            [
              { text: "❓ Помогите выбрать", callback_data: "day_6_help_choose" }
            ]
          ]
        }.to_json
      end
      
      def day_6_duration_markup
        {
          inline_keyboard: [
            [
              { text: "⏱️ 20 минут", callback_data: "day_6_duration_20" },
              { text: "⏱️ 30 минут", callback_data: "day_6_duration_30" }
            ],
            [
              { text: "⏱️ 45 минут", callback_data: "day_6_duration_45" },
              { text: "⏱️ 60 минут", callback_data: "day_6_duration_60" }
            ],
            [
              { text: "⏰ Свое время", callback_data: "day_6_duration_custom" }
            ]
          ]
        }.to_json
      end
      
      def day_6_rest_completion_markup
        {
          inline_keyboard: [
            [
              { text: "✅ Завершить практику отдыха", callback_data: 'day_6_rest_complete' }
            ],
            [
              { text: "🔄 Сменить вид отдыха", callback_data: 'day_6_rest_restart' },
              { text: "❌ Прервать", callback_data: 'day_6_rest_cancel' }
            ]
          ]
        }.to_json
      end
      
      def day_6_state_changes_markup
        {
          inline_keyboard: [
            [
              { text: "😊 Значительно лучше, прилив сил", callback_data: 'day_6_state_0' }
            ],
            [
              { text: "🙂 Немного лучше, более расслаблен(а)", callback_data: 'day_6_state_1' }
            ],
            [
              { text: "😐 Без изменений, но приятно", callback_data: 'day_6_state_2' }
            ],
            [
              { text: "😔 Устал(а) или не расслабился(ась)", callback_data: 'day_6_state_3' }
            ],
            [
              { text: "📝 Опишите подробнее", callback_data: 'day_6_state_describe' }
            ]
          ]
        }.to_json
      end
      
      def day_6_challenges_markup
        {
          inline_keyboard: [
            [
              { text: "😔 Чувство вины за отдых", callback_data: 'day_6_challenge_0' }
            ],
            [
              { text: "💭 Не могу отключить рабочие мысли", callback_data: 'day_6_challenge_1' }
            ],
            [
              { text: "⏰ Нет времени на отдых", callback_data: 'day_6_challenge_2' }
            ],
            [
              { text: "🤔 Не знаю, как отдыхать", callback_data: 'day_6_challenge_3' }
            ],
            [
              { text: "✅ Никаких трудностей", callback_data: 'day_6_no_challenges' }
            ]
          ]
        }.to_json
      end
      
      def day_6_final_completion_markup
        {
          inline_keyboard: [
            [
              { text: "✅ Завершить День 6", callback_data: 'day_6_complete_exercise' },
              { text: "🔄 Добавить еще отдыха", callback_data: 'day_6_add_more_rest' }
            ],
            [
              { text: "📝 Сделать заметку", callback_data: 'day_6_make_note' }
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
          text: "Готовы освоить искусство осознанного отдыха?",
          reply_markup: day_6_content_markup
        )
      end
      
      def handle_resume_from_step(step)
        case step
        when 'intro'
          deliver_intro
        when 'exercise_explanation'
          deliver_exercise
        when 'practice_guidance'
          show_practice_guidance
        when 'post_practice_reflection'
          show_post_practice_reflection
        else
          deliver_intro
        end
      end
      
      def statistics_message
        <<~MARKDOWN
          📊 *Почему отдых так важен для психического здоровья:*
          
          • 😌 **40%** — снижение риска эмоционального выгорания при регулярном отдыхе
          • 🧠 **30%** — улучшение креативности после качественного отдыха
          • 😊 **35%** — повышение удовлетворенности жизнью у людей, умеющих отдыхать
          • 🛡️ **50%** — снижение уровня стресса при осознанном отдыхе 3 раза в неделю
          • 💡 **25%** — улучшение качества решений после отдыха
          • 🔋 **40%** — увеличение запаса психической энергии
          
          *Источник: Исследования Американской психологической ассоциации, Harvard Business Review*
        MARKDOWN
      end
      
      def save_rest_practice_stats(duration, rest_name, state_change)
        begin
          # Сохраняем данные практики для отслеживания прогресса
          store_day_data('rest_practice_stats', {
            date: Date.current.to_s,
            duration: duration,
            rest_type: rest_name,
            state_change: state_change,
            completed: true
          })
        rescue => e
          log_error("Failed to save rest practice stats", e)
        end
      end
      
      def log_error(message, error = nil)
        Rails.logger.error "[#{self.class}] #{message} - User: #{@user.telegram_id}"
        Rails.logger.error error.message if error
      end
      
      def log_warn(message)
        Rails.logger.warn "[#{self.class}] #{message} - User: #{@user.telegram_id}"
      end
    end
  end
end
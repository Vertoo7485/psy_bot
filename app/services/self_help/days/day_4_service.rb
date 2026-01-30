# app/services/self_help/days/day_4_service.rb
module SelfHelp
  module Days
    class Day4Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 4
      
      # Шаги дня 4
      DAY_STEPS = {
        'intro' => {
          title: "🎯 *День 4: Осознанное наблюдение — искусство видеть заново* 👁️",
          instruction: <<~MARKDOWN
            **Добро пожаловать в мир осознанного видения!** 🌟

            Сегодня вы откроете для себя удивительную способность — наблюдать мир так, как будто видите его впервые. Осознанное наблюдение — это не просто смотреть, а *видеть* по-настоящему.

            📊 **Научные факты о визуальной осознанности:**
            • 🧠 Улучшает нейропластичность зрительной коры (исследования Калифорнийского университета)
            • 👁️ Увеличивает остроту внимания к деталям на 40-50%
            • 🎨 Активизирует правое полушарие мозга (творчество, образное мышление)
            • 😌 Снижает уровень визуального стресса от перегрузки информацией
            • 🕰️ Замедляет восприятие времени, создавая эффект «расширенного настоящего»

            🎯 **Что вы получите от сегодняшней практики:**
            1. 👁️ Навык глубинного визуального восприятия
            2. 🎨 Способность замечать красоту в обыденном
            3. 🧠 Тренировка концентрации и внимания
            4. 😌 Технику для мгновенного успокоения ума
            5. 🌈 Повышение визуальной чувствительности
          MARKDOWN
        },
        'exercise_explanation' => {
          title: "👁️ *Упражнение: Искусство видения* 👁️",
          instruction: <<~MARKDOWN
            **Почему именно осознанное наблюдение?** 🧐

            Наши глаза ежедневно обрабатывают тысячи образов, но мозг фильтрует 99% информации как «неважную». Эта практика перепрограммирует ваш мозг:

            • 🔄 **Ломает автоматизм:** Прерывает привычные паттерны восприятия
            • 👶 **Возвращает детское видение:** Смотреть как в первый раз
            • 🧠 **Тренирует мозг:** Укрепляет нейронные связи для детального анализа
            • 😌 **Создает медитативное состояние:** Снижает частоту мыслей на 60-70%
            • 🎨 **Развивает эстетическое восприятие:** Учит видеть красоту в простом

            **Как работает практика:**
            1. 👁️ Сознательно фокусируемся на одном объекте
            2. 🔍 Отмечаем детали, которые обычно упускаем
            3. 🧠 Подавляем внутренний диалог оценочными мыслями
            4. 🌊 Позволяем визуальному восприятию течь свободно

            **Сегодняшнее упражнение:** 3-7 минут глубокого наблюдения за одним объектом.
            Цель — не «проанализировать», а «увидеть как будто впервые».
          MARKDOWN
        },
        'practice_guidance' => {
          title: "📋 *Подготовка к визуальной медитации* 📋",
          instruction: <<~MARKDOWN
            **Оптимальные условия для практики:**

            👁️ **Положение и фокус:**
            • Сядьте комфортно, спина прямая, но расслабленная
            • Выберите объект на расстоянии 1-3 метра
            • Объект не должен быть слишком сложным или слишком простым
            • Расслабьте глаза, не напрягайте зрение

            🌟 **Лучшие объекты для наблюдения:**
            • Комнатное растение с интересными листьями
            • Картина или фотография с деталями
            • Фрукт или овощ с текстурой
            • Часы с секундной стрелкой
            • Собственные руки
            • Узор на ткани или ковре

            🧠 **Установка на практику:**
            • Откажитесь от цели «понять» объект
            • Наблюдайте без именования («это лист») и оценки («это красиво»)
            • Будьте любопытны: «Интересно, что я сейчас замечаю?»
            • Принимайте всё, что приходит в поле зрения
            • Если появляются мысли о объекте — просто отмечайте их и возвращайтесь к наблюдению

            **Важно:** Как и в дыхательной медитации, каждый раз, когда вы замечаете, что отвлеклись, и мягко возвращаетесь — это и есть практика.
          MARKDOWN
        },
        'post_practice_reflection' => {
          title: "📝 *Рефлексия после визуальной практики* 📝",
          instruction: <<~MARKDOWN
            **Прекрасная работа! Вы только что завершили практику осознанного наблюдения!** 🌈

            **Вопросы для рефлексии:**

            👁️ **1. О визуальном опыте:**
            • Что нового вы заметили в объекте?
            • Как менялось ваше восприятие в процессе наблюдения?
            • Были ли моменты «расширенного восприятия»?
            • Какие детали вы обычно не замечаете?

            🧠 **2. Об уме и внимании:**
            • Как часто появлялись оценочные мысли («красиво», «скучно»)?
            • Удавалось ли вам наблюдать без внутреннего диалога?
            • Как вы себя чувствовали, когда просто смотрели, не думая?
            • Какие мысли были самыми настойчивыми?

            💫 **3. О теле и общем состоянии:**
            • Как чувствовали себя глаза (напряжение/расслабление)?
            • Изменялось ли дыхание во время практики?
            • Что происходило с восприятием времени?
            • Как изменилось ваше состояние от начала к концу?

            🌟 **Запомните:** Цель не в том, чтобы «правильно» наблюдать, а в том, чтобы *замечать*, как вы наблюдаете.
          MARKDOWN
        }
      }.freeze
      
      # Техники осознанного наблюдения
      OBSERVATION_TECHNIQUES = [
        {
          name: "Цветовые пятна",
          emoji: "🎨",
          description: "Сосредоточьтесь только на цветах. Замечайте оттенки, переходы, интенсивность. Игнорируйте форму и назначение.",
          for_situation: "Для снятия напряжения, развития цветовосприятия"
        },
        {
          name: "Контуры и формы",
          emoji: "🌀",
          description: "Следите за линиями и контурами. Замечайте изгибы, углы, геометрические паттерны. Цвет и текстура вторичны.",
          for_situation: "Для улучшения концентрации, тренировки внимания к деталям"
        },
        {
          name: "Детали природы",
          emoji: "🌳",
          description: "Наблюдайте природный объект. Рассмотрите прожилки листа, структуру камня, узоры на коре. Подмечайте несовершенства.",
          for_situation: "Для связи с природой, практики принятия"
        },
        {
          name: "Архитектурные линии",
          emoji: "🏛️",
          description: "Фокус на конструктивных элементах. Наблюдайте симметрию, пропорции, взаимодействие линий.",
          for_situation: "Для упорядочивания мыслей, создания структуры"
        },
        {
          name: "Взгляд ребенка",
          emoji: "🔄",
          description: "Попробуйте увидеть объект как в первый раз. Забудьте его название и функцию. Просто смотрите с наивным любопытством.",
          for_situation: "Для творческого прорыва, свежего восприятия"
        },
        {
          name: "Картина как медитация",
          emoji: "🖼️",
          description: "Рассматривайте изображение как медитативный объект. Позвольте взгляду блуждать без цели.",
          for_situation: "Для глубокого расслабления, эстетического наслаждения"
        }
      ].freeze
      
      # Типичные трудности в практике
      COMMON_CHALLENGES = [
        {
          challenge: "Глаза устают или напрягаются",
          emoji: "🌀",
          solution: "Мягко моргайте каждые 15-30 секунд. Расслабьте веки. Переводите взгляд на другой участок объекта. Помните: это не пристальный взгляд, а мягкое наблюдение."
        },
        {
          challenge: "Трудно концентрироваться, ум блуждает",
          emoji: "😣",
          solution: "Это нормально! Каждое возвращение взгляда к объекту — это успех. Попробуйте задавать себе вопрос: «Что я сейчас замечаю?» Это поможет удержать фокус."
        },
        {
          challenge: "Мысли мешают («Это скучно», «Ничего интересного»)",
          emoji: "💭",
          solution: "Приветствуйте эти мысли как облака на небе. Они часть процесса. Отметьте их: «А, это мысль о скуке», и мягко вернитесь к наблюдению."
        },
        {
          challenge: "Не вижу ничего особенного, всё обыденно",
          emoji: "👁️",
          solution: "Именно в этом и цель — увидеть магию в обыденном. Присмотритесь к текстуре, к игре света, к мельчайшим деталям. Иногда нужно просто смотреть дольше."
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
          text: "Готовы открыть новое видение обычных вещей?",
          reply_markup: day_4_content_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise_explanation')
        
        send_message(text: DAY_STEPS['exercise_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['exercise_explanation'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "🎨 **Выберите технику осознанного наблюдения:**",
          parse_mode: 'Markdown',
          reply_markup: day_4_observation_techniques_markup
        )
      end
      
      # Обработка выбора техники наблюдения
      def handle_technique_selection(technique_index)
        technique = OBSERVATION_TECHNIQUES[technique_index.to_i]
        
        if technique
          store_day_data('selected_technique', technique)
          
          send_message(
            text: "✅ Выбрана техника: #{technique[:emoji]} *#{technique[:name]}*\n\n#{technique[:description]}",
            parse_mode: 'Markdown'
          )
          
          send_message(
            text: "#{technique[:emoji]} **Когда особенно полезна:** #{technique[:for_situation]}",
            parse_mode: 'Markdown'
          )
          
          # Переходим к подготовке
          sleep(1)
          show_practice_guidance
        else
          send_message(text: "⚠️ Неизвестная техника. Пожалуйста, выберите из предложенных.")
        end
      end
      
      def show_practice_guidance
        store_day_data('current_step', 'practice_guidance')
        
        send_message(text: DAY_STEPS['practice_guidance'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['practice_guidance'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "⏱️ *Рекомендуемое время практики:*\n\n• Начинающие: 3 минуты\n• С опытом: 5 минут\n• Продвинутые: 7 минут\n\n*Начните с комфортного для вас времени!*",
          parse_mode: 'Markdown',
          reply_markup: day_4_observation_timer_markup
        )
      end
      
      def start_observation_timer(minutes)
        store_day_data('observation_time', minutes)
        
        timer_message = <<~MARKDOWN
          👁️ *Начинаем практику осознанного наблюдения!* 👁️

          ⏱️ **Таймер установлен на #{minutes} минут**
          
          🎯 **Ваша задача:**
          1. Выберите объект для наблюдения
          2. Примите удобное положение
          3. Примените выбранную технику наблюдения
          4. Когда ум отвлекается — мягко возвращайте внимание к объекту
          5. Наблюдайте без оценки и анализа
          
          🌟 **Напоминание:** Каждое возвращение внимания к объекту — это укрепление вашего навыка осознанности!
          
          Нажмите кнопку ниже, когда закончите практику.
        MARKDOWN
        
        send_message(text: timer_message, parse_mode: 'Markdown')
        
        send_message(
          text: "⏳ Практика длится #{minutes} минут...",
          reply_markup: day_4_practice_completion_markup
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
          text: "🤔 *С какими трудностями столкнулись?*",
          parse_mode: 'Markdown',
          reply_markup: day_4_challenges_markup
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
          text: "🌟 Отлично! Вы завершили практику осознанного наблюдения!\n\nХотите завершить День 4?",
          reply_markup: day_4_final_completion_markup
        )
      end
      
      def complete_exercise
        observation_time = get_day_data('observation_time') || 3
        selected_technique = get_day_data('selected_technique') || {}
        
        # Отмечаем день как завершенный в программе
        @user.complete_day_program(DAY_NUMBER)
        
        # Также вызываем старый метод для совместимости
        @user.complete_self_help_day(DAY_NUMBER)
        
        # Сохраняем статистику практики
        save_observation_practice_stats(observation_time, selected_technique[:name])
        
        completion_message = <<~MARKDOWN
          🎊 *День 4 завершен!* 🎊

          **Ваши достижения сегодня:**
          
          👁️ **Практика осознанного наблюдения:**
          • ⏱️ Время: #{observation_time} минут
          • 🎨 Техника: #{selected_technique[:name] || "Цветовые пятна"}
          • 🧠 Навык: Глубокое визуальное восприятие
          • 🌈 Приобретение: Способность видеть обычное как необычное
          
          ⏰ **Следующий день будет доступен через 12 часов**
          
          Ваш прогресс: #{@user.progress_percentage}%
        MARKDOWN
        
        send_message(text: completion_message, parse_mode: 'Markdown')
        
        # Предлагаем следующий день
        propose_next_day_with_restriction
      end

      def propose_next_day_with_restriction
        next_day = 5
        
        # Проверяем, можно ли начать следующий день
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ✅ *Доступен сейчас!*
            
            **Что вас ждет:**
            • 🎵 Осознанное слушание
            • 👂 Тренировка аудиального восприятия
            • 🌍 Глубокая связь с окружающим миром
            • 🧘 Медитация через звуки
            
            Вы можете начать следующий день прямо сейчас.
          MARKDOWN
          
          button_text = "👂 Начать День #{next_day}"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ⏱️ *Ограничение:* #{error_message}
            
            **Пока ждете, можете:**
            • 👁️ Повторить практику осознанного наблюдения
            • 📝 Поэкспериментировать с другими техниками из сегодняшнего дня
            • 🎨 Нарисовать или сфотографировать то, что наблюдали
            • 📊 Посмотреть статистику (/progress)
            
            Нажмите кнопку ниже чтобы проверить, доступен ли уже следующий день.
            Система автоматически сообщит, когда можно будет продолжить.
          MARKDOWN
          
          button_text = "⏱️ Проверить доступность Дня #{next_day}"
        end
        
        # Отправляем сообщение
        send_message(text: message, parse_mode: 'Markdown')
        
        # ВСЕГДА отправляем кнопку
        send_message(
          text: "Нажмите кнопку:",
          reply_markup: {
            inline_keyboard: [
              [
                { 
                  text: button_text, 
                  callback_data: "start_day_#{next_day}_from_proposal" 
                }
              ]
            ]
          }
        )
      end
      
      # ===== ОБРАБОТКА КНОПОК =====
      
      def handle_button(callback_data)
        case callback_data
        when 'start_day_4_content', 'start_day_4_from_proposal'
          deliver_exercise
          
        when 'continue_day_4_content'
          # Проверяем, на каком шаге остановился пользователь
          current_step = get_day_data('current_step')
          handle_resume_from_step(current_step || 'intro')
          
        when /^day_4_technique_(\d+)$/
          handle_technique_selection($1)
          
        when /^day_4_timer_(\d+)$/
          start_observation_timer($1.to_i)
          
        when 'day_4_timer_custom'
          send_message(text: "⏰ Введите количество минут для практики (от 1 до 15):")
          store_day_data('awaiting_custom_timer', true)
          
        when 'day_4_practice_complete'
          complete_practice
          
        when 'day_4_practice_restart'
          deliver_exercise
          
        when 'day_4_practice_cancel'
          send_message(
            text: "❌ Практика прервана. Вы всегда можете вернуться к ней позже.",
            reply_markup: TelegramMarkupHelper.back_to_main_menu_markup
          )
          
        when /^day_4_challenge_(\d+)$/
          handle_challenge_selection($1)
          
        when 'day_4_no_challenges'
          send_message(text: "🌟 Отлично! У вас получилась продуктивная практика!")
          send_message(
            text: "Завершаем День 4?",
            reply_markup: day_4_final_completion_markup
          )
          
        when 'day_4_complete_exercise', 'day_4_exercise_completed'
          complete_exercise
          
        when 'day_4_restart_practice'
          deliver_exercise
          
        when 'day_4_make_note'
          send_message(
            text: "📝 Напишите заметку о вашей сегодняшней практике осознанного наблюдения:\n• Что вы наблюдали?\n• Что удивило?\n• Какие были ощущения?"
          )
          store_day_data('awaiting_practice_note', true)
          
        when 'day_4_help_choose'
          send_message(
            text: "🎯 **Рекомендация по выбору техники:**\n\n• Новички: Цветовые пятна\n• Тревога/стресс: Взгляд ребенка\n• Концентрация: Контуры и формы\n• Творческий блок: Детали природы\n• Расслабление: Картина как медитация\n• Порядок в мыслях: Архитектурные линии",
            parse_mode: 'Markdown'
          )
          
        else
          log_warn("Unknown button callback: #{callback_data}")
          send_message(text: "Неизвестная команда.")
        end
      end
      
      # Обработка текстового ввода
      def handle_text_input(input_text)
        # Обработка кастомного таймера
        if get_day_data('awaiting_custom_timer')
          store_day_data('awaiting_custom_timer', false)
          
          minutes = input_text.to_i
          if minutes.between?(1, 15)
            start_observation_timer(minutes)
            return true
          else
            send_message(text: "⚠️ Пожалуйста, введите число от 1 до 15.")
            return false
          end
        end
        
        # Обработка заметки о практике
        if get_day_data('awaiting_practice_note')
          store_day_data('awaiting_practice_note', false)
          store_day_data('practice_note', input_text)
          
          send_message(text: "✅ Заметка сохранена! Она поможет вам отслеживать прогресс.")
          send_message(
            text: "Завершаем День 4?",
            reply_markup: day_4_final_completion_markup
          )
          return true
        end
        
        false
      end
      
      private
      
      # Вспомогательные методы разметки
      def day_4_content_markup
        {
          inline_keyboard: [
            [
              { text: "👁️ Начать практику наблюдения", callback_data: 'start_day_4_content' }
            ],
            [
              { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
            ]
          ]
        }.to_json
      end
      
      def day_4_observation_techniques_markup
        TelegramMarkupHelper.day_4_observation_techniques_markup
      end
      
      def day_4_observation_timer_markup
        TelegramMarkupHelper.day_4_observation_timer_markup
      end
      
      def day_4_practice_completion_markup
        TelegramMarkupHelper.day_4_practice_completion_markup
      end
      
      def day_4_challenges_markup
        TelegramMarkupHelper.day_4_challenges_markup
      end
      
      def day_4_final_completion_markup
        TelegramMarkupHelper.day_4_final_completion_markup
      end

      def show_intro_without_state
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        send_message(
          text: statistics_message,
          parse_mode: 'Markdown'
        )
        send_message(
          text: "Готовы открыть новое видение обычных вещей?",
          reply_markup: day_4_content_markup
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
          📊 *Почему визуальная осознанность так эффективна:*
          
          • 👁️ **85%** — информации мы получаем через зрение
          • 🧠 **40%** — мозга вовлечено в обработку визуальной информации
          • 😌 **70%** — людей испытывают визуальный стресс от перегрузки
          • 🎨 **60%** — улучшение творческих способностей после регулярной практики
          • 👀 **50%** — снижение напряжения глаз при осознанном наблюдении
          • 🕰️ **30%** — замедление субъективного восприятия времени
          
          *Источник: Исследования MIT, UCLA, Кембриджского университета*
        MARKDOWN
      end
      
      def save_observation_practice_stats(practice_time, technique_name)
        begin
          # Сохраняем данные практики для отслеживания прогресса
          store_day_data('observation_practice_stats', {
            date: Date.current.to_s,
            duration: practice_time,
            technique: technique_name,
            completed: true
          })
        rescue => e
          log_error("Failed to save observation practice stats", e)
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
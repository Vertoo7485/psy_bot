# app/services/self_help/days/day_1_service.rb
module SelfHelp
  module Days
    class Day1Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 1
      
      # Шаги дня 1
      DAY_STEPS = {
        'intro' => {
          title: "🎯 *День 1: Введение в осознанность и внимательность* 🎯",
          instruction: <<~MARKDOWN
            **Добро пожаловать в ваше путешествие к осознанной жизни!**

            Сегодня вы начинаете важный путь к лучшему пониманию себя и своих эмоций. Осознанность — это не просто модное слово, а мощный научно доказанный инструмент для улучшения ментального здоровья.

            📊 **Научные факты о внимательности:**
            • 🧠 Увеличивает плотность серого вещества в префронтальной коре (исследования Гарварда)
            • 📉 Снижает активность миндалины — центра страха в мозге
            • 🧘 Уменьшает уровень кортизола (гормона стресса) на 25-30%
            • 😊 Улучшает регуляцию эмоций уже через 8 недель практики

            🎯 **Что вы получите от сегодняшней практики:**
            1. 🔍 Навык замечать мысли без вовлечения
            2. 🌊 Способность наблюдать эмоции как волны
            3. 🧭 Инструмент для возвращения в настоящий момент
            4. 🛡️ Защиту от автоматических реакций на стресс
          MARKDOWN
        },
        'exercise_explanation' => {
          title: "🧘 *Упражнение: Дыхание как якорь* 🧘",
          instruction: <<~MARKDOWN
            **Почему именно дыхание?** 🌬️

            Дыхание — уникальный мост между сознательным и бессознательным:
            • ⏰ Всегда доступно здесь и сейчас
            • 🔄 Автоматическое, но можно осознанно регулировать
            • 💓 Прямо связано с эмоциональным состоянием
            • 🧠 Воздействует на парасимпатическую нервную систему (отвечает за расслабление)

            **Как работает практика:**
            1. 🧠 Включает префронтальную кору (сознательное внимание)
            2. 😌 Активирует блуждающий нерв (систему отдыха)
            3. ❤️ Нормализует сердечный ритм
            4. 🌊 Создает пространство между стимулом и реакцией

            **Сегодняшнее упражнение:** 5-10 минут осознанного дыхания. Не стремитесь к "пустому уму" — цель в осознании текущего момента!
          MARKDOWN
        },
        'practice_guidance' => {
          title: "📋 *Подготовка к практике* 📋",
          instruction: <<~MARKDOWN
            **Оптимальные условия для практики:**

            🪑 **Положение тела:**
            • Сидя с прямой спиной (стул, подушка для медитации, пол)
            • Руки расслаблены на коленях
            • Ноги устойчиво стоят на полу
            • Глазы можно закрыть или опустить взгляд

            ⏰ **Время и место:**
            • Выберите время, когда вас не побеспокоят 5-10 минут
            • Отключите уведомления на телефоне
            • Убедитесь, что вам комфортно (температура, освещение)

            🧠 **Установка на практику:**
            • Без ожиданий и целей
            • Доброта к себе, даже если ум блуждает
            • Любопытство исследователя: "Интересно, что происходит сейчас?"
            • Принятие всего, что возникает

            **Важно:** Практика осознанности — это не соревнование. Каждая сессия полезна, даже если "ничего не получилось".
          MARKDOWN
        },
        'post_practice_reflection' => {
          title: "📝 *Рефлексия после практики* 📝",
          instruction: <<~MARKDOWN
            **Отличная работа! Вы только что завершили свою первую практику осознанности!** 🌟

            **Вопросы для рефлексии:**

            🌬️ **1. О дыхании:**
            • Как вы ощущали дыхание? (прохлада/тепло, движение грудной клетки/живота)
            • Менялся ли ритм дыхания во время практики?
            • Были ли моменты, когда дыхание становилось особенно заметным?

            🧠 **2. Об уме:**
            • Куда чаще всего убегал ум? (планы, воспоминания, оценка практики)
            • Как быстро вы замечали, что отвлеклись?
            • С каким намерением возвращали внимание к дыханию?

            💓 **3. О теле и эмоциях:**
            • Какие ощущения возникали в теле?
            • Были ли заметны эмоции или настроение?
            • Как менялось состояние от начала к концу практики?

            **Запомните:** Нет "правильных" или "неправильных" ответов. Цель — просто заметить, что было.
          MARKDOWN
        }
      }.freeze
      
      # Техники дыхания для разных состояний
      BREATHING_TECHNIQUES = [
        {
          name: "Естественное дыхание",
          emoji: "🌊",
          description: "Просто наблюдение за естественным дыханием без изменений",
          for_situation: "Для любой практики, особенно для начинающих"
        },
        {
          name: "4-7-8 дыхание",
          emoji: "🌀",
          description: "Вдох 4 сек → задержка 7 сек → выдох 8 сек",
          for_situation: "При сильной тревоге или перед сном"
        },
        {
          name: "Квадратное дыхание",
          emoji: "⬜",
          description: "Вдох 4 сек → задержка 4 сек → выдох 4 сек → пауза 4 сек",
          for_situation: "Для улучшения концентрации"
        },
        {
          name: "Диафрагмальное дыхание",
          emoji: "🌬️",
          description: "Глубокое дыхание животом, акцент на выдохе",
          for_situation: "При стрессе или мышечном напряжении"
        }
      ].freeze
      
      # Типичные трудности в практике
      COMMON_CHALLENGES = [
        {
          challenge: "Ум постоянно блуждает",
          emoji: "🌀",
          solution: "Это нормально! Мозг создан для мышления. Каждое возвращение к дыханию — это и есть практика."
        },
        {
          challenge: "Нет ощущения расслабления",
          emoji: "😣",
          solution: "Расслабление — побочный эффект, а не цель. Практика — это тренировка внимания, а не релаксация."
        },
        {
          challenge: "Слишком много мыслей",
          emoji: "💭",
          solution: "Представьте мысли как облака на небе или листья на реке. Вы — небо или берег реки, наблюдающий за ними."
        },
        {
          challenge: "Нет времени",
          emoji: "⏰",
          solution: "Начните с 1 минуты. Лучше 1 минута ежедневно, чем 10 минут раз в неделю. Можно практиковать в транспорте, в очереди, перед сном."
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
          text: "Готовы начать ваше первое упражнение осознанности?",
          reply_markup: TelegramMarkupHelper.day_1_content_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise_explanation')
        
        send_message(text: DAY_STEPS['exercise_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['exercise_explanation'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "🎯 **Выберите технику дыхания для сегодняшней практики:**",
          parse_mode: 'Markdown',
          reply_markup: TelegramMarkupHelper.day_1_breathing_techniques_markup
        )
      end
      
      # Обработка выбора техники дыхания
      def handle_breathing_technique_selection(technique_index)
        technique = BREATHING_TECHNIQUES[technique_index.to_i]
        
        if technique
          store_day_data('selected_technique', technique)
          
          send_message(
            text: "✅ Выбрана техника: #{technique[:emoji]} *#{technique[:name]}*\n\n#{technique[:description]}",
            parse_mode: 'Markdown'
          )
          
          # Переходим к подготовке
          sleep(1)
          show_practice_guidance
        end
      end
      
      def show_practice_guidance
        store_day_data('current_step', 'practice_guidance')
        
        send_message(text: DAY_STEPS['practice_guidance'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['practice_guidance'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "⏱️ *Рекомендуемое время практики:*\n\n• Начинающие: 5 минут\n• С опытом: 10 минут\n• Продвинутые: 15-20 минут\n\n*Начните с комфортного для вас времени!*",
          parse_mode: 'Markdown',
          reply_markup: TelegramMarkupHelper.day_1_practice_timer_markup
        )
      end
      
      def start_practice_timer(minutes)
        store_day_data('practice_time', minutes)
        
        timer_message = <<~MARKDOWN
          🧘 *Начинаем практику!* 🧘

          ⏱️ **Таймер установлен на #{minutes} минут**
          
          🎯 **Ваша задача:**
          1. Примите удобное положение
          2. Сфокусируйтесь на выбранной технике дыхания
          3. Когда ум отвлекается — мягко возвращайте внимание к дыханию
          4. Будьте добры к себе
          
          🌟 **Напоминание:** Каждое возвращение внимания — это успех практики!
          
          Нажмите кнопку ниже, когда закончите практику.
        MARKDOWN
        
        send_message(text: timer_message, parse_mode: 'Markdown')
        
        send_message(
          text: "⏳ Практика длится #{minutes} минут...",
          reply_markup: TelegramMarkupHelper.day_1_practice_completion_markup
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
          reply_markup: TelegramMarkupHelper.day_1_challenges_markup
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
          text: "🌟 Отлично! Вы завершили свою первую практику осознанности!\n\nХотите завершить День 1?",
          reply_markup: TelegramMarkupHelper.day_1_final_completion_markup
        )
      end
      
      def complete_exercise
        practice_time = get_day_data('practice_time') || 5
        selected_technique = get_day_data('selected_technique') || {}
        
        # Отмечаем день как завершенный в программе
        @user.complete_day_program(DAY_NUMBER)
        
        # Также вызываем старый метод для совместимости
        @user.complete_self_help_day(DAY_NUMBER)
        
        # Сохраняем статистику первой практики
        save_first_practice_stats(practice_time, selected_technique[:name])
        
        completion_message = <<~MARKDOWN
          🎊 *День 1 завершен!* 🎊

          **Ваши достижения сегодня:**
          
          🧘 **Практика осознанности:**
          • ⏱️ Время: #{practice_time} минут
          • 🌬️ Техника: #{selected_technique[:name] || "Естественное дыхание"}
          • 🎯 Навык: Осознание дыхания как якоря
          
          ⏰ **Следующий день будет доступен через 12 часов**
          
          Ваш прогресс: #{@user.progress_percentage}%
        MARKDOWN
        
        send_message(text: completion_message, parse_mode: 'Markdown')
        
        # Предлагаем следующий день
        propose_next_day_with_restriction
      end

      def propose_next_day_with_restriction
        next_day = 2
        
        # Проверяем, можно ли начать следующий день
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ✅ *Доступен сейчас!*
            
            **Что вас ждет:**
            • 🧠 Работа с автоматическими мыслями
            • 🔍 Анализ когнитивных искажений
            • 📝 Техника "Мысль-Факт"
            • 🛠️ Практические инструменты для повседневной жизни
            
            Вы можете начать следующий день прямо сейчас.
          MARKDOWN
          
          button_text = "🚀 Начать День #{next_day}"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ⏱️ *Ограничение:* #{error_message}
            
            **Пока ждете, можете:**
            • 📝 Вести дневник эмоций (/diary)
            • 🧘 Повторить сегодняшнюю практику
            • 📊 Посмотреть статистику (/progress)
            • 🤔 Поразмышлять о сегодняшнем опыте
            
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
        when 'start_day_1_content', 'start_day_1_from_proposal'
          deliver_exercise
          
        when 'continue_day_1_content'
          # Проверяем, на каком шаге остановился пользователь
          current_step = get_day_data('current_step')
          handle_resume_from_step(current_step || 'intro')
          
        when /^day_1_breathing_(\d+)$/
          handle_breathing_technique_selection($1)
          
        when /^day_1_timer_(\d+)$/
          start_practice_timer($1.to_i)
          
        when 'day_1_timer_custom'
          send_message(text: "⏰ Введите количество минут для практики (от 1 до 30):")
          store_day_data('awaiting_custom_timer', true)
          
        when 'day_1_practice_complete'
          complete_practice
          
        when 'day_1_practice_restart'
          deliver_exercise
          
        when 'day_1_practice_cancel'
          send_message(
            text: "❌ Практика прервана. Вы всегда можете вернуться к ней позже.",
            reply_markup: TelegramMarkupHelper.back_to_main_menu_markup
          )
          
        when /^day_1_challenge_(\d+)$/
          handle_challenge_selection($1)
          
        when 'day_1_no_challenges'
          send_message(text: "🌟 Отлично! У вас получилась продуктивная практика!")
          send_message(
            text: "Завершаем День 1?",
            reply_markup: TelegramMarkupHelper.day_1_final_completion_markup
          )
          
        when 'day_1_complete_exercise', 'day_1_exercise_completed'
          complete_exercise
          
        when 'day_1_restart_practice'
          deliver_exercise
          
        when 'day_1_make_note'
          send_message(
            text: "📝 Напишите заметку о вашей сегодняшней практике (можно в свободной форме):"
          )
          store_day_data('awaiting_practice_note', true)
          
        when 'day_1_help_choose'
          send_message(
            text: "🎯 **Рекомендация по выбору техники:**\n\n• Новички: Естественное дыхание\n• Тревога: 4-7-8 дыхание\n• Концентрация: Квадратное дыхание\n• Стресс: Диафрагмальное дыхание",
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
          if minutes.between?(1, 30)
            start_practice_timer(minutes)
            return true
          else
            send_message(text: "⚠️ Пожалуйста, введите число от 1 до 30.")
            return false
          end
        end
        
        # Обработка заметки о практике
        if get_day_data('awaiting_practice_note')
          store_day_data('awaiting_practice_note', false)
          store_day_data('practice_note', input_text)
          
          send_message(text: "✅ Заметка сохранена!")
          send_message(
            text: "Завершаем День 1?",
            reply_markup: TelegramMarkupHelper.day_1_final_completion_markup
          )
          return true
        end
        
        false
      end
      
      private

      def show_intro_without_state
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        send_message(
          text: statistics_message,
          parse_mode: 'Markdown'
        )
        send_message(
          text: "Готовы начать ваше первое упражнение осознанности?",
          reply_markup: TelegramMarkupHelper.day_1_content_markup
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
          📊 *Почему миллионы людей практикуют осознанность:*
          
          • 🧠 **85%** — снижение уровня тревоги после 8 недель практики
          • 😴 **70%** — улучшение качества сна
          • 🎯 **65%** — увеличение концентрации внимания
          • 🤝 **50%** — улучшение отношений с окружающими
          • 💓 **30%** — снижение артериального давления
          
          *Источник: Исследования Гарвардского университета, Оксфорда, Университета Джона Хопкинса*
        MARKDOWN
      end
      
      def save_first_practice_stats(practice_time, technique_name)
        begin
          # Сохраняем данные первой практики для отслеживания прогресса
          store_day_data('first_practice_stats', {
            date: Date.current.to_s,
            duration: practice_time,
            technique: technique_name,
            completed: true
          })
        rescue => e
          log_error("Failed to save practice stats", e)
        end
      end
      
      def propose_next_day
        send_message(
          text: "Готовы перейти к Дню 2?",
          reply_markup: TelegramMarkupHelper.day_start_proposal_markup(2)
        )
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
# app/services/self_help/days/day_5_service.rb
module SelfHelp
  module Days
    class Day5Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 5
      
      # Шаги дня 5
      DAY_STEPS = {
        'intro' => {
          title: "🏃 *День 5: Движение как медитация* 🧠",
          instruction: <<~MARKDOWN
            **Добро пожаловать в мир осознанного движения!** 💫

            Сегодня вы откроете для себя удивительную связь между телом и психикой. Движение — это не просто физическая активность, это мощный инструмент для трансформации настроения и сознания.

            📊 **Научные факты о движении и мозге:**
            • 🧠 Повышает нейротрофический фактор мозга (BDNF) на 30-50%
            • 🎯 Стимулирует рост новых нейронов в гиппокампе (память и обучение)
            • 😊 Увеличивает выработку серотонина и дофамина на 40-60%
            • 🛡️ Снижает уровень воспалительных маркеров в мозге
            • 💤 Улучшает качество глубокого сна на 25-30%
            • 🧘 Активизирует префронтальную кору (самоконтроль и осознанность)

            🎯 **Что вы получите от сегодняшней практики:**
            1. 🏃 Физическое и ментальное перезагрузка
            2. 🧠 Улучшение когнитивных функций
            3. 😌 Естественное снижение тревоги и стресса
            4. 💫 Повышение энергии и жизненного тонуса
            5. 🔄 Навык осознанного движения как практики медитации
          MARKDOWN
        },
        'exercise_explanation' => {
          title: "🏃 *Упражнение: Движение с осознанием* 🧘",
          instruction: <<~MARKDOWN
            **Почему именно осознанное движение?** 🤔

            Когда мы двигаемся с осознанием, мы создаем уникальный диалог между телом и разумом:

            • 🔄 **Нейробиологический эффект:** Движение синхронизирует работу правого и левого полушарий
            • 🧠 **Когнитивная польза:** Улучшает внимание, память и скорость обработки информации на 15-20%
            • 😌 **Эмоциональный баланс:** Регулирует амигдалу (центр страха) и активирует островковую долю (телесное осознание)
            • 💫 **Энергетический подъем:** Увеличивает митохондриальную активность в клетках мозга
            • 🛡️ **Антистрессовый эффект:** Снижает уровень кортизола на 25-35%

            **Как работает практика осознанного движения:**
            1. 🧠 Переключаем фокус с мыслей на телесные ощущения
            2. 🔄 Синхронизируем дыхание с движением
            3. 👁️ Наблюдаем за телесными реакциями без оценки
            4. 🌊 Позволяем движению течь естественно

            **Сегодняшнее упражнение:** 10-30 минут любой активности с полным присутствием в теле.
            Цель — не "нагрузить мышцы", а "почувствовать движение".
          MARKDOWN
        },
        'practice_guidance' => {
          title: "📋 *Подготовка к практике движения* 📋",
          instruction: <<~MARKDOWN
            **Оптимальные условия для практики:**

            👟 **Экипировка и пространство:**
            • Удобная одежда, не стесняющая движений
            • Обувь с хорошей амортизацией или босиком
            • Пространство 2×2 метра для безопасного движения
            • Доступ к свежему воздуху (окно, балкон, улица)

            🎯 **Выбор активности по состоянию:**
            • Усталость/вялость → энергичная ходьба, танцы
            • Тревога/стресс → йога, растяжка, тайцзи
            • Подавленность → кардио, бег, прыжки
            • Мышечное напряжение → стретчинг, пилатес
            • Ментальная усталость → прогулка на природе

            🧠 **Установка на практику:**
            • Откажитесь от цели "потренироваться"
            • Двигайтесь ради самого движения, а не результата
            • Слушайте тело: что ему хочется сейчас?
            • Дышите глубоко и синхронно с движением
            • Если появляются мысли о цели → мягко возвращайтесь к ощущениям

            **Важно:** Как и в сидячей медитации, каждое возвращение внимания к телу — это укрепление осознанности.
          MARKDOWN
        },
        'post_practice_reflection' => {
          title: "📝 *Рефлексия после практики движения* 📝",
          instruction: <<~MARKDOWN
            **Отличная работа! Вы только что завершили практику осознанного движения!** 🌟

            **Вопросы для рефлексии:**

            🏃 **1. О телесных ощущениях:**
            • Как изменились ощущения в теле от начала к концу?
            • Где чувствовались самые приятные ощущения?
            • Были ли моменты сопротивления или дискомфорта?
            • Как дышалось во время движения?

            🧠 **2. Об уме и внимании:**
            • Удавалось ли сохранять фокус на телесных ощущениях?
            • Какие мысли чаще всего отвлекали?
            • Как быстро вы замечали, что отвлеклись?
            • Были ли моменты "потока" (полного погружения)?

            😊 **3. О настроении и эмоциях:**
            • Как изменилось настроение после активности?
            • Какие эмоции возникали во время движения?
            • Чувствуете ли вы сейчас больше энергии?
            • Что произошло с уровнем тревоги/стресса?

            💫 **Запомните:** Даже 10 минут осознанного движения могут перезагрузить и тело, и разум.
          MARKDOWN
        }
      }.freeze
      
      # Типы физической активности
      ACTIVITY_TYPES = [
        {
          name: "Прогулка на природе",
          emoji: "🚶",
          description: "Медленная или быстрая ходьба на свежем воздухе. Наблюдайте за природой, дышите полной грудью.",
          intensity: "Низкая",
          benefits: "Снижение стресса, улучшение настроения, насыщение кислородом"
        },
        {
          name: "Свободные танцы",
          emoji: "💃",
          description: "Движение под любимую музыку без правил. Позвольте телу двигаться так, как хочется.",
          intensity: "Средняя",
          benefits: "Высвобождение эмоций, радость, повышение энергии"
        },
        {
          name: "Йога и растяжка",
          emoji: "🧘",
          description: "Медленные, осознанные движения. Фокус на дыхании и ощущениях в теле.",
          intensity: "Низкая-средняя",
          benefits: "Гибкость, снижение напряжения, ментальное спокойствие"
        },
        {
          name: "Силовые упражнения",
          emoji: "🏋️",
          description: "Приседания, отжимания, планка. Концентрация на работе мышц.",
          intensity: "Средняя-высокая",
          benefits: "Уверенность, сила, дисциплина, выброс эндорфинов"
        },
        {
          name: "Кардио-тренировка",
          emoji: "🏃",
          description: "Бег, прыжки, энергичные движения. Повышение сердечного ритма.",
          intensity: "Высокая",
          benefits: "Энергия, выносливость, снижение тревоги, улучшение сна"
        },
        {
          name: "Функциональные движения",
          emoji: "🤸",
          description: "Естественные движения: приседания, наклоны, повороты. Как двигаются дети.",
          intensity: "Средняя",
          benefits: "Естественность, радость движения, телесная осознанность"
        }
      ].freeze
      
      # Типичные трудности в практике
      COMMON_CHALLENGES = [
        {
          challenge: "Нет энергии или мотивации",
          emoji: "🌀",
          solution: "Начните с 5 минут. Часто энергия приходит в процессе. Выберите самую простую активность — даже прогулка по комнате."
        },
        {
          challenge: "Тело болит или дискомфортно",
          emoji: "😣",
          solution: "Слушайте тело! Выберите более мягкую активность. Йога, растяжка или медленная прогулка. Цель — не преодоление, а осознание."
        },
        {
          challenge: "Постоянно отвлекают мысли",
          emoji: "💭",
          solution: "Это нормально! Используйте движение как якорь. Каждый раз, возвращая внимание к ощущениям в теле, вы тренируете осознанность."
        },
        {
          challenge: "Нет времени или места",
          emoji: "⏰",
          solution: "Движение может быть микропрактикой: 5 минут утренней зарядки, растяжка во время перерыва, прогулка по офису. Важно качество внимания, а не продолжительность."
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
          text: "Готовы открыть целительную силу движения?",
          reply_markup: day_5_content_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise_explanation')
        
        send_message(text: DAY_STEPS['exercise_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['exercise_explanation'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "🏃 **Выберите тип движения для сегодняшней практики:**",
          parse_mode: 'Markdown',
          reply_markup: day_5_activity_types_markup
        )
      end
      
      # Обработка выбора типа активности
      def handle_activity_selection(activity_index)
        activity = ACTIVITY_TYPES[activity_index.to_i]
        
        if activity
          store_day_data('selected_activity', activity)
          
          send_message(
            text: "✅ Выбрана активность: #{activity[:emoji]} *#{activity[:name]}*\n\n#{activity[:description]}",
            parse_mode: 'Markdown'
          )
          
          send_message(
            text: "#{activity[:emoji]} **Интенсивность:** #{activity[:intensity]}\n**Польза:** #{activity[:benefits]}",
            parse_mode: 'Markdown'
          )
          
          # Переходим к выбору времени
          sleep(1)
          show_practice_guidance
        else
          send_message(text: "⚠️ Неизвестный тип активности. Пожалуйста, выберите из предложенных.")
        end
      end
      
      def show_practice_guidance
        store_day_data('current_step', 'practice_guidance')
        
        send_message(text: DAY_STEPS['practice_guidance'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['practice_guidance'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "⏱️ *Рекомендуемое время активности:*\n\n• Начинающие: 10 минут\n• С опытом: 20 минут\n• Продвинутые: 30 минут\n\n*Начните с комфортного для вас времени!*",
          parse_mode: 'Markdown',
          reply_markup: day_5_duration_markup
        )
      end
      
      def start_activity_timer(minutes)
        store_day_data('activity_duration', minutes)
        
        selected_activity = get_day_data('selected_activity') || {}
        
        timer_message = <<~MARKDOWN
          🏃 *Начинаем практику осознанного движения!* 🧘

          ⏱️ **Таймер установлен на #{minutes} минут**
          
          🎯 **Ваша активность:** #{selected_activity[:emoji]} #{selected_activity[:name]}
          
          📋 **Задача:**
          1. Начните движение в комфортном темпе
          2. Сфокусируйтесь на ощущениях в теле
          3. Синхронизируйте дыхание с движением
          4. Когда ум отвлекается — мягко возвращайте внимание к телесным ощущениям
          5. Двигайтесь ради самого движения, а не результата
          
          🌟 **Напоминание:** Каждое возвращение внимания к телу — это укрепление связи разума и тела!
          
          Нажмите кнопку ниже, когда закончите практику.
        MARKDOWN
        
        send_message(text: timer_message, parse_mode: 'Markdown')
        
        send_message(
          text: "⏳ Практика длится #{minutes} минут...",
          reply_markup: day_5_activity_completion_markup
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
          text: "😊 *Как изменилось ваше настроение после движения?*",
          parse_mode: 'Markdown',
          reply_markup: day_5_mood_changes_markup
        )
      end
      
      def handle_mood_selection(mood_index)
        mood_options = [
          "Значительно лучше 😊",
          "Немного лучше 🙂", 
          "Без изменений 😐",
          "Хуже (усталость) 😔"
        ]
        
        mood = mood_options[mood_index.to_i] if mood_index.to_i.between?(0, 3)
        
        if mood
          store_day_data('mood_change', mood)
          send_message(
            text: "📊 **Зафиксировано:** #{mood}\n\nСпасибо за честность! Это важная информация для понимания связи между движением и настроением.",
            parse_mode: 'Markdown'
          )
        end
        
        send_message(
          text: "🤔 *С какими трудностями столкнулись?*",
          parse_mode: 'Markdown',
          reply_markup: TelegramMarkupHelper.day_5_challenges_vertical_markup  # Используем вертикальный вариант
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
          text: "🌟 Отлично! Вы завершили практику осознанного движения!\n\nХотите завершить День 5?",
          reply_markup: day_5_final_completion_markup
        )
      end
      
      def complete_exercise
        activity_duration = get_day_data('activity_duration') || 10
        selected_activity = get_day_data('selected_activity') || {}
        mood_change = get_day_data('mood_change') || "Не указано"
        
        # Отмечаем день как завершенный в программе
        @user.complete_day_program(DAY_NUMBER)
        
        # Также вызываем старый метод для совместимости
        @user.complete_self_help_day(DAY_NUMBER)
        
        # Сохраняем статистику практики
        save_movement_practice_stats(activity_duration, selected_activity[:name], mood_change)
        
        completion_message = <<~MARKDOWN
          🎊 *День 5 завершен!* 🎊

          **Ваши достижения сегодня:**
          
          🏃 **Практика осознанного движения:**
          • ⏱️ Время: #{activity_duration} минут
          • 🎯 Активность: #{selected_activity[:name] || "Прогулка"}
          • 😊 Настроение после: #{mood_change}
          • 🧠 Приобретение: Навык осознанного движения как медитации
          
          📊 **Научный факт:**
          Всего 20 минут движения в день снижают риск депрессии на 30% и улучшают когнитивные функции на 15-20%.
          
          ⏰ **Следующий день будет доступен через 12 часов**
          
          Ваш прогресс: #{@user.progress_percentage}%
        MARKDOWN
        
        send_message(text: completion_message, parse_mode: 'Markdown')
        
        # Предлагаем следующий день
        propose_next_day_with_restriction
      end

      def propose_next_day_with_restriction
        next_day = 6
        
        # Проверяем, можно ли начать следующий день
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ✅ *Доступен сейчас!*
            
            **Что вас ждет:**
            • 😌 Отдых и восстановление
            • 🧘 Техники осознанного отдыха
            • 💫 Научно обоснованные методы релаксации
            • 🔄 Баланс активности и восстановления
            
            Вы можете начать следующий день прямо сейчас.
          MARKDOWN
          
          button_text = "😌 Начать День #{next_day}"
          callback_data = "start_day_#{next_day}_from_proposal"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ⏱️ *Ограничение:* #{error_message}
            
            **Пока ждете, можете:**
            • 🏃 Повторить практику осознанного движения
            • 📝 Экспериментировать с другими видами активности
            • 🧠 Понаблюдать, как движение влияет на ваше состояние в течение дня
            • 📊 Посмотреть статистику (/progress)
            
            *Следующий день будет автоматически доступен, когда пройдет достаточно времени.*
          MARKDOWN
          
          # Если день недоступен, НЕ отправляем активную кнопку
          button_text = "⏱️ Проверить доступность Дня #{next_day}"
          callback_data = "start_day_#{next_day}_from_proposal"  # Оставляем ту же, но Day6Handler проверит
        end
        
        # Отправляем сообщение
        send_message(text: message, parse_mode: 'Markdown')
        
        # Отправляем кнопку ВСЕГДА, но Day6Handler проверит доступность
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
        when 'start_day_5_content', 'start_day_5_from_proposal'
          deliver_exercise
          
        when 'continue_day_5_content'
          # Проверяем, на каком шаге остановился пользователь
          current_step = get_day_data('current_step')
          handle_resume_from_step(current_step || 'intro')
          
        when /^day_5_activity_(\d+)$/
          handle_activity_selection($1)
          
        when /^day_5_duration_(\d+)$/
          start_activity_timer($1.to_i)
          
        when 'day_5_duration_custom'
          send_message(text: "⏰ Введите количество минут для активности (от 5 до 60):")
          store_day_data('awaiting_custom_duration', true)
          
        when 'day_5_activity_complete'
          complete_practice
          
        when 'day_5_activity_restart'
          deliver_exercise
          
        when 'day_5_activity_cancel'
          send_message(
            text: "❌ Практика прервана. Вы всегда можете вернуться к ней позже.",
            reply_markup: TelegramMarkupHelper.back_to_main_menu_markup
          )
          
        when /^day_5_mood_(\d+)$/
          handle_mood_selection($1)
          
        when 'day_5_mood_describe'
          send_message(text: "📝 Опишите, как изменилось ваше настроение после движения:")
          store_day_data('awaiting_mood_description', true)
          
        when /^day_5_challenge_(\d+)$/
          handle_challenge_selection($1)
          
        when 'day_5_no_challenges'
          send_message(text: "🌟 Отлично! У вас получилась продуктивная практика!")
          send_message(
            text: "Завершаем День 5?",
            reply_markup: day_5_final_completion_markup
          )
          
        when 'day_5_complete_exercise', 'day_5_exercise_completed'
          complete_exercise
          
        when 'day_5_restart_practice', 'day_5_add_more_activity'
          deliver_exercise
          
        when 'day_5_make_note'
          send_message(
            text: "📝 Напишите заметку о вашей сегодняшней практике осознанного движения:\n• Что вы делали?\n• Какие были ощущения?\n• Что заметили в своем состоянии?"
          )
          store_day_data('awaiting_practice_note', true)
          
        when 'day_5_help_choose'
          send_message(
            text: "🎯 **Рекомендация по выбору активности:**\n\n• Новички: Прогулка\n• Тревога/стресс: Йога/растяжка\n• Низкая энергия: Танцы\n• Для поднятия настроения: Кардио\n• Телесная осознанность: Функциональные движения\n• Сила и уверенность: Силовые упражнения",
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
          if minutes.between?(5, 60)
            start_activity_timer(minutes)
            return true
          else
            send_message(text: "⚠️ Пожалуйста, введите число от 5 до 60.")
            return false
          end
        end
        
        # Обработка описания настроения
        if get_day_data('awaiting_mood_description')
          store_day_data('awaiting_mood_description', false)
          store_day_data('mood_description', input_text)
          
          send_message(text: "✅ Описание настроения сохранено!")
          send_message(
            text: "🤔 *С какими трудностями столкнулись?*",
            parse_mode: 'Markdown',
            reply_markup: day_5_challenges_markup
          )
          return true
        end
        
        # Обработка заметки о практике
        if get_day_data('awaiting_practice_note')
          store_day_data('awaiting_practice_note', false)
          store_day_data('practice_note', input_text)
          
          send_message(text: "✅ Заметка сохранена! Она поможет вам отслеживать прогресс.")
          send_message(
            text: "Завершаем День 5?",
            reply_markup: day_5_final_completion_markup
          )
          return true
        end
        
        false
      end
      
      private
      
      # Вспомогательные методы разметки
      def day_5_content_markup
        {
          inline_keyboard: [
            [
              { text: "🏃 Начать практику движения", callback_data: 'start_day_5_content' }
            ],
            [
              { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
            ]
          ]
        }.to_json
      end
      
      def day_5_activity_types_markup
        TelegramMarkupHelper.day_5_activity_types_markup
      end
      
      def day_5_duration_markup
        TelegramMarkupHelper.day_5_duration_markup
      end
      
      def day_5_activity_completion_markup
        TelegramMarkupHelper.day_5_activity_completion_markup
      end
      
      def day_5_mood_changes_markup
        TelegramMarkupHelper.day_5_mood_changes_markup
      end
      
      def day_5_challenges_markup
        TelegramMarkupHelper.day_5_challenges_markup
      end
      
      def day_5_final_completion_markup
        TelegramMarkupHelper.day_5_final_completion_markup
      end

      def show_intro_without_state
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        send_message(
          text: statistics_message,
          parse_mode: 'Markdown'
        )
        send_message(
          text: "Готовы открыть целительную силу движения?",
          reply_markup: day_5_content_markup
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
          📊 *Почему движение так важно для психического здоровья:*
          
          • 🏃 **30%** — снижение риска депрессии при регулярной активности
          • 🧠 **20%** — улучшение когнитивных функций после 6 месяцев тренировок
          • 😌 **40%** — снижение уровня тревоги при занятиях 3 раза в неделю
          • 💤 **25%** — улучшение качества сна у людей, занимающихся спортом
          • 🧘 **50%** — увеличение объема гиппокампа (память) у физически активных пожилых людей
          • 🛡️ **35%** — снижение воспалительных маркеров, связанных с депрессией
          
          *Источник: Исследования Harvard Medical School, NIH, Американской психологической ассоциации*
        MARKDOWN
      end
      
      def save_movement_practice_stats(duration, activity_name, mood_change)
        begin
          # Сохраняем данные практики для отслеживания прогресса
          store_day_data('movement_practice_stats', {
            date: Date.current.to_s,
            duration: duration,
            activity: activity_name,
            mood_change: mood_change,
            completed: true
          })
        rescue => e
          log_error("Failed to save movement practice stats", e)
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
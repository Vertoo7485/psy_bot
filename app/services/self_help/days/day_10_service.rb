# app/services/self_help/days/day_10_service.rb
module SelfHelp
  module Days
    class Day10Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 10
      
      # Шаги дня 10
      DAY_STEPS = {
        'intro' => {
          title: "🎭 *День 10: Эмоциональный интеллект* 💡",
          instruction: <<~MARKDOWN
            **Добро пожаловать в мир осознанных эмоций!** 🌟

            Сегодня вы освоите мощный инструмент для развития эмоционального интеллекта — Дневник эмоций. Это не просто запись чувств, а научный метод анализа эмоциональных реакций.

            📊 **Научные факты об эмоциональном интеллекте:**
            • 🧠 ЭИ на 58% определяет успех в жизни и работе
            • 💡 Люди с высоким ЭИ зарабатывают на 29% больше
            • 😌 Снижает уровень стресса на 40-50%
            • 🤝 Улучшает качество отношений на 35-45%
            • 🎯 Повышает продуктивность на 20-25%
            • 🏥 Уменьшает риск выгорания на 50-60%
            • 📈 90% топ-менеджеров имеют высокий ЭИ

            🎯 **Что вы получите от сегодняшней практики:**
            1. 🎭 Навык осознания и анализа эмоций
            2. 🔄 Понимание связи: мысль → эмоция → поведение
            3. 💡 Технику когнитивного рефрейминга для эмоций
            4. 📊 Инструмент для отслеживания эмоциональных паттернов
            5. 🛡️ Защиту от эмоционального выгорания

            **Модель эмоционального интеллекта:**
            1. Самосознание → 2. Саморегуляция → 3. Мотивация → 4. Эмпатия → 5. Социальные навыки
            *Сегодня работаем с первыми двумя компонентами!*
          MARKDOWN
        },
        'exercise_explanation' => {
          title: "📔 *Дневник эмоций: Научный подход* 🔬",
          instruction: <<~MARKDOWN
            **Что такое Дневник эмоций и почему он работает?**

            Это структурированный метод анализа эмоциональных реакций, основанный на принципах когнитивно-поведенческой терапии (КПТ).

            🔬 **Научный механизм:**
            • 🧠 Активирует префронтальную кору (рациональное мышление)
            • 🔄 Прерывает автоматические эмоциональные реакции
            • 💡 Создает дистанцию между эмоцией и реакцией
            • 📊 Развивает мета-познание (мышление о мышлении)
            • 🛡️ Формирует новые нейронные пути

            **6-шаговая модель анализа:**
            1. 🎯 **Ситуация** - что произошло?
            2. 💭 **Мысли** - что я подумал?
            3. 😊 **Эмоции** - что я почувствовал?
            4. 🚶 **Поведение** - как я поступил?
            5. 🔍 **Анализ** - что говорит против моих мыслей?
            6. 🌟 **Новые мысли** - более реалистичная версия

            **Сегодняшнее упражнение:** Заполнение дневника эмоций по 6-шаговой модели.
            *Не обязательно выбирать самую болезненную ситуацию — начните с умеренной.*
          MARKDOWN
        },
        'emotion_types' => {
          title: "😊 *Эмоциональный спектр: От осознания к управлению* 🎨",
          instruction: <<~MARKDOWN
            **Базовые эмоции и их функции:**

            😊 **Радость** - мотивация, энергия, связь
            😔 **Грусть** - принятие потери, переоценка ценностей
            😠 **Гнев** - защита границ, справедливость
            😨 **Страх** - безопасность, осторожность
            😳 **Стыд** - социальная адаптация, принадлежность
            😞 **Вина** - ответственность, исправление ошибок

            **Важные принципы работы с эмоциями:**
            1. Все эмоции имеют ценность и функцию
            2. Эмоции - это данные, а не команды
            3. Между эмоцией и реакцией есть пространство выбора
            4. Осознание эмоции снижает её интенсивность на 40-60%
            5. Назвать эмоцию = получить над ней контроль

            **Совет:** Во время заполнения дневника называйте эмоции точно: 
            не просто "плохо", а "тревожно", "разочарованно", "обиженно".
          MARKDOWN
        },
        'diary_benefits' => {
          title: "📈 *Польза регулярного ведения дневника* 🌱",
          instruction: <<~MARKDOWN
            **Что дает регулярная практика дневника эмоций?**

            📊 **Доказанные эффекты (исследования Harvard, Stanford):**
            • 40-50% снижение тревоги и депрессии
            • 30-40% улучшение качества сна
            • 25-35% повышение удовлетворенности жизнью
            • 20-30% улучшение концентрации и памяти
            • 35-45% снижение конфликтности в отношениях
            • 50-60% уменьшение эмоционального выгорания

            **Как дневник меняет мозг:**
            🧠 Укрепляет связь между амигдалой (эмоции) и префронтальной корой (контроль)
            🔄 Создает новые нейронные пути для осознанных реакций
            💡 Увеличивает объем серого вещества в зонах, отвечающих за самоконтроль
            📈 Повышает активность островковой доли (телесное осознание)

            **Рекомендация:** Вести дневник 2-3 раза в неделю по 10-15 минут.
            Лучшие результаты заметны через 6-8 недель регулярной практики.
          MARKDOWN
        },
        'completion' => {
          title: "🎊 *Анализ завершен!* 📚",
          instruction: <<~MARKDOWN
            **Отличная работа! Вы только что завершили полный эмоциональный анализ!** 🌟

            **Что вы сделали:**
            1. 🎯 Проанализировали эмоционально значимую ситуацию
            2. 💭 Выявили автоматические мысли
            3. 😊 Осознали и назвали эмоции
            4. 🚶 Проанализировали своё поведение
            5. 🔍 Проверили реалистичность мыслей
            6. 🌟 Создали более адаптивные формулировки

            **Поздравляем!** Вы применили технику, которая:
            • 🧠 Используется в когнитивно-поведенческой терапии (КПТ)
            • 📊 Подтверждена исследованиями в психологии
            • 😌 Помогает тысячам людей по всему миру
            • 🔄 Меняет структуру эмоционального реагирования

            **Следующие шаги:**
            • 📚 Просмотрите свои предыдущие записи
            • 🔄 Практикуйте технику с разными ситуациями
            • 💪 Используйте новые мысли в реальной жизни
            • 📅 Сделайте дневник регулярной практикой
          MARKDOWN
        }
      }.freeze
      
      # Основные эмоции для помощи в анализе
      CORE_EMOTIONS = [
        {
          name: "Радость",
          emoji: "😊",
          description: "Чувство удовольствия, счастья, удовлетворения",
          triggers: "Достижения, приятные события, успехи",
          function: "Мотивация, связь с другими, энергия"
        },
        {
          name: "Грусть",
          emoji: "😔",
          description: "Чувство утраты, разочарования, тоски",
          triggers: "Потери, неудачи, разлука",
          function: "Принятие потери, переоценка ценностей, просьба о поддержке"
        },
        {
          name: "Гнев",
          emoji: "😠",
          description: "Чувство раздражения, злости, негодования",
          triggers: "Нарушение границ, несправедливость, фрустрация",
          function: "Защита границ, восстановление справедливости, мобилизация энергии"
        },
        {
          name: "Тревога/Страх",
          emoji: "😨",
          description: "Чувство беспокойства, опасения, страха",
          triggers: "Неопределенность, угрозы, новизна",
          function: "Безопасность, подготовка к опасности, осторожность"
        },
        {
          name: "Стыд",
          emoji: "😳",
          description: "Чувство неловкости, смущения, унижения",
          triggers: "Нарушение социальных норм, публичные ошибки",
          function: "Социальная адаптация, исправление поведения, принадлежность к группе"
        },
        {
          name: "Вина",
          emoji: "😞",
          description: "Чувство ответственности за причиненный вред",
          triggers: "Нарушение собственных ценностей, причинение вреда другим",
          function: "Исправление ошибок, восстановление отношений, личностный рост"
        }
      ].freeze
      
      # Типичные когнитивные искажения в эмоциональных реакциях
      EMOTIONAL_DISTORTIONS = [
        {
          name: "Катастрофизация",
          emoji: "🌀",
          description: "Преувеличение негативных последствий до катастрофических масштабов",
          example: "'Если я ошибусь, это будет конец света'"
        },
        {
          name: "Персонализация",
          emoji: "🎯",
          description: "Принятие на свой счёт событий, к которым вы не имеете отношения",
          example: "'Он нахмурился, значит, я ему не нравлюсь'"
        },
        {
          name: "Чтение мыслей",
          emoji: "🔮",
          description: "Уверенность в том, что вы знаете, что думают другие люди",
          example: "'Они точно считают меня глупым' без доказательств"
        },
        {
          name: "Долженствование",
          emoji: "⚖️",
          description: "Жесткие правила о том, как должны вести себя люди и как должен устроен мир",
          example: "'Я ДОЛЖЕН всегда быть совершенным'"
        },
        {
          name: "Обесценивание позитивного",
          emoji: "⬇️",
          description: "Игнорирование или обесценивание хороших событий и качеств",
          example: "'Этот успех был просто удачей, не моей заслугой'"
        }
      ].freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        # Шаг 1: Введение в день 10
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
          text: "Готовы развивать эмоциональный интеллект с помощью дневника эмоций?",
          reply_markup: day_10_content_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise_explanation')
        
        send_message(text: DAY_STEPS['exercise_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['exercise_explanation'][:instruction], parse_mode: 'Markdown')
        
        # Показываем эмоциональный спектр
        sleep(1)
        show_emotion_types
      end
      
      def show_emotion_types
        store_day_data('current_step', 'emotion_types')
        
        send_message(text: DAY_STEPS['emotion_types'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['emotion_types'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "😊 *Основные эмоции для анализа:*",
          parse_mode: 'Markdown',
          reply_markup: day_10_core_emotions_markup
        )
        
        send_message(
          text: "🎯 *Подумайте о ситуации для анализа:*\n\n• Не обязательно самой болезненной\n• Лучше выбрать недавнюю и умеренно значимую\n• То, что вызвало заметную эмоциональную реакцию\n• Ситуацию, которую вы хотите лучше понять",
          parse_mode: 'Markdown'
        )
        
        # Начинаем дневник эмоций через существующий сервис
        sleep(2)
        start_emotion_diary_for_day_10
      end
      
      def start_emotion_diary_for_day_10
        log_info("Starting emotion diary for Day 10")
        
        # Устанавливаем флаг, что мы в программе самопомощи
        @user.store_self_help_data('emotion_diary_context', 'day_10')
        
        # Используем существующий EmotionDiaryService
        diary_service = EmotionDiaryService.new(@bot_service, @user, @chat_id)
        
        # Начинаем новую запись через существующий сервис
        diary_service.start_new_entry
        
        # Устанавливаем состояние ожидания ввода
        @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_diary")
        
        log_info("Emotion diary started for Day 10")
      end
      
      def handle_diary_completion
        log_info("Handling emotion diary completion for Day 10")
        
        # Проверяем, заполнен ли дневник
        if @user.current_diary_step.present? && @user.current_diary_step != 'completed'
          send_message(
            text: "📝 *Вы еще не завершили заполнение дневника.*\n\nПожалуйста, завершите все 6 шагов перед продолжением.",
            parse_mode: 'Markdown'
          )
          return false
        end
        
        # Получаем последнюю запись пользователя
        last_entry = @user.emotion_diary_entries.recent.first
        
        unless last_entry
          send_message(
            text: "❌ *Запись дневника не найдена.*\n\nПожалуйста, начните заполнение дневника заново.",
            parse_mode: 'Markdown'
          )
          return false
        end
        
        # Устанавливаем состояние завершения
        store_day_data('diary_completed', true)
        store_day_data('diary_entry_id', last_entry.id)
        store_day_data('completion_time', Time.current)
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_diary_completed")
        
        # Показываем пользу дневника
        show_diary_benefits
        
        true
      end
      
      def show_diary_benefits
        store_day_data('current_step', 'diary_benefits')
        
        send_message(text: DAY_STEPS['diary_benefits'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['diary_benefits'][:instruction], parse_mode: 'Markdown')
        
        # Показываем краткий обзор заполненного дневника
        show_diary_summary
        
        sleep(1)
        
        send_message(
          text: "🌟 Отличная работа! Вы завершили анализ эмоций.\n\nЧто дальше?",
          parse_mode: 'Markdown',
          reply_markup: day_10_final_completion_markup
        )
      end
      
      def show_diary_summary
        # Получаем последнюю запись
        last_entry = @user.emotion_diary_entries.recent.first
        
        return unless last_entry
        
        summary = <<~MARKDOWN
          📊 *Краткий обзор вашего анализа:*
          
          📅 **Дата:** #{last_entry.date.strftime('%d.%m.%Y')}
          
          🎯 **Ситуация:** "#{last_entry.situation.truncate(50)}..."
          
          😊 **Основные эмоции:** #{last_entry.emotions.truncate(50)}
          
          💡 **Ключевое осознание:** "#{last_entry.new_thoughts.truncate(50)}..."
          
          ✅ **Сохранено в вашу коллекцию дневников эмоций**
        MARKDOWN
        
        send_message(text: summary, parse_mode: 'Markdown')
      end
      
      def show_previous_entries
        entries = @user.emotion_diary_entries.recent.limit(3)
        
        if entries.empty?
          send_message(
            text: "📚 *Ваши записи дневника эмоций:*\n\nПока нет сохраненных записей.\nЗаполните дневник, чтобы увидеть их здесь.",
            parse_mode: 'Markdown'
          )
          return
        end
        
        send_message(
          text: "📚 *Ваши последние записи (всего: #{@user.emotion_diary_entries.count}):*",
          parse_mode: 'Markdown'
        )
        
        entries.each_with_index do |entry, index|
          entry_summary = <<~MARKDOWN
            *#{index + 1}. #{entry.date.strftime('%d.%m.%Y')}*
            🎯 #{entry.situation.truncate(50)}...
            😊 #{entry.emotions.truncate(30)}
            💡 #{entry.new_thoughts.truncate(30)}
          MARKDOWN
          
          send_message(text: entry_summary, parse_mode: 'Markdown')
        end
        
        if @user.emotion_diary_entries.count > 3
          send_message(
            text: "📖 ...и еще #{@user.emotion_diary_entries.count - 3} записей.\nИспользуйте меню 'Дневник эмоций' для просмотра всех записей.",
            parse_mode: 'Markdown'
          )
        end
      end
      
      def complete_exercise
        # Проверяем, завершен ли дневник
        unless get_day_data('diary_completed') == true
          send_message(
            text: "⚠️ Сначала завершите заполнение дневника эмоций.\n\nУбедитесь, что вы прошли все 6 шагов дневника.",
            parse_mode: 'Markdown',
            reply_markup: day_10_content_markup
          )
          return
        end
        
        # Отмечаем день как завершенный в программе
        @user.complete_day_program(DAY_NUMBER)
        @user.complete_self_help_day(DAY_NUMBER)
        
        # Устанавливаем состояние завершения
        @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
        
        completion_message = <<~MARKDOWN
          🎊 *День 10 завершен!* 🎊

          **Ваши достижения сегодня:**
          
          🎭 **Развитие эмоционального интеллекта:**
          • 📔 Заполнен дневник эмоций по научной модели
          • 🧠 Проанализирована связь: мысль → эмоция → поведение
          • 🔍 Проверена реалистичность автоматических мыслей
          • 💡 Созданы новые, более адаптивные формулировки
          • 🎭 Приобретение: Навык осознанного анализа эмоций
          
          📊 **Научный факт:**
          Регулярное ведение дневника эмоций повышает эмоциональный интеллект на 25-35% за 8 недель и снижает уровень стресса на 40-50%.
          
          🎯 **Что дальше:**
          Завтра - День 11: Техника заземления 5-4-3-2-1
          
          ⏰ **Следующий день будет доступен через 12 часов**
          
          Ваш прогресс: #{@user.progress_percentage}%
        MARKDOWN
        
        send_message(text: completion_message, parse_mode: 'Markdown')
        
        # Предлагаем следующий день
        propose_next_day_with_restriction
      end
      
      # ===== ОБРАБОТКА КНОПОК =====
      
      def handle_button(callback_data)
        case callback_data
        when 'start_day_10_content', 'start_day_10_from_proposal'
          deliver_exercise
          
        when 'continue_day_10_content'
          current_step = get_day_data('current_step')
          handle_resume_from_step(current_step || 'intro')
          
        when 'day_10_start_diary'
          start_emotion_diary_for_day_10
          
        when 'day_10_diary_completed'
          handle_diary_completion
          
        when 'day_10_show_entries'
          show_previous_entries
          
        when 'day_10_view_all_entries'
          # Используем существующий сервис для показа всех записей
          diary_service = EmotionDiaryService.new(@bot_service, @user, @chat_id)
          diary_service.show_entries(10)
          
        when 'day_10_complete_exercise', 'day_10_exercise_completed'
          complete_exercise
          
        when 'day_10_restart_diary'
          deliver_exercise
          
        when /^day_10_emotion_(\d+)$/
          show_emotion_info($1.to_i)
          
        when /^day_10_distortion_(\d+)$/
          show_distortion_info($1.to_i)
          
        when 'day_10_help_choose_situation'
          send_message(
            text: "🎯 *Рекомендации по выбору ситуации:*\n\n• Недавняя (последние 1-2 дня)\n• Умеренно значимая (не травматическая)\n• Конкретная (не абстрактная 'вся жизнь плоха')\n• С доступными деталями (помните подробности)\n• С заметной эмоциональной реакцией",
            parse_mode: 'Markdown'
          )
          
        when 'day_10_skip_to_completion'
          # Пропуск дневника (только для тестирования/экстренных случаев)
          send_message(
            text: "⚠️ *Пропуск дневника эмоций*\n\nВы пропустили практику дневника. Рекомендуем вернуться и заполнить его позже через меню 'Дневник эмоций'.",
            parse_mode: 'Markdown'
          )
          @user.set_self_help_step("day_#{DAY_NUMBER}_diary_completed")
          show_diary_benefits
          
        else
          log_warn("Unknown button callback: #{callback_data}")
          send_message(text: "Неизвестная команда.")
        end
      end
      
      # ===== ОБРАБОТКА ТЕКСТОВОГО ВВОДА =====
      
      def handle_text_input(input_text)
        log_info("Handling text input for day 10: #{input_text}")
        
        current_state = @user.self_help_state
        
        # Проверяем, находится ли пользователь в процессе заполнения дневника
        if current_state == "day_10_waiting_for_diary" || 
           (@user.current_diary_step.present? && @user.current_diary_step != 'completed')
          
          # Используем существующий EmotionDiaryService для обработки ответа
          diary_service = EmotionDiaryService.new(@bot_service, @user, @chat_id)
          
          # Обрабатываем ответ через существующий сервис
          handled = diary_service.handle_answer(input_text)
          
          if handled
            # Если дневник завершен в EmotionDiaryService, проверяем контекст
            if @user.current_diary_step == 'completed'
              # Проверяем, находимся ли мы в программе самопомощи
              if @user.get_self_help_data('emotion_diary_context') == 'day_10'
                # Автоматически переходим к следующему шагу дня 10
                sleep(1)
                handle_diary_completion
              end
            end
            return true
          end
        elsif current_state == "day_10_diary_completed" || current_state == "day_10_completed"
          # Если дневник уже завершен
          send_message(
            text: "✅ Дневник эмоций уже завершен. Вы можете:\n• Просмотреть свои записи\n• Начать новый анализ\n• Завершить день 10",
            reply_markup: day_10_final_completion_markup
          )
          return true
        end
        
        log_warn("No text input handler for current state: #{current_state}")
        false
      end
      
      # Метод для совместимости с SelfHelpFacade
      def handle_smart_input(text)
        handle_text_input(text)
      end
      
      def handle_resume_from_step(step)
        case step
        when 'intro'
          deliver_intro
        when 'exercise_explanation'
          deliver_exercise
        when 'emotion_types'
          show_emotion_types
        when 'diary_benefits'
          show_diary_benefits
        when 'completion'
          show_completion_message
        else
          deliver_exercise
        end
      end
      
      def show_intro_without_state
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        send_message(
          text: statistics_message,
          parse_mode: 'Markdown'
        )
        send_message(
          text: "Готовы развивать эмоциональный интеллект с помощью дневника эмоций?",
          reply_markup: day_10_content_markup
        )
      end
      
      def propose_next_day_with_restriction
        next_day = 11
        
        # Проверяем, можно ли начать следующий день
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ✅ *Доступен сейчас!*
            
            **Что вас ждет:**
            • 🌍 Техника заземления 5-4-3-2-1
            • 🧘 Возвращение в настоящее
            • 😌 Снижение тревоги и панических атак
            • 📍 Фокусировка на ощущениях здесь и сейчас
            
            Вы можете начать следующий день прямо сейчас.
          MARKDOWN
          
          button_text = "🌍 Начать День #{next_day}"
          callback_data = "start_day_#{next_day}_from_proposal"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ⏱️ *Ограничение:* #{error_message}
            
            **Пока ждете, можете:**
            • 📔 Практиковать дневник эмоций с другими ситуациями
            • 📚 Просмотреть свои предыдущие записи
            • 🎭 Экспериментировать с анализом разных эмоций
            • 📊 Посмотреть статистику (/progress)
            
            *Следующий день будет автоматически доступен, когда пройдет достаточно времени.*
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
      
      def show_emotion_info(index)
        emotion = CORE_EMOTIONS[index]
        
        if emotion
          info_text = <<~MARKDOWN
            #{emotion[:emoji]} *#{emotion[:name]}*
            
            #{emotion[:description]}
            
            **Триггеры (что вызывает):**
            #{emotion[:triggers]}
            
            **Функция (зачем нужна):**
            #{emotion[:function]}
            
            **Как работать с этой эмоцией:**
            1. Признайте её присутствие
            2. Назовите её точно
            3. Спросите: "Что эта эмоция хочет мне сказать?"
            4. Поблагодарите её за работу
            5. Решите, как действовать конструктивно
          MARKDOWN
          
          send_message(text: info_text, parse_mode: 'Markdown')
        end
      end
      
      def show_distortion_info(index)
        distortion = EMOTIONAL_DISTORTIONS[index]
        
        if distortion
          info_text = <<~MARKDOWN
            #{distortion[:emoji]} *#{distortion[:name]}*
            
            #{distortion[:description]}
            
            **Пример:**
            #{distortion[:example]}
            
            **Как заметить это искажение:**
            • Спросите: "Какие у меня есть доказательства?"
            • Ищите альтернативные объяснения
            • Проверьте, не преувеличиваете ли вы
            • Отделите факты от интерпретаций
          MARKDOWN
          
          send_message(text: info_text, parse_mode: 'Markdown')
        end
      end
      
      # Вспомогательные методы разметки
      def day_10_content_markup
        TelegramMarkupHelper.day_10_content_markup
      end
      
      def day_10_core_emotions_markup
        TelegramMarkupHelper.day_10_core_emotions_markup
      end
      
      def day_10_diary_start_markup
        TelegramMarkupHelper.day_10_diary_start_markup
      end
      
      def day_10_final_completion_markup
        TelegramMarkupHelper.day_10_final_completion_markup
      end
      
      def statistics_message
        <<~MARKDOWN
          📊 *Научные данные об эмоциональном интеллекте:*
          
          • 🧠 **58%** — влияние ЭИ на успех в работе и жизни (Harvard Business Review)
          • 💼 **29%** — разница в зарплате между людьми с высоким и низким ЭИ
          • 😌 **40-50%** — снижение стресса при развитии ЭИ
          • 🤝 **35-45%** — улучшение качества отношений
          • 🎯 **20-25%** — повышение продуктивности
          • 🏥 **50-60%** — снижение риска выгорания
          • 📈 **90%** — топ-менеджеров с высоким ЭИ
          
          *Источник: Исследования Yale, Harvard, American Psychological Association*
        MARKDOWN
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
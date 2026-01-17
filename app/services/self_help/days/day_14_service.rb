# app/services/self_help/days/day_14_service.rb
module SelfHelp
  module Days
    class Day14Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 14
      
      # Шаги дня 14
      DAY_STEPS = {
        'intro' => {
          title: "🔄 *День 14: Промежуточная рефлексия* 🔄",
          instruction: <<~MARKDOWN
            **Поздравляем с завершением первых 2 недель программы!** 🎉

            За эти 14 дней вы проделали впечатляющий путь:

            📅 **Ваш путь за 2 недели:**
            • Неделя 1: Освоение основ осознанности и саморегуляции
            • Неделя 2: Работа с мышлением и эмоциональным интеллектом
            • 🧠 13 различных техник и практик
            • 💪 Значительный прогресс в самопонимании

            📊 **Научные факты о промежуточной рефлексии:**
            • 🧠 Промежуточная рефлексия улучшает долгосрочное запоминание на 45-55%
            • 😌 Снижает уровень выгорания на 30-40%
            • 💡 Повышает осознанность применения навыков на 35-45%
            • 🔄 Ускоряет прогресс в следующих этапах на 25-30%
            • 🎯 Улучшает целеполагание и планирование на 40-50%

            🎯 **Что вы получите от сегодняшней практики:**
            1. 📊 Ясную картину вашего двухнедельного прогресса
            2. 🧠 Интеграцию полученного опыта в единую систему
            3. 🎯 Осознание сильных сторон и зон роста
            4. 💫 План на следующие 2 недели
            5. 🌟 Признание своих достижений и усилий
          MARKDOWN
        },
        'exercise_explanation' => {
          title: "📖 *Упражнение: Глубинная рефлексия 2 недель* 💭",
          instruction: <<~MARKDOWN
            **Почему рефлексия на середине пути так важна?** 🤔

            Промежуточная рефлексия создает "точку опоры" для всего процесса:

            • 🔄 **Нейробиологический эффект:** Активирует дефолт-систему мозга (интеграция опыта) и префронтальную кору (планирование)
            • 🧠 **Когнитивная польза:** Улучшает метапознание — способность думать о своем мышлении
            • 😌 **Эмоциональный баланс:** Помогает осознать и интегрировать эмоциональные переживания
            • 🎯 **Стратегическое мышление:** Позволяет скорректировать курс на основе полученного опыта
            • 🌱 **Мотивация и энергия:** Восстанавливает ресурсы для продолжения пути

            **Сегодняшнее упражнение:** Глубинная рефлексия первых 2 недель.
            Цель — интегрировать опыт и создать прочную основу для продолжения.
          MARKDOWN
        }
      }.freeze
      
      # Категории рефлексии для 2 недель
      REFLECTION_CATEGORIES = [
        {
          id: 0,
          name: "Основные достижения",
          emoji: "🏆",
          description: "Что стало вашими главными победами за 2 недели?",
          prompt: <<~PROMPT
            🏆 *Основные достижения 2 недель:*

            • Какие техники или практики оказались для вас наиболее ценными и почему?
            • В какие моменты вы чувствовали наибольший прогресс или прорыв?
            • Какие привычки или навыки начали формироваться?
            • Что изменилось в вашем повседневном самочувствии?

            *Напишите о ваших главных достижениях:* 📝
          PROMPT
        },
        {
          id: 1,
          name: "Ключевые инсайты",
          emoji: "💡",
          description: "Какие важные открытия вы сделали о себе?",
          prompt: <<~PROMPT
            💡 *Ключевые инсайты о себе:*

            • Что нового вы узнали о своих эмоциональных реакциях?
            • Какие паттерны мышления или поведения обнаружили?
            • Какие сильные стороны себя открыли?
            • Что стало самым неожиданным открытием?

            *Напишите о ваших главных инсайтах:* 📝
          PROMPT
        },
        {
          id: 2,
          name: "Преодоленные трудности",
          emoji: "🌊",
          description: "Какие вызовы встретились и как вы с ними справились?",
          prompt: <<~PROMPT
            🌊 *Преодоленные трудности:*

            • С какими упражнениями или темами было труднее всего работать?
            • Какие внутренние сопротивления вы преодолели?
            • Как изменилось ваше отношение к сложностям?
            • Какие ресурсы помогали вам продолжать в трудные моменты?

            *Напишите о преодоленных трудностях:* 📝
          PROMPT
        },
        {
          id: 3,
          name: "Наиболее полезные техники",
          emoji: "🛠️",
          description: "Какие инструменты стали вашими любимыми?",
          prompt: <<~PROMPT
            🛠️ *Наиболее полезные техники:*

            • Какие 3-5 техник оказались самыми эффективными для вас?
            • Какие инструменты стали частью вашей повседневности?
            • Какие практики давали наибольшее чувство облегчения или прогресса?
            • Что вы планируете продолжать использовать регулярно?

            *Напишите о самых полезных техниках:* 📝
          PROMPT
        },
        {
          id: 4,
          name: "Планы на следующие 2 недели",
          emoji: "🗺️",
          description: "Как вы видите продолжение своего пути?",
          prompt: <<~PROMPT
            🗺️ *Планы на следующие 2 недели:*

            • Какие цели вы ставите перед собой на вторую половину программы?
            • На что хотите обратить особое внимание?
            • Как будете поддерживать свою мотивацию?
            • Какие техники хотите углубить или освоить?

            *Напишите о ваших планах:* 📝
          PROMPT
        }
      ].freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        
        # Статистика 2 недель для мотивации
        send_message(
          text: two_weeks_statistics_message,
          parse_mode: 'Markdown'
        )
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        store_day_data('current_step', 'intro')
        
        send_message(
          text: "Готовы к глубинной рефлексии первых 2 недель?",
          reply_markup: day_14_content_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise_explanation')
        
        send_message(text: DAY_STEPS['exercise_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['exercise_explanation'][:instruction], parse_mode: 'Markdown')
        
        # Инициализируем процесс рефлексии
        init_reflection_process
      end
      
      def init_reflection_process
        # Сбрасываем прогресс рефлексии
        store_day_data('reflection_progress', {
          current_category_index: 0,
          completed_categories: [],
          reflections: {},
          start_time: Time.current
        })
        
        # Показываем первую категорию
        show_next_reflection_category
      end
      
      def show_next_reflection_category
        progress = get_reflection_progress
        current_index = progress[:current_category_index]
        
        if current_index >= REFLECTION_CATEGORIES.size
          # Все категории пройдены
          complete_reflection_process
          return
        end
        
        category = REFLECTION_CATEGORIES[current_index]
        
        # Показываем прогресс
        show_reflection_progress(current_index)
        
        # Показываем категорию
        send_message(
          text: category_prompt_with_progress(category, current_index),
          parse_mode: 'Markdown',
          reply_markup: day_14_category_options_markup(current_index)
        )
        
        # Устанавливаем состояние ожидания ввода
        @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_reflection_#{current_index}")
      end
      
      def handle_reflection_text(input_text, category_index)
        return false if input_text.blank?
        
        # Сохраняем рефлексию
        progress = get_reflection_progress
        progress[:reflections][category_index.to_s] = {
          text: input_text,
          timestamp: Time.current,
          length: input_text.length
        }
        
        # Отмечаем категорию как завершенную
        progress[:completed_categories] << category_index unless progress[:completed_categories].include?(category_index)
        
        # Переходим к следующей категории
        progress[:current_category_index] = category_index + 1
        
        save_reflection_progress(progress)
        
        # Подтверждаем сохранение
        send_message(
          text: "✅ Сохранено! #{category_emoji(category_index)} Рефлексия по категории *#{REFLECTION_CATEGORIES[category_index][:name]}* сохранена.",
          parse_mode: 'Markdown'
        )
        
        # Автоматически переходим к следующей категории
        if progress[:current_category_index] < REFLECTION_CATEGORIES.size
          sleep(1) # Небольшая пауза
          show_next_reflection_category
        else
          complete_reflection_process
        end
        
        true
      end
      
      def skip_category(category_index)
        progress = get_reflection_progress
        
        # Пропускаем категорию
        progress[:current_category_index] = category_index + 1
        save_reflection_progress(progress)
        
        send_message(
          text: "⏭️ Пропущено: #{category_emoji(category_index)} *#{REFLECTION_CATEGORIES[category_index][:name]}*",
          parse_mode: 'Markdown'
        )
        
        # Переходим к следующей категории
        if progress[:current_category_index] < REFLECTION_CATEGORIES.size
          show_next_reflection_category
        else
          complete_reflection_process
        end
      end
      
      def complete_reflection_process
        progress = get_reflection_progress
        completed_count = progress[:completed_categories].size
        
        send_message(
          text: completion_summary_message(completed_count),
          parse_mode: 'Markdown'
        )
        
        # Сохраняем полную рефлексию
        save_two_weeks_reflection_entry
        
        # Переходим к вопросам о трудностях
        show_reflection_challenges
      end
      
      def show_reflection_challenges
        send_message(
          text: "🤔 *С какими трудностями столкнулись в процессе рефлексии?*",
          parse_mode: 'Markdown',
          reply_markup: day_14_challenges_markup
        )
      end
      
      def handle_challenge_selection(challenge_index)
        challenge_options = [
          "🧠 Трудно вспомнить все 2 недели",
          "😔 Чувствую, что могло быть лучше",
          "🤔 Не знаю, как оценить свой прогресс",
          "😰 Боюсь, что недостаточно продвинулся"
        ]
        
        challenge = challenge_options[challenge_index.to_i] if challenge_index.to_i.between?(0, 3)
        
        if challenge
          solutions = [
            "Начните с последних дней и двигайтесь назад. Вспомните 2-3 самых ярких момента — этого достаточно.",
            "Прогресс редко бывает линейным. Отметьте даже маленькие изменения — они важны.",
            "Сравните себя сегодня с собой 2 недели назад. Что изменилось в ваших реакциях, мыслях, ощущениях?",
            "Каждый день практики — это уже достижение. Вы проявили настойчивость, и это ценно само по себе."
          ]
          
          send_message(
            text: "🌀 **#{challenge}**\n\n#{solutions[challenge_index.to_i]}",
            parse_mode: 'Markdown'
          )
        end
        
        send_message(
          text: "🌟 Отлично! Вы завершили глубинный анализ 2 недель!\n\nХотите завершить День 14 и отметить середину программы?",
          reply_markup: day_14_final_completion_markup
        )
      end
      
      def complete_exercise
        progress = get_reflection_progress
        completed_count = progress[:completed_categories].size
        
        # Исправляем подсчет длины - защита от nil
        total_length = progress[:reflections].values.sum do |r|
          r[:length].to_i  # Используем .to_i для преобразования nil в 0
        end
        
        # Отмечаем день как завершенный в программе
        @user.complete_day_program(DAY_NUMBER)
        @user.complete_self_help_day(DAY_NUMBER)
        
        completion_message = <<~MARKDOWN
          🎊 *День 14 и первые 2 недели программы завершены!* 🎉

          **Ваши достижения за 2 недели:**
          
          📊 **Итоги рефлексии:**
          • ✅ Завершено категорий: #{completed_count}/#{REFLECTION_CATEGORIES.size}
          • 📝 Общий объем: #{total_length} символов
          • 🧠 Приобретение: Навык глубинной промежуточной рефлексии
          
          🌟 **Прогресс за 2 недели:**
          • ✅ Освоено 13 различных техник самопомощи
          • 📈 Развиты навыки осознанности, эмоционального интеллекта и работы с мышлением
          • 💫 Создана прочная основа для второй половины программы
          • 🏆 Пройдено 50% всей программы!
          
          ⏰ **Следующая неделя будет доступна через 12 часов**
          
          Ваш общий прогресс: #{@user.progress_percentage}%
        MARKDOWN
        
        send_message(text: completion_message, parse_mode: 'Markdown')
        
        # Предлагаем следующую неделю
        propose_next_week
      end
      
      # ===== ОБРАБОТКА КНОПОК =====
      
      def handle_button(callback_data)
        case callback_data
        when 'start_day_14_content', 'start_day_14_from_proposal', 'start_two_weeks_reflection'
          deliver_exercise
          
        when 'continue_day_14_content'
          current_step = get_day_data('current_step')
          handle_resume_from_step(current_step || 'intro')
          
        when /^day_14_skip_(\d+)$/
          skip_category($1.to_i)
          
        when /^day_14_challenge_(\d+)$/
          handle_challenge_selection($1)
          
        when 'day_14_no_challenges'
          send_message(text: "🌟 Отлично! У вас получилась продуктивная рефлексия!")
          send_message(
            text: "Завершаем День 14 и отмечаем середину программы?",
            reply_markup: day_14_final_completion_markup
          )
          
        when 'day_14_complete_exercise', 'reflection_exercise_completed'
          complete_exercise
          
        when 'day_14_restart_reflection'
          init_reflection_process
          
        else
          log_warn("Unknown button callback: #{callback_data}")
          send_message(text: "Неизвестная команда.")
        end
      end
      
      # Обработка текстового ввода
      def handle_text_input(input_text)
        # Проверяем, в каком состоянии находится пользователь
        current_state = @user.self_help_state
        
        # Определяем, какая категория рефлексии активна
        if current_state&.start_with?("day_14_waiting_reflection_")
          category_index = current_state.split('_').last.to_i
          return handle_reflection_text(input_text, category_index)
        end
        
        # Обработка старого формата для обратной совместимости
        if current_state == "day_14_waiting_for_reflection"
          return handle_reflection_input_legacy(input_text)
        end
        
        false
      end
      
      def resume_session
        current_state = @user.self_help_state
        
        case current_state
        when "day_#{DAY_NUMBER}_intro"
          deliver_intro
          
        when "day_#{DAY_NUMBER}_exercise_in_progress"
          progress = get_reflection_progress
          if progress[:current_category_index] > 0
            # Продолжаем с текущей категории
            show_next_reflection_category
          else
            # Начинаем сначала
            deliver_exercise
          end
          
        when /^day_#{DAY_NUMBER}_waiting_reflection_/
          # Восстанавливаем текущую категорию
          progress = get_reflection_progress
          show_next_reflection_category
          
        else
          deliver_intro
        end
      end
      
      private
      
      # Вспомогательные методы разметки
      def day_14_content_markup
        {
          inline_keyboard: [
            [
              { text: "📖 Начать рефлексию 2 недель", callback_data: 'start_day_14_content' }
            ],
            [
              { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
            ]
          ]
        }.to_json
      end
      
      def day_14_category_options_markup(category_index)
        {
          inline_keyboard: [
            [
              { text: "⏭️ Пропустить эту категорию", callback_data: "day_14_skip_#{category_index}" }
            ]
          ]
        }.to_json
      end
      
      def day_14_challenges_markup
        {
          inline_keyboard: [
            [
              { text: "🧠 Трудно вспомнить все", callback_data: 'day_14_challenge_0' }
            ],
            [
              { text: "😔 Могло быть лучше", callback_data: 'day_14_challenge_1' }
            ],
            [
              { text: "🤔 Не знаю как оценить", callback_data: 'day_14_challenge_2' }
            ],
            [
              { text: "😰 Боюсь недостаточного прогресса", callback_data: 'day_14_challenge_3' }
            ],
            [
              { text: "✅ Никаких трудностей", callback_data: 'day_14_no_challenges' }
            ]
          ]
        }.to_json
      end
      
      def day_14_final_completion_markup
        {
          inline_keyboard: [
            [
              { text: "🎉 Завершить 2 недели!", callback_data: 'day_14_complete_exercise' },
              { text: "🔄 Начать заново", callback_data: 'day_14_restart_reflection' }
            ]
          ]
        }.to_json
      end
      
      # Методы для управления прогрессом рефлексии
      def get_reflection_progress
        progress_data = get_day_data('reflection_progress') || {}
        {
          current_category_index: progress_data['current_category_index']&.to_i || 0,
          completed_categories: Array(progress_data['completed_categories']).map(&:to_i),
          reflections: progress_data['reflections'] || {},
          start_time: (Time.parse(progress_data['start_time']) rescue Time.current)
        }
      end
      
      def save_reflection_progress(progress)
        store_day_data('reflection_progress', {
          current_category_index: progress[:current_category_index],
          completed_categories: progress[:completed_categories],
          reflections: progress[:reflections],
          start_time: progress[:start_time].iso8601
        })
      end
      
      def show_reflection_progress(current_index)
        total = REFLECTION_CATEGORIES.size
        progress_bar = "🟩" * (current_index) + "⬜" * (total - current_index)
        
        send_message(
          text: "📊 *Прогресс:* #{progress_bar} (#{current_index + 1}/#{total})",
          parse_mode: 'Markdown'
        )
      end
      
      def category_prompt_with_progress(category, current_index)
        <<~MARKDOWN
          #{category[:emoji]} *Категория #{current_index + 1}/#{REFLECTION_CATEGORIES.size}: #{category[:name]}*
          
          #{category[:prompt]}
          
          *Просто напишите ваш ответ и отправьте его как обычное сообщение.*
          *Бот автоматически сохранит его и перейдет к следующей категории.*
        MARKDOWN
      end
      
      def category_emoji(category_index)
        REFLECTION_CATEGORIES[category_index][:emoji] rescue "📝"
      end
      
      def completion_summary_message(completed_count)
        total = REFLECTION_CATEGORIES.size
        
        if completed_count == total
          "🎉 *Отлично! Вы завершили все #{total} категории рефлексии 2 недель!*"
        elsif completed_count > 0
          "✅ *Хорошая работа! Вы завершили #{completed_count} из #{total} категорий.*"
        else
          "⏭️ *Вы пропустили все категории. Рефлексия завершена.*"
        end
      end
      
      def save_two_weeks_reflection_entry
        progress = get_reflection_progress
        return if progress[:reflections].empty?
        
        begin
          # Собираем все рефлексии в один текст
          full_text = REFLECTION_CATEGORIES.map do |category|
            reflection = progress[:reflections][category[:id].to_s]
            next unless reflection
            
            <<~TEXT
              #{category[:emoji]} *#{category[:name]}:*
              #{reflection[:text]}
              
            TEXT
          end.compact.join("\n")
          
          # Добавляем заголовок и дату
          final_text = <<~TEXT
            📖 *Рефлексия 2 недель программы* 📅 #{Date.current.strftime('%d.%m.%Y')}
            
            #{full_text}
            
            📊 *Статистика рефлексии:*
            • Категорий завершено: #{progress[:completed_categories].size}/#{REFLECTION_CATEGORIES.size}
            • Общий объем: #{full_text.length} символов
            • Время начала: #{progress[:start_time].strftime('%H:%M')}
            • Пройдено дней программы: 14/28 (50%)
          TEXT
          
          # Сохраняем в ReflectionEntry (та же модель, что и для дня 7)
          ReflectionEntry.create!(
            user: @user,
            entry_date: Date.current,
            entry_text: final_text,
            reflection_type: 'two_weeks'
          )
          
        rescue => e
          log_error("Failed to save two weeks reflection entry", e)
        end
      end
      
      def two_weeks_statistics_message
        completed_days = @user.completed_days || []
        two_weeks_days = completed_days.select { |day| day <= 14 }
        
        <<~MARKDOWN
          📊 *Ваша статистика за 2 недели:*
          
          • ✅ Завершено дней: #{two_weeks_days.size}/14
          • 📈 Прогресс 2 недель: #{(two_weeks_days.size.to_f / 14 * 100).round}%
          • 🏆 Серия дней: #{@user.current_streak} дней подряд
          • 💫 Общий прогресс: #{@user.progress_percentage}%
          • 🎯 Пройдено программы: 50%
          
          *Помните:* Вы прошли половину пути — это огромное достижение!
        MARKDOWN
      end
      
      def propose_next_week
        next_day = 15
        
        # Проверяем, можно ли начать следующий день
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День 15 (Начало второй половины программы)**
            
            ✅ *Доступен сейчас!*
            
            **Что вас ждет во второй половине программы:**
            • 🧠 Углубленная работа с прокрастинацией и мотивацией
            • 💪 Развитие уверенности и самооценки
            • 🔄 Интеграция всех освоенных техник
            • 🌱 Проработка глубинных убеждений
            
            Вы можете начать вторую половину программы прямо сейчас.
          MARKDOWN
          
          button_text = "🚀 Начать День 15"
          callback_data = "start_day_#{next_day}_from_proposal"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День 15 (Начало второй половины программы)**
            
            ⏱️ *Ограничение:* #{error_message}
            
            **Пока ждете, можете:**
            • 📖 Перечитать свою рефлексию 2 недель
            • 🧠 Практиковать наиболее эффективные для вас техники
            • 📊 Посмотреть полную статистику прогресса (/progress)
            • 🌟 Отпраздновать достижение половины пути!
            
            *Вторая половина программы будет автоматически доступна, когда пройдет достаточно времени.*
          MARKDOWN
          
          button_text = "⏱️ Проверить доступность Дня 15"
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
      
      # Метод для обратной совместимости
      def handle_reflection_input_legacy(input_text)
        return false if input_text.blank?
        
        begin
          ReflectionEntry.create!(
            user: @user,
            entry_date: Date.current,
            entry_text: input_text,
            reflection_type: 'two_weeks'
          )
          
          @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
          
          send_message(
            text: "💭 Спасибо за вашу рефлексию! Половина программы завершена.",
            reply_markup: TelegramMarkupHelper.complete_program_markup
          )
          
          return true
        rescue => e
          log_error("Failed to save reflection entry", e)
          send_message(text: "Ошибка при сохранении. Попробуйте еще раз.")
          return false
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
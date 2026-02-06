# app/services/self_help/days/day_7_service.rb
module SelfHelp
  module Days
    class Day7Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 7
      
      # Шаги дня 7
      DAY_STEPS = {
        'intro' => {
          title: "🌟 *День 7: Подведение итогов недели* 🎯",
          instruction: <<~MARKDOWN
            **Поздравляем! Вы завершили первую неделю программы!** 🎉

            За эти 7 дней вы проделали впечатляющий путь:

            📅 **Ваш путь за неделю:**
            • День 1: Освоили осознанное дыхание 🧘
            • День 2: Развили навык самонаблюдения 👁️
            • День 3: Практиковали благодарность 🙏
            • День 4: Учились осознанному видению 🎨
            • День 5: Открыли движение как медитацию 🏃
            • День 6: Освоили искусство отдыха 😌
            • День 7: Подводим итоги и интегрируем опыт 🌟

            📊 **Научные факты о рефлексии:**
            • 🧠 Люди, практикующие регулярную рефлексию, на 40% быстрее достигают целей
            • 😌 Рефлексия снижает уровень стресса на 25-30%
            • 💡 Осознанный анализ опыта повышает продуктивность на 20-25%
            • 🛡️ Регулярное подведение итогов снижает риск эмоционального выгорания на 50%
            • 🔄 Интеграция опыта ускоряет нейропластичность на 30-40%

            🎯 **Что вы получите от сегодняшней практики:**
            1. 📊 Ясное понимание вашего прогресса
            2. 🧠 Интеграцию полученного опыта
            3. 🎯 Осознание сильных сторон и зон роста
            4. 💫 План на следующую неделю
            5. 🌟 Признание своих достижений
          MARKDOWN
        },
        'exercise_explanation' => {
          title: "📖 *Упражнение: Глубинная рефлексия* 💭",
          instruction: <<~MARKDOWN
            **Почему рефлексия так важна?** 🤔

            Когда мы осознанно подводим итоги, мы создаем прочную связь между опытом и обучением:

            • 🔄 **Нейробиологический эффект:** Рефлексия активирует префронтальную кору (планирование) и гиппокамп (память)
            • 🧠 **Когнитивная польза:** Улучшает консолидацию памяти и извлечение уроков на 35-45%
            • 😌 **Эмоциональный баланс:** Помогает интегрировать эмоциональный опыт
            • 🎯 **Целеполагание:** Уточняет цели и создает план действий
            • 🌱 **Рост и развитие:** Создает основу для дальнейшего прогресса

            **Как работает практика рефлексии:**
            1. 📅 Вспоминаем и структурируем опыт
            2. 🧠 Анализируем с разных углов зрения
            3. 💫 Выделяем ключевые инсайты
            4. 🎯 Формируем выводы и планы

            **Сегодняшнее упражнение:** Глубинная рефлексия прошедшей недели.
            Цель — не просто вспомнить, а интегрировать полученный опыт.
          MARKDOWN
        }
      }.freeze
      
      # Категории рефлексии
      REFLECTION_CATEGORIES = [
        {
          id: 0,
          name: "Достижения и успехи",
          emoji: "🏆",
          description: "Что получилось хорошо? Какие моменты принесли радость и удовлетворение?",
          prompt: <<~PROMPT
            🏆 *Достижения и успехи этой недели:*

            • Какие техники или практики оказались для вас наиболее ценными?
            • В какие моменты вы чувствовали себя наиболее "на своем месте"?
            • Какие маленькие победы вы можете отметить за эту неделю?
            • Что удалось лучше, чем вы ожидали?

            *Напишите о ваших достижениях:* 📝
          PROMPT
        },
        {
          id: 1,
          name: "Вызовы и трудности",
          emoji: "🌱",
          description: "Что было сложным? Где встречалось сопротивление?",
          prompt: <<~PROMPT
            🌱 *Вызовы и рост этой недели:*

            • С какими упражнениями или мыслями было труднее всего?
            • Какие внутренние сопротивления вы заметили?
            • Что показалось вам самым неожиданным в процессе?
            • В каких моментах вы чувствовали растерянность или неуверенность?

            *Напишите о ваших вызовах:* 📝
          PROMPT
        },
        {
          id: 2,
          name: "Изменения и инсайты",
          emoji: "🔄",
          description: "Что изменилось? Какие новые понимания пришли?",
          prompt: <<~PROMPT
            🔄 *Изменения и инсайты этой недели:*

            • Какие изменения в настроении вы заметили за неделю?
            • Как изменилось ваше отношение к себе и своим эмоциям?
            • Какие новые осознания пришли к вам?
            • Что вы поняли о своих паттернах мышления или поведения?

            *Напишите о ваших изменениях:* 📝
          PROMPT
        },
        {
          id: 3,
          name: "Планы и намерения",
          emoji: "🎯",
          description: "Что хочу продолжать? Какие цели на следующую неделю?",
          prompt: <<~PROMPT
            🎯 *Планы на следующую неделю:*

            • Какие практики вы хотите продолжать в следующую неделю?
            • Что бы вы хотели изменить в своем подходе?
            • Какие цели вы ставите перед собой на следующую неделю?
            • Как вы можете поддержать свой прогресс?

            *Напишите о ваших планах:* 📝
          PROMPT
        }
      ].freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        
        # Статистика недели для мотивации
        send_message(
          text: week_statistics_message,
          parse_mode: 'Markdown'
        )
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        store_day_data('current_step', 'intro')
        
        send_message(
          text: "Готовы к глубинной рефлексии первой недели?",
          reply_markup: day_7_content_markup
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
          reply_markup: day_7_category_options_markup(current_index)
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
        save_full_reflection_entry
        
        # Переходим к вопросам о трудностях
        show_reflection_challenges
      end
      
      def show_reflection_challenges
        send_message(
          text: "🤔 *С какими трудностями столкнулись в процессе рефлексии?*",
          parse_mode: 'Markdown',
          reply_markup: day_7_challenges_markup
        )
      end
      
      def handle_challenge_selection(challenge_index)
        challenge_options = [
          "🧠 Трудно вспомнить детали недели",
          "😔 Чувствую, что мало что достиг",
          "🤔 Не знаю, что писать",
          "😰 Боюсь быть неидеальным"
        ]
        
        challenge = challenge_options[challenge_index.to_i] if challenge_index.to_i.between?(0, 3)
        
        if challenge
          solutions = [
            "Начните с одного дня. Вспомните, что делали вчера, затем позавчера. Не нужно идеального отчета.",
            "Маленькие шаги тоже важны! Отметьте даже минимальный прогресс. Осознанность — это уже достижение.",
            "Начните с простого: 'Сегодня я заметил(а)...' или 'Мне понравилось, когда...'. Не фильтруйте мысли.",
            "Рефлексия — это не экзамен, а исследование. Все ответы правильные. Будьте добры к себе."
          ]
          
          send_message(
            text: "🌀 **#{challenge}**\n\n#{solutions[challenge_index.to_i]}",
            parse_mode: 'Markdown'
          )
        end
        
        send_message(
          text: "🌟 Отлично! Вы завершили глубинный анализ недели!\n\nХотите завершить День 7 и первую неделю программы?",
          reply_markup: day_7_final_completion_markup
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
          🎊 *День 7 и первая неделя программы завершены!* 🎉

          **Ваши достижения за неделю:**
          
          📊 **Итоги рефлексии:**
          • ✅ Завершено категорий: #{completed_count}/#{REFLECTION_CATEGORIES.size}
          • 📝 Общий объем: #{total_length} символов
          • 🧠 Приобретение: Навык структурированной рефлексии
          
          🌟 **Прогресс за неделю:**
          • ✅ Освоено 6 различных техник самопомощи
          • 📈 Развиты навыки самонаблюдения и осознанности
          • 💫 Создана основа для дальнейшего роста
          • 🏆 Пройдено 25% всей программы!
          
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
        when 'start_day_7_content', 'start_day_7_from_proposal'
          deliver_exercise
          
        when 'continue_day_7_content'
          current_step = get_day_data('current_step')
          handle_resume_from_step(current_step || 'intro')
          
        when /^day_7_skip_(\d+)$/
          skip_category($1.to_i)
          
        when /^day_7_challenge_(\d+)$/
          handle_challenge_selection($1)
          
        when 'day_7_no_challenges'
          send_message(text: "🌟 Отлично! У вас получилась продуктивная рефлексия!")
          send_message(
            text: "Завершаем День 7 и первую неделю?",
            reply_markup: day_7_final_completion_markup
          )
          
        when 'day_7_complete_exercise', 'day_7_exercise_completed'
          complete_exercise
          
        when 'day_7_restart_reflection'
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
        if current_state&.start_with?("day_7_waiting_reflection_")
          category_index = current_state.split('_').last.to_i
          return handle_reflection_text(input_text, category_index)
        end
        
        # Обработка старого формата для обратной совместимости
        if current_state == "day_7_waiting_for_reflection"
          return handle_reflection_input_legacy(input_text)
        end
        
        false
      end
      
      private
      
      # Вспомогательные методы разметки
      def day_7_content_markup
        {
          inline_keyboard: [
            [
              { text: "📖 Начать рефлексию недели", callback_data: 'start_day_7_content' }
            ],
            [
              { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
            ]
          ]
        }.to_json
      end
      
      def day_7_category_options_markup(category_index)
        {
          inline_keyboard: [
            [
              { text: "⏭️ Пропустить эту категорию", callback_data: "day_7_skip_#{category_index}" }
            ]
          ]
        }.to_json
      end
      
      def day_7_challenges_markup
        {
          inline_keyboard: [
            [
              { text: "🧠 Трудно вспомнить детали", callback_data: 'day_7_challenge_0' }
            ],
            [
              { text: "😔 Чувствую, что мало достиг", callback_data: 'day_7_challenge_1' }
            ],
            [
              { text: "🤔 Не знаю, что писать", callback_data: 'day_7_challenge_2' }
            ],
            [
              { text: "😰 Боюсь быть неидеальным", callback_data: 'day_7_challenge_3' }
            ],
            [
              { text: "✅ Никаких трудностей", callback_data: 'day_7_no_challenges' }
            ]
          ]
        }.to_json
      end
      
      def day_7_final_completion_markup
        {
          inline_keyboard: [
            [
              { text: "🎉 Завершить неделю!", callback_data: 'day_7_complete_exercise' },
              { text: "🔄 Начать заново", callback_data: 'day_7_restart_reflection' }
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
          "🎉 *Отлично! Вы завершили все #{total} категории рефлексии!*"
        elsif completed_count > 0
          "✅ *Хорошая работа! Вы завершили #{completed_count} из #{total} категорий.*"
        else
          "⏭️ *Вы пропустили все категории. Рефлексия завершена.*"
        end
      end
      
      def save_full_reflection_entry
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
            📖 *Рефлексия недели 1* 📅 #{Date.current.strftime('%d.%m.%Y')}
            
            #{full_text}
            
            📊 *Статистика рефлексии:*
            • Категорий завершено: #{progress[:completed_categories].size}/#{REFLECTION_CATEGORIES.size}
            • Общий объем: #{full_text.length} символов
            • Время начала: #{progress[:start_time].strftime('%H:%M')}
          TEXT
          
          # Сохраняем в ReflectionEntry
          ReflectionEntry.create!(
            user: @user,
            entry_date: Date.current,
            entry_text: final_text
          )
          
        rescue => e
          log_error("Failed to save full reflection entry", e)
        end
      end
      
      def week_statistics_message
        completed_days = @user.completed_days || []
        week_days = completed_days.select { |day| day <= 7 }
        
        <<~MARKDOWN
          📊 *Ваша статистика за неделю:*
          
          • ✅ Завершено дней: #{week_days.size}/7
          • 📈 Прогресс недели: #{(week_days.size.to_f / 7 * 100).round}%
          • 🏆 Серия дней: #{@user.current_streak} дней подряд
          • 💫 Общий прогресс: #{@user.progress_percentage}%
          
          *Помните:* Каждый завершенный день — это шаг к лучшей версии себя!
        MARKDOWN
      end
      
      def propose_next_week
        next_day = 8
        
        # Проверяем, можно ли начать следующий день
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День 8 (Начало второй недели)**
            
            ✅ *Доступен сейчас!*
            
            **Что вас ждет во второй неделе:**
            • 🧠 Углубление в когнитивные техники
            • 💪 Работа с самооценкой и уверенностью
            • 🔄 Интеграция практик в повседневную жизнь
            • 🌱 Продвинутые методы эмоциональной регуляции
            
            Вы можете начать вторую неделю прямо сейчас.
          MARKDOWN
          
          button_text = "🚀 Начать День 8"
          callback_data = "start_day_#{next_day}_from_proposal"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День 8 (Начало второй недели)**
            
            ⏱️ *Ограничение:* #{error_message}
            
            **Пока ждете, можете:**
            • 📖 Перечитать свои рефлексии за неделю
            • 🧠 Практиковать наиболее понравившиеся техники
            • 📊 Посмотреть полную статистику (/progress)
            • 🌟 Поздравить себя с завершением первой недели!
            
            *Вторая неделя будет автоматически доступна, когда пройдет достаточно времени.*
          MARKDOWN
          
          button_text = "⏱️ Проверить доступность Дня 8"
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
            entry_text: input_text
          )
          
          @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
          
          send_message(
            text: "💭 Спасибо за вашу рефлексию! Неделя завершена.",
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
# app/services/self_help/days/day_12_service.rb
module SelfHelp
  module Days
    class Day12Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 12
      
      # Шаги дня 12
      DAY_STEPS = {
        'intro' => {
          title: "💝 *День 12: Практика самосострадания* 🧘",
          instruction: <<~MARKDOWN
            **Добро пожаловать в день развития доброты к себе!** 🌟

            Самосострадание — это способность относиться к себе с той же добротой, пониманием и поддержкой, которую мы обычно предлагаем близким друзьям в трудные времена.

            **Три компонента самосострадания:**
            1. **Доброта к себе** — вместо самокритики
            2. **Общечеловечность** — понимание, что страдание — часть человеческого опыта
            3. **Осознанность** — балансированное осознание болезненных эмоций

            **Исследования показывают**, что самосострадание:
            • 🧠 Снижает тревогу и депрессию на 30-40%
            • 💪 Повышает мотивацию и устойчивость
            • 🤝 Улучшает качество отношений
            • 🌱 Способствует личностному росту
            • 😌 Уменьшает самокритику на 50-60%

            **Сегодня вы освоите 5-шаговую медитацию самосострадания.**
          MARKDOWN
        },
        'exercise_explanation' => {
          title: "🔬 *5-шаговая медитация самосострадания: Научный подход* 📊",
          instruction: <<~MARKDOWN
            **Как работает практика самосострадания?**

            **Научные факты:**
            • 🧠 Активирует островковую долю и переднюю поясную кору (эмпатия к себе)
            • 😌 Снижает активность миндалевидного тела (центр страха) на 25-35%
            • 💡 Повышает уровень окситоцина (гормон доверия) на 20-30%
            • 🔄 Усиливает связь между префронтальной корой и лимбической системой
            • 🎯 Эффективность: 4-8 недель регулярной практики дают устойчивые изменения

            **5 шагов медитации:**
            1. 🕊️ Признание трудности
            2. 🤝 Общечеловеческий опыт  
            3. 💬 Добрые слова к себе
            4. 🤗 Физическое утешение
            5. ✨ Мантра самосострадания

            **Готовы начать?**
          MARKDOWN
        },
        'completion' => {
          title: "🎊 *Практика самосострадания освоена!* 🌟",
          instruction: <<~MARKDOWN
            **Отличная работа! Вы только что завершили мощную практику доброты к себе.** 💝

            **Что вы сделали:**
            1. 🕊️ Признали свою трудность с добротой
            2. 🤝 Увидели связь с общечеловеческим опытом
            3. 💬 Нашли добрые слова для себя
            4. 🤗 Применили физическое утешение
            5. ✨ Создали мантру самосострадания

            **Поздравляем!** Вы освоили практику, которая:
            • 🧠 Подтверждена исследованиями в нейропсихологии
            • 😌 Используется в терапии принятия и ответственности (ACT)
            • 💪 Помогает развивать психологическую устойчивость
            • 🌟 Применяется миллионами людей по всему миру

            **Регулярная практика самосострадания:**
            • Снижает самокритику на 40-50%
            • Повышает самооценку на 30-40%
            • Улучшает эмоциональную регуляцию на 35-45%
            • Уменьшает симптомы тревоги и депрессии на 25-35%
          MARKDOWN
        }
      }.freeze
      
      # Шаги самосострадания
      SELF_COMPASSION_STEPS = {
  'difficulty' => {
    title: "🕊️ *Шаг 1: Признание трудности*",
    instruction: "**Что сейчас вызывает у вас дискомфорт или боль?**\n\nЭто может быть:\n• Физическое ощущение (боль, напряжение, усталость)\n• Эмоциональное страдание (тревога, грусть, гнев)\n• Стрессовая ситуация (конфликт, перегрузка)\n• Самокритичная мысль («Я недостаточно хорош»)\n\n**Научный факт:** Признание трудности активирует островковую долю мозга, отвечающую за телесное и эмоциональное осознание.\n\n**Опишите свою трудность одним-двумя предложениями:**",
    min_words: 5,
    emoji: "🕊️",
    step_name: "признание трудности"
  },
  'humanity' => {
    title: "🤝 *Шаг 2: Общечеловеческий опыт*",
    instruction: "**Как эта трудность связывает вас с другими людьми?**\n\nВспомните, что:\n• Миллионы людей испытывают что-то подобное прямо сейчас\n• Страдание — неотъемлемая часть человеческого опыта\n• Вы не одиноки в своих переживаниях\n• Это делает нас человечными, а не слабыми\n\n**Научный факт:** Осознание общечеловечности снижает чувство изоляции и активирует зоны мозга, связанные с эмпатией.\n\n**Как это знание помогает вам чувствовать себя менее одиноким?**",
    min_words: 5,
    emoji: "🤝",
    step_name: "осознание общечеловечности"
  },
  'kind_words' => {
    title: "💬 *Шаг 3: Добрые слова к себе*",
    instruction: "**Представьте, что ваш лучший друг переживает то же самое.**\n\nЧто бы вы сказали другу в этой ситуации?\n• Слова поддержки и понимания\n• Ободряющие фразы\n• Признание их усилий\n• Напоминание об их ценности\n\n**А теперь скажите эти же слова себе.**\n\n**Научный факт:** Добрые слова к себе активируют зоны мозга, связанные с заботой и привязанностью, снижая уровень кортизола.\n\n**Напишите 2-3 добрых, поддерживающих фразы:**",
    min_words: 10,
    emoji: "💬",
    step_name: "добрые слова к себе"
  },
  'physical_comfort' => {
    title: "🤗 *Шаг 4: Физическое утешение*",
    instruction: "**Как вы можете физически утешить себя прямо сейчас?**\n\nПримеры:\n• Положить руку на сердце\n• Обнять себя\n• Сделать 3 глубоких вдоха\n• Укрыться пледом\n• Выпить теплый напиток\n• Принять удобную позу\n\n**Научный факт:** Физическое утешение активирует блуждающий нерв, который отвечает за состояние покоя и восстановления.\n\n**Опишите, что вы сделаете и какие ощущения это принесет:**",
    min_words: 5,
    emoji: "🤗",
    step_name: "физическое утешение"
  },
  'mantra' => {
    title: "✨ *Шаг 5: Мантра самосострадания*",
    instruction: "**Создайте свою мантру доброты к себе.**\n\nКлассическая формула Кристин Нефф:\n1. «Это момент страдания» (признание)\n2. «Страдание — часть жизни» (общечеловечность)\n3. «Пусть я буду добр(а) к себе» (доброта)\n\n**Создайте свою собственную фразу.**\nПримеры:\n• «Я принимаю себя таким(ой), какой(ая) я есть»\n• «Я делаю лучшее, что могу в этой ситуации»\n• «Я заслуживаю доброты и понимания»\n• «Это пройдет, и я стану сильнее»\n\n**Напишите вашу мантру:**",
    min_words: 3,
    emoji: "✨",
    step_name: "мантра самосострадания"
  }
}.freeze
      
      # Типичные трудности в практике
      COMPASSION_CHALLENGES = [
        {
          challenge: "Не могу найти добрые слова для себя",
          emoji: "💬",
          solution: "Представьте, что говорите с ребенком или лучшим другом. Что бы вы сказали им? Используйте эти же слова для себя."
        },
        {
          challenge: "Чувствую фальшь, говоря добрые слова себе",
          emoji: "🎭",
          solution: "Это нормально в начале! Самосострадание — это навык, который развивается. Даже механическое повторение добрых слов создает новые нейронные пути."
        },
        {
          challenge: "Не верю, что заслуживаю доброты",
          emoji: "😔",
          solution: "Помните: доброта к себе — не награда за достижения, а основная человеческая потребность, как вода и воздух. Вы заслуживаете ее просто потому, что существуете."
        },
        {
          challenge: "Мысли постоянно возвращаются к проблеме",
          emoji: "🌀",
          solution: "Каждое возвращение к практике — это победа! Просто мягко возвращайтесь к следующему шагу. Мозг учится через повторение."
        }
      ].freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        store_day_data('current_step', 'intro')
        
        send_message(
          text: "Готовы попрактиковать доброту к себе?",
          reply_markup: day_12_content_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise_explanation')
        clear_day_data
        
        send_message(text: DAY_STEPS['exercise_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['exercise_explanation'][:instruction], parse_mode: 'Markdown')
        
        exercise_text = <<~MARKDOWN
          💝 *Медитация на самосострадание* 💝

          **Подготовка:**
          1. Найдите тихое место
          2. Сядьте удобно
          3. Закройте глаза, если вам комфортно
          4. Сделайте 3 глубоких вдоха

          **Мы пройдем 5 шагов.** Отвечайте на вопросы по мере их поступления.
        MARKDOWN
        
        send_message(text: exercise_text, parse_mode: 'Markdown')
        
        # Начинаем первый шаг
        start_self_compassion_step('difficulty')
      end
      
      def start_self_compassion_step(step_type)
        store_day_data('current_compassion_step', step_type)
        @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_#{step_type}")
        
        step = SELF_COMPASSION_STEPS[step_type]
        return unless step
        
        send_message(text: step[:title], parse_mode: 'Markdown')
        send_message(text: step[:instruction], parse_mode: 'Markdown')
        
        # Показываем подсказку с эмодзи
        send_message(
          text: "#{step[:emoji]} *#{step[:step_name].upcase}: Напишите ответ*",
          parse_mode: 'Markdown',
          reply_markup: day_12_input_markup
        )
      end
      
      def handle_self_compassion_input(input_text)
        current_step = get_day_data('current_compassion_step')
        step_config = SELF_COMPASSION_STEPS[current_step]
        
        return false unless step_config
        
        # УБИРАЕМ ВАЛИДАЦИЮ ПО КОЛИЧЕСТВУ СЛОВ:
        # Просто проверяем, что ввод не пустой
        if input_text.blank?
          send_message(text: "⚠️ Пожалуйста, введите ответ.")
          return false
        end
        
        # Сохраняем данные
        store_day_data("#{current_step}_response", input_text)
        store_day_data("#{current_step}_completed", true)
        
        # Подтверждаем сохранение
        send_message(
          text: "✅ #{step_config[:emoji]} *Шаг завершен!* Сохранен ответ.",
          parse_mode: 'Markdown'
        )
        
        # Переходим к следующему шагу
        next_step = get_next_compassion_step(current_step)
        
        if next_step
          sleep(1) # Пауза между шагами
          start_self_compassion_step(next_step)
        else
          # Все шаги выполнены
          complete_self_compassion_practice
        end
        
        true
      end
      
      def complete_self_compassion_practice
        store_day_data('compassion_completed', true)
        store_day_data('completion_time', Time.current)
        
        # Сохраняем в модель SelfCompassionPractice
        save_self_compassion_practice
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_compassion_completed")
        
        # Показываем завершение
        show_compassion_completion
      end
      
      def show_compassion_completion
        store_day_data('current_step', 'completion')
        
        send_message(text: DAY_STEPS['completion'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['completion'][:instruction], parse_mode: 'Markdown')
        
        # Показываем краткий обзор практики
        show_compassion_summary
        
        sleep(1)
        
        send_message(
          text: "🌟 Отличная работа! Вы завершили практику самосострадания.\n\nС какими трудностями столкнулись?",
          parse_mode: 'Markdown',
          reply_markup: day_12_challenges_markup
        )
      end
      
      def handle_challenge_selection(challenge_index)
  challenge = COMPASSION_CHALLENGES[challenge_index.to_i]
  
  if challenge
    send_message(
      text: "#{challenge[:emoji]} **#{challenge[:challenge]}**\n\n#{challenge[:solution]}",
      parse_mode: 'Markdown'
    )
  end
  
  @user.set_self_help_step("day_#{DAY_NUMBER}_reflection_done")
  
  # Используем существующий метод разметки из хелпера
  send_message(
    text: "🎯 Практика самосострадания освоена!\n\nХотите завершить День 12?",
    parse_mode: 'Markdown',
    reply_markup: TelegramMarkupHelper.day_12_final_completion_markup
  )
end
      
      def show_compassion_summary
        difficulty_response = get_day_data('difficulty_response') || "не указана"
        mantra_response = get_day_data('mantra_response') || "не указана"
        
        summary = <<~MARKDOWN
          📊 *Краткий обзор вашей практики:*
          
          🕊️ **Признанная трудность:** #{truncate_text(difficulty_response, 50)}
          
          ✨ **Ваша мантра:** #{truncate_text(mantra_response, 50)}
          
          ✅ **Все 5 шагов выполнены!**
          
          📅 **Сохранено в вашу коллекцию практик самосострадания**
        MARKDOWN
        
        send_message(text: summary, parse_mode: 'Markdown')
      end
      
      def show_practices
        practices = SelfCompassionPractice.where(user: @user).recent.limit(3)
        
        if practices.empty?
          send_message(
            text: "💝 *Ваши практики самосострадания:*\n\nПока нет сохраненных практик.\nПройдите упражнение дня 12, чтобы создать первую запись.",
            parse_mode: 'Markdown',
            reply_markup: day_12_content_markup
          )
          return
        end
        
        total_count = SelfCompassionPractice.where(user: @user).count
        
        send_message(
          text: "💝 *Ваши последние практики (всего: #{total_count}):*",
          parse_mode: 'Markdown'
        )
        
        practices.each_with_index do |practice, index|
          entry_date = practice.entry_date.strftime('%d.%m.%Y')
          difficulty = truncate_text(practice.current_difficulty, 30)
          mantra = truncate_text(practice.mantra, 30)
          
          entry_summary = <<~MARKDOWN
            *#{index + 1}. #{entry_date}*
            
            🕊️ Трудность: #{difficulty}
            ✨ Мантра: #{mantra}
          MARKDOWN
          
          send_message(text: entry_summary, parse_mode: 'Markdown')
        end
        
        send_message(
          text: "Хотите начать новую практику самосострадания?",
          reply_markup: {
            inline_keyboard: [
              [
                { text: "💝 Новая практика", callback_data: "day_12_start_compassion" }
              ]
            ]
          }
        )
      end
      
      def complete_exercise
        # Проверяем, завершена ли практика
        unless get_day_data('compassion_completed') == true
          send_message(
            text: "⚠️ Сначала завершите практику самосострадания.\n\nУбедитесь, что вы прошли все 5 шагов медитации.",
            parse_mode: 'Markdown',
            reply_markup: day_12_content_markup
          )
          return
        end
        
        # Отмечаем день как завершенный
        @user.complete_day_program(DAY_NUMBER)
        @user.complete_self_help_day(DAY_NUMBER)
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
        
        completion_message = <<~MARKDOWN
          🎊 *День 12 завершен!* 🎊

          **Ваши достижения сегодня:**
          
          💝 **Практика самосострадания:**
          • 🕊️ Освоена 5-шаговая медитация
          • 🤝 Развито чувство общечеловечности
          • 💬 Найдены добрые слова к себе
          • 🤗 Применены техники физического утешения
          • ✨ Создана личная мантра
          
          📊 **Научный факт:**
          Регулярная практика самосострадания снижает самокритику на 40-50%, повышает самооценку на 30-40% и улучшает эмоциональную регуляцию на 35-45% за 4-8 недель.
          
          🎯 **Что дальше:**
          Завтра - День 13: Работа с прокрастинацией
          
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
        when 'start_day_12_content', 'start_day_12_from_proposal'
          deliver_exercise
          
        when 'continue_day_12_content'
          current_step = get_day_data('current_step')
          handle_resume_from_step(current_step || 'intro')
          
        when 'day_12_start_compassion', 'start_self_compassion_exercise'
          deliver_exercise
          
        when 'day_12_skip_step'
          # Пропуск текущего шага
          current_step = get_day_data('current_compassion_step')
          if current_step
            next_step = get_next_compassion_step(current_step)
            if next_step
              send_message(text: "⚠️ Шаг пропущен. Переходим к следующему.")
              start_self_compassion_step(next_step)
            else
              complete_self_compassion_practice
            end
          end
          
        when 'day_12_restart_compassion'
          deliver_exercise
          
        when 'self_compassion_exercise_completed', 'day_12_complete_compassion'
          complete_self_compassion_practice
          
        when /^day_12_challenge_(\d+)$/
          handle_challenge_selection($1)
          
        when 'day_12_no_challenges'
          @user.set_self_help_step("day_#{DAY_NUMBER}_reflection_done")
          send_message(text: "🌟 Отлично! У вас получилась продуктивная практика!")
          send_message(
            text: "Завершаем День 12?",
            reply_markup: day_12_final_completion_markup
          )
          
        when 'day_12_complete_exercise'
          complete_exercise
          
        when 'day_12_show_entries', 'view_self_compassion_practices'
          show_practices
          
        when 'day_12_all_practices'
          show_all_practices
          
        when 'day_12_help_tips'
          send_message(
            text: "💡 *Советы для эффективной практики:*\n\n• Практикуйте регулярно, даже по 5 минут в день\n• Будьте терпеливы — навык развивается постепенно\n• Используйте разные форматы (письменно, мысленно, вслух)\n• Практикуйте в разных эмоциональных состояниях\n• Помните: даже маленькие шаги имеют значение",
            parse_mode: 'Markdown'
          )
          
        when 'day_12_emergency_self_compassion'
          send_message(
            text: "🆘 *Экстренное самосострадание:*\n\nВ моменты сильной самокритики или стресса:\n1. Положите руку на сердце\n2. Скажите: «Это момент страдания»\n3. Добавьте: «Страдание — часть жизни»\n4. Закончите: «Пусть я буду добр(а) к себе»\n\nПовторите 3 раза медленно и глубоко дыша.",
            parse_mode: 'Markdown',
            reply_markup: day_12_content_markup
          )
          
        else
          log_warn("Unknown button callback: #{callback_data}")
          send_message(text: "Неизвестная команда.")
        end
      end
      
      # ===== ОБРАБОТКА ТЕКСТОВОГО ВВОДА =====
      
      def handle_text_input(input_text)
        log_info("Handling text input for day 12: #{input_text}")
        
        current_state = @user.self_help_state
        
        # Определяем, какой ввод ожидается
        case current_state
        when "day_12_waiting_for_difficulty"
          return handle_self_compassion_input(input_text)
          
        when "day_12_waiting_for_humanity"
          return handle_self_compassion_input(input_text)
          
        when "day_12_waiting_for_kind_words"
          return handle_self_compassion_input(input_text)
          
        when "day_12_waiting_for_physical_comfort"
          return handle_self_compassion_input(input_text)
          
        when "day_12_waiting_for_mantra"
          return handle_self_compassion_input(input_text)
          
        when "day_12_compassion_completed", "day_12_reflection_done", "day_12_completed"
          send_message(
            text: "✅ Практика самосострадания уже завершена. Вы можете:\n• Просмотреть свои практики\n• Начать новую практику\n• Завершить день 12",
            reply_markup: day_12_final_completion_markup
          )
          return true
        end
        
        log_warn("No text input handler for current state: #{current_state}")
        false
      end
      
      def handle_smart_input(text)
        handle_text_input(text)
      end
      
      def handle_resume_from_step(step)
        case step
        when 'intro'
          deliver_intro
        when 'exercise_explanation'
          deliver_exercise
        when 'completion'
          show_compassion_completion
        else
          deliver_exercise
        end
      end
      
      def show_intro_without_state
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        send_message(
          text: "Готовы попрактиковать доброту к себе?",
          reply_markup: day_12_content_markup
        )
      end
      
      def propose_next_day_with_restriction
        next_day = 13
        
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ✅ *Доступен сейчас!*
            
            **Что вас ждет:**
            • 🚀 Работа с прокрастинацией
            • 📝 Техника «первого шага»
            • 🎯 Преодоление сопротивления
            • 💪 Развитие волевых навыков
            
            Вы можете начать следующий день прямо сейчас.
          MARKDOWN
          
          button_text = "🚀 Начать День #{next_day}"
          callback_data = "start_day_#{next_day}_from_proposal"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ⏱️ *Ограничение:* #{error_message}
            
            **Пока ждете, можете:**
            • 💝 Практиковать самосострадание в разных ситуациях
            • 📚 Просмотреть свои предыдущие практики
            • 🔄 Экспериментировать с разными мантрами
            • 📊 Посмотреть статистику (/progress)
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
      
      def get_next_compassion_step(current_step)
        steps_order = SELF_COMPASSION_STEPS.keys
        current_index = steps_order.index(current_step)
        
        return steps_order[current_index + 1] if current_index && current_index < steps_order.length - 1
        nil
      end
      
      def save_self_compassion_practice
        begin
          difficulty = get_day_data('difficulty_response')
          humanity = get_day_data('humanity_response')
          kind_words = get_day_data('kind_words_response')
          physical_comfort = get_day_data('physical_comfort_response')
          mantra = get_day_data('mantra_response')
          
          SelfCompassionPractice.create!(
            user: @user,
            entry_date: Date.current,
            current_difficulty: difficulty,
            common_humanity: humanity,
            kind_words: kind_words,
            mantra: mantra
          )
          
          log_info("Saved self-compassion practice")
          store_day_data('entry_id', SelfCompassionPractice.last&.id)
          
          true
        rescue => e
          log_error("Failed to save self-compassion practice", e)
          false
        end
      end
      
      def clear_day_data
        SELF_COMPASSION_STEPS.keys.each do |step|
          store_day_data("#{step}_response", nil)
          store_day_data("#{step}_completed", nil)
        end
        store_day_data('current_compassion_step', nil)
        store_day_data('compassion_completed', nil)
        store_day_data('completion_time', nil)
        store_day_data('entry_id', nil)
      end
      
      def truncate_text(text, length)
        return "не указано" if text.blank?
        text.length > length ? "#{text[0...length]}..." : text
      end
      
      # Вспомогательные методы разметки
      def day_12_content_markup
        TelegramMarkupHelper.day_12_start_exercise_markup
      end
      
      def day_12_input_markup
        {
          inline_keyboard: [
            [
              { text: "⏭️ Пропустить шаг", callback_data: 'day_12_skip_step' },
              { text: "🔄 Начать заново", callback_data: 'day_12_restart_compassion' }
            ]
          ]
        }
      end
      
      def day_12_final_completion_markup
        TelegramMarkupHelper.day_12_menu_markup
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
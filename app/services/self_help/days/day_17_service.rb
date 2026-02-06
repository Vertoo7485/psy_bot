# app/services/self_help/days/day_17_service.rb (упрощенная версия)
module SelfHelp
  module Days
    class Day17Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 17
      
      # ===== НАУЧНЫЕ ФАКТЫ О САМОСОСТРАДАНИИ =====
      COMPASSION_FACTS = {
        anxiety_reduction: "Снижает тревожность на 40%",
        resilience_boost: "Повышает устойчивость к стрессу на 35%",
        self_esteem: "Улучшает самооценку на 45%",
        motivation: "Повышает внутреннюю мотивацию на 30%",
        relationships: "Улучшает качество отношений на 25%"
      }.freeze
      
      # ===== ШАГИ ПИСЬМА САМОСОСТРАДАНИЯ =====
      COMPASSION_STEPS = {
        'intro' => {
          title: "💝 *День 17: Искусство самосострадания* 🧠",
          instruction: <<~MARKDOWN
            **Добро пожаловать в практику письма себе от лучшего друга!** ✨

            Сегодня вы научитесь дарить себе ту же поддержку, которую дарите другим.

            📊 **Научные факты о самосострадании:**
            • 🧠 #{COMPASSION_FACTS[:anxiety_reduction]}
            • 🛡️ #{COMPASSION_FACTS[:resilience_boost]}
            • 💝 #{COMPASSION_FACTS[:self_esteem]}
            • 🚀 #{COMPASSION_FACTS[:motivation]}
            • 🤝 #{COMPASSION_FACTS[:relationships]}
            • 💤 Улучшает качество сна на 20%
            • 🔄 Ускоряет восстановление после неудач на 50%

            🎯 **Что вы получите от сегодняшней практики:**
            1. 💭 Навык самоподдержки в трудные моменты
            2. 🧠 Способность говорить с собой как с другом
            3. ❤️ Снижение внутреннего критика
            4. 🌟 Повышение эмоциональной устойчивости
            5. 📖 Инструмент для регулярной самопомощи

            **Мифы о самосострадании:**
            ❌ *"Это слабость"* → Правда: Это признак эмоциональной зрелости
            ❌ *"Я буду лениться"* → Правда: Самосострадание повышает мотивацию
            ❌ *"Не заслуживаю доброты"* → Правда: Каждый человек достоин заботы
            ❌ *"Лучше быть строгим"* → Правда: Доброта эффективнее критики
          MARKDOWN
        },
        'situation' => {
          title: "📝 *Шаг 1: Опишите ситуацию как другу* 👥",
          instruction: <<~MARKDOWN
            **Представьте, что ваш лучший друг оказался в вашей ситуации.**

            📋 **Вопросы для описания:**
            • Что именно происходит?
            • Какие чувства возникают?
            • Что самое трудное в этой ситуации?
            • Как ситуация влияет на вашу жизнь?

            ✨ **Как описать эффективно:**
            1. Используйте простые и честные слова
            2. Опишите факты, а не интерпретации
            3. Включите чувства и телесные ощущения
            4. Будьте конкретны, но не критичны

            **Пример описания:**
            "Мой друг сейчас переживает сложный период на работе. У него много дедлайнов, он чувствует усталость и тревогу. Ему трудно сосредоточиться и он переживает, что не справится."

            📝 **Напишите описание ситуации:**
          MARKDOWN
        },
        'understanding' => {
          title: "🤗 *Шаг 2: Проявите понимание и сочувствие* 💭",
          instruction: <<~MARKDOWN
            **Что бы вы сказали другу, чтобы показать понимание?**

            📋 **Фразы для понимания:**
            • "Это действительно сложная ситуация..."
            • "Я понимаю, почему ты так себя чувствуешь..."
            • "Любой на твоем месте чувствовал бы похоже..."
            • "Твои чувства абсолютно нормальны и понятны..."

            📝 **Напишите слова понимания и поддержки:**
          MARKDOWN
        },
        'kindness' => {
          title: "💝 *Шаг 3: Слова поддержки и ободрения* ✨",
          instruction: <<~MARKDOWN
            **Какие добрые слова вы бы сказали другу?**

            📋 **Виды поддерживающих сообщений:**

            🎯 **Подтверждающие:**
            • "Ты справишься с этим!"
            • "У тебя есть все необходимые качества!"
            • "Я верю в тебя!"

            📝 **Напишите слова поддержки для себя:**
          MARKDOWN
        },
        'advice' => {
          title: "🧠 *Шаг 4: Мудрый совет от лучшего друга* 💡",
          instruction: <<~MARKDOWN
            **Какой мудрый и добрый совет вы бы дали другу?**

            📋 **Примеры мудрых советов:**
            • "Может быть, стоит сделать небольшой перерыв и восстановить силы?"
            • "Попробуй разбить большую задачу на маленькие шаги"
            • "Вспомни, как ты справлялся(ась) с похожими ситуациями раньше"

            📝 **Напишите мудрый совет для себя:**
          MARKDOWN
        },
        'closure' => {
          title: "✨ *Шаг 5: Завершение с теплотой и заботой* 💌",
          instruction: <<~MARKDOWN
            **Завершите письмо словами, которые согреют сердце друга.**

            📋 **Завершающие фразы:**
            • "Я всегда с тобой"
            • "Ты не одинок(а) в этом"
            • "Береги себя, ты важен(а)"
            • "Я верю, что у тебя все получится"

            📝 **Напишите завершение вашего письма:**
          MARKDOWN
        }
      }.freeze
      
      # ===== ТИПИЧНЫЕ ТРУДНОСТИ (как в Дне 6) =====
      COMMON_CHALLENGES = [
        {
          challenge: "Не могу найти добрые слова для себя",
          emoji: "💬",
          solution: "Представьте, что говорите с маленьким ребенком. Какие слова поддержки вы бы сказали ему?"
        },
        {
          challenge: "Чувствую фальшь и неестественность",
          emoji: "🎭",
          solution: "Начните с маленьких, простых фраз: 'Это нормально чувствовать себя так'. Практика делает навык естественным."
        },
        {
          challenge: "Не верю, что заслуживаю такой доброты",
          emoji: "😔",
          solution: "Напомните себе: самосострадание — это не награда за достижения, а базовое право каждого человека."
        },
        {
          challenge: "Мысли возвращаются к критике, а не к поддержке",
          emoji: "🌀",
          solution: "Сделайте паузу. Скажите себе: 'Сейчас я учусь новому способу'. Вернитесь к письму позже."
        },
        {
          challenge: "Нет времени на полное письмо",
          emoji: "⏰",
          solution: "Начните с одного шага. Даже 2-3 предложения поддержки лучше, чем ничего. Качество важнее объема."
        }
      ].freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        send_message(text: COMPASSION_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: COMPASSION_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        store_day_data('current_step', 'intro')
        
        send_message(
          text: "Готовы научиться говорить с собой как с лучшим другом?",
          reply_markup: day_17_content_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'situation')
        
        send_message(text: "✉️ *Упражнение: Письмо себе от лучшего друга* ✨", parse_mode: 'Markdown')
        
        exercise_explanation = <<~MARKDOWN
          **Как работает практика:**
          
          ✨ **Простое правило:** Говорите с собой так, как говорили бы с лучшим другом в трудной ситуации.
          
          📝 **5 шагов к письму поддержки:**
          1. 📝 Описание ситуации
          2. 🤗 Понимание и сочувствие  
          3. 💝 Слова поддержки
          4. 🧠 Мудрый совет
          5. ✨ Теплое завершение
          
          **Важно:** Не стремитесь к совершенству. Искренность важнее красоты фраз.
        MARKDOWN
        
        send_message(text: exercise_explanation, parse_mode: 'Markdown')
        
        # Начинаем первый шаг
        sleep(1)
        start_compassion_step('situation')
      end
      
      def complete_exercise
  # Сохраняем письмо
  save_compassion_letter
  
  # Получаем данные для отчета
  letter_themes = extract_letter_themes
  
  # Завершаем день
  @user.complete_day_program(DAY_NUMBER)
  @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
  
  completion_message = <<~MARKDOWN
    🎊 *День 17 завершен!* 🎊

    **Ваши достижения сегодня:**

    ✉️ **Практика письма самосострадания:**
    • 📝 Создано письмо поддержки от лучшего друга
    • 🤗 Проявлено понимание к себе в трудной ситуации
    • 💝 Найдены слова доброты и ободрения
    • 🧠 Сформулирован мудрый совет
    • ✨ Завершено с теплотой и заботой
    #{letter_themes.present? ? "• 🏷️ Основные темы: #{letter_themes.join(', ')}" : ""}

    📊 **Научный факт:**
    Регулярная практика самосострадания снижает уровень тревоги на 40%, повышает самооценку на 45% и улучшает качество отношений на 25%.

    ⏰ **Следующий день будет доступен через 12 часов**

    Ваш прогресс: #{@user.progress_percentage}%
  MARKDOWN
  
  send_message(text: completion_message, parse_mode: 'Markdown')
  
  # Простое меню (как в Дне 6)
  show_simple_menu
  
  # Предложение следующего дня
  propose_next_day_with_restriction
end
      
      def show_simple_menu
        menu_text = <<~MARKDOWN
          ✨ *День 17 завершен!* ✨

          **Что вы можете делать:**
          
          📚 *Мои письма* — просмотр всех созданных писем
          ✍️ *Новое письмо* — создать новое письмо в любое время
          
          Письма останутся доступными через главное меню.
        MARKDOWN
        
        send_message(
          text: menu_text,
          parse_mode: 'Markdown',
          reply_markup: day_17_simple_menu_markup
        )
      end
      
      def show_previous_letters
        letters = @user.compassion_letters.order(created_at: :desc).limit(5)
        
        if letters.empty?
          send_message(
            text: "📭 *У вас пока нет сохраненных писем самосострадания.*\n\nНапишите первое письмо — это мощный инструмент самоподдержки!",
            parse_mode: 'Markdown',
            reply_markup: day_17_start_exercise_markup
          )
          return
        end
        
        message = "📚 *Ваши письма самосострадания:*\n\n"
        
        letters.each_with_index do |letter, index|
          date = letter.entry_date.strftime('%d.%m.%Y')
          preview = letter.situation_text.to_s.truncate(60)
          
          message += "#{index + 1}. 📅 *#{date}*\n"
          message += "   💭 #{preview}\n\n"
        end
        
        send_message(
          text: message,
          parse_mode: 'Markdown',
          reply_markup: simple_letters_menu_markup
        )
      end
      
      # ===== ОБРАБОТКА ТРУДНОСТЕЙ (как в Дне 6) =====
      
      def handle_challenge_selection(challenge_index)
        challenge = COMMON_CHALLENGES[challenge_index.to_i]
        
        if challenge
          send_message(
            text: "🌀 **#{challenge[:challenge]}**\n\n#{challenge[:solution]}",
            parse_mode: 'Markdown'
          )
        end
        
        # После трудностей спрашиваем про завершение
        send_message(
          text: "🌟 Теперь, когда знаете как справиться с трудностями, готовы завершить День 17?",
          reply_markup: day_17_final_completion_markup
        )
      end
      
      def ask_about_challenges
        send_message(
          text: "🤔 *С какими трудностями столкнулись во время написания письма?*",
          parse_mode: 'Markdown',
          reply_markup: day_17_challenges_markup
        )
      end
      
      # ===== ОБРАБОТКА ВВОДА =====
      
      def handle_text_input(input_text)
        current_step = get_day_data('current_step')
        
        return false unless COMPASSION_STEPS.key?(current_step)
        
        # Сохраняем ввод
        store_day_data("#{current_step}_text", input_text)
        log_info("Saved #{current_step}_text")
        
        # Определяем следующий шаг
        next_step = get_next_compassion_step(current_step)
        
        if next_step
          # Переходим к следующему шагу
          start_compassion_step(next_step)
          return true
        else
          # Все шаги выполнены
          show_compassion_summary
          return true
        end
      end
      
      def handle_button(callback_data)
        case callback_data
        when 'compassion_step_2', 'compassion_step_3', 'compassion_step_4', 'compassion_step_5'
          # Обработка шагов через CompassionStepHandler
          # Здесь просто логируем
          log_info("Step button pressed: #{callback_data}")
          
        when 'day_17_challenge_0', 'day_17_challenge_1', 'day_17_challenge_2', 'day_17_challenge_3', 'day_17_challenge_4'
          # Обработка трудностей
          index = callback_data.split('_').last.to_i
          handle_challenge_selection(index)
          
        when 'day_17_no_challenges'
          # Нет трудностей
          send_message(text: "🌟 Отлично! У вас получилась продуктивная практика!")
          send_message(
            text: "Завершаем День 17?",
            reply_markup: day_17_final_completion_markup
          )
          
        when 'day_17_complete_exercise'
          complete_exercise
          
        when 'day_17_view_letters'
          show_previous_letters
          
        when 'day_17_new_letter'
          start_new_practice
          
        else
          log_warn("Unknown button: #{callback_data}")
        end
      end
      
      def start_new_practice
        # Очищаем данные
        clear_compassion_data
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        
        send_message(
          text: "✍️ *Начинаем новое письмо самосострадания!* 💝",
          parse_mode: 'Markdown'
        )
        
        deliver_exercise
      end
      
      private

      def extract_letter_themes
  themes = []
  text = [
    get_day_data('situation_text'),
    get_day_data('understanding_text'),
    get_day_data('kindness_text'),
    get_day_data('advice_text'),
    get_day_data('closure_text')
  ].compact.join(' ').downcase
  
  # Определяем темы по ключевым словам
  theme_keywords = {
    'работа' => ['работа', 'рабочий', 'дедлайн', 'проект', 'коллега'],
    'отношения' => ['друг', 'подруга', 'отношен', 'семья', 'родител'],
    'тревога' => ['тревог', 'страх', 'беспоко', 'волнен', 'нервни'],
    'усталость' => ['устал', 'утомлен', 'упадок', 'энерг', 'сил'],
    'самооценка' => ['ценност', 'уверен', 'самооцен', 'достоин', 'способност']
  }
  
  theme_keywords.each do |theme, keywords|
    if keywords.any? { |keyword| text.include?(keyword) }
      themes << theme.capitalize
    end
  end
  
  themes.any? ? themes : []
end
      
      def start_compassion_step(step_type)
        store_day_data('current_step', step_type)
        
        step = COMPASSION_STEPS[step_type]
        return unless step
        
        send_message(text: step[:title], parse_mode: 'Markdown')
        send_message(text: step[:instruction])
        
        # Для шагов, кроме первого, показываем кнопку
        if step_type != 'situation'
          send_message(
            text: "Напишите ответ выше, затем нажмите:",
            reply_markup: compassion_step_markup(step_type)
          )
        end
      end
      
      def get_next_compassion_step(current_step)
        steps_order = ['situation', 'understanding', 'kindness', 'advice', 'closure']
        current_index = steps_order.index(current_step)
        steps_order[current_index + 1] if current_index && current_index < steps_order.length - 1
      end
      
      def show_compassion_summary
        # Простой итог
        send_message(
          text: "✅ *Все шаги выполнены!*\n\nВаше письмо самосострадания готово.",
          parse_mode: 'Markdown'
        )
        
        # Спрашиваем про трудности (как в Дне 6)
        sleep(1)
        ask_about_challenges
      end
      
      def save_compassion_letter
        begin
          CompassionLetter.create!(
            user: @user,
            entry_date: Date.current,
            situation_text: get_day_data('situation_text') || '',
            understanding_text: get_day_data('understanding_text') || '',
            kindness_text: get_day_data('kindness_text') || '',
            advice_text: get_day_data('advice_text') || '',
            closure_text: get_day_data('closure_text') || '',
            full_text: compile_full_letter
          )
          log_info("Compassion letter saved")
        rescue => e
          log_error("Failed to save letter", e)
          store_day_data('letter_saved_fallback', true)
        end
      end
      
      def compile_full_letter
        parts = [
          "Ситуация: #{get_day_data('situation_text')}",
          "Понимание: #{get_day_data('understanding_text')}",
          "Поддержка: #{get_day_data('kindness_text')}",
          "Совет: #{get_day_data('advice_text')}",
          "Завершение: #{get_day_data('closure_text')}"
        ].compact.join("\n\n")
      end
      
      def clear_compassion_data
        ['situation', 'understanding', 'kindness', 'advice', 'closure'].each do |step|
          store_day_data("#{step}_text", nil)
        end
        store_day_data('current_step', nil)
      end
      
      # ===== МЕТОДЫ РАЗМЕТКИ =====
      
      def day_17_content_markup
        {
          inline_keyboard: [
            [
              { text: "✍️ Начать письмо", callback_data: 'start_day_17_content' }
            ],
            [
              { text: "#{EMOJI[:back]} Главное меню", callback_data: 'back_to_main_menu' }
            ]
          ]
        }.to_json
      end
      
      def day_17_start_exercise_markup
        {
          inline_keyboard: [
            [
              { text: "✍️ Начать письмо", callback_data: 'start_day_17_exercise' }
            ]
          ]
        }.to_json
      end
      
      def compassion_step_markup(step_type)
        button_text = case step_type
                     when 'understanding' then "➡️ К пониманию"
                     when 'kindness' then "➡️ К поддержке"
                     when 'advice' then "➡️ К совету"
                     when 'closure' then "✅ Завершить"
                     else "➡️ Продолжить"
                     end
        
        callback = case step_type
                  when 'understanding' then 'compassion_step_2'
                  when 'kindness' then 'compassion_step_3'
                  when 'advice' then 'compassion_step_4'
                  when 'closure' then 'compassion_step_5'
                  else 'compassion_step_2'
                  end
        
        {
          inline_keyboard: [
            [
              { text: button_text, callback_data: callback }
            ]
          ]
        }.to_json
      end
      
      def day_17_challenges_markup
        {
          inline_keyboard: [
            [
              { text: "💬 Не могу найти добрые слова", callback_data: 'day_17_challenge_0' }
            ],
            [
              { text: "🎭 Чувствую фальшь", callback_data: 'day_17_challenge_1' }
            ],
            [
              { text: "😔 Не верю, что заслуживаю", callback_data: 'day_17_challenge_2' }
            ],
            [
              { text: "🌀 Мысли возвращаются к критике", callback_data: 'day_17_challenge_3' }
            ],
            [
              { text: "⏰ Нет времени на письмо", callback_data: 'day_17_challenge_4' }
            ],
            [
              { text: "✅ Никаких трудностей", callback_data: 'day_17_no_challenges' }
            ]
          ]
        }.to_json
      end
      
      def day_17_final_completion_markup
        {
          inline_keyboard: [
            [
              { text: "✅ Завершить День 17", callback_data: 'day_17_complete_exercise' }
            ],
            [
              { text: "📝 Сделать заметку", callback_data: 'day_17_make_note' }
            ]
          ]
        }.to_json
      end
      
      def day_17_simple_menu_markup
        {
          inline_keyboard: [
            [
              { text: "📚 Мои письма", callback_data: 'day_17_view_letters' }
            ],
            [
              { text: "✍️ Новое письмо", callback_data: 'day_17_new_letter' }
            ],
            [
              { text: "#{EMOJI[:back]} Главное меню", callback_data: 'back_to_main_menu' }
            ]
          ]
        }.to_json
      end
      
      def simple_letters_menu_markup
        {
          inline_keyboard: [
            [
              { text: "✍️ Новое письмо", callback_data: 'day_17_new_letter' }
            ],
            [
              { text: "#{EMOJI[:back]} Назад", callback_data: 'back_to_main_menu' }
            ]
          ]
        }.to_json
      end
      
      def propose_next_day_with_restriction
        next_day = 18
        
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ✅ *Доступен сейчас!*
            
            Вы можете начать следующий день прямо сейчас.
          MARKDOWN
          
          button_text = "🌟 Начать День #{next_day}"
          callback_data = "start_day_#{next_day}_from_proposal"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ⏱️ *Ограничение:* #{error_message}
            
            Следующий день будет доступен автоматически.
          MARKDOWN
          
          button_text = "⏱️ Проверить доступность"
          callback_data = "start_day_#{next_day}_from_proposal"
        end
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Нажмите кнопку:",
          reply_markup: {
            inline_keyboard: [
              [
                { text: button_text, callback_data: callback_data }
              ]
            ]
          }
        )
      end
    end
  end
end
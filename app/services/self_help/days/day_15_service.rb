# app/services/self_help/days/day_15_service.rb
module SelfHelp
  module Days
    class Day15Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 15
      
      # Шаги дня 15
      DAY_STEPS = {
        'intro' => {
          title: "🤝 *День 15: Сила доброты* 🌟",
          instruction: <<~MARKDOWN
            **Доброта — это не слабость, а осознанная сила.** 🧠

            📊 **Научные факты о доброте:**
            • 🧠 Активирует центры удовольствия в мозге (выработка дофамина)
            • 😌 Снижает уровень кортизола (гормона стресса) на 20-30%
            • ❤️ Повышает выработку окситоцина (гормона связи и доверия)
            • 🔄 Запускает «эффект заражения» — доброта порождает доброту
            • 📈 Повышает субъективное благополучие на 25-35%
            • 🤝 Укрепляет социальные связи и создает сеть поддержки
            • 🛡️ Повышает психологическую устойчивость к стрессу

            🎯 **Что вы получите от сегодняшней практики:**
            1. 🧠 Нейробиологический заряд — активация центров удовольствия
            2. 😌 Снижение уровня стресса и тревожности
            3. 🤝 Укрепление социальных связей
            4. 🔄 Навык создания цепной реакции доброты
            5. 💪 Развитие эмпатии и эмоционального интеллекта
            6. 🌟 Повышение самооценки и чувства собственной значимости

            *Интересный факт:* Свидетели актов доброты часто сами становятся добрее — это называется «социальное заражение добротой».
          MARKDOWN
        },
        'exercise_explanation' => {
          title: "🎯 *Упражнение: Три целенаправленных акта доброты* 🎁",
          instruction: <<~MARKDOWN
            **Как работает практика целенаправленной доброты?** 🔬

            📚 **Научный подход:**
            • 🎯 *Целенаправленность* — заранее спланированные акты увеличивают эффект на 40%
            • 🔄 *Разнообразие* — разные типы доброты активируют разные нейронные сети
            • 📊 *Отслеживание* — фиксация опыта усиливает нейронные связи
            • 💭 *Рефлексия* — анализ опыта интегрирует его в долговременную память

            **3 типа актов доброты (по возрастанию сложности):**
            1. 🟢 **Простые** — для знакомых, требуют минимальных усилий
            2. 🟡 **Средние** — для коллег/соседей, требуют умеренных усилий  
            3. 🔴 **Более значительные** — для незнакомцев/сообщества, требуют больше усилий

            **Формат:** Мы пройдем 4 шага структурированной практики.
          MARKDOWN
        }
      }.freeze
      
      # Шаги практики доброты
      KINDNESS_STEPS = {
        'planning' => {
          title: "📝 *Шаг 1: Планирование доброты* 🗺️",
          instruction: <<~MARKDOWN
            **Выберите 3 акта доброты, которые совершите сегодня:**

            🟢 *Простые (выберите 1):*
            • 🙏 Поблагодарите кого-то за их работу/помощь
            • 😊 Улыбнитесь незнакомцу искренне
            • 👍 Похвалите чью-то идею или работу
            • 💌 Напишите ободряющее сообщение другу
            • 👥 Пропустите кого-то в очереди

            🟡 *Средние (выберите 1):*
            • ☕ Купите кофе/чай для коллеги
            • 🤝 Предложите помощь с задачей
            • 👂 Выслушайте кого-то, не перебивая
            • 📚 Поделитесь полезной информацией
            • 🛒 Помогите соседу с покупками

            🔴 *Более значительные (выберите 1):*
            • 🫂 Организуйте небольшую помощь для нуждающегося
            • 🧑‍🏫 Помогите с обучением или наставничеством
            • ❤️ Простите старую обиду и дайте понять об этом
            • 🌱 Создайте что-то полезное для сообщества

            **Напишите ваши 3 выбранных акта через запятую или с новой строки:**
          MARKDOWN
        },
        'execution' => {
          title: "🚀 *Шаг 2: Исполнение доброты* ⏱️",
          instruction: <<~MARKDOWN
            **Совершите выбранные акты доброты сегодня!**

            💡 **Советы для успешного выполнения:**
            • ❤️ Будьте искренними — не ожидайте благодарности или награды
            • 👀 Обратите внимание на реакцию других людей
            • 🌈 Заметьте, как вы себя чувствуете во время и после акта
            • 🎯 Не перегружайте себя — доброта должна быть в радость
            • ⏰ Лучше маленький, но искренний акт, чем большой, но формальный

            **Важные правила:**
            1. Сделайте все 3 акта сегодня
            2. Не обязательно сообщать, что это «упражнение»
            3. Наслаждайтесь процессом, а не только результатом
            4. Помните: каждый акт доброты меняет мир, даже чуть-чуть

            **Когда выполните все 3 акта, напишите:**
            ✅ Готово!
          MARKDOWN
        },
        'reflection' => {
          title: "💭 *Шаг 3: Рефлексия опыта* 🧠",
          instruction: <<~MARKDOWN
            **Поделитесь впечатлениями о вашем дне доброты:**

            🔍 **Вопросы для глубокой рефлексии:**
            
            1. 🎯 **Легкость/Сложность:**
            • Что было самым легким в совершении актов доброты?
            • Что оказалось сложнее всего?

            2. 👥 **Реакции других:**
            • Как реагировали люди на вашу доброту?
            • Что вы заметили в их поведении или выражении лица?

            3. 🌈 **Ваши ощущения:**
            • Как изменилось ваше настроение после каждого акта?
            • Какие эмоции вы испытали (радость, удовлетворение, спокойствие)?

            4. 💡 **Инсайты и открытия:**
            • Что нового вы узнали о себе в процессе?
            • Как изменилось ваше восприятие возможностей для доброты?

            **📝 Напишите 5-10 предложений о вашем опыте:**
          MARKDOWN
        },
        'integration' => {
          title: "🔄 *Шаг 4: Интеграция в жизнь* 📅",
          instruction: <<~MARKDOWN
            **Как сделать доброту регулярной практикой?**

            📋 **Ежедневные ритуалы доброты:**
            • 🌅 Каждое утро: думайте, кому можете сделать приятное сегодня
            • 👁️ В течение дня: замечайте возможности для маленькой помощи
            • 🙏 Вечером: вспоминайте моменты доброты (своей и других)
            • 💬 Регулярно: благодарите людей искренне и конкретно

            🗓️ **Недельные цели:**
            • Совершать минимум 3 целенаправленных акта доброты в неделю
            • Записывать самые значимые моменты в «дневник доброты»
            • Делиться историями доброты с близкими (усиливает эффект)

            🎯 **Принципы устойчивой практики:**
            • Начинайте с малого — лучше регулярно понемногу, чем редко и много
            • Будьте разнообразны — разные типы доброты развивают разные навыки
            • Отслеживайте прогресс — замечайте изменения в себе и отношениях
            • Не будьте перфекционистом — неидеальная доброта все равно ценна

            **Напишите, какую одну практику доброты вы возьмете в свою регулярную жизнь:**
          MARKDOWN
        }
      }.freeze
      
      # Категории трудностей в практике доброты
      KINDNESS_CHALLENGES = [
        {
          name: "Неловкость или стеснение",
          emoji: "😳",
          description: "Чувствую себя неловко, проявляя доброту",
          solution: "Начните с маленьких, незаметных актов. Помните: большинство людей ценят искреннюю доброту, даже если немного смущаются."
        },
        {
          name: "Ожидание благодарности",
          emoji: "🎭",
          description: "Расстраиваюсь, если люди не благодарят",
          solution: "Сосредоточьтесь на внутренних ощущениях, а не на реакции других. Доброта — это дар, который вы дарите, а не обмен."
        },
        {
          name: "Недостаток времени",
          emoji: "⏰",
          description: "Не нахожу времени для добрых дел",
          solution: "Интегрируйте доброту в повседневность. Улыбка, комплимент, помощь с дверью — занимают секунды."
        },
        {
          name: "Сомнения в искренности",
          emoji: "🤔",
          description: "Сомневаюсь, искренни ли мои намерения",
          solution: "Даже если сначала это кажется «упражнением», регулярная практика формирует искреннюю привычку."
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
          text: "Готовы запустить цепную реакцию доброты?",
          reply_markup: day_15_content_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise_explanation')
        clear_day_data
        
        send_message(text: DAY_STEPS['exercise_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['exercise_explanation'][:instruction], parse_mode: 'Markdown')
        
        # Начинаем первый шаг практики
        start_kindness_step('planning')
      end
      
      def start_kindness_step(step_type)
        store_day_data('current_kindness_step', step_type)
        @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_#{step_type}")
        
        step = KINDNESS_STEPS[step_type]
        return unless step
        
        send_message(text: step[:title], parse_mode: 'Markdown')
        send_message(text: step[:instruction], parse_mode: 'Markdown')
        
        # Показываем подсказку
        send_message(
          text: "📝 *Введите ваш ответ:*",
          parse_mode: 'Markdown',
          reply_markup: day_15_input_markup
        )
      end
      
      def handle_kindness_input(input_text)
        current_step = get_day_data('current_kindness_step')
        return false unless current_step
        
        case current_step
        when 'planning'
          return handle_planning_input(input_text)
        when 'execution'
          return handle_execution_input(input_text)
        when 'reflection'
          return handle_reflection_input(input_text)
        when 'integration'
          return handle_integration_input(input_text)
        end
        
        false
      end
      
      def handle_planning_input(input_text)
        return false if input_text.blank?
        
        acts = input_text.split(/[,\.\n]/).map(&:strip).reject(&:empty?)
        
        if acts.size >= 3
          store_day_data('planned_acts', acts)
          store_day_data('planning_completed', true)
          
          # Подтверждаем сохранение
          send_message(
            text: "✅ *Планирование завершено!* Сохранено #{acts.size} актов доброты.",
            parse_mode: 'Markdown'
          )
          
          # Переходим к выполнению
          store_day_data('current_kindness_step', 'execution')
          sleep(1)
          start_kindness_step('execution')
          return true
        else
          send_message(
            text: "⚠️ Пожалуйста, напишите минимум 3 акта доброты (разделяйте запятыми или с новой строки).",
            parse_mode: 'Markdown'
          )
          return false
        end
      end
      
      def handle_execution_input(input_text)
        return false if input_text.blank?
        
        if input_text.downcase.include?('готово') || input_text.downcase.include?('done') || input_text.include?('✅')
          store_day_data('execution_confirmed', true)
          store_day_data('execution_completed_at', Time.current)
          
          send_message(
            text: "🎉 *Отлично! Вы совершили 3 акта доброты!*",
            parse_mode: 'Markdown'
          )
          
          # Переходим к рефлексии
          store_day_data('current_kindness_step', 'reflection')
          sleep(1)
          start_kindness_step('reflection')
          return true
        else
          send_message(
            text: "⏳ Когда закончите все 3 акта доброты, напишите '✅ Готово!' или 'Готово'",
            parse_mode: 'Markdown'
          )
          return false
        end
      end
      
      def handle_reflection_input(input_text)
        return false if input_text.blank?
        
        if input_text.split.size >= 1
          store_day_data('reflection_text', input_text)
          store_day_data('reflection_completed', true)
          
          send_message(
            text: "💭 *Рефлексия сохранена!* Спасибо за ваши мысли.",
            parse_mode: 'Markdown'
          )
          
          # Переходим к интеграции
          store_day_data('current_kindness_step', 'integration')
          sleep(1)
          start_kindness_step('integration')
          return true
        else
          send_message(
            text: "⚠️ Пожалуйста, напишите более развернутый ответ.",
            parse_mode: 'Markdown'
          )
          return false
        end
      end
      
      def handle_integration_input(input_text)
  return false if input_text.blank?
  
  store_day_data('integration_commitment', input_text)
  store_day_data('integration_completed', true)
  
  # Все шаги выполнены
  show_completion_menu
  
  true
end
      
      def complete_kindness_practice
  store_day_data('kindness_completed', true)
  store_day_data('completion_time', Time.current)
  
  # Сохраняем практику
  save_kindness_practice
  
  # Показываем меню завершения (не вызывает несуществующий метод)
  show_completion_menu
end


      def show_completion_menu
  # Устанавливаем состояние, что практика завершена
  store_day_data('kindness_completed', true)
  store_day_data('completion_time', Time.current)
  
  # Сохраняем практику
  save_kindness_practice
  
  # Устанавливаем состояние отражения
  @user.set_self_help_step("day_15_reflection_done")
  
  # Показываем меню завершения
  send_message(
    text: "🌟 Практика доброты завершена!\n\nВы можете:\n1. 🤝 Начать новую практику\n2. 🎯 Завершить День 15",
    reply_markup: day_15_completion_menu_markup
  )
end

      def start_new_practice
  log_info("Starting new kindness practice for user #{@user.telegram_id}")
  
  # Очищаем данные предыдущей практики
  clear_day_data
  
  # Устанавливаем состояние
  @user.set_self_help_step("day_15_exercise_in_progress")
  store_day_data('current_step', 'exercise_explanation')
  
  # Начинаем упражнение
  deliver_exercise
  
  true
end
      
      def show_kindness_completion
        store_day_data('current_step', 'completion')
        
        completion_message = <<~MARKDOWN
          🎊 *Практика доброты завершена!* 🎊

          **Вы только что:**
          
          1. 📝 Спланировали целенаправленные акты доброты
          2. 🚀 Реализовали их на практике
          3. 💭 Провели глубокую рефлексию опыта
          4. 🔄 Создали план интеграции в жизнь
          
          **Ваши достижения:**
          • 🤝 Развили навык целенаправленной доброты
          • 🧠 Укрепили нейронные связи, связанные с эмпатией
          • 😌 Снизили уровень стресса через позитивные действия
          • 🌟 Повысили субъективное благополучие
          • 🔄 Стали частью цепной реакции доброты
          
          **Поздравляем!** Вы освоили практику, которая:
          • 🧬 Изменяет структуру мозга через нейропластичность
          • 🤝 Улучшает качество социальных отношений
          • 😊 Повышает уровень счастья и удовлетворенности
          • 💪 Развивает психологическую устойчивость
        MARKDOWN
        
        send_message(text: completion_message, parse_mode: 'Markdown')
        
        sleep(2)
        
        # Показываем трудности
        send_message(
          text: "🤔 *С какими трудностями столкнулись в практике доброты?*",
          parse_mode: 'Markdown',
          reply_markup: day_15_challenges_markup
        )
      end
      
      def handle_challenge_selection(challenge_index)
  challenge = KINDNESS_CHALLENGES[challenge_index.to_i]
  
  if challenge
    send_message(
      text: "#{challenge[:emoji]} **#{challenge[:name]}**\n\n#{challenge[:description]}\n\n💡 **Решение:** #{challenge[:solution]}",
      parse_mode: 'Markdown'
    )
  end
  
  @user.set_self_help_step("day_15_reflection_done")
  
  send_message(
    text: "🌟 Отлично! Вы завершили практику доброты.\n\nХотите начать новую практику или завершить день?",
    reply_markup: day_15_completion_menu_markup
  )
end
      
      def complete_exercise
        # Проверяем, завершена ли практика
        unless get_day_data('kindness_completed') == true
          send_message(
            text: "⚠️ Сначала завершите практику доброты.\n\nУбедитесь, что вы прошли все 4 шага.",
            parse_mode: 'Markdown',
            reply_markup: day_15_content_markup
          )
          return
        end
        
        # Отмечаем день как завершенный
        @user.complete_day_program(DAY_NUMBER)
        @user.complete_self_help_day(DAY_NUMBER)
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
        
        completion_message = <<~MARKDOWN
          🎉 *День 15 завершен!* 🎉

          **Ваши достижения сегодня:**
          
          🤝 **Практика целенаправленной доброты:**
          • 📊 Освоена научно-обоснованная методика
          • 🎯 Спланированы и реализованы 3 акта доброты
          • 💭 Проведена глубокая рефлексия опыта
          • 🔄 Создан план интеграции в повседневность
          
          📚 **Научный факт:**
          Регулярная практика доброты повышает субъективное благополучие на 25-35%, снижает уровень стресса на 20-30%, укрепляет социальные связи и активирует центры удовольствия в мозге.
          
          🎯 **Что дальше:**
          Следующий день программы самопомощи
          
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
  when 'start_day_15_content', 'start_day_15_from_proposal', 'start_kindness_exercise'
    deliver_exercise
    
  when 'continue_day_15_content'
    current_step = get_day_data('current_step')
    handle_resume_from_step(current_step || 'intro')
    
  when 'day_15_skip_step'
    # Пропуск текущего шага
    current_step = get_day_data('current_kindness_step')
    if current_step
      next_step = get_next_kindness_step(current_step)
      if next_step
        send_message(text: "⚠️ Шаг пропущен. Переходим к следующему.")
        start_kindness_step(next_step)
      else
        complete_kindness_practice
      end
    end
    
  when 'day_15_restart_kindness'
    deliver_exercise
    
  when 'day_15_exercise_completed', 'kindness_exercise_completed'
    complete_kindness_practice
    
  when /^day_15_challenge_(\d+)$/
    handle_challenge_selection($1)
    
  when 'day_15_no_challenges'
    @user.set_self_help_step("day_15_reflection_done")
    send_message(
      text: "🌟 Отлично! У вас получилась продуктивная практика!",
      reply_markup: day_15_completion_menu_markup
    )
    
  when 'day_15_complete_exercise'
    complete_exercise
    
  when 'day_15_show_practices'
    show_previous_practices
  when 'day_15_start_new_practice'
    start_new_practice
    
  else
    log_warn("Unknown button callback: #{callback_data}")
    send_message(text: "Неизвестная команда.")
  end
end
      
      # ===== ОБРАБОТКА ТЕКСТОВОГО ВВОДА =====
      
      def handle_text_input(input_text)
  log_info("Handling text input for day 15: #{input_text}")
  
  current_state = @user.self_help_state
  
  # Определяем, какой ввод ожидается
  case current_state
  when "day_15_waiting_for_planning"
    return handle_kindness_input(input_text)
    
  when "day_15_waiting_for_execution"
    return handle_kindness_input(input_text)
    
  when "day_15_waiting_for_reflection"
    return handle_kindness_input(input_text)
    
  when "day_15_waiting_for_integration"
    return handle_kindness_input(input_text)
    
  when "day_15_kindness_completed", "day_15_reflection_done", "day_15_completed"
    send_message(
      text: "✅ Практика доброты уже завершена. Вы можете:\n• 🤝 Начать новую практику\n• 🎯 Завершить день 15",
      reply_markup: day_15_completion_menu_markup
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
          show_kindness_completion
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
          text: "Готовы запустить цепную реакцию доброты?",
          reply_markup: day_15_content_markup
        )
      end
      
      def propose_next_day_with_restriction
        next_day = 16
        
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ✅ *Доступен сейчас!*
            
            Вы можете начать следующий день прямо сейчас.
          MARKDOWN
          
          button_text = "➡️ Начать День #{next_day}"
          callback_data = "start_day_#{next_day}_from_proposal"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День #{next_day}**
            
            ⏱️ *Ограничение:* #{error_message}
            
            **Пока ждете, можете:**
            • 🤝 Практиковать акты доброты в разных ситуациях
            • 📊 Отслеживать влияние доброты на ваше настроение
            • 🔄 Создавать свои собственные ритуалы доброты
            • 📈 Посмотреть статистику (/progress)
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
      
      def get_next_kindness_step(current_step)
        steps_order = KINDNESS_STEPS.keys
        current_index = steps_order.index(current_step)
        
        return steps_order[current_index + 1] if current_index && current_index < steps_order.length - 1
        nil
      end
      
      def save_kindness_practice
        begin
          # Сохраняем практику в модель KindnessPractice, если она существует
          # Или сохраняем в self_help_data
          
          planned_acts = get_day_data('planned_acts') || []
          reflection_text = get_day_data('reflection_text') || ''
          integration_commitment = get_day_data('integration_commitment') || ''
          
          # Сохраняем в self_help_data
          store_day_data('kindness_practice', {
            planned_acts: planned_acts,
            reflection_text: reflection_text,
            integration_commitment: integration_commitment,
            completed_at: Time.current
          })
          
          log_info("Saved kindness practice for user #{@user.telegram_id}")
          
          true
        rescue => e
          log_error("Failed to save kindness practice", e)
          false
        end
      end
      
      def clear_day_data
        # Очищаем данные предыдущей практики
        store_day_data('planned_acts', nil)
        store_day_data('planning_completed', nil)
        store_day_data('execution_confirmed', nil)
        store_day_data('reflection_text', nil)
        store_day_data('reflection_completed', nil)
        store_day_data('integration_commitment', nil)
        store_day_data('integration_completed', nil)
        store_day_data('current_kindness_step', nil)
        store_day_data('kindness_completed', nil)
        store_day_data('completion_time', nil)
      end
      
      def statistics_message
        <<~MARKDOWN
          📊 *Почему доброта — это научно-обоснованная практика для психического здоровья:*
          
          • 🧠 **25-35%** повышение субъективного благополучия у практикующих регулярную доброту
          • 😌 **20-30%** снижение уровня стресса и тревожности
          • ❤️ **15-25%** повышение уровня окситоцина (гормона доверия и связи)
          • 🤝 **30-40%** улучшение качества социальных отношений
          • 🛡️ **25-35%** повышение психологической устойчивости к стрессу
          • 🔄 **85%** свидетелей актов доброта сами становятся добрее в течение 24 часов
          
          *Источник: Исследования Journal of Happiness Studies, Journal of Positive Psychology*
        MARKDOWN
      end
      
      # Вспомогательные методы разметки
      def day_15_content_markup
        {
          inline_keyboard: [
            [
              { text: "🤝 Начать практику доброты", callback_data: 'start_day_15_content' }
            ],
            [
              { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
            ]
          ]
        }.to_json
      end
      
      def day_15_input_markup
        {
          inline_keyboard: [
            [
              { text: "🔄 Начать заново", callback_data: 'day_15_restart_kindness' }
            ]
          ]
        }.to_json
      end
      
      def day_15_challenges_markup
        {
          inline_keyboard: KINDNESS_CHALLENGES.each_with_index.map do |challenge, index|
            [{ text: "#{challenge[:emoji]} #{challenge[:name]}", callback_data: "day_15_challenge_#{index}" }]
          end + [
            [{ text: "✅ Никаких трудностей", callback_data: 'day_15_no_challenges' }]
          ]
        }.to_json
      end
      
      def day_15_completion_menu_markup
        {
          inline_keyboard: [
            [
              { text: "🎯 Завершить День 15", callback_data: 'day_15_complete_exercise' },
              { text: "🤝 Новая практика", callback_data: 'start_day_15_content' }
            ]
          ]
        }.to_json
      end
      
      def show_previous_practices
        # Показываем сохраненные практики из self_help_data
        kindness_practices = @user.self_help_program_data.select { |k, v| k.start_with?('kindness_practice_') }
        
        if kindness_practices.empty?
          send_message(
            text: "🤝 *Ваши практики доброты:*\n\nПока нет сохраненных практик.\nПройдите упражнение дня 15, чтобы создать первую запись.",
            parse_mode: 'Markdown',
            reply_markup: day_15_content_markup
          )
          return
        end
        
        send_message(
          text: "🤝 *Ваши предыдущие практики доброты:*",
          parse_mode: 'Markdown'
        )
        
        kindness_practices.each_with_index do |(key, practice_data), index|
          planned_acts = practice_data['planned_acts'] || []
          reflection = practice_data['reflection_text'] || ''
          
          practice_summary = <<~MARKDOWN
            *Практика ##{index + 1}*
            
            📋 **Акты:** #{planned_acts.first(3).join(', ').truncate(50)}
            💭 **Рефлексия:** #{reflection.truncate(50)}
            ──────────────────────────────
          MARKDOWN
          
          send_message(text: practice_summary, parse_mode: 'Markdown')
        end
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
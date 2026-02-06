# app/services/self_help/days/day_16_service.rb
module SelfHelp
  module Days
    class Day16Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 16
      
      # Шаги дня 16
      DAY_STEPS = {
        'intro' => {
          title: "🌉 *День 16: Мост через время* 🌉",
          instruction: <<~MARKDOWN
            **Почему социальные связи — это научно-обоснованная практика для психического здоровья?**
            
            📊 **Научные факты о социальных связях:**
            • 🧠 **25-35%** — повышение субъективного благополучия у людей с сильной социальной поддержкой
            • 😌 **20-30%** — снижение уровня стресса и тревожности через качественное общение
            • ❤️ **15-20%** — увеличение продолжительности жизни благодаря социальным связям
            • 🤝 **30-40%** — улучшение качества социальных отношений при регулярной коммуникации
            • 🛡️ **25-35%** — повышение психологической устойчивости к стрессу
            • 🔄 **60-70%** — эффективность восстановления связей для повышения уровня счастья
            
            *Интересный факт:* Каждое значимое социальное взаимодействие активирует выработку окситоцина — гормона доверия и связи.
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            🤔 **Почему мы теряем контакты?**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            
            ❌ **Временной парадокс:**
            «Сейчас некогда» → «Уже прошло полгода» → «Слишком поздно»
            
            ❌ **Эффект дистанции:**
            📍 Переезд, смена работы, разные графики создают искусственные барьеры
            
            ❌ **Синдром перфекциониста:**
            🎭 «Нужен идеальный повод» → «Повода нет» → «Не пишу»
            
            ❌ **Страх неловкости:**
            😰 «А вдруг им не интересно?» → «Лучше не беспокоить»
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            🎯 **Что вы получите от сегодняшней практики:**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            
            1. 🌉 **Навык восстановления связей** — научный подход к общению
            2. 💬 **Уверенность в коммуникации** — преодоление страха неловкости
            3. 🤝 **Укрепление социальной сети** — создание надежной поддержки
            4. 🔄 **Техника регулярного общения** — поддержание связей без усилий
            5. 💡 **Понимание ценности отношений** — осознание роли каждого человека
            6. 🌟 **Повышение самооценки** — через позитивные социальные взаимодействия
            
            **Хорошая новость: 95% людей рады, когда с ними связываются старые друзья!**
          MARKDOWN
        },
        'exercise_explanation' => {
          title: "🎯 *Упражнение: Мост через время* 🌉",
          instruction: <<~MARKDOWN
            **6-шаговый алгоритм осмысленного восстановления связей:**
            
            1. 🗺️ **Карта связей** — вспомнить ценных людей из прошлого
            2. 🎯 **Планирование** — выбрать подходящий формат общения
            3. 💬 **Подготовка** — найти правильные слова
            4. 🚀 **Исполнение** — сделать первый шаг
            5. 💭 **Рефлексия** — проанализировать опыт общения
            6. 🔄 **Интеграция** — сделать практику регулярной
            
            **Научный механизм:**
            • 🧠 Активация социальных центров мозга (префронтальная кора, островковая доля)
            • 💡 Выработка окситоцина и эндорфинов при позитивном общении
            • 🔄 Создание новых нейронных связей для социальных навыков
            • 📈 Повышение эмоционального интеллекта через практику эмпатии
            
            **Сегодняшнее упражнение:** Полный цикл восстановления хотя бы одной связи.
            *Не обязательно выбирать самую сложную связь — начните с комфортной.*
          MARKDOWN
        }
      }.freeze
      
      # Шаги упражнения восстановления связей
      RECONNECTION_STEPS = {
        'reflection' => {
          title: "🗺️ *Шаг 1: Карта связей* 📝",
          instruction: <<~MARKDOWN
            **Вспомните людей из вашего прошлого:**
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            🤗 **Близкие друзья**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            • С кем делились самыми сокровенными мыслями?
            • Кто знал вас «настоящего»?
            • С кем прошли через важные этапы жизни?
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            👨‍👩‍👧‍👦 **Родственные души**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            • Кто всегда верил в вас?
            • Чье мнение было для вас важно?
            • Кто поддерживал в трудные моменты?
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            🧑‍🏫 **Наставники и вдохновители**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            • Кто вас учил или направлял?
            • Чьим примером восхищались?
            • У кого перенимали опыт?
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            📝 **Задание:**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            Напишите 3-5 имен людей, с которыми хотели бы восстановить связь (через запятую или с новой строки):
          MARKDOWN
        },
        'planning' => {
          title: "🎯 *Шаг 2: Планирование общения* 📱",
          instruction: <<~MARKDOWN
            **Как вы хотите связаться?**
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            📞 **Звонок** (самый личный вариант)
            ━━━━━━━━━━━━━━━━━━━━━━━━
            ✅ Плюсы: Живое общение, эмоции, спонтанность
            ❌ Минусы: Требует смелости, может застать врасплох
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            💬 **Сообщение** (наиболее комфортно)
            ━━━━━━━━━━━━━━━━━━━━━━━━
            ✅ Плюсы: Можно обдумать слова, удобное время
            ❌ Минусы: Меньше эмоций, можно откладывать ответ
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            ✉️ **Письмо** (для глубоких размышлений)
            ━━━━━━━━━━━━━━━━━━━━━━━━
            ✅ Плюсы: Можно выразить все мысли, сохранить
            ❌ Минусы: Долго пишется, медленный ответ
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            📝 **Задание:**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            Выберите одного человека и формат общения.
            
            **Напишите в формате:**
            Имя - Формат (звонок/сообщение/письмо)
            
            *Пример: "Анна - сообщение"*
          MARKDOWN
        },
        'preparation' => {
          title: "💬 *Шаг 3: Подготовка к общению* 🧠",
          instruction: <<~MARKDOWN
            **Что сказать, чтобы не было неловко?**
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            ✅ **Удачные начала:**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            • «Привет! Недавно вспоминал(а) о тебе и решил(а) написать»
            • «Здравствуй! Как твои дела? Давно не общались»
            • «Привет! Случайно наткнулся(ась) на наши старые фото и улыбнулся(ась)»
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            ❌ **Чего избегать:**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            • Извинений за долгое молчание
            • Жалоб на жизнь или проблем
            • Сравнений «а помнишь, как раньше...»
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            💡 **Темы для разговора:**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            • Как дела? Что нового в жизни?
            • Чем сейчас увлекаетесь/занимаетесь?
            • Вспомнить общий приятный момент
            • Поделиться позитивной новостью о себе
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            📝 **Задание:**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            Напишите ваше начало разговора (1-2 предложения):
          MARKDOWN
        },
        'execution' => {
          title: "🚀 *Шаг 4: Время действовать!* ⏰",
          instruction: <<~MARKDOWN
            **Идеальное время для связи:**
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            📅 **Когда лучше звонить/писать:**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            🕒 **18:00-21:00** — после работы, но до сна
            🗓️ **Среда-пятница** — середина/конец недели
            🌤️ **Выходной день** — больше времени на общение
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            💡 **Советы для успешного общения:**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            🎯 Будьте искренними и позитивными
            👂 Больше слушайте, чем говорите
            😊 Улыбайтесь (даже в сообщениях это чувствуется!)
            ⏳ Не спешите — дайте время на ответ
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            📝 **Задание:**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            Когда закончите общение, напишите:
            "✅ Связался!"
            
            *Не обязательно ждать ответа сразу — главное сделать первый шаг.*
          MARKDOWN
        },
        'reflection_after' => {
          title: "💭 *Шаг 5: Рефлексия после общения* 🧘",
          instruction: <<~MARKDOWN
            **Как прошло общение?**
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            🤔 **Вопросы для анализа:**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            1. 🌟 Что было самым приятным в общении?
            2. 🎭 Какие эмоции вы испытали?
            3. 🔗 Чувствуется ли прежняя связь?
            4. 💡 Что узнали нового о человеке/себе?
            5. 📅 Хотите ли продолжить общение?
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            📝 **Задание:**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            Напишите 3-5 предложений о вашем опыте:
          MARKDOWN
        },
        'integration' => {
          title: "🔄 *Шаг 6: Социальная экосистема* 📅",
          instruction: <<~MARKDOWN
            **Как поддерживать связи регулярно?**
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            📅 **Ежемесячный ритуал:**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            📞 1 звонок старому другу
            💬 2 сообщения с новостями
            🎂 Поздравление с днем рождения
            📸 Отправка старой совместной фото
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            🗓️ **Квартальные цели:**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            👥 Встреча с 1-2 старыми друзьями
            ✉️ Написание 1 благодарственного письма
            🎪 Участие в общем мероприятии
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            💡 **Практики для ежедневного применения:**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            • Отмечайте в календаре важные даты друзей
            • Сохраняйте контакты с заметками о людях
            • Реагируйте на сторис/посты друзей
            • Делитесь тем, что напомнило о человеке
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            📝 **Задание:**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            Напишите, какую практику вы возьмете для поддержания связей:
          MARKDOWN
        },
        'completion' => {
          title: "🎊 *Практика восстановления связей завершена!* 🎊",
          instruction: <<~MARKDOWN
            **Вы только что:**
            
            1. 🗺️ Составили карту значимых людей
            2. 🎯 Выбрали формат и время общения
            3. 💬 Подготовили искреннее начало разговора
            4. 🚀 Сделали первый шаг к восстановлению
            5. 💭 Проанализировали опыт общения
            6. 🔄 Создали план регулярной практики
            
            ━━━━━━━━━━━━━━━━━━━━━━━━
            🏆 **Ваши достижения:**
            ━━━━━━━━━━━━━━━━━━━━━━━━
            • 🌉 Освоили алгоритм восстановления связей
            • 💬 Преодолели страх неловкости
            • 🤝 Укрепили социальную сеть
            • 🔄 Интегрировали практику в регулярную жизнь
            
            **Поздравляем!** Вы освоили навык, который:
            • 🧬 Улучшает структуру социальных центров мозга
            • 🤝 Повышает качество отношений
            • 😊 Увеличивает уровень счастья и удовлетворенности
            • 💪 Развивает психологическую устойчивость
          MARKDOWN
        }
      }.freeze
      
      # Категории трудностей в восстановлении связей
      RECONNECTION_CHALLENGES = [
        {
          name: "Страх отказа или неловкости",
          emoji: "😳",
          description: "Боюсь, что человек не захочет общаться",
          solution: "Помните: 95% людей рады, когда с ними связываются. Начните с простого сообщения."
        },
        {
          name: "Не знаю, о чем говорить",
          emoji: "🤔",
          description: "Кажется, что темы для разговора исчерпаны",
          solution: "Спросите о жизни сейчас, поделитесь воспоминанием или позитивной новостью."
        },
        {
          name: "Слишком много времени прошло",
          emoji: "⏳",
          description: "Прошло несколько лет, кажется уже поздно",
          solution: "Лучше поздно, чем никогда. Люди ценят, когда их вспоминают."
        },
        {
          name: "Нет времени для общения",
          emoji: "📅",
          description: "Слишком занят(а), чтобы поддерживать связи",
          solution: "Начните с малого — короткое сообщение занимает 2 минуты."
        }
      ].freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        store_day_data('current_step', 'intro')
        
        send_message(
          text: "Готовы построить мосты через время?",
          reply_markup: day_16_content_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise_explanation')
        clear_day_data
        
        send_message(text: DAY_STEPS['exercise_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['exercise_explanation'][:instruction], parse_mode: 'Markdown')
        
        # Начинаем первый шаг практики
        start_reconnection_step('reflection')
      end
      
      def start_reconnection_step(step_type)
        store_day_data('current_reconnection_step', step_type)
        @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_#{step_type}")
        
        step = RECONNECTION_STEPS[step_type]
        return unless step
        
        send_message(text: step[:title], parse_mode: 'Markdown')
        send_message(text: step[:instruction], parse_mode: 'Markdown')
        
        # Показываем подсказку
        send_message(
          text: "📝 *Введите ваш ответ:*",
          parse_mode: 'Markdown',
          reply_markup: day_16_input_markup
        )
      end
      
      def handle_reconnection_input(input_text)
        current_step = get_day_data('current_reconnection_step')
        return false unless current_step
        
        case current_step
        when 'reflection'
          return handle_reflection_input(input_text)
        when 'planning'
          return handle_planning_input(input_text)
        when 'preparation'
          return handle_preparation_input(input_text)
        when 'execution'
          return handle_execution_input(input_text)
        when 'reflection_after'
          return handle_reflection_after_input(input_text)
        when 'integration'
          return handle_integration_input(input_text)
        end
        
        false
      end
      
      def handle_reflection_input(input_text)
        return false if input_text.blank?
        
        names = input_text.split(/[,\.\n]/).map(&:strip).reject(&:empty?)
        
        if names.size >= 1
          store_day_data('people_to_reconnect', names)
          store_day_data('reflection_completed', true)
          
          send_message(
            text: "✅ *Карта связей составлена!* Сохранено #{names.size} имён.",
            parse_mode: 'Markdown'
          )
          
          # Переходим к планированию
          store_day_data('current_reconnection_step', 'planning')
          sleep(1)
          start_reconnection_step('planning')
          return true
        else
          send_message(
            text: "⚠️ Пожалуйста, напишите хотя бы 1 имя.",
            parse_mode: 'Markdown'
          )
          return false
        end
      end
      
      def handle_planning_input(input_text)
        return false if input_text.blank?
        
        match = input_text.match(/(.+)\s*-\s*(звонок|сообщение|письмо)/i)
        
        if match
          person = match[1].strip
          format = match[2].downcase
          
          store_day_data('chosen_person', person)
          store_day_data('communication_format', format)
          store_day_data('planning_completed', true)
          
          send_message(
            text: "✅ *Планирование завершено!*\n#{person} - #{format.capitalize}",
            parse_mode: 'Markdown'
          )
          
          # Переходим к подготовке
          store_day_data('current_reconnection_step', 'preparation')
          sleep(1)
          start_reconnection_step('preparation')
          return true
        else
          send_message(
            text: "⚠️ Пожалуйста, напишите в формате: Имя - формат (звонок/сообщение/письмо)",
            parse_mode: 'Markdown'
          )
          return false
        end
      end
      
      def handle_preparation_input(input_text)
        return false if input_text.blank?
        
        if input_text.split.size >= 1
          store_day_data('conversation_start', input_text)
          store_day_data('preparation_completed', true)
          
          send_message(
            text: "💬 *Начало разговора сохранено!* Хороший выбор слов.",
            parse_mode: 'Markdown'
          )
          
          # Переходим к исполнению
          store_day_data('current_reconnection_step', 'execution')
          sleep(1)
          start_reconnection_step('execution')
          return true
        else
          send_message(
            text: "⚠️ Пожалуйста, напишите хотя бы одно предложение.",
            parse_mode: 'Markdown'
          )
          return false
        end
      end
      
      def handle_execution_input(input_text)
        return false if input_text.blank?
        
        if input_text.downcase.include?('связался') || input_text.downcase.include?('готово') || input_text.include?('✅')
          store_day_data('execution_confirmed', true)
          store_day_data('execution_completed_at', Time.current)
          
          send_message(
            text: "🎉 *Отлично! Вы сделали первый шаг!*",
            parse_mode: 'Markdown'
          )
          
          # Переходим к рефлексии
          store_day_data('current_reconnection_step', 'reflection_after')
          sleep(1)
          start_reconnection_step('reflection_after')
          return true
        else
          send_message(
            text: "⏳ Когда закончите общение, напишите '✅ Связался!' или 'Готово'",
            parse_mode: 'Markdown'
          )
          return false
        end
      end
      
      def handle_reflection_after_input(input_text)
        return false if input_text.blank?
        
        if input_text.split.size >= 1
          store_day_data('reflection_after', input_text)
          store_day_data('reflection_after_completed', true)
          
          send_message(
            text: "💭 *Рефлексия сохранена!* Спасибо за ваши мысли.",
            parse_mode: 'Markdown'
          )
          
          # Переходим к интеграции
          store_day_data('current_reconnection_step', 'integration')
          sleep(1)
          start_reconnection_step('integration')
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
        
        store_day_data('integration_practice', input_text)
        store_day_data('integration_completed', true)
        
        # Все шаги выполнены
        show_completion_menu
        
        true
      end
      
      def show_completion_menu
        # Устанавливаем состояние, что практика завершена
        store_day_data('reconnection_completed', true)
        store_day_data('completion_time', Time.current)
        
        # Сохраняем практику
        save_reconnection_practice
        
        # Устанавливаем состояние отражения
        @user.set_self_help_step("day_16_reflection_done")
        
        # Показываем меню завершения
        send_message(
          text: "🌟 Практика восстановления связей завершена!\n\nВы можете:\n1. 🤝 Начать новую практику\n2. 🎯 Завершить День 16",
          reply_markup: day_16_completion_menu_markup
        )
      end
      
      def complete_reconnection_practice
        store_day_data('reconnection_completed', true)
        store_day_data('completion_time', Time.current)
        
        # Сохраняем практику
        save_reconnection_practice
        
        # Показываем меню завершения
        show_completion_menu
      end
      
      def start_new_practice
        log_info("Starting new reconnection practice for user #{@user.telegram_id}")
        
        # Очищаем данные предыдущей практики
        clear_day_data
        
        # Устанавливаем состояние
        @user.set_self_help_step("day_16_exercise_in_progress")
        store_day_data('current_step', 'exercise_explanation')
        
        # Начинаем упражнение
        deliver_exercise
        
        true
      end
      
      def show_reconnection_completion
        store_day_data('current_step', 'completion')
        
        completion_message = RECONNECTION_STEPS['completion'][:instruction]
        
        send_message(text: RECONNECTION_STEPS['completion'][:title], parse_mode: 'Markdown')
        send_message(text: completion_message, parse_mode: 'Markdown')
        
        sleep(2)
        
        # Показываем трудности
        send_message(
          text: "🤔 *С какими трудностями столкнулись в восстановлении связей?*",
          parse_mode: 'Markdown',
          reply_markup: day_16_challenges_markup
        )
      end
      
      def handle_challenge_selection(challenge_index)
        challenge = RECONNECTION_CHALLENGES[challenge_index.to_i]
        
        if challenge
          send_message(
            text: "#{challenge[:emoji]} **#{challenge[:name]}**\n\n#{challenge[:description]}\n\n💡 **Решение:** #{challenge[:solution]}",
            parse_mode: 'Markdown'
          )
        end
        
        @user.set_self_help_step("day_16_reflection_done")
        
        send_message(
          text: "🌟 Отлично! Вы завершили практику восстановления связей.\n\nХотите начать новую практику или завершить день?",
          reply_markup: day_16_completion_menu_markup
        )
      end
      
      def complete_exercise
        # Проверяем, завершена ли практика
        unless get_day_data('reconnection_completed') == true
          send_message(
            text: "⚠️ Сначала завершите практику восстановления связей.\n\nУбедитесь, что вы прошли все 6 шагов.",
            parse_mode: 'Markdown',
            reply_markup: day_16_content_markup
          )
          return
        end
        
        # Отмечаем день как завершенный
        @user.complete_day_program(DAY_NUMBER)
        @user.complete_self_help_day(DAY_NUMBER)
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
        
        completion_message = <<~MARKDOWN
          🎉 *День 16 завершен!* 🎉

          **Ваши достижения сегодня:**
          
          🌉 **Практика восстановления связей:**
          • 🗺️ Составлена карта значимых людей
          • 🎯 Выбран оптимальный формат общения
          • 💬 Подготовлено искреннее начало разговора
          • 🚀 Сделан первый шаг к восстановлению
          • 💭 Проведена глубокая рефлексия опыта
          • 🔄 Создан план регулярной практики
          
          📚 **Научный факт:**
          Регулярное поддержание социальных связей повышает субъективное благополучие на 25-35%, снижает риск депрессии на 30-40% и увеличивает продолжительность жизни на 15-20%.
          
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
        when 'start_day_16_content', 'start_day_16_from_proposal', 'start_reconnection_exercise'
          deliver_exercise
          
        when 'continue_day_16_content'
          current_step = get_day_data('current_step')
          handle_resume_from_step(current_step || 'intro')
          
        when 'day_16_skip_step'
          # Пропуск текущего шага
          current_step = get_day_data('current_reconnection_step')
          if current_step
            next_step = get_next_reconnection_step(current_step)
            if next_step
              send_message(text: "⚠️ Шаг пропущен. Переходим к следующему.")
              start_reconnection_step(next_step)
            else
              complete_reconnection_practice
            end
          end
          
        when 'day_16_restart_reconnection'
          deliver_exercise
          
        when 'day_16_exercise_completed', 'reconnection_exercise_completed'
          complete_reconnection_practice
          
        when /^day_16_challenge_(\d+)$/
          handle_challenge_selection($1)
          
        when 'day_16_no_challenges'
          @user.set_self_help_step("day_16_reflection_done")
          send_message(
            text: "🌟 Отлично! У вас получилась продуктивная практика!",
            reply_markup: day_16_completion_menu_markup
          )
          
        when 'day_16_complete_exercise'
          complete_exercise
          
        when 'day_16_show_practices'
          show_previous_practices
          
        when 'day_16_start_new_practice'
          start_new_practice
          
        when 'view_reconnection_history'
          show_previous_practices
          
        when 'reconnection_stats'
          show_reconnection_stats
          
        else
          log_warn("Unknown button callback: #{callback_data}")
          send_message(text: "Неизвестная команда.")
        end
      end
      
      # ===== ОБРАБОТКА ТЕКСТОВОГО ВВОДА =====
      
      def handle_text_input(input_text)
        log_info("Handling text input for day 16: #{input_text}")
        
        current_state = @user.self_help_state
        
        # Определяем, какой ввод ожидается
        case current_state
        when "day_16_waiting_for_reflection"
          return handle_reconnection_input(input_text)
          
        when "day_16_waiting_for_planning"
          return handle_reconnection_input(input_text)
          
        when "day_16_waiting_for_preparation"
          return handle_reconnection_input(input_text)
          
        when "day_16_waiting_for_execution"
          return handle_reconnection_input(input_text)
          
        when "day_16_waiting_for_reflection_after"
          return handle_reconnection_input(input_text)
          
        when "day_16_waiting_for_integration"
          return handle_reconnection_input(input_text)
          
        when "day_16_reconnection_completed", "day_16_reflection_done", "day_16_completed"
          send_message(
            text: "✅ Практика восстановления связей уже завершена. Вы можете:\n• 🤝 Начать новую практику\n• 🎯 Завершить день 16",
            reply_markup: day_16_completion_menu_markup
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
          show_reconnection_completion
        else
          deliver_exercise
        end
      end
      
      def show_intro_without_state
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "Готовы построить мосты через время?",
          reply_markup: day_16_content_markup
        )
      end
      
      def propose_next_day_with_restriction
        next_day = 17
        
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
            • 🤝 Практиковать восстановление других связей
            • 📊 Отслеживать влияние общения на ваше настроение
            • 🔄 Создавать свои собственные ритуалы поддержания связей
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
      
      # ===== ПОКАЗ ПРАКТИК =====
      
      def show_previous_practices
        practices = @user.reconnection_practices.recent.limit(10)
        
        if practices.empty?
          send_message(
            text: "🤝 *Ваши восстановленные связи:*\n\nПока нет сохраненных практик.\nПройдите упражнение дня 16, чтобы создать первую запись.",
            parse_mode: 'Markdown',
            reply_markup: day_16_content_markup
          )
          return
        end
        
        send_message(
          text: "🤝 *Ваши предыдущие практики восстановления связей:*",
          parse_mode: 'Markdown'
        )
        
        practices.each_with_index do |practice, index|
          practice_summary = <<~MARKDOWN
            *Практика ##{index + 1}*
            
            👤 **С кем:** #{practice.reconnected_person}
            📅 **Когда:** #{practice.entry_date.strftime('%d.%m.%Y')}
            📱 **Формат:** #{practice.communication_format.capitalize}
            💭 **Рефлексия:** #{practice.reflection_text.truncate(50)}
            ──────────────────────────────
          MARKDOWN
          
          send_message(text: practice_summary, parse_mode: 'Markdown')
        end
      end
      
      def show_reconnection_stats
        practices = @user.reconnection_practices
        
        if practices.empty?
          send_message(text: "📊 У вас пока нет данных для статистики.")
          return
        end
        
        total = practices.count
        calls = practices.by_format('звонок').count
        messages = practices.by_format('сообщение').count
        letters = practices.by_format('письмо').count
        
        stats_message = <<~MARKDOWN
          📊 *Статистика восстановленных связей:*
          
          📅 **Всего практик:** #{total}
          📞 **Звонков:** #{calls} (#{(calls.to_f/total*100).round}%)
          💬 **Сообщений:** #{messages} (#{(messages.to_f/total*100).round}%)
          ✉️ **Писем:** #{letters} (#{(letters.to_f/total*100).round}%)
          
          🎯 **Продолжайте восстанавливать связи!** 💪
        MARKDOWN
        
        send_message(text: stats_message, parse_mode: 'Markdown')
      end
      
      private
      
      def get_next_reconnection_step(current_step)
        steps_order = RECONNECTION_STEPS.keys
        current_index = steps_order.index(current_step)
        
        return steps_order[current_index + 1] if current_index && current_index < steps_order.length - 1
        nil
      end
      
      def save_reconnection_practice
        begin
          planned_acts = get_day_data('people_to_reconnect') || []
          reflection_text = get_day_data('reflection_after') || ''
          integration_practice = get_day_data('integration_practice') || ''
          chosen_person = get_day_data('chosen_person') || 'Не указано'
          communication_format = get_day_data('communication_format') || 'сообщение'
          conversation_start = get_day_data('conversation_start') || ''
          
          # Сохраняем в модель
          ReconnectionPractice.create!(
            user: @user,
            entry_date: Date.current,
            reconnected_person: chosen_person,
            communication_format: communication_format,
            conversation_start: conversation_start,
            reflection_text: reflection_text,
            integration_plan: integration_practice
          )
          
          log_info("Saved reconnection practice for user #{@user.telegram_id}")
          
          # Также сохраняем в self_help_data для совместимости
          store_day_data('reconnection_practice', {
            people_to_reconnect: planned_acts,
            reflection_text: reflection_text,
            integration_practice: integration_practice,
            chosen_person: chosen_person,
            communication_format: communication_format,
            conversation_start: conversation_start,
            completed_at: Time.current
          })
          
          true
        rescue => e
          log_error("Failed to save reconnection practice", e)
          
          # Фолбэк: сохраняем только в self_help_data
          store_day_data('reconnection_practice_saved_fallback', true)
          store_day_data('practice_completed_at', Time.current.to_s)
          
          false
        end
      end
      
      def clear_day_data
        # Очищаем данные предыдущей практики
        store_day_data('people_to_reconnect', nil)
        store_day_data('reflection_completed', nil)
        store_day_data('chosen_person', nil)
        store_day_data('communication_format', nil)
        store_day_data('planning_completed', nil)
        store_day_data('conversation_start', nil)
        store_day_data('preparation_completed', nil)
        store_day_data('execution_confirmed', nil)
        store_day_data('execution_completed_at', nil)
        store_day_data('reflection_after', nil)
        store_day_data('reflection_after_completed', nil)
        store_day_data('integration_practice', nil)
        store_day_data('integration_completed', nil)
        store_day_data('current_reconnection_step', nil)
        store_day_data('reconnection_completed', nil)
        store_day_data('completion_time', nil)
      end
      
      # Вспомогательные методы разметки
      def day_16_content_markup
        {
          inline_keyboard: [
            [
              { text: "🤝 Начать практику восстановления связей", callback_data: 'start_day_16_content' }
            ],
            [
              { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
            ]
          ]
        }.to_json
      end
      
      def day_16_input_markup
        {
          inline_keyboard: [
            [
              { text: "🔄 Начать заново", callback_data: 'day_16_restart_reconnection' }
            ]
          ]
        }.to_json
      end
      
      def day_16_challenges_markup
        {
          inline_keyboard: RECONNECTION_CHALLENGES.each_with_index.map do |challenge, index|
            [{ text: "#{challenge[:emoji]} #{challenge[:name]}", callback_data: "day_16_challenge_#{index}" }]
          end + [
            [{ text: "✅ Никаких трудностей", callback_data: 'day_16_no_challenges' }]
          ]
        }.to_json
      end
      
      def day_16_completion_menu_markup
        {
          inline_keyboard: [
            [
              { text: "🤝 Новая практика", callback_data: 'day_16_start_new_practice' },
              { text: "🎯 Завершить День 16", callback_data: 'day_16_complete_exercise' }
            ]
          ]
        }.to_json
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
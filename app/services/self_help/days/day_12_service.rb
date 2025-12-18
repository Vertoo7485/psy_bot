# app/services/self_help/days/day_12_service.rb
module SelfHelp
  module Days
    class Day12Service < DayBaseService
      include TelegramMarkupHelper
      # Константы
      DAY_NUMBER = 12
      SELF_COMPASSION_STEPS = {
        'difficulty' => {
          title: "🕊️ **Шаг 1: Признание трудности**",
          instruction: "**Что сейчас вызывает у вас дискомфорт или боль?**\n\nЭто может быть:\n• Физическое ощущение\n• Эмоциональное страдание\n• Стрессовая ситуация\n• Самокритичная мысль\n\n**Просто опишите это одним-двумя предложениями:**"
        },
        'humanity' => {
          title: "🤝 **Шаг 2: Общечеловеческий опыт**",
          instruction: "**Как эта трудность связывает вас с другими людьми?**\n\nВспомните, что:\n• Миллионы людей испытывают что-то подобное\n• Страдание — часть человеческого опыта\n• Вы не одиноки в своих переживаниях\n\n**Как это знание помогает вам чувствовать себя менее одиноким?**"
        },
        'kind_words' => {
          title: "💬 **Шаг 3: Добрые слова к себе**",
          instruction: "**Представьте, что ваш лучший друг переживает то же самое.**\n\nЧто бы вы сказали другу в этой ситуации?\n\nА теперь скажите эти же слова себе.\n\n**Напишите 2-3 добрых, поддерживающих фразы,** которые вы можете сказать себе прямо сейчас:"
        },
        'physical_comfort' => {
          title: "🤗 **Шаг 4: Физическое утешение**",
          instruction: "**Как вы можете физически утешить себя прямо сейчас?**\n\nНапример:\n• Положить руку на сердце\n• Обнять себя\n• Сделать глубокий вдох\n• Укрыться пледом\n\n**Опишите, что вы сделаете и какие ощущения это принесет:**"
        },
        'mantra' => {
          title: "✨ **Шаг 5: Мантра самосострадания**",
          instruction: "**Создайте свою мантру доброты к себе.**\n\nПовторите про себя:\n1. «Это момент страдания»\n2. «Страдание — часть жизни»\n3. «Пусть я буду добр(а) к себе»\n\n**А теперь создайте свою собственную фразу.**\nНапример: «Я принимаю себя таким(ой), какой(ая) я есть»."
        }
      }.freeze
      
      def deliver_intro
        message_text = <<~MARKDOWN
          🎯 *День 12: Доброта к себе* 🎯

          **Практика самосострадания**

          Самосострадание — это способность относиться к себе с той же добротой, пониманием и поддержкой, которую мы обычно предлагаем близким друзьям в трудные времена.

          **Три компонента самосострадания:**
          1. **Доброта к себе** — вместо самокритики
          2. **Общечеловечность** — понимание, что страдание — часть человеческого опыта
          3. **Осознанность** — балансированное осознание болезненных эмоций

          **Исследования показывают**, что самосострадание:
          • Снижает тревогу и депрессию
          • Повышает мотивацию
          • Улучшает отношения
          • Способствует личностному росту
        MARKDOWN
        
        send_message(text: message_text, parse_mode: 'Markdown')
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        
        send_message(
          text: "Готовы попрактиковать доброту к себе?",
          reply_markup: TelegramMarkupHelper.day_12_start_exercise_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        clear_day_data
        
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
      
      def complete_exercise
        # Сохраняем практику
        save_self_compassion_practice
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
        
        message = <<~MARKDOWN
          🌟 *Практика завершена!* 🌟

          Вы сделали важный шаг в развитии доброты к себе.

          **Почему это важно:**
          • Самокритика истощает энергию
          • Самосострадание дает силы для изменений
          • Доброта к себе — основа психического здоровья

          **Как практиковать регулярно:**
          • Каждое утро говорите себе доброе слово
          • В моменты ошибок вспоминайте: «Я делаю лучшее, что могу»
          • Относитесь к себе как к лучшему другу
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        # ИЗМЕНЕНИЕ: Добавляем предложение следующего дня
        propose_next_day
      rescue => e
        log_error("Failed to complete exercise", e)
        # Fallback: все равно предлагаем следующий день
        @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
        propose_next_day
      end
      
      def handle_self_compassion_input(input_text)
        current_step = get_day_data('current_step')
        
        return false if input_text.blank?
        
        case current_step
        when 'difficulty'
          store_day_data('difficulty', input_text)
          start_self_compassion_step('humanity')
          return true
          
        when 'humanity'
          store_day_data('humanity', input_text)
          start_self_compassion_step('kind_words')
          return true
          
        when 'kind_words'
          store_day_data('kind_words', input_text)
          start_self_compassion_step('physical_comfort')
          return true
          
        when 'physical_comfort'
          store_day_data('physical_comfort', input_text)
          start_self_compassion_step('mantra')
          return true
          
        when 'mantra'
          store_day_data('mantra', input_text)
          
          # Все шаги выполнены
          send_message(
            text: "✅ *Медитация завершена!*\n\nВы прошли все 5 шагов практики самосострадания.\n\nНажмите кнопку, чтобы завершить упражнение:",
            reply_markup: TelegramMarkupHelper.self_compassion_exercise_completed_markup
          )
          return true
        end
        
        false
      end
      
      def show_practices
        practices = @user.self_compassion_practices.recent.limit(5)
        
        if practices.empty?
          send_message(text: "У вас пока нет сохраненных практик самосострадания.")
          return
        end
        
        practices.each_with_index do |practice, index|
          message = <<~MARKDOWN
            📝 *Практика ##{index + 1}* (#{practice.entry_date.strftime('%d.%m.%Y')})

            💭 Трудность: #{practice.current_difficulty.truncate(50)}
            🤝 Общечеловеческое: #{practice.common_humanity.truncate(50)}
            💬 Добрые слова: #{practice.kind_words.truncate(50)}
            ✨ Мантра: #{practice.mantra.truncate(50)}
            ──────────────────────────────
          MARKDOWN
          
          send_message(text: message, parse_mode: 'Markdown')
        end
        
        send_message(
          text: "Всего практик: #{practices.count}",
          reply_markup: TelegramMarkupHelper.day_12_menu_markup
        )
      end
      
      def ask_for_input_again
        current_step = get_day_data('current_step')
        start_self_compassion_step(current_step) if current_step
      end
      
      private
      
      def start_self_compassion_step(step_type)
        store_day_data('current_step', step_type)
        
        step = SELF_COMPASSION_STEPS[step_type]
        return unless step
        
        send_message(text: step[:title], parse_mode: 'Markdown')
        send_message(text: step[:instruction])
      end
      
      def save_self_compassion_practice
        begin
          SelfCompassionPractice.create!(
            user: @user,
            entry_date: Date.current,
            current_difficulty: get_day_data('difficulty'),
            common_humanity: get_day_data('humanity'),
            kind_words: get_day_data('kind_words'),
            mantra: get_day_data('mantra')
          )
        rescue => e
          log_error("Failed to save self-compassion practice", e)
        end
      end
    end
  end
end
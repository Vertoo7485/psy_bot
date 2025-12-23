module SelfHelp
  module Days
    class Day17Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 17
      
      # Шаги письма самосострадания
      COMPASSION_STEPS = {
        'situation' => {
          title: "📝 Шаг 1: Опишите ситуацию",
          instruction: "Опишите ситуацию, в которой вы сейчас находитесь, как если бы описывали ее своему лучшему другу.\n\nЧто происходит? Как вы себя чувствуете?",
          button_text: "Продолжить к шагу 2 ➡️",
          callback_data: 'compassion_step_2'
        },
        'understanding' => {
          title: "🤗 Шаг 2: Проявите понимание",
          instruction: "Что бы вы сказали своему другу, чтобы показать понимание и сочувствие?\n\nНапомните себе, что:\n• Испытывать трудности — это нормально\n• Вы делаете все, что можете\n• Это временное состояние",
          button_text: "Продолжить к шагу 3 ➡️",
          callback_data: 'compassion_step_3'
        },
        'kindness' => {
          title: "💝 Шаг 3: Слова поддержки",
          instruction: "Какие добрые и поддерживающие слова вы бы сказали другу?\n\nНапример:\n• \"Ты справишься!\"\n• \"Я верю в тебя!\"\n• \"Ты уже прошел через многое\"",
          button_text: "Продолжить к шагу 4 ➡️",
          callback_data: 'compassion_step_4'
        },
        'advice' => {
          title: "🧠 Шаг 4: Мудрый совет",
          instruction: "Какой мудрый совет вы бы дали другу в этой ситуации?\n\nПодумайте:\n• Что действительно важно?\n• Что могло бы помочь?\n• Как посмотреть на ситуацию по-другому?",
          button_text: "Продолжить к шагу 5 ➡️",
          callback_data: 'compassion_step_5'
        },
        'closure' => {
          title: "✨ Шаг 5: Завершение письма",
          instruction: "Завершите письмо теплыми словами поддержки и ободрения.\n\nНапример:\n• \"Береги себя\"\n• \"Ты не одинок\"\n• \"Я всегда с тобой\"",
          button_text: "Завершить письмо ✅",
          callback_data: 'compassion_complete'
        }
      }.freeze
      
      # ===== ОСНОВНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        message_text = <<~MARKDOWN
          💝 День 17: Письмо самосострадания 💝

        Зачем писать письмо самому себе?

          Исследования показывают, что самосострадание:
          🧠 Снижает тревожность на 40%
          ❤️ Повышает самооценку и устойчивость
          🤝 Улучшает отношения с другими людьми
          🌱 Помогает восстанавливаться после неудач

          Мифы о самосострадании:
          ❌ "Это слабость"
          ❌ "Я буду лениться"
          ❌ "Не заслуживаю доброты"
          ❌ "Лучше быть строгим к себе"

          Правда:
          ✅ Самосострадание — это сила
          ✅ Помогает двигаться вперед
          ✅ Основа здоровой мотивации
          ✅ Право каждого человека
        MARKDOWN
        
        send_message(text: message_text, parse_mode: 'Markdown')
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        
        send_message(
          text: "Готовы написать письмо поддержки самому себе?",
          reply_markup: day_17_start_exercise_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        clear_day_data
        
        exercise_text = <<~MARKDOWN
          ✉️ Упражнение: Письмо себе от лучшего друга ✉️

          Инструкция:

          Представьте, что ваш лучший друг оказался в вашей ситуации. Что бы вы ему написали? Как поддержали бы?

          Мы пройдем через 5 шагов, чтобы создать полноценное письмо поддержки.

          Формат: Просто пишите от сердца. Это только для вас.
        MARKDOWN
        
        send_message(text: exercise_text, parse_mode: 'Markdown')
        
        # Начинаем первый шаг
        start_compassion_step('situation')
      end
      
      def complete_exercise
  # Сохраняем письмо
  save_compassion_letter
  
  @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
  
  message = <<~MARKDOWN
    🎉 *Письмо самосострадания завершено!* 🎉

    Что вы сделали сегодня:
    ✅ Признали свои трудности
    ✅ Проявили к себе понимание
    ✅ Нашли слова поддержки
    ✅ Дали мудрый совет
    ✅ Завершили с теплотой и заботой

    Как использовать эту практику дальше:
    📖 Перечитывайте письмо в трудные моменты
    ✍️ Пишите новые письма раз в неделю
    🗣️ Говорите с собой как с другом
    💭 Помните: вы достойны доброты

    «Самосострадание — это дать себе то, что нам нужно в трудный момент, а не то, что мы думаем, что заслуживаем.»
    — Кристин Нефф
  MARKDOWN
  
  send_message(text: message, parse_mode: 'Markdown')
  
  # ВАЖНО: Показываем меню для просмотра писем, а не сразу предлагаем следующий день
  show_day_17_menu
  propose_next_day
end

def show_day_17_menu
  menu_text = <<~MARKDOWN
    ✨ *День 17 завершен!* ✨

    Теперь у вас есть доступ к:
    📚 *Мои письма* - просмотр всех созданных писем самосострадания
    ✍️ *Новое письмо* - создание нового письма в любое время

    Вы можете перечитывать свои письма в трудные моменты или создавать новые, когда почувствуете необходимость.
  MARKDOWN
  
  send_message(
    text: menu_text,
    parse_mode: 'Markdown',
    reply_markup: day_17_menu_markup
  )
end

      
      def handle_compassion_input(input_text, step_type)
        # Сохраняем ввод для текущего шага
        store_day_data("#{step_type}_text", input_text)
        
        # Переходим к следующему шагу
        next_step = get_next_compassion_step(step_type)
        
        if next_step
          start_compassion_step(next_step)
        else
          # Все шаги выполнены
          show_compassion_summary
        end
        
        true
      end
      
      def handle_compassion_button(callback_data)
        case callback_data
        when 'compassion_step_2'
          # Переход ко второму шагу
          store_day_data('current_step', 'understanding')
          start_compassion_step('understanding')
        when 'compassion_step_3'
          store_day_data('current_step', 'kindness')
          start_compassion_step('kindness')
        when 'compassion_step_4'
          store_day_data('current_step', 'advice')
          start_compassion_step('advice')
        when 'compassion_step_5'
          store_day_data('current_step', 'closure')
          start_compassion_step('closure')
        when 'compassion_complete'
          # Завершение упражнения
          show_compassion_completion
        end
      end
      
      def ask_for_input_again
        current_step = get_day_data('current_step')
        start_compassion_step(current_step) if current_step
      end
      
      def show_previous_letters
  letters = @user.compassion_letters.order(created_at: :desc).limit(5)
  
  if letters.empty?
    send_message(
      text: "📭 У вас пока нет сохраненных писем самосострадания.\n\nНапишите первое письмо в упражнении дня 17!",
      reply_markup: day_17_menu_markup
    )
    return
  end
  
  message = "📚 Ваши письма самосострадания:\n\n"
  
  letters.each_with_index do |letter, index|
    date = letter.entry_date.strftime('%d.%m.%Y')
    preview = letter.situation_text.to_s.truncate(50)
    
    message += "#{index + 1}. 📅 #{date}\n"
    message += "   💭 #{preview}\n\n"
  end
  
  send_message(
    text: message,
    parse_mode: 'Markdown',
    reply_markup: compassion_letters_markup
  )
end

def compassion_letters_detailed_markup
  letters = @user.compassion_letters.order(created_at: :desc).limit(5)
  
  keyboard = letters.each_with_index.map do |letter, index|
    date = letter.entry_date.strftime('%d.%m')
    [{ text: "📖 #{date} - #{index + 1}", callback_data: "compassion_show_#{letter.id}" }]
  end
  
  keyboard << [{ text: "📅 Все даты", callback_data: 'compassion_all_dates' }]
  keyboard << [{ text: "✍️ Новое письмо", callback_data: 'start_day_17_exercise' }]
  keyboard << [{ text: "📋 Назад", callback_data: 'back_to_day_17_menu' }]
  
  { inline_keyboard: keyboard }.to_json
end
      
      private
      
      def start_compassion_step(step_type)
        store_day_data('current_step', step_type)
        
        step = COMPASSION_STEPS[step_type]
        return unless step
        
        # Отправляем заголовок и инструкцию
        send_message(text: step[:title], parse_mode: 'Markdown')
        send_message(text: step[:instruction])
        
        # Для шагов с кнопками показываем кнопку продолжения
        if step[:button_text]
          send_message(
            text: "Напишите ваш ответ выше, затем нажмите кнопку чтобы продолжить:",
            reply_markup: compassion_step_markup(step[:button_text], step[:callback_data])
          )
        end
      end
      
      def get_next_compassion_step(current_step)
        steps_order = COMPASSION_STEPS.keys
        current_index = steps_order.index(current_step)
        
        return steps_order[current_index + 1] if current_index && current_index < steps_order.length - 1
        nil
      end
      
      def show_compassion_summary
        # Собираем все части письма
        situation = get_day_data('situation_text') || 'Не указано'
        understanding = get_day_data('understanding_text') || 'Не указано'
        kindness = get_day_data('kindness_text') || 'Не указано'
        advice = get_day_data('advice_text') || 'Не указано'
        closure = get_day_data('closure_text') || 'Не указано'
        
        message = "📖 Ваше письмо самосострадания:\n\n"
        message += "1. Ситуация:\n#{situation}\n\n"
        message += "2. Понимание:\n#{understanding}\n\n"
        message += "3. Поддержка:\n#{kindness}\n\n"
        message += "4. Совет:\n#{advice}\n\n"
        message += "5. Завершение:\n#{closure}\n\n"
        message += "💝 Сохраните это письмо и перечитывайте в трудные моменты."
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Готовы сохранить ваше письмо и завершить упражнение?",
          reply_markup: day_17_exercise_completed_markup
        )
      end
      
      def show_compassion_completion
        # Сохраняем и показываем итог
        save_compassion_letter
        
        message = <<~MARKDOWN
          ✅ *Письмо сохранено!*

          Вы создали мощный инструмент самоподдержки.

          Советы по использованию:
          📱 Сделайте скриншот этого письма
          📅 Перечитывайте раз в неделю
          🗣️ Проговорите вслух слова поддержки
          💖 Помните: вы достойны такой же заботы, как и другие

          «Будьте добры к себе, когда учитесь летать.»
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Нажмите кнопку чтобы завершить упражнение дня 17:",
          reply_markup: day_17_exercise_completed_markup
        )
      end
      
      def save_compassion_letter
        begin
          # Создаем модель CompassionLetter если еще нет
          if defined?(CompassionLetter)
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
          else
            # Фолбэк: сохраняем в self_help_data
            store_day_data('compassion_letter_saved', true)
            store_day_data('letter_completed_at', Time.current.to_s)
          end
          
          log_info("Compassion letter saved successfully")
          
        rescue => e
          log_error("Failed to save compassion letter", e)
          store_day_data('compassion_letter_saved_fallback', true)
        end
      end
      
      def compile_full_letter
        parts = [
          get_day_data('situation_text'),
          get_day_data('understanding_text'),
          get_day_data('kindness_text'),
          get_day_data('advice_text'),
          get_day_data('closure_text')
        ].compact.join("\n\n")
      end
      
      # Методы разметки
      def day_17_start_exercise_markup
        {
          inline_keyboard: [
            [
              { text: "✍️ Начать упражнение", callback_data: 'start_day_17_exercise' }
            ]
          ]
        }.to_json
      end
      
      def compassion_step_markup(button_text, callback_data)
        {
          inline_keyboard: [
            [
              { text: button_text, callback_data: callback_data }
            ]
          ]
        }.to_json
      end
      
      def day_17_exercise_completed_markup
        {
          inline_keyboard: [
            [
              { text: "✅ Завершить упражнение", callback_data: 'day_17_exercise_completed' }
            ]
          ]
        }.to_json
      end
      
      def day_17_menu_markup
        {
          inline_keyboard: [
            [
              { text: "📚 Мои письма", callback_data: 'view_compassion_letters' }
            ],
            [
              { text: "🏠 Главное меню", callback_data: 'back_to_main_menu' }
            ]
          ]
        }.to_json
      end
      
      def compassion_letters_markup
  {
    inline_keyboard: [
      [
        { text: "📅 По дате", callback_data: 'compassion_by_date' },
        { text: "✍️ Новое письмо", callback_data: 'start_day_17_exercise' }
      ],
      [
        { text: "📋 Назад", callback_data: 'back_to_day_17_menu' }
      ]
    ]
  }.to_json
end
    end
  end
end
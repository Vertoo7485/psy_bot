# app/services/self_help/days/day_2_service.rb
module SelfHelp
  module Days
    class Day2Service < DayBaseService
      include TelegramMarkupHelper
      # Константы
      DAY_NUMBER = 2
      
      def deliver_intro
        message_text = <<~MARKDOWN
          🎯 *День 2: Связь с телом* 🎯

          **Научиться лучше чувствовать свое тело**

          Сегодня мы сосредоточимся на развитии самосознания через телесные ощущения.

          **Почему это важно:**
          • Тело часто сигнализирует о стрессе раньше, чем мы это осознаем
          • Телесное осознание помогает лучше понимать свои эмоции
          • Работа с телом может снизить физическое напряжение
        MARKDOWN
        
        send_message(text: message_text, parse_mode: 'Markdown')
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        
        send_message(
          text: "Готовы попробовать медитацию 'Сканирование тела'?",
          reply_markup: TelegramMarkupHelper.day_2_start_exercise_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        
        # Сначала отправляем текстовую инструкцию
        send_text_meditation_instruction
        
        # Затем пробуем отправить аудио
        audio_sent = send_audio_meditation
        
        # Если аудио не отправилось, это нормально - у пользователя уже есть текстовая инструкция
        
        send_message(
          text: "Когда закончите медитацию, нажмите кнопку:",
          reply_markup: TelegramMarkupHelper.day_2_exercise_completed_markup
        )
      end
      
      def complete_exercise
        @user.complete_self_help_day(DAY_NUMBER)
        
        message = <<~MARKDOWN
          🌟 *Прекрасно!* 🌟

          Вы завершили медитацию 'Сканирование тела'!

          **Что это дает:**
          • Лучшее понимание сигналов тела
          • Снижение мышечного напряжения
          • Улучшение связи между телом и разумом

          Эту технику можно использовать в любой момент, когда чувствуете напряжение.
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        # ДОБАВЛЯЕМ: Предлагаем следующий день
        propose_next_day
      end
      
      def resume_session
        current_state = @user.self_help_state
        
        case current_state
        when "day_2_intro"
          deliver_intro
        when "day_2_exercise_in_progress"
          deliver_exercise
        else
          super
        end
      end
      
      private
      
      def send_audio_meditation
        audio_file_path = Rails.root.join('public', 'assets', 'audio', 'body_scan.mp3')
        
        unless File.exist?(audio_file_path)
          log_error("Audio file not found: #{audio_file_path}")
          return false
        end
        
        begin
          @bot_service.bot.send_audio(
            chat_id: @chat_id,
            audio: File.open(audio_file_path),
            caption: "🧘 Медитация 'Сканирование тела' 🧘\n\nСледуйте инструкциям в аудио."
          )
          true
        rescue => e
          log_error("Failed to send audio", e)
          false
        end
      end
      
      def send_text_meditation_instruction
        text = <<~MARKDOWN
          🧘 *Медитация 'Сканирование тела' (текстовая версия)* 🧘

          **Инструкция:**

          1. Лягте или сядьте удобно
          2. Закройте глаза, сделайте 3 глубоких вдоха
          3. Внимательно пройдитесь по всем частям тела:

          • Начните с макушки головы
          • Лицо, шея, плечи
          • Руки, кисти, пальцы
          • Грудь, живот, спина
          • Ноги, стопы, пальцы ног

          4. В каждой части замечайте ощущения:
            - Тепло или холод?
            - Напряжение или расслабление?
            - Покалывание или тяжесть?

          5. Не пытайтесь что-то изменить
          6. Просто наблюдайте 10-15 минут

          Если ум отвлекается, мягко верните внимание к телу.
        MARKDOWN
        
        send_message(text: text, parse_mode: 'Markdown')
      end
    end
  end
end
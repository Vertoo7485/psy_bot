# app/services/self_help/days/day_base_service.rb
module SelfHelp
  module Days
    class DayBaseService
      include TelegramMarkupHelper
      # Константы
      DAY_NUMBER = nil # Должен быть переопределен в наследниках
      
      # Атрибуты
      attr_reader :bot_service, :user, :chat_id, :message_sender
      
      def initialize(bot_service, user, chat_id)
        @bot_service = bot_service
        @user = user
        @chat_id = chat_id
        @message_sender = Telegram::RobustMessageSender.new(bot_service, user, chat_id)
      end
      
      # Основной метод доставки контента дня
      def deliver_content
        save_current_progress
        deliver_intro
        
        # Если нужно сразу перейти к упражнению
        deliver_exercise if should_deliver_exercise_immediately?
      end
      
      # Метод для продолжения дня (после интро)
      def continue_content
        save_current_progress
        deliver_exercise
      end
      
      # Метод для завершения упражнения дня
      def handle_exercise_completion
        save_current_progress
        complete_exercise
        
        # Предлагаем следующий день
        propose_next_day
      end
      
      # Метод для завершения дня полностью
      def complete_day
        save_current_progress
        @user.complete_self_help_day(self.class::DAY_NUMBER)
        
        send_completion_message
        propose_next_day
      end
      
      # Метод для восстановления сессии
      def resume_session
        current_state = @user.self_help_state
        
        case current_state
        when "day_#{self.class::DAY_NUMBER}_intro"
          deliver_intro
        when "day_#{self.class::DAY_NUMBER}_exercise_in_progress"
          deliver_exercise
        when "day_#{self.class::DAY_NUMBER}_waiting_for_input"
          ask_for_input_again
        else
          deliver_content
        end
      end
      
      # Абстрактные методы (должны быть реализованы в наследниках)
      def deliver_intro
        raise NotImplementedError, "#{self.class} must implement #deliver_intro"
      end
      
      def deliver_exercise
        raise NotImplementedError, "#{self.class} must implement #deliver_exercise"
      end
      
      def complete_exercise
        # Этот метод должен быть переопределен в наследниках,
        # но мы добавляем базовую логику
        
        # Сохраняем прогресс
        save_current_progress
        
        # Устанавливаем состояние завершения
        @user.set_self_help_step("day_#{self.class::DAY_NUMBER}_completed")
        
        # Отправляем сообщение о завершении
        send_exercise_completion_message
        
        # Предлагаем следующий день
        propose_next_day
      end
      
      protected

      def send_exercise_completion_message
        message = "🎉 *Упражнение дня #{self.class::DAY_NUMBER} завершено!* 🎉\n\n" \
                  "Отличная работа! Вы освоили новую технику."
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def send_completion_message
        message = "🎉 *День #{self.class::DAY_NUMBER} завершен!* 🎉\n\n" \
                  "Отличная работа! Вы сделали важный шаг в своем развитии."
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def send_program_completion_message
        message = "🏆 *Поздравляем! Вы завершили всю программу самопомощи!* 🏆\n\n" \
                  "Вы прошли 13-дневный путь развития и освоили множество полезных техник.\n\n" \
                  "Продолжайте практиковать полученные навыки!"
        
        send_message(
          text: message,
          parse_mode: 'Markdown',
          reply_markup: TelegramMarkupHelper.final_program_completion_markup
        )
      end
      
      # Вспомогательные методы
      def save_current_progress
        # Сохраняем прогресс в сессию
        @user.active_session&.update_progress(
          day: self.class::DAY_NUMBER,
          state: @user.self_help_state,
          timestamp: Time.current
        )
      end
      
      def should_deliver_exercise_immediately?
        false # По умолчанию не сразу
      end
      
      def ask_for_input_again
        send_message(text: "Пожалуйста, продолжите ввод...")
      end
      
      def send_completion_message
        message = "🎉 *День #{self.class::DAY_NUMBER} завершен!* 🎉\n\n" \
                  "Отличная работа! Вы сделали важный шаг в своем развитии."
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def propose_next_day
        next_day = self.class::DAY_NUMBER + 1
        
        if next_day <= 28
          @user.set_self_help_step("awaiting_day_#{next_day}_start")
          
          message = "Готовы начать День #{next_day}?"
          markup = TelegramMarkupHelper.send("day_#{next_day}_start_proposal_markup")
          
          send_message(text: message, reply_markup: markup)
        else
          # Программа завершена
          send_program_completion_message
        end
      end
      
      def send_program_completion_message
        message = "🏆 *Поздравляем! Вы завершили всю программу самопомощи!* 🏆\n\n" \
                  "Вы прошли 13-дневный путь развития и освоили множество полезных техник.\n\n" \
                  "Продолжайте практиковать полученные навыки!"
        
        send_message(
          text: message,
          parse_mode: 'Markdown',
          reply_markup: TelegramMarkupHelper.final_program_completion_markup
        )
      end
      
      def send_message(text:, reply_markup: nil, parse_mode: nil, save_progress: true)
        success = @message_sender.send_with_retry(
          text: text,
          reply_markup: reply_markup,
          parse_mode: parse_mode
        )
        
        save_current_progress if success && save_progress
        success
      end
      
      # Получить данные дня из self_help_program_data
      def get_day_data(key)
        @user.get_self_help_data("day_#{self.class::DAY_NUMBER}_#{key}")
      end
      
      # Сохранить данные дня в self_help_program_data
      def store_day_data(key, value)
        @user.store_self_help_data("day_#{self.class::DAY_NUMBER}_#{key}", value)
      end
      
      # Очистить данные дня
      def clear_day_data
        ['thought', 'probability', 'facts_pro', 'facts_con', 'reframe', 
         'gratitude', 'reflection', 'task', 'steps', 'feelings'].each do |key|
          store_day_data(key, nil)
        end
      end
      
      # Логирование
      def log_info(message)
        Rails.logger.info "[#{self.class}] #{message} - User: #{@user.telegram_id}"
      end
      
      def log_error(message, error = nil)
        Rails.logger.error "[#{self.class}] #{message} - User: #{@user.telegram_id}"
        Rails.logger.error error.message if error
      end
    end
  end
end
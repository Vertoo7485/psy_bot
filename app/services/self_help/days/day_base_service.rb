# app/services/self_help/days/day_base_service.rb

module SelfHelp
  module Days
    class DayBaseService
      include TelegramMarkupHelper
      
      DAY_NUMBER = nil # Должен быть переопределен в наследниках
      
      # Атрибуты
      attr_reader :bot_service, :user, :chat_id, :message_sender
      
      def initialize(bot_service, user, chat_id)
        @bot_service = bot_service
        @user = user
        @chat_id = chat_id
        @message_sender = Telegram::RobustMessageSender.new(bot_service, user, chat_id)
        @access_control = AccessControlService.new(user)
      end
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      # Основной метод доставки контента дня
      def deliver_content
        # Проверяем доступ перед началом дня
        check_access!
        
        save_current_progress
        deliver_intro
        
        # Если нужно сразу перейти к упражнению
        deliver_exercise if should_deliver_exercise_immediately?
        
      rescue AccessControlService::AccessDeniedError,
             AccessControlService::TrialExpiredError,
             AccessControlService::SubscriptionExpiredError,
             AccessControlService::NotPremiumError => e
        
        handle_access_error(e)
        false
      end
      
      # Метод для продолжения дня (после интро)
      def continue_content
        check_access!
        save_current_progress
        deliver_exercise
        
      rescue AccessControlService::AccessDeniedError,
             AccessControlService::TrialExpiredError,
             AccessControlService::SubscriptionExpiredError,
             AccessControlService::NotPremiumError => e
        
        handle_access_error(e)
        false
      end
      
      # Метод для завершения упражнения дня
      def handle_exercise_completion
        check_access!
        save_current_progress
        complete_exercise
        
        # Предлагаем следующий день
        propose_next_day
        
      rescue AccessControlService::AccessDeniedError,
             AccessControlService::TrialExpiredError,
             AccessControlService::SubscriptionExpiredError,
             AccessControlService::NotPremiumError => e
        
        handle_access_error(e)
        false
      end
      
      # Метод для завершения дня полностью
      def complete_day
        check_access!
        save_current_progress
        @user.complete_self_help_day(self.class::DAY_NUMBER)
        
        send_completion_message
        propose_next_day
        
      rescue AccessControlService::AccessDeniedError,
             AccessControlService::TrialExpiredError,
             AccessControlService::SubscriptionExpiredError,
             AccessControlService::NotPremiumError => e
        
        handle_access_error(e)
        false
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
      
      # ===== ОСНОВНЫЕ ПУБЛИЧНЫЕ ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ =====
      # Эти методы должны быть ПУБЛИЧНЫМИ, чтобы их можно было вызывать из обработчиков
      
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
      
      # ===== ЗАЩИЩЕННЫЕ МЕТОДЫ (protected) =====
      # Эти методы доступны только внутри класса и его наследников
      
      protected

      def check_access!
        @access_control.check_self_help_access!
      end
      
      def handle_access_error(error)
        log_error("Access denied for user #{@user.id}: #{error.class}")
        
        case error
        when AccessControlService::NotPremiumError
          send_not_premium_message(error.message)
        when AccessControlService::TrialExpiredError
          send_trial_expired_message(error.message)
        when AccessControlService::SubscriptionExpiredError
          send_subscription_expired_message(error.message)
        when AccessControlService::AccessDeniedError
          send_access_denied_message(error.message)
        else
          send_generic_access_error(error.message)
        end
      end

      def send_not_premium_message(message)
  text = "🔒 *Доступ к программе самопомощи*\n\n" \
         "#{message}\n\n" \
         "Ваш текущий уровень доступа: *#{@user.access_info}*\n\n" \
         "Для получения премиум доступа:\n" \
         "1. Обратитесь к администратору @your_admin_username\n" \
         "2. Укажите ваш Telegram (@#{@user.username || 'username'})\n" \
         "3. После оплаты вы получите доступ на 30 дней\n\n" \
         "Пробный период: 3 дня бесплатно для новых пользователей."
  
  send_access_message(text)
end

# Сообщение об истёкшем trial
def send_trial_expired_message(message)
  text = "⏰ *Пробный период завершен*\n\n" \
         "#{message}\n\n" \
         "Вы успешно опробовали программу самопомощи!\n\n" \
         "Чтобы продолжить, приобретите подписку:\n" \
         "1. Обратитесь к администратору @your_admin_username\n" \
         "2. Укажите ваш Telegram (@#{@user.username || 'username'})\n" \
         "3. После оплаты получите доступ на 30 дней\n\n" \
         "💰 Стоимость: XXX руб. / 30 дней"
  
  send_access_message(text)
end

# Сообщение об истёкшей подписке
def send_subscription_expired_message(message)
  text = "📅 *Подписка истекла*\n\n" \
         "#{message}\n\n" \
         "Спасибо, что были с нами!\n\n" \
         "Для продления подписки:\n" \
         "1. Обратитесь к администратору @your_admin_username\n" \
         "2. Укажите ваш Telegram (@#{@user.username || 'username'})\n" \
         "3. После оплаты доступ будет продлён\n\n" \
         "Ваш прогресс сохранён и будет доступен после активации."
  
  send_access_message(text)
end

# Общее сообщение об ошибке доступа
def send_access_denied_message(message)
  text = "❌ *Доступ ограничен*\n\n" \
         "#{message}\n\n" \
         "Обратитесь к администратору @your_admin_username для помощи."
  
  send_access_message(text)
end

# Общее сообщение об ошибке
def send_generic_access_error(message)
  text = "⚠️ *Ошибка доступа*\n\n" \
         "#{message}\n\n" \
         "Обратитесь к администратору @your_admin_username."
  
  send_access_message(text)
end

# Отправка сообщения с кнопками
def send_access_message(text)
  markup = {
    inline_keyboard: [
      [
        { text: "📋 Тесты", callback_data: 'show_test_categories' },
        { text: "📔 Дневник", callback_data: 'start_emotion_diary' }
      ],
      [
        { text: "ℹ️ О программе", callback_data: 'self_help_info' },
        { text: "👑 Админ", callback_data: 'contact_admin' }
      ],
      [
        { text: "🏠 Главное меню", callback_data: 'back_to_main_menu' }
      ]
    ]
  }.to_json
  
  send_message(
    text: text,
    parse_mode: 'Markdown',
    reply_markup: markup,
    save_progress: false
  )
end

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
      
      def propose_next_day
        next_day = self.class::DAY_NUMBER + 1
        
        if next_day <= 28
          @user.set_self_help_step("awaiting_day_#{next_day}_start")
          
          message = "Готовы начать День #{next_day}?"
          
          begin
            # Пробуем получить разметку
            markup_method = "day_#{next_day}_start_proposal_markup"
            if TelegramMarkupHelper.respond_to?(markup_method)
              markup = TelegramMarkupHelper.send(markup_method)
            else
              # Запасной вариант
              markup = {
                inline_keyboard: [
                  [{ text: "✅ Начать День #{next_day}", callback_data: "start_day_#{next_day}_from_proposal" }]
                ]
              }.to_json
            end
          rescue => e
            log_error("Failed to get markup for day #{next_day}", e)
            markup = {
              inline_keyboard: [
                [{ text: "✅ Начать День #{next_day}", callback_data: "start_day_#{next_day}_from_proposal" }]
              ]
            }.to_json
          end
          
          send_message(text: message, reply_markup: markup)
        else
          # Программа завершена
          send_program_completion_message
        end
      end
      
      # ===== ПРИВАТНЫЕ МЕТОДЫ (private) =====
      # Эти методы доступны только внутри самого класса
      
      private
      
      # Здесь могут быть приватные вспомогательные методы
      # которые не должны быть доступны даже наследникам
    end
  end
end
# app/services/telegram/context_handlers/self_help_context_handler.rb
module Telegram
  module ContextHandlers
    class SelfHelpContextHandler < BaseContextHandler
      # Карта обработчиков состояний
      STATE_HANDLERS = {
        'day_3_waiting_for_gratitude' => :handle_gratitude_input,
        'day_7_waiting_for_reflection' => :handle_reflection_input,
        'day_9_waiting_for_thought' => :handle_day_9_thought_input,
        'day_9_waiting_for_probability' => :handle_day_9_probability_input,
        'day_9_waiting_for_facts_pro' => :handle_day_9_facts_pro_input,
        'day_9_waiting_for_facts_con' => :handle_day_9_facts_con_input,
        'day_9_waiting_for_reframe' => :handle_day_9_reframe_input,
        'day_11_exercise_in_progress' => :handle_grounding_input,
        'day_12_exercise_in_progress' => :handle_self_compassion_input,
        'day_13_exercise_in_progress' => :handle_procrastination_input
      }.freeze
      
      def process
        current_state = @user.self_help_state
        handler_method = STATE_HANDLERS[current_state]
        
        if handler_method
          send(handler_method)
        else
          log_debug("No handler for state: #{current_state}")
          false
        end
      end
      
      private
      
      # Обработка благодарностей (День 3)
      def handle_gratitude_input
        return false if @text.blank?
        
        begin
          GratitudeEntry.create!(
            user: @user,
            entry_date: Date.current,
            entry_text: @text
          )
          
          @user.set_self_help_step('day_3_entry_saved')
          
          send_message(
            text: "✅ Запись сохранена! Вы можете добавить еще или завершить день.",
            reply_markup: TelegramMarkupHelper.day_3_menu_markup
          )
          
          true
        rescue => e
          log_error("Failed to save gratitude entry", e)
          send_message(text: "Ошибка при сохранении. Попробуйте еще раз.")
          false
        end
      end
      
      # Обработка рефлексии (День 7)
      def handle_reflection_input
        return false if @text.blank?
        
        begin
          ReflectionEntry.create!(
            user: @user,
            entry_date: Date.current,
            entry_text: @text
          )
          
          @user.set_self_help_step('day_7_completed')
          
          send_message(
            text: "💭 Спасибо за вашу рефлексию! Неделя завершена.",
            reply_markup: TelegramMarkupHelper.complete_program_markup
          )
          
          true
        rescue => e
          log_error("Failed to save reflection entry", e)
          send_message(text: "Ошибка при сохранении. Попробуйте еще раз.")
          false
        end
      end
      
      # Обработка тревожной мысли (День 9 - Шаг 1)
      def handle_day_9_thought_input
        return false if @text.blank?
        
        # Проверка на минимальную длину
        if @text.strip.length < 3
          send_message(text: "Мысль должна содержать хотя бы 3 символа. Попробуйте описать подробнее.")
          return false
        end
        
        @user.store_self_help_data('day_9_thought', @text)
        @user.set_self_help_step('day_9_waiting_for_probability')
        
        send_message(text: "Спасибо. Теперь оцените вероятность этой мысли от 1 до 10:")
        
        true
      end
      
      # Обработка вероятности мысли (День 9 - Шаг 2)
      def handle_day_9_probability_input
        probability = @text.to_i
        
        unless (1..10).include?(probability)
          send_message(text: "Пожалуйста, введите число от 1 до 10:")
          return false
        end
        
        @user.store_self_help_data('day_9_probability', probability)
        @user.set_self_help_step('day_9_waiting_for_facts_pro')
        
        send_message(text: "Какие факты подтверждают эту мысль?")
        
        true
      end
      
      # Обработка подтверждающих фактов (День 9 - Шаг 3)
      def handle_day_9_facts_pro_input
        return false if @text.blank?
        
        @user.store_self_help_data('day_9_facts_pro', @text)
        @user.set_self_help_step('day_9_waiting_for_facts_con')
        
        send_message(text: "Какие факты опровергают эту мысль?")
        
        true
      end
      
      # Обработка опровергающих фактов (День 9 - Шаг 4)
      def handle_day_9_facts_con_input
        return false if @text.blank?
        
        @user.store_self_help_data('day_9_facts_con', @text)
        @user.set_self_help_step('day_9_waiting_for_reframe')
        
        send_message(text: "Как можно переформулировать мысль более реалистично?")
        
        true
      end
      
      # Обработка переформулировки (День 9 - Шаг 5)
      def handle_day_9_reframe_input
        return false if @text.blank?
        
        @user.store_self_help_data('day_9_reframe', @text)
        
        # Все шаги выполнены
        send_message(
          text: "✅ Все данные собраны! Нажмите кнопку, чтобы завершить анализ:",
          reply_markup: TelegramMarkupHelper.day_9_back_to_menu_markup
        )
        
        true
      end
      
      # Обработка ввода для техники заземления (День 11)
      def handle_grounding_input
        # Используем фасад для обработки ввода
        facade = SelfHelp::Facade::SelfHelpFacade.new(@bot, @user, @chat_id)
        facade.handle_day_input(@text, @user.self_help_state)
      end
      
      # Обработка ввода для самосострадания (День 12)
      def handle_self_compassion_input
        # Используем фасад для обработки ввода
        facade = SelfHelp::Facade::SelfHelpFacade.new(@bot, @user, @chat_id)
        facade.handle_day_input(@text, @user.self_help_state)
      end
      
      # Обработка ввода для прокрастинации (День 13)
      def handle_procrastination_input
        # Используем фасад для обработки ввода
        facade = SelfHelp::Facade::SelfHelpFacade.new(@bot, @user, @chat_id)
        facade.handle_day_input(@text, @user.self_help_state)
      end
    end
  end
end
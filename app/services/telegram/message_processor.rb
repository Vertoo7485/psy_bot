# app/services/telegram/message_processor.rb
module Telegram
  class MessageProcessor
    include TelegramMarkupHelper # Для генерации клавиатур

    def initialize(bot, user, message_data)
      @bot = bot
      @user = user
      @message_data = message_data
      @chat_id = message_data.dig(:chat, :id)
      @text = message_data.dig(:text).to_s.strip
    end

    def process
      # Первым делом проверяем, не является ли сообщение ответом в рамках какого-то сценария.
      # Это должно иметь приоритет над обычными командами.
      if handle_contextual_input(@text)
        # Если сообщение было обработано в контексте, завершаем работу.
        return
      end

      # Если не контекстный ввод, обрабатываем как команду.
      case @text
      when '/start'
        handle_start_command
      when '/help'
        handle_help_command
      else
        handle_unknown_command
      end
    end

    private

    # Обрабатывает текстовый ввод, который является частью какого-то сценария (например, программы самопомощи).
    # Возвращает true, если ввод был обработан, false - иначе.
    def handle_contextual_input(text)
      @user.active_session&.touch_activity
      # 1. Проверяем, ждем ли мы ввод для дневника благодарности (День 3)
      if @user.get_self_help_step == 'day_3_waiting_for_gratitude'
        # Передаем текст в SelfHelpService для обработки.
        return SelfHelpService.new(@bot, @user, @chat_id).handle_gratitude_input(text)
      end

      # 2. Проверяем, ждем ли мы рефлексию (День 7)
      if @user.get_self_help_step == 'day_7_waiting_for_reflection'
        # Передаем текст в SelfHelpService для обработки.
        return SelfHelpService.new(@bot, @user, @chat_id).handle_reflection_input(text)
      end

      # 3. Проверяем, ждем ли мы ответ для дневника эмоций
      if @user.current_diary_step.present?
        # Используем EmotionDiaryService для обработки ответа.
        return EmotionDiaryService.new(@bot, @user, @chat_id).handle_answer(text)
      end

      # 4. День 9: Работа с тревожной мыслью
      case @user.get_self_help_step
      when 'day_9_waiting_for_thought'
        return SelfHelpService.new(@bot, @user, @chat_id).handle_day_9_thought_input(text)
      when 'day_9_waiting_for_probability'
        return SelfHelpService.new(@bot, @user, @chat_id).handle_day_9_probability_input(text)
      when 'day_9_waiting_for_facts_pro'
        return SelfHelpService.new(@bot, @user, @chat_id).handle_day_9_facts_pro_input(text)
      when 'day_9_waiting_for_facts_con'
        return SelfHelpService.new(@bot, @user, @chat_id).handle_day_9_facts_con_input(text)
      when 'day_9_waiting_for_reframe'
        return SelfHelpService.new(@bot, @user, @chat_id).handle_day_9_reframe_input(text)
      end

      # Если ввод не относится ни к одному из активных сценариев.
        false
      end

    # Обработка команды /start
    def handle_start_command
  # ОЧИСТКА: При старте очищаем возможные некорректные данные дня 9
  ['day_9_thought', 'day_9_probability', 'day_9_facts_pro', 'day_9_facts_con', 'day_9_reframe'].each do |key|
    @user.store_self_help_data(key, nil) if @user.get_self_help_data(key).present?
  end
  
  # Сбрасываем шаг программы
  @user.set_self_help_step(nil) if @user.get_self_help_step&.start_with?('day_9')
  
  # Проверяем, есть ли активная сессия для восстановления
  if @user.active_session
    # Используем правильный метод отправки сообщения
    @bot.send_message(
      chat_id: @chat_id,
      text: "Найдена незавершенная сессия. Хотите продолжить с того места, где остановились?",
      reply_markup: {
        inline_keyboard: [
          [{ text: 'Да, продолжить', callback_data: 'resume_session' }],
          [{ text: 'Нет, начать заново', callback_data: 'start_fresh' }]
        ]
      }.to_json
    )
  else
    send_main_menu("Привет! Выберите действие:")
  end
end

    # Обработка команды /help
    def handle_help_command
      @bot.send_message(chat_id: @chat_id, text: "Я умею показывать список тестов, вести дневник эмоций и помогать вам в программе самопомощи. Используйте кнопки для навигации.")
    end

    # Обработка неизвестных команд
    def handle_unknown_command
      @bot.send_message(chat_id: @chat_id, text: "Я не понимаю эту команду. Напишите /help или используйте кнопки.")
    end

    # Вспомогательный метод для отправки главного меню
    def send_main_menu(text)
      @bot.send_message(chat_id: @chat_id, text: text, reply_markup: TelegramMarkupHelper.main_menu_markup)
    rescue Telegram::Bot::Error => e
      Rails.logger.error "Failed to send main menu to user #{@user.telegram_id}: #{e.message}"
    end
  end
end

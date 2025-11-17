
# app/controllers/telegram_webhooks_controller.rb
require 'telegram/bot'
require 'json'
require 'faraday/multipart'

class TelegramWebhooksController < ApplicationController
  include TelegramMarkupHelper
  before_action :set_bot

  def message
    if params[:message]
      user = User.find_or_create_from_telegram_message(params[:message][:from])
      Telegram::MessageProcessor.new(@bot, user, params[:message]).process
    elsif params[:callback_query]
      user = User.find_by(telegram_id: params[:callback_query][:from][:id])
      # Проверяем, есть ли пользователь, чтобы избежать ошибок
      return render plain: 'OK' unless user

      case params[:callback_query][:data]
      when 'start_self_help_program'
        handle_start_self_help_program(user)
      when 'start_self_help_program_tests'
        handle_start_self_help_program_tests(user)
      when 'help' # Предполагается, что 'help' обрабатывается здесь, если не через MessageProcessor
        Telegram::CallbackQueryProcessor.new(@bot, user, params[:callback_query]).process
      when 'show_test_categories'
        Telegram::CallbackQueryProcessor.new(@bot, user, params[:callback_query]).process
      when 'start_emotion_diary'
        Telegram::CallbackQueryProcessor.new(@bot, user, params[:callback_query]).process
      when 'new_emotion_diary_entry'
        Telegram::CallbackQueryProcessor.new(@bot, user, params[:callback_query]).process
      when 'show_emotion_diary_entries'
        Telegram::CallbackQueryProcessor.new(@bot, user, params[:callback_query]).process
      when 'back_to_main_menu'
        Telegram::CallbackQueryProcessor.new(@bot, user, params[:callback_query]).process
      when 'prepare_anxiety_test', 'prepare_depression_test', 'prepare_eq_test', 'prepare_luscher_test'
        Telegram::CallbackQueryProcessor.new(@bot, user, params[:callback_query]).process
      when /^start_(anxiety|depression|eq|luscher)_test$/
        Telegram::CallbackQueryProcessor.new(@bot, user, params[:callback_query]).process
      when 'start_luscher_test'
        Telegram::CallbackQueryProcessor.new(@bot, user, params[:callback_query]).process
      when 'show_luscher_interpretation'
        Telegram::CallbackQueryProcessor.new(@bot, user, params[:callback_query]).process
      when /^answer_(\d+)_(\d+)_(\d+)$/
        Telegram::CallbackQueryProcessor.new(@bot, user, params[:callback_query]).process
      when /^luscher_choose_(.+)$/
        Telegram::CallbackQueryProcessor.new(@bot, user, params[:callback_query]).process
      # Новые обработчики для программы самопомощи
      when 'yes'
        handle_yes_response(user)
      when 'no'
        handle_no_response(user)
      when 'complete_day_7' # <--- ЭТОТ ОБРАБОТЧИК УЖЕ ДОЛЖЕН БЫТЬ В CallbackQueryProcessor
        Telegram::CallbackQueryProcessor.new(@bot, user, params[:callback_query]).process
      when 'start_day_8_content', 'day_8_confirm_exercise', 'day_8_decline_exercise',
           'day_8_stopped_thought_first_try', 'day_8_ready_for_distraction',
           /^day_8_distraction_(music|video|friend|exercise|book)$/,
           'day_8_exercise_completed', 'complete_program_final' # <--- Добавляем все новые callback_data
        Telegram::CallbackQueryProcessor.new(@bot, user, params[:callback_query]).process
      else
        # Передаем управление CallbackQueryProcessor для остальных callback_data
        Telegram::CallbackQueryProcessor.new(@bot, user, params[:callback_query]).process
      end
    end

    render plain: 'OK'
  end

  private

  def set_bot
    @bot = Telegram::Bot::Client.new(ENV['TELEGRAM_BOT_TOKEN']) do |faraday|
     faraday.request :multipart # Для отправки файлов
     faraday.request :url_encoded # Для других параметров
     faraday.adapter Faraday.default_adapter # Используем стандартный адаптер
   end
  end

  # Новый метод для старта программы самопомощи
  def handle_start_self_help_program(user)
    # Перед запуском новой программы, убедимся, что предыдущая завершена или сброшена
    user.clear_self_help_program if user.get_self_help_step.present?

    user.set_self_help_step('ready_for_tests')
    message_text = "Привет! Я твой бот для самопомощи, тут ты найдешь много полезной информации.\n" \
                   "Сейчас я попрошу тебя пройти несколько тестов, чтобы мы могли начать совместную работу! Спасибо, что присоединился. Все полностью анонимно и останется между нами."
    @bot.send_message(chat_id: user.telegram_id, text: message_text, reply_markup: self_help_intro_markup)
  end

  # Обработка нажатия "Начать программу" (после вводного сообщения)
  def handle_start_self_help_program_tests(user)
    user.set_self_help_step('day_1_intro')
    message_text = "Привет! Начнем наше путешествие к улучшению самочувствия. Сегодня предлагаю пройти короткий тест на депрессию и тревожность. Это поможет нам лучше понять твое состояние. Ты готов?"
    @bot.send_message(chat_id: user.telegram_id, text: message_text, reply_markup: yes_no_markup)
  end

  # Обработка ответа "Да" на вопрос о готовности к тестам
  def handle_yes_response(user)
    current_step = user.get_self_help_step
    if current_step == 'day_1_intro'
      user.set_self_help_step('taking_tests') # Переходим в состояние прохождения тестов
      # Начинаем тест на депрессию
      @bot.send_message(chat_id: user.telegram_id, text: "Отлично! Сначала пройдем тест на депрессию.")
      # Здесь мы запускаем тест депрессии. Для этого нужно будет немного модифицировать QuizRunner или создать отдельный метод.
      # Пока предположим, что `QuizRunner` может быть вызван с `test_type: 'depression'` и он вернет callback_data для продолжения.
      # В идеале, `QuizRunner` должен работать как отдельный сервис, который управляет всем процессом прохождения теста.
      # Чтобы не усложнять, будем использовать уже существующий механизм, но нужно будет убедиться, что он корректно работает
      # с `test_result_id` и возвращает callback_data для следующего шага.

      # Для простоты, отправим сообщение и будем ждать callback_query от завершения теста.
      # В более сложном сценарии, QuizRunner должен был бы вернуть callback_data, который бы здесь обрабатывался.
      # Здесь мы предполагаем, что после прохождения теста Депрессии, будет отправлен callback_query, который мы как-то перехватим
      # и затем запустим тест Тревожности.

      # ИЗМЕНЕНИЕ: Вместо того, чтобы запускать тест напрямую и ждать callback_query,
      # мы можем просто отправить сообщение и кнопкой перейти к запуску теста.
      # Это упростит логику.
      @bot.send_message(chat_id: user.telegram_id, text: "Запускаю тест на депрессию...")
      # Это вызовет Telegram::CallbackQueryProcessor#prepare_depression_test, который в свою очередь вызовет QuizRunner#start_quiz
      # Но нам нужно, чтобы после прохождения теста депрессии, запустился тест тревожности.
      # Это требует более сложной оркестровки.

      # Оптимальный подход: создать отдельный метод или сервис для запуска цепочки тестов.
      # Давайте создадим `SelfHelpService`

      SelfHelpService.new(@bot, user, user.telegram_id).start_tests_sequence
    else
      @bot.send_message(chat_id: user.telegram_id, text: "Похоже, вы уже начали программу. Нажмите /start, чтобы вернуться в главное меню.")
    end
  end

  # Обработка ответа "Нет"
  def handle_no_response(user)
      if user.get_self_help_step == 'day_1_intro'
        @bot.send_message(chat_id: user.telegram_id, text: "Хорошо, мы можем начать в любой другой момент. Просто нажмите кнопку '⭐️ Программа самопомощи ⭐️' в главном меню.", reply_markup: main_menu_markup) # <-- Исправлено
        user.clear_self_help_program # Сбрасываем прогресс, если пользователь отказывается
      else
        @bot.send_message(chat_id: user.telegram_id, text: "Пожалуйста, вернитесь в главное меню, нажав /start.")
      end
    end
end
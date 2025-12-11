require 'telegram/bot'
# app/services/telegram_markup_helper.rb
module TelegramMarkupHelper
  extend self
  
      def main_menu_markup
        {
          inline_keyboard: [
            [{ text: 'Список тестов', callback_data: 'show_test_categories' }],
            [{ text: 'Дневник эмоций', callback_data: 'start_emotion_diary' }],
            [{ text: '⭐️ Программа самопомощи ⭐️', callback_data: 'start_self_help_program' }], # <-- Новая кнопка
            [{ text: 'Помощь', callback_data: 'help' }]
          ]
        }.to_json
      end

      def luscher_test_completed_markup
      {
        inline_keyboard: [
          [{ text: "Показать интерпретацию", callback_data: "show_luscher_interpretation" }],
          [{ text: "⬅️ Назад в главное меню", callback_data: "back_to_main_menu" }]
        ]
      }.to_json
    end

      def back_to_main_menu_markup
        {
          inline_keyboard: [
            [{ text: 'Вернуться в главное меню', callback_data: 'back_to_main_menu' }]
          ]
        }.to_json
      end

  def test_categories_markup
    test_buttons = []
    Test.all.each do |test|
      current_test_type = test.test_type.try(:to_sym) || :standard
      case current_test_type
      when :standard
        case test.name
        when "Тест Тревожности"
          test_buttons << [{ text: test.name, callback_data: 'prepare_anxiety_test' }]
        when "Тест Депрессии (PHQ-9)"
          test_buttons << [{ text: test.name, callback_data: 'prepare_depression_test' }]
        when "Тест EQ (Эмоциональный Интеллект)"
          test_buttons << [{ text: test.name, callback_data: 'prepare_eq_test' }]
        end
      when :luscher
        test_buttons << [{ text: test.name, callback_data: 'prepare_luscher_test' }]
      end
    end
    test_buttons << [{ text: 'Назад', callback_data: 'back_to_main_menu' }]
        { inline_keyboard: test_buttons }.to_json
      end

      def luscher_start_markup
        { inline_keyboard: [[{ text: 'Начать тест', callback_data: 'start_luscher_test' }]] }.to_json
      end

      def luscher_interpretation_markup
        { inline_keyboard: [[{ text: 'Показать интерпретацию', callback_data: 'show_luscher_interpretation' }]] }.to_json
      end

      def emotion_diary_menu_markup
        {
          inline_keyboard: [
            [{ text: 'Новая запись', callback_data: 'new_emotion_diary_entry' }],
            [{ text: 'Мои записи', callback_data: 'show_emotion_diary_entries' }],
            [{ text: 'Назад', callback_data: 'back_to_main_menu' }]
          ]
        }.to_json
      end

  def self_help_intro_markup
        {
          inline_keyboard: [
            [{ text: 'Начать программу', callback_data: 'start_self_help_program_tests' }]
          ]
        }.to_json
      end

      def yes_no_markup(callback_data_yes: 'yes', callback_data_no: 'no')
        markup = {
          inline_keyboard: [
            [{ text: "Да", callback_data: callback_data_yes }],
            [{ text: "Нет", callback_data: callback_data_no }]
          ]
        }.to_json
      end

      # Разметка для возобновления программы
      def self.resume_program_markup
        {
          inline_keyboard: [
            [{ text: 'Продолжить программу', callback_data: 'start_self_help_program_tests' }], # Используем существующий callback, но SelfHelpService будет обрабатывать его иначе
            [{ text: 'Вернуться в главное меню', callback_data: 'back_to_main_menu' }]
          ]
        }.to_json
      end

      def day_1_content_markup
        markup = {
          inline_keyboard: [
            [{ text: "Начать первый день", callback_data: 'start_day_1_content' }],
            [{ text: "Вернуться в главное меню", callback_data: 'back_to_main_menu' }]
          ]
        }.to_json
      end

      def day_1_continue_markup
        # Это разметка для кнопок, которые появляются ВНУТРИ контента дня 1
        markup = {
          inline_keyboard: [
            [{ text: "Продолжить изучение дня 1", callback_data: 'continue_day_1_content' }],
            [{ text: "Вернуться в главное меню", callback_data: 'back_to_main_menu' }]
          ]
        }.to_json
      end

      def day_1_exercise_completed_markup
    # Создаем две кнопки: "Продолжить" (переход к следующему шагу) и "Назад" (возврат к меню)
    # Полагаем, что 'continue_day_2_content' - это callback_data для продолжения программы.
    # Полагаем, что 'main_menu' - это callback_data для возврата в главное меню.
    markup = {
      inline_keyboard: [
        [
          { text: "Завершить первый день", callback_data: "day_1_exercise_completed" }, # Название callback_data может отличаться, проверь свои обработчики
          { text: "Вернуться в меню", callback_data: "main_menu" } # Название callback_data может отличаться
        ]
      ]
    }.to_json
  end

  def self.day_2_start_proposal_markup
    { inline_keyboard: [[{ text: 'Начать День 2', callback_data: 'start_day_2_from_proposal' }]] }
  end

  def day_2_start_exercise_markup
    {
      inline_keyboard: [
        [{ text: 'Начать медитацию', callback_data: 'start_day_2_exercise_audio' }] # <-- ИЗМЕНЕНО: теперь ведет на запуск аудио
      ]
    }.to_json
  end

  # ПЕРЕИМЕНОВАННАЯ разметка: Кнопка для подтверждения завершения упражнения Дня 2
  def day_2_exercise_completed_markup # <-- ИЗМЕНЕНО: переименовано
    {
      inline_keyboard: [
        [{ text: 'Я завершил(а) упражнение', callback_data: 'day_2_exercise_completed' }] # <-- callback_data остается прежним, потому что оно для завершения
      ]
    }.to_json
  end

  def day_3_start_proposal_markup
    { inline_keyboard: [[{ text: 'Начать День 3', callback_data: 'start_day_3_from_proposal' }]] }
  end

      def day_3_menu_markup
        {
          inline_keyboard: [
            [{ text: 'Ввести благодарности', callback_data: 'day_3_enter_gratitude' }],
            [{ text: 'Посмотреть мои записи', callback_data: 'show_gratitude_entries' }],
            [{ text: 'Завершить День 3', callback_data: 'complete_day_3' }]
          ]
        }.to_json
      end

  def day_4_start_proposal_markup
    { inline_keyboard: [[{ text: 'Начать День 4', callback_data: 'start_day_4_from_proposal' }]] }
  end

  # Markup для вопроса "Готовы к упражнению Дня 4?"
  def day_4_exercise_consent_markup
    {
      inline_keyboard: [
        [{ text: "Да, готов(а)!", callback_data: 'start_day_4_exercise' }],
        [{ text: "Нет, позже", callback_data: 'back_to_main_menu' }]
      ]
    }.to_json
  end
  
  # Markup для завершения упражнения Дня 4
  def day_4_exercise_completed_markup
    {
      inline_keyboard: [
        [{ text: "Я выполнил(а) упражнение", callback_data: 'day_4_exercise_completed' }]
      ]
    }.to_json
  end

  def day_5_start_proposal_markup
    { inline_keyboard: [[{ text: 'Начать День 5', callback_data: 'start_day_5_from_proposal' }]] }
  end

  def start_day_5_exercise_markup
    {
      inline_keyboard: [
        [{ text: 'Начать упражнение', callback_data: 'start_day_5_exercise' }]
      ]
    }.to_json
  end

  # Разметка для подтверждения завершения упражнения Дня 5
  def day_5_exercise_completed_markup
    {
      inline_keyboard: [
        [{ text: "Я выполнил(а) упражнение", callback_data: 'day_5_exercise_completed' }]
      ]
    }.to_json
  end


  def day_6_start_proposal_markup
    { inline_keyboard: [[{ text: 'Начать День 6', callback_data: 'start_day_6_from_proposal' }]] }
  end

  def day_6_start_exercise_markup
    {
      inline_keyboard: [
        [{ text: "Я отдохнул и готов продолжить", callback_data: 'day_6_exercise_completed' }]
      ]
    }.to_json
  end

  def day_6_exercise_completed_markup
    {
      inline_keyboard: [
        [{ text: "Продолжить", callback_data: 'day_6_exercise_completed' }]
      ]
    }.to_json
  end


  def day_7_start_proposal_markup
    { inline_keyboard: [[{ text: 'Начать День 7', callback_data: 'start_day_7_from_proposal' }]] }
  end

  def complete_program_markup
    {
      inline_keyboard: [
        [{ text: "Завершить неделю", callback_data: 'complete_day_7' }] # <-- Изменено название кнопки и callback
      ]
    }.to_json
  end

  def self.day_8_start_proposal_markup
    { inline_keyboard: [[{ text: 'Начать День 8', callback_data: 'start_day_8_from_proposal' }]] }
  end

  # Markup для согласия/отказа начать упражнение дня 8
  def day_8_consent_markup
    {
      inline_keyboard: [
        [{ text: "Да, готов(а)!", callback_data: 'day_8_confirm_exercise' }],
        [{ text: "Нет, позже", callback_data: 'day_8_decline_exercise' }]
      ]
    }.to_json
  end

  # Markup после первого "СТОП!"
  def day_8_stopped_thought_first_try_markup
    {
      inline_keyboard: [
        [{ text: "Я попробовал(а) остановить мысль", callback_data: 'day_8_stopped_thought_first_try' }]
      ]
    }.to_json
  end

  # Markup после второго "СТОП!"
  def day_8_ready_for_distraction_markup
    {
      inline_keyboard: [
        [{ text: "Я готов(а) переключиться", callback_data: 'day_8_ready_for_distraction' }]
      ]
    }.to_json
  end

  # Markup для выбора отвлечения
  def day_8_distraction_options_markup
    {
      inline_keyboard: [
        [{ text: "Послушать музыку", callback_data: 'day_8_distraction_music' }],
        [{ text: "Посмотреть видео", callback_data: 'day_8_distraction_video' }],
        [{ text: "Поговорить с другом", callback_data: 'day_8_distraction_friend' }],
        [{ text: "Сделать упражнения", callback_data: 'day_8_distraction_exercise' }],
        [{ text: "Почитать книгу", callback_data: 'day_8_distraction_book' }]
      ]
    }.to_json
  end

  # Markup для завершения упражнения Дня 8
  def day_8_exercise_completed_markup
    {
      inline_keyboard: [
        [{ text: "Я выполнил(а) упражнение", callback_data: 'day_8_exercise_completed' }]
      ]
    }.to_json
  end

  def day_9_start_proposal_markup
  { inline_keyboard: [[{ text: 'Начать День 9: Работа с тревожной мыслью', callback_data: 'start_day_9_from_proposal' }]] }.to_json
  end

  def day_9_menu_markup
    {
      inline_keyboard: [
        [{ text: 'Ввести тревожную мысль', callback_data: 'day_9_enter_thought' }],
        [{ text: 'Посмотреть текущую работу (если есть)', callback_data: 'day_9_show_current' }],
        [{ text: 'Завершить День 9', callback_data: 'complete_day_9' }],
        [{ text: 'Вернуться в главное меню', callback_data: 'back_to_main_menu' }]
      ]
    }.to_json
  end

  def day_9_back_to_menu_markup
    { inline_keyboard: [[{ text: 'Завершить День 9', callback_data: 'complete_day_9' }]]}.to_json
  end

  # Markup для завершения программы (после Дня 8)
  def final_program_completion_markup
    {
      inline_keyboard: [
        [{ text: 'Начать программу заново', callback_data: 'restart_self_help_program' }],
        [{ text: "Вернуться в главное меню", callback_data: 'back_to_main_menu' }]
      ]
    }.to_json
  end
end

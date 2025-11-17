# app/services/telegram_markup_helper.rb
module TelegramMarkupHelper
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
            [{ text: "Завершить День 1", callback_data: 'complete_day_1' }],
            [{ text: "Вернуться в главное меню", callback_data: 'back_to_main_menu' }]
          ]
        }.to_json
      end

      def day_2_intro_markup
    {
      inline_keyboard: [
        [{ text: "Начать День 2", callback_data: 'start_day_2_content' }]
      ]
    }.to_json
  end

  def day_2_continue_markup
    {
      inline_keyboard: [
        [{ text: "Продолжить изучение дня 2", callback_data: 'continue_day_2_content' }],
        [{ text: "Завершить День 2", callback_data: 'complete_day_2' }]
      ]
    }.to_json
  end

      def day_2_exercise_markup
        {
          inline_keyboard: [
            [{ text: 'Прослушал(а) аудио', callback_data: 'day_2_exercise_completed' }]
          ]
        }.to_json
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

      def day_4_intro_markup
    {
      inline_keyboard: [
        [{ text: "Начать День 4", callback_data: 'start_day_4_content' }]
      ]
    }.to_json
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

  # Markup для перехода ко Дню 5
  def day_5_intro_markup
    {
      inline_keyboard: [
        [{ text: "Начать День 5", callback_data: 'start_day_5_content' }]
      ]
    }.to_json
  end

  # Markup для перехода ко Дню 6
  def day_6_intro_markup
    {
      inline_keyboard: [
        [{ text: "Начать День 6", callback_data: 'start_day_6_content' }]
      ]
    }.to_json
  end

  # Markup для перехода ко Дню 7
  def day_7_intro_markup
    {
      inline_keyboard: [
        [{ text: "Начать День 7", callback_data: 'start_day_7_content' }]
      ]
    }.to_json
  end
  def complete_program_markup
    {
      inline_keyboard: [
        [{ text: "Завершить неделю", callback_data: 'complete_day_7' }] # <-- Изменено название кнопки и callback
      ]
    }.to_json
  end

  # Markup для перехода ко Дню 8 (после завершения Дня 7)
  def day_8_intro_markup
    {
      inline_keyboard: [
        [{ text: "Начать День 8", callback_data: 'start_day_8_content' }]
      ]
    }.to_json
  end

  def day_8_intro_markup
    {
      inline_keyboard: [
        [{ text: "Начать День 8", callback_data: 'start_day_8_content' }]
      ]
    }.to_json
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

  # Markup для завершения программы (после Дня 8)
  def final_program_completion_markup
    {
      inline_keyboard: [
        [{ text: "Вернуться в главное меню", callback_data: 'back_to_main_menu' }]
      ]
    }.to_json
  end
end

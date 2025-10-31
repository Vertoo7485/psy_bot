# app/services/telegram_markup_helper.rb
module TelegramMarkupHelper
  def main_menu_markup
    {
      inline_keyboard: [
        [{ text: 'Список тестов', callback_data: 'show_test_categories' }],
        [{ text: 'Дневник эмоций', callback_data: 'start_emotion_diary' }],
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
end

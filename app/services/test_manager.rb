# app/services/test_manager.rb
class TestManager
  include TelegramMarkupHelper

  # Словарь с сообщениями для подготовки к тестам
  TEST_PREP_MESSAGES = {
    anxiety: "Тест Тревожности поможет вам оценить уровень тревожности. Ответьте на вопросы, чтобы получить результат. Примерное время прохождения: 5-10 минут.",
    depression: "Тест Депрессии (PHQ-9) - это короткий опросник, который поможет оценить ваше состояние и выявить возможные признаки депрессии. Примерное время прохождения: 3-5 минут.",
    eq: "Тест EQ (Эмоциональный Интеллект) поможет вам оценить вашу способность понимать и управлять своими эмоциями, а также понимать эмоции других людей. Примерное время прохождения: 7-12 минут.",
    luscher: "8-ми цветовой тест Люшера поможет вам оценить ваше психоэмоциональное состояние. Тест состоит из двух этапов. Между этапами необходимо сделать небольшой перерыв. Готовы начать?"
  }.freeze

  def initialize(bot_service, user, chat_id)
    @bot_service = bot_service # Теперь это экземпляр Telegram::TelegramBotService
    @bot = bot_service.bot     # И это правильно получает Telegram::Bot::Client
    @user = user
    @chat_id = chat_id
  end

  # Показывает список категорий тестов.
  def show_categories
    # `test_categories_markup` уже использует `Test.all`, так что здесь ничего не меняем.
    message_text = "Выберите тест, который вы хотите пройти:"
    @bot_service.send_message(chat_id: @chat_id, text: message_text, reply_markup: TelegramMarkupHelper.test_categories_markup)
  end

  # Подготавливает к началу конкретного теста.
  def prepare_test(test_type)
    message = TEST_PREP_MESSAGES[test_type.to_sym]
    return @bot_service.send_message(chat_id: @chat_id, text: "Извините, информация по этому тесту не найдена.") unless message

    # Определяем callback_data для запуска теста.
    # Это должен быть callback_data, который вызовет соответствующий метод в CallbackQueryProcessor.
    callback_data = "start_#{test_type}_test"
    kb = { inline_keyboard: [[{ text: 'Начать тест', callback_data: callback_data }]] }.to_json
    @bot_service.send_message(chat_id: @chat_id, text: message, reply_markup: kb)
  end
end

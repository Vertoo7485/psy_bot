    # app/services/test_manager.rb
    class TestManager
      include TelegramMarkupHelper # Для генерации клавиатур

      TEST_PREP_MESSAGES = {
        anxiety: "Тест Тревожности поможет вам оценить уровень тревожности. Ответьте на вопросы, чтобы получить результат. Примерное время прохождения: 5-10 минут.",
        depression: "Тест Депрессии (PHQ-9) - это короткий опросник, который поможет оценить ваше состояние и выявить возможные признаки депрессии. Примерное время прохождения: 3-5 минут.",
        eq: "Тест EQ (Эмоциональный Интеллект) поможет вам оценить вашу способность понимать и управлять своими эмоциями, а также понимать эмоции других людей. Примерное время прохождения: 7-12 минут.",
        luscher: "8-ми цветовой тест Люшера поможет вам оценить ваше психоэмоциональное состояние. Тест состоит из двух этапов. Между этапами необходимо сделать небольшой перерыв. Готовы начать?"
      }.freeze

      def initialize(bot, user, chat_id)
        @bot = bot
        @user = user
        @chat_id = chat_id
      end

      def show_categories(message_id)
        @bot.send_message(chat_id: @chat_id, text: "Выберите тест:", reply_markup: test_categories_markup)
      end

      def prepare_test(test_type)
        message = TEST_PREP_MESSAGES[test_type.to_sym]
        callback_data = "start_#{test_type}_test" # Это callback_data, который вызовет QuizRunner#start_quiz
        kb = { inline_keyboard: [[{ text: 'Начать тест', callback_data: callback_data }]] }.to_json
        @bot.send_message(chat_id: @chat_id, text: message, reply_markup: kb)
      end
    end

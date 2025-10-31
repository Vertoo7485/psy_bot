# app/services/quiz_runner.rb
class QuizRunner
  def initialize(bot, user, chat_id)
    @bot = bot
    @user = user
    @chat_id = chat_id
  end

  def start_quiz(test_type)
    test = Test.find_by_type_name(test_type) # Используем новый метод модели Test
    return @bot.send_message(chat_id: @chat_id, text: "Тест не найден.") unless test

    # Удаляем все незаконченные тесты этого типа
    TestResult.where(user: @user, test: test, completed_at: nil).destroy_all

    test_result = TestResult.new(user: @user, test: test)

    if test_result.save
      question = test.questions.first
      send_question(question, test_result.id)
    else
      Rails.logger.error "Ошибка при создании TestResult: #{test_result.errors.full_messages.join(', ')}"
      @bot.send_message(chat_id: @chat_id, text: "Произошла ошибка при создании теста. Попробуйте позже.")
    end
  end

  def process_answer(question_id, answer_option_id, test_result_id, message_id)
    question = Question.find(question_id)
    answer_option = AnswerOption.find(answer_option_id)
    test_result = TestResult.find(test_result_id)

    Answer.create(test_result: test_result, question: question, answer_option: answer_option)

    next_question = test_result.test.questions.where("id > ? AND test_id = ?", question_id, test_result.test.id).order(:id).first

    if next_question
      edit_question(message_id, next_question, test_result.id)
    else
      TestResultCalculator.new(@bot, @chat_id, test_result).calculate_and_send_results
    end
  end

  private

  def send_question(question, test_result_id)
    inline_keyboard = question.answer_options.map do |answer_option|
      callback_data = "answer_#{question.id}_#{answer_option.id}_#{test_result_id}"
      [{ text: answer_option.text, callback_data: callback_data }]
    end
    markup = { inline_keyboard: inline_keyboard }.to_json

    @bot.send_message(chat_id: @chat_id, text: question.text, reply_markup: markup)
  end

  def edit_question(message_id, question, test_result_id)
    inline_keyboard = question.answer_options.map do |answer_option|
      [{ text: answer_option.text, callback_data: "answer_#{question.id}_#{answer_option.id}_#{test_result_id}" }]
    end
    markup = { inline_keyboard: inline_keyboard }.to_json

    begin
      @bot.edit_message_text(chat_id: @chat_id, message_id: message_id, text: question.text, reply_markup: markup)
    rescue Telegram::Bot::Exceptions::ResponseError => e
      Rails.logger.error "Ошибка при редактировании сообщения (QuizRunner): #{e.message}. Отправляем новое сообщение."
      @bot.send_message(chat_id: @chat_id, text: question.text, reply_markup: markup)
    end
  end
end

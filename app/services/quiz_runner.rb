# app/services/quiz_runner.rb
class QuizRunner
  def initialize(bot, user, chat_id)
    @bot = bot
    @user = user
    @chat_id = chat_id
  end

  def start_quiz(test_type)
    test = Test.find_by_type_name(test_type)
    return @bot.send_message(chat_id: @chat_id, text: "Тест не найден.") unless test

    TestResult.where(user: @user, test: test, completed_at: nil).destroy_all
    test_result = TestResult.new(user: @user, test: test)

    if test_result.save
      @user.store_self_help_data('current_test_result_id', test_result.id) # Сохраняем ID текущего теста
      @user.store_self_help_data('current_test_type', test_type) # Сохраняем тип теста

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

    # ... (проверки)

    # Если тест уже завершен, игнорируем ответ (предотвращение повторных ответов)
    return if test_result.completed_at.present?

    Answer.create(test_result: test_result, question: question, answer_option: answer_option)

    next_question = test_result.test.questions.where("id > ? AND test_id = ?", question_id, test_result.test.id).order(:id).first

    if next_question
          edit_message_or_send_new(message_id, next_question, test_result.id)
        else # Тест завершен
      test_result.update(completed_at: Time.now)
      completed_test_type = test_result.test.test_type

      case completed_test_type
      when 'standard' # Для тестов депрессии, тревожности, EQ
        # TestResultCalculator теперь сам отправляет результаты и следующую кнопку
        TestResultCalculator.new(@bot, @chat_id, test_result).calculate_and_send_results
      when 'luscher'
        # Для Люшера пока оставим старую логику, если она работает
        # Если LuscherTestService сам отправляет результаты и кнопку, то этот блок тоже нужно упростить
        # Если LuscherTestService ТОЛЬКО считает, но НЕ отправляет, то здесь нужно отправлять сообщение:
        # @bot.send_message(chat_id: @chat_id, text: "Тест Люшера завершен! (Результаты обрабатываются...) ", reply_markup: { inline_keyboard: [[{ text: "Продолжаем...", callback_data: 'test_completed_luscher' }]] }.to_json)
      end

      # Очищаем временные данные о тесте у пользователя
      @user.store_self_help_data('current_test_result_id', nil)
      @user.store_self_help_data('current_test_type', nil)
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

  def edit_message_or_send_new(message_id, question, test_result_id)
    inline_keyboard = question.answer_options.map do |option|
      { text: option.text, callback_data: "answer_#{question.id}_#{option.id}_#{test_result_id}" }
    end
    markup = { inline_keyboard: [inline_keyboard] }.to_json

    begin
      @bot.edit_message_text(
        chat_id: @chat_id,
        message_id: message_id,
        text: question.text,
        reply_markup: markup,
        parse_mode: 'HTML'
      )
    # --- ИСПРАВЛЕНИЕ ЗДЕСЬ ---
    # Вместо Telegram::Bot::Exceptions, используем Telegram::Bot::Error (общий класс для ошибок API)
    # или более специфичные Telegram::Bot::Forbidden / Telegram::Bot::NotFound
    rescue Telegram::Bot::Error => e
      # Логируем ошибку для отладки
      Rails.logger.warn "Failed to edit message #{message_id}: #{e.message}. Sending new message instead."
      # Отправляем новое сообщение, если не удалось отредактировать старое
      @bot.send_message(
        chat_id: @chat_id,
        text: question.text,
        reply_markup: markup,
        parse_mode: 'HTML'
      )
    end
  end
end

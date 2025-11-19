# app/services/quiz_runner.rb
class QuizRunner
  def initialize(bot_service, user, chat_id)
    @bot_service = bot_service
    @bot = bot_service.bot # ЭТУ СТРОКУ НЕ УДАЛЯТЬ! QuizRunner её использует.
    @user = user
    @chat_id = chat_id
  end

  def start_quiz(test_type)
    test = Test.find_by_type_name(test_type)
    return @bot_service.send_message(chat_id: @chat_id, text: "Тест '#{test_type}' не найден.") unless test

    # Удаляем все незаконченные тесты с этим же типом теста.
    # Это предотвратит запуск нового теста, если предыдущий не был завершен.
    TestResult.where(user: @user, test: test, completed_at: nil).destroy_all

    test_result = TestResult.new(user: @user, test: test)

    if test_result.save
      @user.store_self_help_data('current_test_result_id', test_result.id) # Сохраняем ID текущего теста
      @user.store_self_help_data('current_test_type', test_type) # Сохраняем тип теста

      question = test.questions.order(:id).first # Берем первый вопрос
      send_question(question, test_result.id)
    else
      Rails.logger.error "QuizRunner: Failed to create TestResult for user #{@user.telegram_id}, test #{test.name}: #{test_result.errors.full_messages.join(', ')}"
      @bot_service.send_message(chat_id: @chat_id, text: "Произошла ошибка при создании теста. Попробуйте позже.")
    end
  end

  def process_answer(question_id, answer_option_id, test_result_id)
    question = Question.find_by(id: question_id)
    answer_option = AnswerOption.find_by(id: answer_option_id)
    test_result = TestResult.find_by(id: test_result_id)

    unless question && answer_option && test_result
      Rails.logger.error "QuizRunner: Invalid data for processing answer. QID: #{question_id}, AOID: #{answer_option_id}, TRID: #{test_result_id}"
      @bot_service.send_message(chat_id: @chat_id, text: "Произошла ошибка при обработке вашего ответа. Попробуйте ответить снова.")
      return
    end

    # Если тест уже завершен, игнорируем ответ (предотвращение повторных ответов)
    return if test_result.completed_at.present?

    # Создаем запись ответа.
    Answer.create!(test_result: test_result, question: question, answer_option: answer_option)

    # Находим следующий вопрос.
    next_question = test_result.test.questions.where("id > ? AND test_id = ?", question_id, test_result.test.id).order(:id).first

    if next_question
      # Отправляем следующий вопрос.
      send_question(next_question, test_result.id)
    else # Тест завершен
      Rails.logger.info "QuizRunner: Test #{test_result.test.name} completed by user #{@user.telegram_id} (TestResult ID: #{test_result_id})."
      test_result.update(completed_at: Time.now)
      completed_test_type = test_result.test.test_type

      # TestResultCalculator сам отправит результаты и следующую кнопку.
      # Если мы хотим, чтобы QuizRunner контролировал callback_data после завершения,
      # то TestResultCalculator должен быть вызван здесь.
      TestResultCalculator.new(@bot_service, @chat_id, test_result).calculate_and_send_results

      # Очищаем временные данные о тесте у пользователя.
      @user.store_self_help_data('current_test_result_id', nil)
      @user.store_self_help_data('current_test_type', nil)
    end
  rescue => e
    Rails.logger.error "QuizRunner: Exception while processing answer for user #{@user.telegram_id}: #{e.message}"
    @bot_service.send_message(chat_id: @chat_id, text: "Произошла ошибка при обработке вашего ответа. Пожалуйста, попробуйте ответить еще раз.")
  end

  private

  # Отправляет вопрос пользователю.
  def send_question(question, test_result_id)
    inline_keyboard = question.answer_options.map do |answer_option|
      callback_data = "answer_#{question.id}_#{answer_option.id}_#{test_result_id}"
      { text: answer_option.text, callback_data: callback_data }
    end

    markup = { inline_keyboard: [inline_keyboard] }.to_json

    @bot_service.send_message(chat_id: @chat_id, text: question.text, reply_markup: markup)
  end
end

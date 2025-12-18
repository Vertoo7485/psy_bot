# app/services/quiz_runner.rb
class QuizRunner
  # Константы
  MAX_RETRIES = 3
  
  attr_reader :bot_service, :user, :chat_id
  
  def initialize(bot_service, user, chat_id)
    @bot_service = bot_service
    @user = user
    @chat_id = chat_id
  end
  
  # Запуск теста
  def start_quiz(test_type)
    test = Test.find_by_type_name(test_type)
    
    unless test
      log_error("Test not found: #{test_type}")
      send_test_not_found_message(test_type)
      return false
    end
    
    # Очищаем незавершенные тесты
    cleanup_incomplete_tests(test)
    
    # Создаем новый результат теста
    test_result = create_test_result(test)
    
    unless test_result
      log_error("Failed to create test result for test: #{test.name}")
      send_error_message("Ошибка при создании теста. Попробуйте позже.")
      return false
    end
    
    # Сохраняем временные данные
    save_temporary_test_data(test_type, test_result.id)
    
    # Создаем сессию теста
    create_test_session(test_type, test_result.id)
    
    # Отправляем первый вопрос
    send_first_question(test, test_result.id)
    
    true
  rescue => e
    log_error("Failed to start quiz for test: #{test_type}", e)
    send_error_message("Произошла ошибка при запуске теста. Пожалуйста, попробуйте позже.")
    false
  end
  
  # Обработка ответа на вопрос
  def process_answer(question_id, answer_option_id, test_result_id)
    # Получаем объекты из базы данных
    question, answer_option, test_result = fetch_quiz_objects(question_id, answer_option_id, test_result_id)
    
    # Проверяем валидность объектов
    unless valid_quiz_objects?(question, answer_option, test_result)
      log_error("Invalid quiz objects", question_id: question_id, answer_option_id: answer_option_id, test_result_id: test_result_id)
      send_error_message("Произошла ошибка при обработке вашего ответа. Попробуйте ответить снова.")
      return false
    end
    
    # Проверяем, что тест еще не завершен
    return handle_completed_test(test_result) if test_result.completed?
    
    # Сохраняем ответ
    save_answer(test_result, question, answer_option)
    
    # Получаем следующий вопрос или завершаем тест
    handle_next_step(test_result, question)
    
    true
  rescue => e
    log_error("Exception while processing answer", e, question_id: question_id, answer_option_id: answer_option_id, test_result_id: test_result_id)
    send_error_message("Произошла ошибка при обработке вашего ответа. Пожалуйста, попробуйте ответить еще раз.")
    false
  end
  
  private
  
  # Очистка незавершенных тестов
  def cleanup_incomplete_tests(test)
    TestResult.where(user: @user, test: test, completed_at: nil).destroy_all
    log_info("Cleaned up incomplete tests for user: #{@user.telegram_id}, test: #{test.name}")
  end
  
  # Создание результата теста
  def create_test_result(test)
    test_result = TestResult.new(user: @user, test: test)
    
    if test_result.save
      log_info("Created test result: #{test_result.id} for test: #{test.name}")
      test_result
    else
      log_error("Failed to save test result: #{test_result.errors.full_messages.join(', ')}")
      nil
    end
  end
  
  # Сохранение временных данных теста
  def save_temporary_test_data(test_type, test_result_id)
    @user.store_self_help_data('current_test_result_id', test_result_id)
    @user.store_self_help_data('current_test_type', test_type)
    log_info("Saved temporary test data for user: #{@user.telegram_id}")
  end
  
  # Создание сессии теста
  def create_test_session(test_type, test_result_id)
    begin
      @user.get_or_create_session('test', 'started')
      @user.update_session_progress('test_started', {
        test_type: test_type,
        test_result_id: test_result_id
      })
      log_info("Created test session for user: #{@user.telegram_id}")
    rescue => e
      log_warn("Failed to save session for test: #{e.message}")
      # Не прерываем тест из-за ошибки сессии
    end
  end
  
  # Отправка первого вопроса
  def send_first_question(test, test_result_id)
    question = test.first_question
    
    if question
      send_question(question, test_result_id)
      log_info("Sent first question for test: #{test.name}")
    else
      log_error("No questions found for test: #{test.name}")
      send_error_message("В тесте нет вопросов. Пожалуйста, свяжитесь с администратором.")
    end
  end
  
  # Получение объектов викторины из базы данных
  def fetch_quiz_objects(question_id, answer_option_id, test_result_id)
    [
      Question.find_by(id: question_id),
      AnswerOption.find_by(id: answer_option_id),
      TestResult.find_by(id: test_result_id)
    ]
  end
  
  # Проверка валидности объектов викторины
  def valid_quiz_objects?(question, answer_option, test_result)
    question && answer_option && test_result && 
    test_result.user == @user && 
    test_result.test_id == question.test_id &&
    answer_option.question_id == question.id
  end
  
  # Обработка завершенного теста
  def handle_completed_test(test_result)
    log_warn("Attempt to answer completed test: #{test_result.id}")
    send_message(text: "Этот тест уже завершен. Вы не можете отвечать на вопросы.")
    false
  end
  
  # Сохранение ответа
  def save_answer(test_result, question, answer_option)
    Answer.create!(
      test_result: test_result,
      question: question,
      answer_option: answer_option
    )
    log_info("Saved answer for question: #{question.id}, test_result: #{test_result.id}")
  end
  
  # Обработка следующего шага
  def handle_next_step(test_result, current_question)
    next_question = find_next_question(test_result.test, current_question.id)
    
    if next_question
      send_question(next_question, test_result.id)
    else
      complete_test(test_result)
    end
  end
  
  # Поиск следующего вопроса
  def find_next_question(test, current_question_id)
    test.questions
        .where("id > ?", current_question_id)
        .order(:id)
        .first
  end
  
  # Завершение теста
  def complete_test(test_result)
    test_result.update(completed_at: Time.now)
    
    # Проверяем, проходит ли пользователь тест в рамках программы самопомощи
    in_program_context = @user.self_help_state.present? && 
                        @user.get_self_help_data('current_test_type').present?
    
    # Рассчитываем и отправляем результаты
    calculator = TestResultCalculator.new(@bot_service, @chat_id, test_result)
    calculator.calculate_and_send_results(in_program_context: in_program_context)
    
    # Очищаем временные данные
    clear_temporary_test_data
    
    log_info("Test completed: #{test_result.test.name}, result_id: #{test_result.id}, in_program: #{in_program_context}")
  end
  
  # Отправка результатов теста
  def send_test_results(test_result)
    calculator = TestResultCalculator.new(@bot_service, @chat_id, test_result)
    calculator.calculate_and_send_results
    
    # Обрабатываем завершение теста в контексте программы самопомощи
    handle_test_completion_in_context(test_result)
  end
  
  # Обработка завершения теста в контексте программы самопомощи
  def handle_test_completion_in_context(test_result)
    current_test_type = @user.get_self_help_data('current_test_type')
    
    if current_test_type
      facade = SelfHelp::Facade::SelfHelpFacade.new(@bot_service, @user, @chat_id)
      facade.handle_test_completion(current_test_type)
    end
  end
  
  # Очистка временных данных теста
  def clear_temporary_test_data
    @user.store_self_help_data('current_test_result_id', nil)
    @user.store_self_help_data('current_test_type', nil)
  end
  
  # Отправка вопроса пользователю
  def send_question(question, test_result_id)
    inline_keyboard = question.answer_options.map do |answer_option|
      callback_data = "answer_#{question.id}_#{answer_option.id}_#{test_result_id}"
      { text: answer_option.text, callback_data: callback_data }
    end

    markup = { inline_keyboard: [inline_keyboard] }.to_json

    @bot_service.send_message(
      chat_id: @chat_id,
      text: question.text,
      reply_markup: markup
    )
  end
  
  # Отправка сообщения об ошибке
  def send_error_message(text = "Произошла ошибка. Пожалуйста, попробуйте позже.")
    @bot_service.send_message(
      chat_id: @chat_id,
      text: text
    )
  end
  
  # Отправка сообщения о ненайденном тесте
  def send_test_not_found_message(test_type)
    @bot_service.send_message(
      chat_id: @chat_id,
      text: "Тест '#{test_type}' не найден."
    )
  end
  
  # Общая отправка сообщения
  def send_message(text:, reply_markup: nil)
    @bot_service.send_message(
      chat_id: @chat_id,
      text: text,
      reply_markup: reply_markup
    )
  end
  
  # Логирование
  def log_info(message, extra = {})
    Rails.logger.info "[QuizRunner] #{message} - User: #{@user.telegram_id}, #{extra.to_json}"
  end
  
  def log_error(message, error = nil, extra = {})
    Rails.logger.error "[QuizRunner] #{message} - User: #{@user.telegram_id}, #{extra.to_json}"
    Rails.logger.error error.message if error
    Rails.logger.error error.backtrace.join("\n") if error.respond_to?(:backtrace)
  end
  
  def log_warn(message, extra = {})
    Rails.logger.warn "[QuizRunner] #{message} - User: #{@user.telegram_id}, #{extra.to_json}"
  end
end
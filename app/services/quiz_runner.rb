# app/services/quiz_runner.rb
class QuizRunner
  # Константы
  MAX_RETRIES = 3
  
  attr_reader :bot_service, :user, :chat_id, :in_program_context
  
  def initialize(bot_service, user, chat_id, in_program_context: false)
    @bot_service = bot_service
    @user = user
    @chat_id = chat_id
    @in_program_context = in_program_context
    
    log_info("QuizRunner initialized", {
      user_id: user.id,
      telegram_id: user.telegram_id,
      in_program_context: @in_program_context,
      self_help_state: user.self_help_state,
      current_test_type: user.get_self_help_data('current_test_type')
    })
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
    
    # Если тест запущен из программы, сохраняем тип теста
    if @in_program_context
      @user.store_self_help_data('current_test_type', test_type)
    end
    
    log_info("Starting quiz", {
      test_name: test.name,
      test_type: test_type,
      test_result_id: test_result.id,
      in_program_context: @in_program_context,
      current_test_type: @user.get_self_help_data('current_test_type')
    })
    
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
    return unless valid_quiz_objects?(question_id, answer_option_id, test_result_id)
    
    # Сохраняем ответ
    save_answer(question_id, answer_option_id, test_result_id)
    
    # Получаем следующий вопрос
    test_result = TestResult.find(test_result_id)
    next_question = find_next_question(question_id, test_result.test_id)
    
    if next_question
      # Отправляем следующий вопрос
      send_question(next_question, test_result_id)
    else
      # Завершаем тест
      complete_test(test_result)
    end
  rescue => e
    log_error("Error processing answer", e)
    send_error_message("Произошла ошибка при обработке ответа.")
  end
  
  # Завершение теста
  def complete_test(test_result)
    test_result.update(completed_at: Time.current)
    
    # Определяем финальный контекст:
    # 1. Используем явно переданный параметр
    # 2. Если не передан, проверяем current_test_type как fallback
    final_in_program_context = if @in_program_context.present?
                                @in_program_context
                              else
                                @user.get_self_help_data('current_test_type').present?
                              end
    
    log_info("Test completion context", {
      user_id: @user.id,
      test_result_id: test_result.id,
      test_name: test_result.test.name,
      in_program_context_param: @in_program_context,
      current_test_type: @user.get_self_help_data('current_test_type'),
      final_in_program_context: final_in_program_context,
      program_step: @user.self_help_program_step
    })
    
    # Рассчитываем и отправляем результаты
    calculator = TestResultCalculator.new(@bot_service, @chat_id, test_result)
    calculator.calculate_and_send_results(in_program_context: final_in_program_context)
    
    # Очищаем временные данные
    clear_temporary_test_data(final_in_program_context)
    
    log_info("Test completed", {
      test_name: test_result.test.name,
      result_id: test_result.id,
      in_program: final_in_program_context
    })
  end
  
  # Отправка результатов теста (для прямого вызова)
  def send_test_results(test_result)
    calculator = TestResultCalculator.new(@bot_service, @chat_id, test_result)
    calculator.calculate_and_send_results
    
    # Обрабатываем завершение теста в контексте программы самопомощи
    handle_test_completion_in_context(test_result)
  end
  
  private
  
  # Проверка валидности объектов викторины
  def valid_quiz_objects?(question_id, answer_option_id, test_result_id)
    question = Question.find_by(id: question_id)
    answer_option = AnswerOption.find_by(id: answer_option_id)
    test_result = TestResult.find_by(id: test_result_id)
    
    unless question && answer_option && test_result
      log_error("Invalid quiz objects", {
        question_id: question_id,
        answer_option_id: answer_option_id,
        test_result_id: test_result_id
      })
      return false
    end
    
    unless answer_option.question_id == question_id
      log_error("Answer option doesn't belong to question")
      return false
    end
    
    true
  rescue => e
    log_error("Error validating quiz objects", e)
    false
  end
  
  # Сохранение ответа
  def save_answer(question_id, answer_option_id, test_result_id)
    Answer.create!(
      test_result_id: test_result_id,
      question_id: question_id,
      answer_option_id: answer_option_id
    )
    
    log_info("Saved answer", {
      question_id: question_id,
      answer_option_id: answer_option_id,
      test_result_id: test_result_id
    })
  rescue => e
    log_error("Error saving answer", e)
    raise
  end
  
  # Поиск следующего вопроса
  def find_next_question(current_question_id, test_id)
    Question.where(test_id: test_id)
            .where("id > ?", current_question_id)
            .order(:id)
            .first
  end
  
  # Создание результата теста
  def create_test_result(test)
    TestResult.create!(
    user: @user,
    test: test
    # started_at не существует в таблице
    )
    rescue => e
      log_error("Error creating test result", e)
      nil
    end
  
  # Очистка незавершенных тестов
  def cleanup_incomplete_tests(test)
    TestResult.where(user: @user, test: test, completed_at: nil)
              .destroy_all
  end
  
  # Сохранение временных данных теста
  def save_temporary_test_data(test_type, test_result_id)
    @user.store_self_help_data('current_test_result_id', test_result_id)
  end
  
  # Создание сессии теста
  def create_test_session(test_type, test_result_id)
    # Можно добавить логику сессий если нужно
    log_info("Test session created", {
      test_type: test_type,
      test_result_id: test_result_id
    })
  end
  
  # Очистка временных данных с учетом контекста
  def clear_temporary_test_data(in_program_context = false)
    # Очищаем current_test_type только если тест был в программе
    if in_program_context
      @user.store_self_help_data('current_test_type', nil)
    end
    
    # Базовая очистка
    @user.store_self_help_data('current_test_result_id', nil)
    
    log_info("Cleared temporary test data", {
      in_program_context: in_program_context,
      current_test_type: @user.get_self_help_data('current_test_type')
    })
  end
  
  # Отправка первого вопроса
  def send_first_question(test, test_result_id)
  # Предзагрузка answer_options для избежания N+1
  first_question = test.questions
                      .includes(:answer_options)
                      .order(:id)
                      .first
  
  if first_question
    send_question(first_question, test_result_id, is_first: true)
  else
    log_error("No questions found for test: #{test.name}")
    send_error_message("В тесте нет вопросов.")
  end
end
  
  # Отправка следующего вопроса
  def find_next_question(current_question_id, test_id)
  Question.where(test_id: test_id)
          .includes(:answer_options) # Предзагрузка
          .where("id > ?", current_question_id)
          .order(:id)
          .first
  end
  
  # Отправка вопроса
  def send_question(question, test_result_id, is_first: false)
    message = is_first ? "Начинаем тест!\n\n#{question.text}" : question.text
    reply_markup = build_question_markup(question, test_result_id)
    
    @bot_service.send_message(
      chat_id: @chat_id,
      text: message,
      reply_markup: reply_markup
    )
  end
  
  # Построение разметки для вопроса
  def build_question_markup(question, test_result_id)
    inline_keyboard = question.answer_options.map do |option|
      [{
        text: option.text,
        callback_data: "answer_#{question.id}_#{option.id}_#{test_result_id}"
      }]
    end
    
    { inline_keyboard: inline_keyboard }.to_json
  end
  
  # Отправка сообщения об ошибке
  def send_error_message(text)
    @bot_service.send_message(
      chat_id: @chat_id,
      text: text
    )
  end
  
  # Отправка сообщения о ненайденном тесте
  def send_test_not_found_message(test_type)
    send_error_message("Тест '#{test_type}' не найден.")
  end
  
  # Обработка завершения теста в контексте программы
  def handle_test_completion_in_context(test_result)
    # Можно добавить дополнительную логику если нужно
    log_info("Handling test completion in context", {
      test_result_id: test_result.id,
      test_name: test_result.test.name
    })
  end
  
  # Логирование
  def log_info(message, data = {})
    Rails.logger.info "[QuizRunner] #{message} - User: #{@user.id}, #{data}"
  end
  
  def log_error(message, error = nil)
    Rails.logger.error "[QuizRunner] #{message} - User: #{@user.id}"
    Rails.logger.error error.message if error
    Rails.logger.error error.backtrace.join("\n") if error
  end
end
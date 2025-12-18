# app/services/test_result_calculator.rb

class TestResultCalculator
  include TelegramMarkupHelper
  
  # Константы для интерпретации тестов с правильными диапазонами
  
  # PHQ-9 (Тест депрессии): 0-27 баллов
  PHQ9_INTERPRETATIONS = {
    0..4 => "Минимальная депрессия. Возможно, вам не требуется лечение, но обращайте внимание на свое состояние.",
    5..9 => "Легкая депрессия. Рекомендуется консультация специалиста.",
    10..14 => "Умеренная депрессия. Обратитесь к специалисту для дальнейшей оценки и возможного лечения.",
    15..19 => "Умеренно тяжелая депрессия. Необходима консультация специалиста и, возможно, лечение.",
    20..27 => "Тяжелая депрессия. Срочно обратитесь за профессиональной помощью."
  }.freeze
  
  # GAD-7 (Тест тревожности): 0-21 балл
  GAD7_INTERPRETATIONS = {
    0..4 => "Минимальная тревожность. Вероятно, ваше состояние в норме.",
    5..9 => "Легкая тревожность. Обратите внимание на свое состояние, возможно, полезно обсудить это со специалистом.",
    10..14 => "Умеренная тревожность. Рекомендуется консультация специалиста для оценки и дальнейших рекомендаций.",
    15..21 => "Тяжелая тревожность. Срочно обратитесь к специалисту для получения помощи."
  }.freeze
  
  # EQ (Эмоциональный интеллект): нужно узнать правильные диапазоны
  # Допустим, максимум 150 баллов
  EQ_INTERPRETATIONS = {
    0..50 => "Низкий уровень эмоционального интеллекта. Есть потенциал для развития.",
    51..100 => "Средний уровень эмоционального интеллекта. Хорошо, но есть куда стремиться.",
    101..150 => "Высокий уровень эмоционального интеллекта. Отличная способность понимать и управлять эмоциями."
  }.freeze
  
  attr_reader :bot_service, :chat_id, :test_result, :user
  
  def initialize(bot_service, chat_id, test_result)
    @bot_service = bot_service
    @chat_id = chat_id
    @test_result = test_result
    @user = test_result.user
  end
  
  # Рассчитать и отправить результаты
  def calculate_and_send_results(silent: false, in_program_context: false)
    # Рассчитываем общий балл
    total_score = calculate_total_score
    
    # Обновляем результат теста
    update_test_result(total_score)
    
    # Получаем интерпретацию
    interpretation = get_interpretation(total_score)
    
    # Если silent режим, возвращаем только текст
    return build_result_text(total_score, interpretation) if silent
    
    # Отправляем результаты пользователю
    send_results(total_score, interpretation, in_program_context)
    
    nil
  rescue => e
    log_error("Error calculating and sending results", e)
    
    unless silent
      send_error_message("Произошла ошибка при обработке результатов теста. Пожалуйста, попробуйте позже.")
    end
    
    "Произошла ошибка при расчете результатов."
  end
  
  private
  
  # Рассчет общего балла
  def calculate_total_score
    # Для PHQ-9 и GAD-7: ответы от 0 до 3, сумма всех ответов
    # Проверим значения в базе данных
    answers = @test_result.answers.includes(:answer_option)
    total = answers.sum { |answer| answer.answer_option.value.to_i }
    
    log_info("Calculated score: #{total} from #{answers.count} answers")
    total
  end
  
  # Обновление результата теста
  def update_test_result(total_score)
    @test_result.update(
      score: total_score,
      completed_at: Time.current
    ) unless @test_result.completed_at.present?
    
    log_info("Updated test result: score=#{total_score}")
  end
  
  # Получение интерпретации
  def get_interpretation(total_score)
    test_name = @test_result.test.name
    test_type = @test_result.test.test_type.to_sym
    
    case test_type
    when :standard
      get_standard_interpretation(test_name, total_score)
    when :luscher
      "Интерпретация теста Люшера будет предоставлена отдельно."
    else
      "Неизвестный тип теста."
    end
  end
  
  # Получение интерпретации для стандартных тестов
  def get_standard_interpretation(test_name, total_score)
    case test_name
    when "Тест Депрессии (PHQ-9)"
      get_range_interpretation(PHQ9_INTERPRETATIONS, total_score)
    when "Тест Тревожности"
      get_range_interpretation(GAD7_INTERPRETATIONS, total_score)
    when "Тест EQ (Эмоциональный Интеллект)"
      get_range_interpretation(EQ_INTERPRETATIONS, total_score)
    else
      "Неизвестный стандартный тест."
    end
  end
  
  # Получение интерпретации по диапазонам
  def get_range_interpretation(interpretations, score)
    range = interpretations.keys.find { |key_range| key_range.include?(score) }
    
    if range
      interpretations[range]
    else
      "Некорректный балл: #{score}."
    end
  end
  
  # Построение текста результата
  def build_result_text(total_score, interpretation)
    <<~TEXT
      Тест "#{@test_result.test.name}" завершен!
      
      Ваш балл: #{total_score}.
      
      #{interpretation}
    TEXT
  end
  
  # Отправка результатов пользователю
  def send_results(total_score, interpretation, in_program_context)
    message = build_result_message(total_score, interpretation)
    next_step_markup = get_next_step_markup(in_program_context)
    
    if next_step_markup
      send_message(message, next_step_markup)
    else
      send_message(message)
    end
    
    log_info("Sent test results to user")
  end
  
  # Построение сообщения с результатами
  def build_result_message(total_score, interpretation)
    <<~MARKDOWN
      🎯 *Тест завершен!*

      *Название теста:* #{@test_result.test.name}
      *Ваш балл:* #{total_score}

      *Интерпретация:*
      #{interpretation}
    MARKDOWN
  end
  
  # Получение разметки для следующего шага
  def get_next_step_markup(in_program_context)
    # Если тест проходит вне программы самопомощи, показываем главное меню
    return TelegramMarkupHelper.main_menu_markup unless in_program_context
    
    test_name = @test_result.test.name
    test_type = @test_result.test.test_type.to_sym
    
    case test_type
    when :standard
      case test_name
      when "Тест Депрессии (PHQ-9)"
        # Только если в контексте программы самопомощи
        in_program_context ? {
          inline_keyboard: [
            [{ text: "Продолжить программу", callback_data: 'test_completed_depression' }]
          ]
        }.to_json : TelegramMarkupHelper.main_menu_markup
      when "Тест Тревожности"
        # Только если в контексте программы самопомощи
        in_program_context ? {
          inline_keyboard: [
            [{ text: "Перейти к материалам дня 1", callback_data: 'test_completed_anxiety' }]
          ]
        }.to_json : TelegramMarkupHelper.main_menu_markup
      when "Тест EQ (Эмоциональный Интеллект)"
        TelegramMarkupHelper.main_menu_markup
      else
        TelegramMarkupHelper.main_menu_markup
      end
    when :luscher
      # Для теста Люшера интерпретация обрабатывается отдельно
      nil
    else
      TelegramMarkupHelper.main_menu_markup
    end
  end
  
  # Отправка сообщения
  def send_message(text, reply_markup = nil)
    @bot_service.send_message(
      chat_id: @chat_id,
      text: text,
      parse_mode: 'Markdown',
      reply_markup: reply_markup
    )
  end
  
  # Отправка сообщения об ошибке
  def send_error_message(text)
    send_message(text)
  end
  
  # Логирование
  def log_info(message)
    Rails.logger.info "[TestResultCalculator] #{message} - User: #{@user.telegram_id}, TestResult: #{@test_result.id}"
  end
  
  def log_error(message, error = nil)
    Rails.logger.error "[TestResultCalculator] #{message} - User: #{@user.telegram_id}, TestResult: #{@test_result.id}"
    Rails.logger.error error.message if error
    Rails.logger.error error.backtrace.join("\n") if error.respond_to?(:backtrace)
  end
end
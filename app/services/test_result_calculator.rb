# app/services/test_result_calculator.rb
class TestResultCalculator
  include TelegramMarkupHelper
  
  # ПРАВИЛЬНЫЕ КОНСТАНТЫ С ПРАВИЛЬНЫМИ ДИАПАЗОНАМИ
  
  # Тест тревожности: 20 вопросов × 1-4 = 20-80 баллов
  GAD7_INTERPRETATIONS = {
    20..35 => "Минимальная тревожность. Ваше состояние в пределах нормы.",
    36..50 => "Легкая тревожность. Рекомендуется обратить внимание на самочувствие.",
    51..65 => "Умеренная тревожность. Рекомендуется консультация специалиста.",
    66..80 => "Тяжелая тревожность. Срочно обратитесь к специалисту."
  }.freeze
  
  # Тест депрессии PHQ-9: 9 вопросов × 0-3 = 0-27 баллов
  PHQ9_INTERPRETATIONS = {
    0..4 => "Минимальная депрессия. Ваше состояние в норме.",
    5..9 => "Легкая депрессия. Рекомендуется наблюдение.",
    10..14 => "Умеренная депрессия. Рекомендуется консультация специалиста.",
    15..27 => "Тяжелая депрессия. Срочно обратитесь за профессиональной помощью."
  }.freeze
  
  # Тест EQ: 10 вопросов × 1-5 = 10-50 баллов  
  EQ_INTERPRETATIONS = {
    10..20 => "Низкий уровень эмоционального интеллекта. Есть потенциал для развития.",
    21..35 => "Средний уровень эмоционального интеллекта. Хорошие базовые навыки.",
    36..50 => "Высокий уровень эмоционального интеллекта. Отличная способность понимать и управлять эмоциями."
  }.freeze
  
  attr_reader :bot_service, :chat_id, :test_result, :user
  
  def initialize(bot_service, chat_id, test_result)
    @bot_service = bot_service
    @chat_id = chat_id
    @test_result = test_result
    @user = test_result.user
  end
  
  # Основной метод - рассчитать и отправить результаты
  def calculate_and_send_results(in_program_context: false)
    # Рассчитываем балл
    total_score = calculate_total_score
    
    # Обновляем результат
    update_test_result(total_score)
    
    # Получаем интерпретацию
    interpretation = get_interpretation(total_score)
    
    # Отправляем результаты
    send_results(total_score, interpretation, in_program_context)
    
    total_score
  rescue => e
    log_error("Error calculating results", e)
    send_error_message("Произошла ошибка при обработке результатов теста.")
    nil
  end
  
  private
  
  # Подсчет общего балла
  def calculate_total_score
    # ВАРИАНТ 1: JOIN запрос (лучший для PostgreSQL)
    @test_result.answers
      .joins(:answer_option)
      .sum('answer_options.value::integer')
  end
  
  # Обновление результата теста
  def update_test_result(total_score)
    @test_result.update(score: total_score, completed_at: Time.current)
  end
  
  # Получение интерпретации
  def get_interpretation(total_score)
    test_name = @test_result.test.name
    
    case test_name
    when "Тест Тревожности"
      get_range_interpretation(GAD7_INTERPRETATIONS, total_score)
    when "Тест Депрессии (PHQ-9)"
      get_range_interpretation(PHQ9_INTERPRETATIONS, total_score)
    when "Тест EQ (Эмоциональный Интеллект)"
      get_range_interpretation(EQ_INTERPRETATIONS, total_score)
    else
      "Интерпретация для этого теста не настроена."
    end
  end
  
  # Получение интерпретации по диапазону
  def get_range_interpretation(interpretations, score)
    range = interpretations.keys.find { |key_range| key_range.include?(score) }
    range ? interpretations[range] : "Балл: #{score} (вне диапазона интерпретации)"
  end
  
  # Отправка результатов
  def send_results(total_score, interpretation, in_program_context)
    message = build_result_message(total_score, interpretation)
    markup = get_result_markup(in_program_context)
    
    send_message(message, markup)
  end
  
  # Построение сообщения с результатами
  def build_result_message(total_score, interpretation)
    test_name = @test_result.test.name
    
    <<~MARKDOWN
      🎯 *Тест завершен!*

      *Название теста:* #{test_name}
      *Ваш балл:* #{total_score}

      *Интерпретация:*
      #{interpretation}

      #{get_recommendation(test_name, total_score)}
    MARKDOWN
  end
  
  # Получение рекомендации
  def get_recommendation(test_name, score)
    case test_name
    when "Тест Тревожности"
      case score
      when 20..35 then "💡 *Рекомендация:* Ваше состояние в норме. Продолжайте следить за самочувствием."
      when 36..50 then "💡 *Рекомендация:* Попробуйте техники релаксации и дыхательные упражнения."
      when 51..65 then "💡 *Рекомендация:* Рекомендуется консультация специалиста."
      when 66..80 then "💡 *Рекомендация:* Срочно обратитесь за профессиональной помощью."
      else "💡 *Рекомендация:* Обратитесь к специалисту для консультации."
      end
    when "Тест Депрессии (PHQ-9)"
      case score
      when 0..4 then "💡 *Рекомендация:* Ваше состояние в пределах нормы."
      when 5..9 then "💡 *Рекомендация:* Рекомендуется наблюдение за состоянием."
      when 10..14 then "💡 *Рекомендация:* Рекомендуется консультация специалиста."
      when 15..27 then "💡 *Рекомендация:* Срочно обратитесь за профессиональной помощью."
      else "💡 *Рекомендация:* Обратитесь к специалисту для консультации."
      end
    when "Тест EQ (Эмоциональный Интеллект)"
      case score
      when 10..20 then "💡 *Рекомендация:* Развивайте навыки эмпатии и самоконтроля."
      when 21..35 then "💡 *Рекомендация:* Продолжайте развивать эмоциональный интеллект."
      when 36..50 then "💡 *Рекомендация:* Отличный результат! Продолжайте в том же духе."
      else "💡 *Рекомендация:* Развивайте эмоциональные навыки."
      end
    else
      "💡 *Рекомендация:* Обратитесь к специалисту для подробной консультации."
    end
  end
  
  # Получение разметки для результатов
  def get_result_markup(in_program_context)
    if in_program_context
      # Определяем тип теста для программы самопомощи
      test_type = @test_result.test.test_type
      callback_data = case test_type
                     when "depression"
                       "test_completed_depression"
                     when "anxiety"
                       "test_completed_anxiety"
                     else
                       "continue_self_help" # fallback
                     end
      
      {
        inline_keyboard: [
          [{ text: "Продолжить программу", callback_data: callback_data }],
          [{ text: "В главное меню", callback_data: "back_to_main_menu" }]
        ]
      }.to_json
    else
      {
        inline_keyboard: [
          [{ text: "В главное меню", callback_data: "back_to_main_menu" }],
          [{ text: "Пройти еще раз", callback_data: "show_test_categories" }]
        ]
      }.to_json
    end
  end
  
  # === ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ ===
  
  def send_message(text, reply_markup = nil)
    @bot_service.send_message(
      chat_id: @chat_id,
      text: text,
      parse_mode: 'Markdown',
      reply_markup: reply_markup
    )
  end
  
  def send_error_message(text)
    @bot_service.send_message(
      chat_id: @chat_id,
      text: text,
      parse_mode: 'Markdown'
    )
  end
  
  def log_info(message)
    Rails.logger.info "[TestResultCalculator] #{message} - User: #{@user.telegram_id}, Test: #{@test_result.test.name}"
  end
  
  def log_error(message, error = nil)
    Rails.logger.error "[TestResultCalculator] #{message} - User: #{@user.telegram_id}, Test: #{@test_result.test.name}"
    if error
      Rails.logger.error "Error: #{error.message}"
      Rails.logger.error "Backtrace:\n#{error.backtrace.join("\n")}" if error.respond_to?(:backtrace)
    end
  end
end

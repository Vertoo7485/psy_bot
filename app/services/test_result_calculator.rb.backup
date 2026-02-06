# app/services/test_result_calculator.rb
class TestResultCalculator
  include TelegramMarkupHelper
  
  # КОНСТАНТЫ С ПРАВИЛЬНЫМИ ДИАПАЗОНАМИ
  
  # GAD-7 (Тест тревожности): 20 вопросов × 1-4 = 20-80 баллов
  GAD7_INTERPRETATIONS = {
    20..35 => "Минимальная тревожность. Вероятно, ваше состояние в норме.",
    36..50 => "Легкая тревожность. Обратите внимание на свое состояние.",
    51..65 => "Умеренная тревожность. Рекомендуется консультация специалиста.",
    66..80 => "Тяжелая тревожность. Срочно обратитесь к специалисту."
  }.freeze
  
  # PHQ-9 (Тест депрессии): 9 вопросов × 1-4 = 9-36 баллов
  PHQ9_INTERPRETATIONS = {
    9..15 => "Минимальная депрессия. Возможно, вам не требуется лечение.",
    16..22 => "Легкая депрессия. Рекомендуется консультация специалиста.",
    23..29 => "Умеренная депрессия. Обратитесь к специалисту.",
    30..36 => "Тяжелая депрессия. Срочно обратитесь за профессиональной помощью."
  }.freeze
  
  # EQ (Эмоциональный интеллект): 20 вопросов × 1-4 = 20-80 баллов
  EQ_INTERPRETATIONS = {
  10..25 => "Низкий уровень эмоционального интеллекта. Есть потенциал для развития.",
  26..35 => "Средний уровень эмоционального интеллекта. Хорошо, но есть куда стремиться.",
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
    <<~MARKDOWN
      🎯 *Тест завершен!*

      *Название теста:* #{@test_result.test.name}
      *Ваш балл:* #{total_score}

      *Интерпретация:*
      #{interpretation}
      
      #{get_recommendation(@test_result.test.name, total_score)}
    MARKDOWN
  end
  
  # Получение рекомендаций
  def get_recommendation(test_name, score)
    case test_name
    when "Тест Тревожности"
      if score >= 66
        "💡 *Рекомендация:* Рекомендуется обратиться к психологу для консультации."
      elsif score >= 51
        "💡 *Рекомендация:* Попробуйте техники релаксации и дыхательные упражнения."
      else
        "💡 *Рекомендация:* Ваше состояние в норме. Продолжайте следить за самочувствием."
      end
    when "Тест Депрессии (PHQ-9)"
      if score >= 30
        "💡 *Рекомендация:* Срочно обратитесь за профессиональной помощью."
      elsif score >= 23
        "💡 *Рекомендация:* Рекомендуется консультация специалиста."
      else
        "💡 *Рекомендация:* Ваше состояние в пределах нормы."
      end
    else
      ""
    end
  end
  
  # Получение разметки для кнопок
 def get_result_markup(in_program_context)
  test_name = @test_result.test.name
  
  # Если пользователь в программе самопомощи
  if in_program_context
    case test_name
    when "Тест Тревожности"
      # ТОЛЬКО ОДНА КНОПКА - "Перейти к Дню 1 программы"
      return {
        inline_keyboard: [
          [{ text: "Перейти к Дню 1 программы", callback_data: 'test_completed_anxiety' }]
          # Убираем "Вернуться в меню программы" - используем back_to_main_menu
        ]
      }.to_json
    when "Тест Депрессии (PHQ-9)"
      return {
        inline_keyboard: [
          [{ text: "Продолжить программу", callback_data: 'test_completed_depression' }]
        ]
      }.to_json
    else
      # Для других тестов в программе - главное меню
      return {
        inline_keyboard: [
          [{ text: "Вернуться в главное меню", callback_data: 'back_to_main_menu' }]
        ]
      }.to_json
    end
  end
  
  # Если тест НЕ в программе - главное меню бота
  TelegramMarkupHelper.main_menu_markup
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
  
  # Отправка ошибки
  def send_error_message(text)
    send_message(text)
  end
  
  # Логирование
  def log_info(message)
    Rails.logger.info "[TestResultCalculator] #{message}"
  end
  
  def log_error(message, error = nil)
    Rails.logger.error "[TestResultCalculator] #{message}"
    Rails.logger.error error.message if error
  end
end
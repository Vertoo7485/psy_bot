# app/services/test_result_calculator.rb
class TestResultCalculator
  include TelegramMarkupHelper

  def initialize(bot_service, chat_id, test_result)
    @bot_service = bot_service
    @bot = bot_service.bot
    @chat_id = chat_id
    @test_result = test_result
    @user = test_result.user
  end

  # Добавляем параметр `silent` для возможности получения только текста.
  def calculate_and_send_results(silent: false)
    total_score = @test_result.answers.sum { |answer| answer.answer_option.value }
    @test_result.update(score: total_score, completed_at: Time.now) unless @test_result.completed_at.present?

    test_name = @test_result.test.name
    test_type = @test_result.test.test_type
    interpretation_text = ""
    next_step_markup = nil

    # Получаем интерпретацию теста.
    interpretation_text = get_interpretation_for_test(test_type, test_name, total_score)

    if silent
      # Если silent: true, возвращаем только текст интерпретации.
      return "Ваш балл: #{total_score}.\n#{interpretation_text}"
    else
      # Если не silent, отправляем сообщение пользователю.
      message = "Тест \"#{test_name}\" завершен!\n\nВаш балл: #{total_score}.\n\n#{interpretation_text}"

      # Определяем следующий шаг и соответствующую клавиатуру.
      case test_type.to_sym
      when :standard
        case test_name
        when "Тест Депрессии (PHQ-9)"
          # После теста на депрессию, предлагаем перейти к тесту на тревожность.
          next_step_markup = { inline_keyboard: [[{ text: "Продолжаем к тесту на тревожность", callback_data: 'test_completed_depression' }]] }.to_json
        when "Тест Тревожности"
          # После теста на тревожность, предлагаем перейти к материалам Дня 1 программы.
          next_step_markup = { inline_keyboard: [[{ text: "Перейти к материалам дня 1", callback_data: 'test_completed_anxiety' }]] }.to_json
        when "Тест EQ (Эмоциональный Интеллект)"
          # После теста EQ, возвращаем в главное меню.
          next_step_markup = TelegramMarkupHelper.main_menu_markup
        end
      when :luscher
        # Для теста Люшера, обработка результатов полностью лежит на LuscherTestService.
        # Здесь ничего не отправляем.
        return
      end

      if next_step_markup
        @bot_service.send_message(chat_id: @chat_id, text: message, reply_markup: next_step_markup)
      else
        @bot_service.send_message(chat_id: @chat_id, text: message)
      end
      return nil # Сообщение было отправлено.
    end
  rescue => e
    Rails.logger.error "TestResultCalculator: Error in calculate_and_send_results for user #{@user.telegram_id}, TestResult ID #{@test_result.id}: #{e.message}"
    unless silent
      @bot_service.send_message(chat_id: @chat_id, text: "Произошла ошибка при обработке результатов теста. Пожалуйста, попробуйте позже.")
    end
    return "Произошла ошибка при расчете результатов." if silent
  end

  private

  # Получает интерпретацию для конкретного теста.
  def get_interpretation_for_test(test_type, test_name, total_score)
    case test_type.to_sym
    when :standard
      case test_name
      when "Тест Депрессии (PHQ-9)" then get_phq9_interpretation(total_score)
      when "Тест Тревожности" then get_gad7_interpretation(total_score)
      when "Тест EQ (Эмоциональный Интеллект)" then get_eq_interpretation(total_score)
      else "Неизвестный стандартный тест."
      end
    when :luscher
      # Для теста Люшера, интерпретация будет получена отдельно через LuscherTestService.
      # Здесь просто возвращаем заглушку.
      "Интерпретация теста Люшера будет предоставлена отдельно."
    else
      "Неизвестный тип теста."
    end
  end

  # Интерпретации для тестов.
  def get_phq9_interpretation(score)
    case score
    when 0..4 then "Минимальная депрессия. Возможно, вам не требуется лечение, но обращайте внимание на свое состояние."
    when 5..9 then "Легкая депрессия. Рекомендуется консультация специалиста."
    when 10..14 then "Умеренная депрессия. Обратитесь к специалисту для дальнейшей оценки и возможного лечения."
    when 15..19 then "Умеренно тяжелая депрессия. Необходима консультация специалиста и, возможно, лечение."
    when 20..27 then "Тяжелая депрессия. Срочно обратитесь за профессиональной помощью."
    else "Некорректный балл."
    end
  end

  def get_gad7_interpretation(score)
    case score
    when 0..4 then "Минимальная тревожность. Вероятно, ваше состояние в норме."
    when 5..9 then "Легкая тревожность. Обратите внимание на свое состояние, возможно, полезно обсудить это со специалистом."
    when 10..14 then "Умеренная тревожность. Рекомендуется консультация специалиста для оценки и дальнейших рекомендаций."
    when 15..21 then "Тяжелая тревожность. Срочно обратитесь к специалисту для получения помощи."
    else "Некорректный балл."
    end
  end

  def get_eq_interpretation(score)
    # Пример интерпретации для EQ. Замените на вашу реальную логику.
    case score
    when 0..50 then "Низкий уровень эмоционального интеллекта. Есть потенциал для развития."
    when 51..100 then "Средний уровень эмоционального интеллекта. Хорошо, но есть куда стремиться."
    when 101..150 then "Высокий уровень эмоционального интеллекта. Отличная способность понимать и управлять эмоциями."
    else "Некорректный балл."
    end
  end
end

# app/services/test_result_calculator.rb
class TestResultCalculator
  include TelegramMarkupHelper
  
  def initialize(bot, chat_id, test_result)
    @bot = bot
    @chat_id = chat_id
    @test_result = test_result
    @test = test_result.test
  end

  def calculate_and_send_results
    answers = @test_result.answers.includes(:question, :answer_option)
    total_score = answers.sum { |answer| answer.answer_option.value }

    interpretation = get_interpretation(total_score)

    message = "Результаты теста \"#{@test.name}\":\n"
    message += "Ваш балл: #{total_score}\n" # Добавим балл для наглядности
    message += "Интерпретация: #{interpretation}"

    @test_result.update(score: total_score, completed_at: Time.now)

    @bot.send_message(
      chat_id: @chat_id,
      text: message,
      reply_markup: back_to_main_menu_markup # Используем новую клавиатуру
    )
  end

  private

  def get_interpretation(score)
    case @test.name
    when "Тест Тревожности"
      case score
      when 20..40 then "Низкий уровень тревожности."
      when 41..60 then "Умеренный уровень тревожности."
      else "Высокий уровень тревожности."
      end
    when "Тест Депрессии (PHQ-9)"
      case score
      when 0..4 then "Минимальная депрессия. Вам может не потребоваться лечение."
      when 5..9 then "Легкая депрессия. Может потребоваться наблюдение или легкие изменения в образе жизни."
      when 10..14 then "Умеренная депрессия. Рекомендуется обратиться к врачу для обсуждения возможных вариантов лечения, включая терапию и/или медикаменты."
      when 15..19 then "Умеренно тяжелая депрессия. Рекомендуется обратиться к врачу для обсуждения возможных вариантов лечения, включая терапию и/или медикаменты."
      when 20..27 then "Тяжелая депрессия. Необходима немедленная консультация с врачом. Важно рассмотреть терапию и/или медикаменты."
      else "Невозможно определить уровень депрессии."
      end
    when "Тест EQ (Эмоциональный Интеллект)"
      case score
      when 10..25 then "Низкий уровень EQ. Вам может быть сложно понимать и управлять своими эмоциями, а также эмоциями других людей. Рекомендуется уделить внимание развитию эмоционального интеллекта."
      when 26..40 then "Средний уровень EQ. У вас есть определенные навыки в области эмоционального интеллекта, но есть области, в которых можно улучшить."
      when 41..50 then "Высокий уровень EQ. Вы хорошо понимаете и управляете своими эмоциями, а также эмпатичны к другим людям."
      else "Невозможно определить уровень EQ."
      end
    else
      "Неизвестный тест. Невозможно определить результаты."
    end
  end
end

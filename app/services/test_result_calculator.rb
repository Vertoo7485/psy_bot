# app/services/test_result_calculator.rb
    class TestResultCalculator
      include TelegramMarkupHelper

      def initialize(bot, chat_id, test_result)
        @bot = bot
        @chat_id = chat_id
        @test_result = test_result
        @user = test_result.user
      end

      # Добавляем параметр `silent`
      def calculate_and_send_results(silent: false)
        # ... (весь код расчета total_score)
        total_score = @test_result.answers.sum { |answer| answer.answer_option.value }
        @test_result.update(score: total_score) # Обновление score происходит всегда
        # completed_at уже обновляется в QuizRunner, но можно и здесь для надежности:
        @test_result.update(completed_at: Time.now) unless @test_result.completed_at.present?

        test_name = @test_result.test.name
        test_type = @test_result.test.test_type
        score_description = ""
        next_step_markup = nil

        # Переносим логику определения score_description и next_step_markup
        # в отдельный приватный метод, чтобы было чище
        score_description = get_interpretation_for_test(test_type, test_name, total_score)

        if !silent
          # Логика отправки сообщения с кнопками, если не silent
          case test_type.to_sym
          when :standard
            case test_name
            when "Тест Депрессии (PHQ-9)"
              next_step_markup = { inline_keyboard: [[{ text: "Продолжаем к тесту на тревожность", callback_data: 'test_completed_depression' }]] }.to_json
            when "Тест Тревожности"
              next_step_markup = { inline_keyboard: [[{ text: "Перейти к материалам дня 1", callback_data: 'test_completed_anxiety' }]] }.to_json
            when "Тест EQ (Эмоциональный Интеллект)"
              next_step_markup = main_menu_markup
            end
          when :luscher
            # Для Люшера здесь ничего не отправляем, он обрабатывается LuscherTestService
            return
          end

          message = "Тест \"#{test_name}\" завершен!\n\nВаш балл: #{total_score}.\n\n#{score_description}"
          if next_step_markup
            @bot.send_message(chat_id: @chat_id, text: message, reply_markup: next_step_markup)
          else
            @bot.send_message(chat_id: @chat_id, text: message)
          end
          return nil # Если сообщение было отправлено, возвращаем nil
        else
          # Если silent: true, возвращаем только текст интерпретации
          return "Ваш балл: #{total_score}.\n#{score_description}"
        end
      rescue => e
        Rails.logger.error "TestResultCalculator: Error in calculate_and_send_results: #{e.message}"
        # Если silent, то просто выбрасываем ошибку или возвращаем сообщение об ошибке
        # Если не silent, то отправляем сообщение об ошибке пользователю
        unless silent
          @bot.send_message(chat_id: @chat_id, text: "Произошла ошибка при обработке результатов теста. Пожалуйста, попробуйте позже.")
        end
        return "Произошла ошибка при расчете результатов." if silent
      end


      private

      # Новый приватный метод для получения интерпретации
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
          "Тест Люшера требует специальной интерпретации."
        else
          "Неизвестный тип теста."
        end
      end

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
        # Пример интерпретации для EQ, замените на вашу логику
        case score
        when 0..50 then "Низкий уровень эмоционального интеллекта. Есть потенциал для развития."
        when 51..100 then "Средний уровень эмоционального интеллекта. Хорошо, но есть куда стремиться."
        when 101..150 then "Высокий уровень эмоционального интеллекта. Отличная способность понимать и управлять эмоциями."
        else "Некорректный балл."
        end
      end
    end

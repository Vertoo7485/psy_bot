module SelfHelp
  module Days
    class EmotionDiarySequenceService
      include TelegramMarkupHelper
      
      # Константы класса
      STEPS = {
        'situation' => {
          title: "*Шаг 1: Ситуация*",
          instruction: "Опишите конкретную ситуацию, которая вызвала у вас негативные чувства. Это может быть что-то, что произошло на работе, в личной жизни, или даже просто мысль, которая пришла в голову.\n\nБудьте максимально конкретны: кто, что, где, когда.\n\nПример: Я получил(а) отказ на собеседовании.",
          next_step: 'thoughts'
        },
        'thoughts' => {
          title: "*Шаг 2: Мысли*",
          instruction: "Запишите мысли, которые возникли у вас в этой ситуации.\nЧто вы думали о себе, о других, о ситуации в целом?\n\nЭти мысли могут быть автоматическими, быстрыми и не всегда осознанными. Постарайтесь их выявить.\n\nПример: Я ни на что не гожусь. Я никогда не найду работу.",
          next_step: 'emotions'
        },
        'emotions' => {
          title: "*Шаг 3: Эмоции*",
          instruction: "Опишите ваши чувства, которые были результатом этих мыслей.\nЧто вы чувствовали (например, тревогу, грусть, гнев)?",
          next_step: 'behavior'
        },
        'behavior' => {
          title: "*Шаг 4: Поведение*",
          instruction: "Опишите ваше поведение.\nКак вы поступили (например, спорили, ушли в себя)?",
          next_step: 'evidence_against'
        },
        'evidence_against' => {
          title: "*Шаг 5: Анализ мыслей*",
          instruction: "Теперь постарайтесь оспорить свои мысли из шага 2.\nЗадайте себе вопросы:\n• Есть ли доказательства, подтверждающие эту мысль?\n• Есть ли доказательства, опровергающие ее?\n• Какие есть альтернативные способы взглянуть на эту ситуацию?\n• Является ли эта мысль полезной для меня?\n\nПомните, что цель - не заменить негативные мысли позитивными, а сделать их более реалистичными и сбалансированными.\n\nПример: Доказательства, подтверждающие: Я получила отказ.\nДоказательства, опровергающие: У меня есть опыт и навыки, которые соответствуют многим другим вакансиям. Это было только одно собеседование.\nАльтернативный взгляд: Возможно, я просто не подошла для этой конкретной компании, или у них были другие кандидаты, которые лучше соответствовали их требованиям.\nПолезность мысли: Эта мысль только заставляет меня чувствовать себя хуже и мешает мне продолжать поиск работы.",
          next_step: 'new_thoughts'
        },
        'new_thoughts' => {
          title: "*Шаг 6: Новые мысли*",
          instruction: "Сформулируйте новую, более рациональную и полезную мысль, которая учитывает все ваши опровержения.\nЭта мысль должна быть более реалистичной и помогать вам чувствовать себя лучше и действовать более конструктивно.\n\nПример: Отказ на собеседовании - это неприятно, но это не значит, что я ни на что не гожусь. Я учту опыт этого собеседования и продолжу искать работу, которая мне подходит.",
          next_step: 'complete'
        }
      }.freeze
      
      STEP_KEYS = %w[situation thoughts emotions behavior evidence_against new_thoughts].freeze
      
      attr_reader :bot_service, :user, :chat_id, :current_step
      
      def initialize(bot_service, user, chat_id)
        @bot_service = bot_service
        @user = user
        @chat_id = chat_id
        
        # Инициализируем или восстанавливаем состояние
        @current_step = initialize_or_restore_state
      end
      
      def start
        send_current_step
      end
      
      def handle_answer(text)
        # Сохраняем ответ для текущего шага
        store_step_answer(@current_step, text)
        
        # Получаем следующий шаг
        next_step = STEPS[@current_step][:next_step]
        
        if next_step == 'complete'
          complete_diary_entry_for_day_10
        else
          # Переходим к следующему шагу
          @user.store_self_help_data('emotion_diary_current_step', next_step)
          @current_step = next_step
          
          # Добавляем небольшую задержку
          sleep(0.3) if Rails.env.development? || Rails.env.test?
          
          send_current_step
        end
        
        true
      end
      
      private
      
      def initialize_or_restore_state
        # Пытаемся восстановить состояние из user session
        stored_step = @user.get_self_help_data('emotion_diary_current_step')
        
        if stored_step.present? && STEPS.key?(stored_step)
          stored_step
        else
          # Начинаем с первого шага
          'situation'
        end
      end
      
      def send_current_step
        step_config = STEPS[@current_step]
        return unless step_config
        
        # Отправляем заголовок и инструкцию
        send_message(text: step_config[:title], parse_mode: 'Markdown')
        
        # Добавляем небольшую задержку для естественного отображения
        delay_between_messages
        
        send_message(text: step_config[:instruction])
      end
      
      def store_step_answer(step, answer)
        @user.store_self_help_data("emotion_diary_#{step}", answer)
      end
      
      def get_step_answer(step)
        @user.get_self_help_data("emotion_diary_#{step}")
      end
      
      def complete_diary_entry_for_day_10
        begin
          # Собираем все ответы
          diary_data = {}
          STEP_KEYS.each do |step|
            diary_data[step] = get_step_answer(step)
          end
          
          # Создаем запись в базе данных
          EmotionDiaryEntry.create!(
            user: @user,
            date: Date.current,
            situation: diary_data['situation'],
            thoughts: diary_data['thoughts'],
            emotions: diary_data['emotions'],
            behavior: diary_data['behavior'],
            evidence_against: diary_data['evidence_against'],
            new_thoughts: diary_data['new_thoughts']
          )
          
          # Очищаем временные данные
          clear_temporary_data
          
          # Отправляем сообщение о завершении
          send_message(
            text: "✅ *Дневник эмоций успешно заполнен и сохранен!*\n\nВы проделали отличную работу по анализу своих эмоций и мыслей.",
            parse_mode: 'Markdown'
          )
          
          # Показываем кнопку завершения дня 10
          send_message(
            text: "Нажмите кнопку, чтобы завершить день 10:",
            reply_markup: TelegramMarkupHelper.day_10_exercise_completed_markup
          )
          
        rescue ActiveRecord::RecordInvalid => e
          log_error("Ошибка при сохранении записи дневника", e)
          send_message(text: "Произошла ошибка при сохранении записи. Попробуйте еще раз.")
        end
      end
      
      def clear_temporary_data
        # Очищаем все временные данные дневника
        STEP_KEYS.each do |step|
          @user.store_self_help_data("emotion_diary_#{step}", nil)
        end
        @user.store_self_help_data('emotion_diary_current_step', nil)
        @user.store_self_help_data('is_filling_emotion_diary', nil)
      end
      
      def send_message(text:, reply_markup: nil, parse_mode: nil)
        @bot_service.send_message(
          chat_id: @chat_id,
          text: text,
          reply_markup: reply_markup,
          parse_mode: parse_mode
        )
      end
      
      def delay_between_messages
        # Небольшая задержка между сообщениями для более естественного отображения
        sleep(0.3) if Rails.env.test? || Rails.env.development?
      end
      
      def log_error(message, error = nil)
        Rails.logger.error "[EmotionDiarySequenceService] #{message} - User: #{@user.telegram_id}"
        Rails.logger.error error.message if error
      end
    end
  end
end
# app/services/emotion_diary_service.rb
class EmotionDiaryService
  include TelegramMarkupHelper
  
  # Константы
  DIARY_STEPS = {
    'situation' => {
      title: "Шаг 1: Ситуация",
      instruction: "Опишите конкретную ситуацию, которая вызвала у вас негативные чувства.\nЭто может быть что-то, что произошло на работе, в личной жизни, или даже просто мысль, которая пришла в голову.\nБудьте максимально конкретны: кто, что, где, когда.\nПример: Я получил(а) отказ на собеседовании."
    },
    'thoughts' => {
      title: "Шаг 2: Мысли",
      instruction: "Запишите мысли, которые возникли у вас в этой ситуации.\nЧто вы думали о себе, о других, о ситуации в целом?\nЭти мысли могут быть автоматическими, быстрыми и не всегда осознанными. Постарайтесь их выявить.\nПример: Я ни на что не гожусь. Я никогда не найду работу."
    },
    'emotions' => {
      title: "Шаг 3: Эмоции",
      instruction: "Опишите ваши чувства, которые были результатом этих мыслей.\nЧто вы чувствовали (например, тревогу, грусть, гнев)?"
    },
    'behavior' => {
      title: "Шаг 4: Поведение",
      instruction: "Опишите ваше поведение.\nКак вы поступили (например, спорили, ушли в себя)?"
    },
    'evidence_against' => {
      title: "Шаг 5: Анализ мыслей",
      instruction: "Теперь постарайтесь оспорить свои мысли из шага 2.\nЗадайте себе вопросы:\n• Есть ли доказательства, подтверждающие эту мысль?\n• Есть ли доказательства, опровергающие ее?\n• Какие есть альтернативные способы взглянуть на эту ситуацию?\n• Является ли эта мысль полезной для меня?\nПомните, что цель - не заменить негативные мысли позитивными, а сделать их более реалистичными и сбалансированными.\nПример: Доказательства, подтверждающие: Я получила отказ.\nДоказательства, опровергающие: У меня есть опыт и навыки, которые соответствуют многим другим вакансиям. Это было только одно собеседование.\nАльтернативный взгляд: Возможно, я просто не подошла для этой конкретной компании, или у них были другие кандидаты, которые лучше соответствовали их требованиям.\nПолезность мысли: Эта мысль только заставляет меня чувствовать себя хуже и мешает мне продолжать поиск работы."
    },
    'new_thoughts' => {
      title: "Шаг 6: Новые мысли",
      instruction: "Сформулируйте новую, более рациональную и полезную мысль, которая учитывает все ваши опровержения.\nЭта мысль должна быть более реалистичной и помогать вам чувствовать себя лучше и действовать более конструктивно.\nПример: Отказ на собеседовании - это неприятно, но это не значит, что я ни на что не гожусь. Я учту опыт этого собеседования и продолжу искать работу, которая мне подходит."
    }
  }.freeze
  
  DIARY_STEP_ORDER = %w[situation thoughts emotions behavior evidence_against new_thoughts].freeze
  
  attr_reader :bot_service, :bot, :user, :chat_id
  
  def initialize(bot_or_service, user, chat_id)
    @user = user
    @chat_id = chat_id
    
    # Определяем, что передано: bot или bot_service
    if bot_or_service.respond_to?(:bot)
      # Передан bot_service
      @bot_service = bot_or_service
      @bot = @bot_service.bot
    elsif bot_or_service.respond_to?(:send_message)
      # Передан bot (Telegram::Bot::Client)
      @bot = bot_or_service
      @bot_service = create_bot_service_wrapper(@bot)
    else
      raise ArgumentError, "Expected TelegramBotService or Telegram::Bot::Client"
    end
  end
  
  # Показать меню дневника эмоций
  def start_diary_menu
    send_message(
      text: "Дневник эмоций. Выберите действие:",
      reply_markup: emotion_diary_menu_markup
    )
  end
  
  # Начать новую запись
  def start_new_entry
    @user.start_diary_entry
    send_current_step
  end
  
  # Обработка ответа пользователя
  def handle_answer(text)
    current_step = @user.current_diary_step
    
    unless DIARY_STEPS.key?(current_step)
      send_message(text: "Неизвестный шаг дневника.")
      return false
    end
    
    # Сохраняем ответ
    @user.update_diary_data(current_step, text)
    
    # Переходим к следующему шагу или завершаем
    next_step_index = DIARY_STEP_ORDER.index(current_step) + 1
    
    if next_step_index < DIARY_STEP_ORDER.length
      next_step = DIARY_STEP_ORDER[next_step_index]
      @user.update(current_diary_step: next_step)
      send_current_step
    else
      complete_diary_entry
    end
    
    true
  rescue ActiveRecord::RecordInvalid => e
    log_error("Ошибка при обновлении данных дневника", e)
    send_message(text: "Произошла ошибка при сохранении. Попробуйте еще раз.")
    false
  end
  
  # Показать записи пользователя
  def show_entries(limit = 10)
    entries = @user.emotion_diary_entries.recent.limit(limit)
    
    if entries.empty?
      send_message(text: "У вас пока нет записей в дневнике.")
      return
    end
    
    message = "📔 *Ваши записи в дневнике эмоций*\n\n"
    
    entries.each_with_index do |entry, index|
      message += "*#{index + 1}. #{entry.date.strftime('%d.%m.%Y')}*\n"
      message += "  🎯 Ситуация: #{entry.situation.truncate(50)}\n"
      message += "  💭 Мысли: #{entry.thoughts.truncate(50)}\n"
      message += "  😊 Эмоции: #{entry.emotions.truncate(50)}\n"
      message += "  🚶 Поведение: #{entry.behavior.truncate(50)}\n"
      message += "  🔍 Анализ: #{entry.evidence_against.truncate(50)}\n"
      message += "  🌟 Новые мысли: #{entry.new_thoughts.truncate(50)}\n"
      message += "  ─" * 20 + "\n\n"
    end
    
    send_message(text: message, parse_mode: 'Markdown')
    
    # Показать меню после записей
    send_message(
      text: "Что хотите сделать дальше?",
      reply_markup: emotion_diary_menu_markup
    )
  end
  
  private

  def create_bot_service_wrapper(bot)
    # Создаем простую обертку вокруг bot
    Class.new do
      def initialize(bot)
        @bot = bot
      end
      
      def send_message(chat_id:, text:, reply_markup: nil, parse_mode: nil)
        @bot.send_message(
          chat_id: chat_id,
          text: text,
          reply_markup: reply_markup,
          parse_mode: parse_mode
        )
      end
      
      def bot
        @bot
      end
    end.new(bot)
  end
  
  # Отправить текущий шаг пользователю
  def send_current_step
    current_step = @user.current_diary_step
    step_config = DIARY_STEPS[current_step]
    
    return unless step_config
    
    # Отправляем заголовок шага
    if step_config[:title]
      send_message(text: "*#{step_config[:title]}*", parse_mode: 'Markdown')
    end
    
    # Отправляем инструкцию
    send_message(text: step_config[:instruction])
  end
  
  # Завершить запись в дневнике
  def complete_diary_entry
    begin
      # Создаем запись в базе данных
      EmotionDiaryEntry.create!(
        user: @user,
        date: Date.current,
        situation: @user.diary_data['situation'],
        thoughts: @user.diary_data['thoughts'],
        emotions: @user.diary_data['emotions'],
        behavior: @user.diary_data['behavior'],
        evidence_against: @user.diary_data['evidence_against'],
        new_thoughts: @user.diary_data['new_thoughts']
      )
      
      # Сбрасываем состояние пользователя
      @user.complete_diary_entry
      
      # Проверяем контекст (программа самопомощи или обычный дневник)
      handle_completion_context
      
    rescue ActiveRecord::RecordInvalid => e
      log_error("Ошибка при сохранении записи дневника", e)
      send_message(text: "Произошла ошибка при сохранении записи. Попробуйте еще раз.")
    end
  end
  
  # Обработка контекста завершения
  def handle_completion_context
    # Проверяем контекст через данные пользователя
    diary_context = @user.get_self_help_data('emotion_diary_context')
    
    # Если пользователь в программе самопомощи (День 10)
    if diary_context == 'day_10'
      # Очищаем контекст
      @user.store_self_help_data('emotion_diary_context', nil)
      
      # Возвращаемся в контекст программы
      send_message(
        text: "✅ Дневник эмоций заполнен и сохранен!\n\nВозвращаемся к программе самопомощи...",
        reply_markup: TelegramMarkupHelper.day_10_exercise_completed_markup
      )
    else
      # Обычное поведение
      send_message(
        text: "✅ Дневник заполнен и сохранен!\n\nЧто хотите сделать дальше?",
        reply_markup: emotion_diary_menu_markup
      )
    end
  end
  
  # Отправка сообщения
  def send_message(text:, reply_markup: nil, parse_mode: nil)
    @bot_service.send_message(
      chat_id: @chat_id,
      text: text,
      reply_markup: reply_markup,
      parse_mode: parse_mode
    )
  end
  
  # Логирование
  def log_info(message)
    Rails.logger.info "[EmotionDiaryService] #{message} - User: #{@user.telegram_id}"
  end
  
  def log_error(message, error = nil)
    Rails.logger.error "[EmotionDiaryService] #{message} - User: #{@user.telegram_id}"
    Rails.logger.error error.message if error
  end
end
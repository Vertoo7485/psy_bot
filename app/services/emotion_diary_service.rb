# app/services/emotion_diary_service.rb
class EmotionDiaryService
  include TelegramMarkupHelper # Для генерации клавиатур

  DIARY_STEPS = {
    'situation' => "Шаг 1: Опишите конкретную ситуацию, которая вызвала у вас негативные чувства. \nЭто может быть что-то, что произошло на работе, в личной жизни, или даже просто мысль, которая пришла в голову. \nБудьте максимально конкретны: кто, что, где, когда.\nПример: Я получил(а) отказ на собеседовании.",
    'thoughts' => "Шаг 2: Запишите мысли, которые возникли у вас в этой ситуации.\nЧто вы думали о себе, о других, о ситуации в целом?\nЭти мысли могут быть автоматическими, быстрыми и не всегда осознанными. Постарайтесь их выявить.\nПример: Я ни на что не гожусь. Я никогда не найду работу.",
    'emotions' => "Шаг 3: Опишите ваши чувства, которые были результатом этих мыслей.\nЧто вы чувствовали (например, тревогу, грусть, гнев)?",
    'behavior' => "Шаг 4: Опишите ваши поведение.\nКак вы поступили (например, спорили, ушли в себя)?",
    'evidence_against' => "Шаг 5: Теперь постарайтесь оспорить свои мысли из шага 2. \nЗадайте себе вопросы: Есть ли доказательства, подтверждающие эту мысль? \nЕсть ли доказательства, опровергающие ее? \nКакие есть альтернативные способы взглянуть на эту ситуацию? \nЯвляется ли эта мысль полезной для меня? Помните, что цель - не заменить негативные мысли позитивными, а сделать их более реалистичными и сбалансированными.\nПример: Доказательства, подтверждающие: Я получила отказ.\nДоказательства, опровергающие: У меня есть опыт и навыки, которые соответствуют многим другим вакансиям. Это было только одно собеседование.\nАльтернативный взгляд: Возможно, я просто не подошла для этой конкретной компании, или у них были другие кандидаты, которые лучше соответствовали их требованиям.\nПолезность мысли: Эта мысль только заставляет меня чувствовать себя хуже и мешает мне продолжать поиск работы.",
    'new_thoughts' => "Шаг 6: Сформулируйте новую, более рациональную и полезную мысль, которая учитывает все ваши опровержения.\nЭта мысль должна быть более реалистичной и помогать вам чувствовать себя лучше и действовать более конструктивно.\nПример: Отказ на собеседовании - это неприятно, но это не значит, что я ни на что не гожусь. Я учту опыт этого собеседования и продолжу искать работу, которая мне подходит."
  }.freeze

  DIARY_STEP_ORDER = %w[situation thoughts emotions behavior evidence_against new_thoughts].freeze

  def initialize(bot_service, user, chat_id)
    @bot_service = bot_service # Теперь это экземпляр Telegram::TelegramBotService
    @bot = bot_service     # И это правильно получает Telegram::Bot::Client
    @user = user
    @chat_id = chat_id
  end

  def start_diary_menu
    @bot.send_message(chat_id: @chat_id, text: "Выберите действие:", reply_markup: emotion_diary_menu_markup)
  end

  def start_new_entry
    @user.update(current_diary_step: 'situation', diary_data: {})
    @bot.send_message(chat_id: @chat_id, text: DIARY_STEPS['situation'])
  end

  def handle_answer(text)
  current_step = @user.current_diary_step
  return @bot_service.send_message(chat_id: @chat_id, text: "Неизвестный шаг дневника.") unless DIARY_STEPS.key?(current_step)

  @user.diary_data[current_step] = text
  next_step_index = DIARY_STEP_ORDER.index(current_step) + 1

  if next_step_index < DIARY_STEP_ORDER.length
    next_step = DIARY_STEP_ORDER[next_step_index]
    @user.update(current_diary_step: next_step, diary_data: @user.diary_data)
    @bot_service.send_message(chat_id: @chat_id, text: DIARY_STEPS[next_step])
  else
    # Последний шаг, сохраняем запись
    EmotionDiaryEntry.create!(
      user: @user,
      date: Date.today,
      situation: @user.diary_data['situation'],
      thoughts: @user.diary_data['thoughts'],
      emotions: @user.diary_data['emotions'],
      behavior: @user.diary_data['behavior'],
      evidence_against: @user.diary_data['evidence_against'],
      new_thoughts: @user.diary_data['new_thoughts']
    )
    
    @user.update(current_diary_step: nil, diary_data: {})
    
    # ПРОВЕРКА: Если пользователь в программе самопомощи (День 10)
    if @user.get_self_help_step == 'day_10_exercise_in_progress'
      # Возвращаемся в контекст программы
      @bot_service.send_message(
        chat_id: @chat_id,
        text: "✅ Дневник эмоций заполнен и сохранен!\n\n" \
              "Вернемся к программе самопомощи...",
        reply_markup: TelegramMarkupHelper.day_10_exercise_completed_markup
      )
    else
      # Обычное поведение
      @bot_service.send_message(
        chat_id: @chat_id,
        text: "Дневник заполнен и сохранен! Выберите следующее действие:",
        reply_markup: TelegramMarkupHelper.main_menu_markup
      )
    end
  end
rescue ActiveRecord::RecordInvalid => e
  Rails.logger.error "Ошибка при сохранении записи дневника: #{e.message}"
  @bot_service.send_message(chat_id: @chat_id, text: "Произошла ошибка при сохранении записи. Попробуйте еще раз.")
end

  def show_entries
    entries = @user.emotion_diary_entries.order(date: :desc)

    if entries.empty?
      @bot.send_message(chat_id: @chat_id, text: "У вас пока нет записей в дневнике.")
      return
    end

    message = "Ваши записи в дневнике:\n\n"
    entries.each_with_index do |entry, index|
      message += "#{index + 1}. *#{entry.date.strftime('%d.%m.%Y')}*\n"
      message += "  - Ситуация: #{entry.situation.truncate(50)}\n"
      message += "  - Мысли: #{entry.thoughts.truncate(50)}\n"
      message += "  - Эмоции: #{entry.emotions.truncate(50)}\n"
      message += "  - Поведение: #{entry.behavior.truncate(50)}\n"
      message += "  - Доказательства против: #{entry.evidence_against.truncate(50)}\n"
      message += "  - Новые мысли: #{entry.new_thoughts.truncate(50)}\n"
      message += "\n"
    end

    @bot.send_message(chat_id: @chat_id, text: message, parse_mode: 'Markdown')
  end
end

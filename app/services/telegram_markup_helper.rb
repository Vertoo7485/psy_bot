# app/services/telegram_markup_helper.rb
module TelegramMarkupHelper
  extend self
  
  # Основные константы для эмодзи
  EMOJI = {
    home: '🏠',
    tests: '📋',
    diary: '📔',
    self_help: '⭐️',
    help: '🆘',
    back: '⬅️',
    home: '🏠',
    check: '✅',
    warning: '⚠️',
    info: 'ℹ️',
    settings: '⚙️',
    calendar: '📅',
    clock: '⏰',
    heart: '❤️',
    brain: '🧠',
    yoga: '🧘',
    exercise: '🏃',
    music: '🎵',
    book: '📚',
    video: '🎬',
    friend: '👥',
    thought: '💭',
    gratitude: '🙏',
    reflection: '📖',
    procrastination: '🚀',
    grounding: '🌍',
    compassion: '💝'
  }.freeze
  
  # Главное меню
  def main_menu_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:tests]} Список тестов", callback_data: 'show_test_categories' }
        ],
        [
          { text: "#{EMOJI[:diary]} Дневник эмоций", callback_data: 'start_emotion_diary' }
        ],
        [
          { text: "#{EMOJI[:self_help]} Программа самопомощи", callback_data: 'start_self_help_program' }
        ],
        [
          { text: "#{EMOJI[:help]} Помощь", callback_data: 'help' }
        ]
      ]
    }.to_json
  end
  
  # Кнопка "Назад в главное меню"
  def back_to_main_menu_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:back]} Назад в главное меню", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end
  
  # Категории тестов
  def test_categories_markup
    test_buttons = []
    
    # Добавляем стандартные тесты
    test_buttons << [
      { text: "#{EMOJI[:brain]} Тест Тревожности", callback_data: 'prepare_anxiety_test' }
    ]
    
    test_buttons << [
      { text: "#{EMOJI[:heart]} Тест Депрессии (PHQ-9)", callback_data: 'prepare_depression_test' }
    ]
    
    test_buttons << [
      { text: "#{EMOJI[:brain]} Тест EQ (Эмоциональный Интеллект)", callback_data: 'prepare_eq_test' }
    ]
    
    test_buttons << [
      { text: "#{EMOJI[:yoga]} Тест Люшера (8 цветов)", callback_data: 'prepare_luscher_test' }
    ]
    
    # Кнопка назад
    test_buttons << [
      { text: "#{EMOJI[:back]} Назад", callback_data: 'back_to_main_menu' }
    ]
    
    { inline_keyboard: test_buttons }.to_json
  end
  
  # Меню дневника эмоций
  def emotion_diary_menu_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:diary]} Новая запись", callback_data: 'new_emotion_diary_entry' }
        ],
        [
          { text: "#{EMOJI[:calendar]} Мои записи", callback_data: 'show_emotion_diary_entries' }
        ],
        [
          { text: "#{EMOJI[:back]} Назад", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end
  
  # Введение в программу самопомощи
  def self_help_intro_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Начать программу", callback_data: 'start_self_help_program_tests' }
        ]
      ]
    }.to_json
  end
  
  # Разметка для возобновления программы
  def resume_program_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Продолжить программу", callback_data: 'resume_session' }
        ],
        [
          { text: "#{EMOJI[:warning]} Начать заново", callback_data: 'restart_self_help_program' }
        ],
        [
          { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end
  
  # Универсальная разметка Да/Нет
  def yes_no_markup(callback_data_yes: 'yes', callback_data_no: 'no', show_back: false)
    buttons = [
      [
        { text: "#{EMOJI[:check]} Да", callback_data: callback_data_yes },
        { text: "#{EMOJI[:warning]} Нет", callback_data: callback_data_no }
      ]
    ]
    
    if show_back
      buttons << [
        { text: "#{EMOJI[:back]} Назад", callback_data: 'back_to_main_menu' }
      ]
    end
    
    { inline_keyboard: buttons }.to_json
  end
  
  # Методы для дней программы самопомощи
  
  # День 1
  def day_1_content_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Начать первый день", callback_data: 'start_day_1_content' }
        ],
        [
          { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end
  
  def day_1_continue_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Продолжить изучение дня 1", callback_data: 'continue_day_1_content' }
        ],
        [
          { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end
  
  def day_1_exercise_completed_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Завершить упражнение", callback_data: 'day_1_exercise_completed' }
        ]
      ]
    }.to_json
  end

    # Новые методы для Дня 1 (переработанного)
  def day_1_breathing_techniques_markup
    {
      inline_keyboard: [
        [
          { text: "🌊 Естественное дыхание", callback_data: 'day_1_breathing_0' },
          { text: "🌀 4-7-8 дыхание", callback_data: 'day_1_breathing_1' }
        ],
        [
          { text: "⬜ Квадратное дыхание", callback_data: 'day_1_breathing_2' },
          { text: "🌬️ Диафрагмальное", callback_data: 'day_1_breathing_3' }
        ],
        [
          { text: "❓ Помощь в выборе", callback_data: 'day_1_help_choose' }
        ]
      ]
    }.to_json
  end

  def day_1_practice_timer_markup
    {
      inline_keyboard: [
        [
          { text: "⏱️ 5 минут", callback_data: 'day_1_timer_5' },
          { text: "⏱️ 10 минут", callback_data: 'day_1_timer_10' }
        ],
        [
          { text: "⏱️ 15 минут", callback_data: 'day_1_timer_15' },
          { text: "⏰ Свой таймер", callback_data: 'day_1_timer_custom' }
        ]
      ]
    }.to_json
  end

  def day_1_practice_completion_markup
    {
      inline_keyboard: [
        [
          { text: "✅ Завершить практику", callback_data: 'day_1_practice_complete' }
        ],
        [
          { text: "🔄 Начать заново", callback_data: 'day_1_practice_restart' },
          { text: "❌ Прервать", callback_data: 'day_1_practice_cancel' }
        ]
      ]
    }.to_json
  end

  def day_1_challenges_markup
    {
      inline_keyboard: [
        [
          { text: "🌀 Ум блуждает", callback_data: 'day_1_challenge_0' },
          { text: "😣 Не расслабляюсь", callback_data: 'day_1_challenge_1' }
        ],
        [
          { text: "💭 Слишком мыслей", callback_data: 'day_1_challenge_2' },
          { text: "⏰ Нет времени", callback_data: 'day_1_challenge_3' }
        ],
        [
          { text: "✅ Никаких трудностей", callback_data: 'day_1_no_challenges' }
        ]
      ]
    }.to_json
  end

  def day_1_final_completion_markup
    {
      inline_keyboard: [
        [
          { text: "🎯 Завершить День 1", callback_data: 'day_1_complete_exercise' },
          { text: "🔄 Повторить практику", callback_data: 'day_1_restart_practice' }
        ],
        [
          { text: "📝 Сделать заметку", callback_data: 'day_1_make_note' }
        ]
      ]
    }.to_json
  end

  # Метод для предложения дня 1 (для единообразия)
  def self.day_1_start_proposal_markup
    { inline_keyboard: [[{ text: "#{EMOJI[:check]} Начать День 1", callback_data: 'start_day_1_from_proposal' }]] }.to_json
  end

  
  # День 3
  def day_3_menu_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:gratitude]} Ввести благодарности", callback_data: 'day_3_enter_gratitude' }
        ],
        [
          { text: "#{EMOJI[:calendar]} Посмотреть мои записи", callback_data: 'show_gratitude_entries' }
        ],
        [
          { text: "#{EMOJI[:check]} Завершить День 3", callback_data: 'complete_day_3' }
        ],
        [
          { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end

  def day_4_observation_techniques_markup
    {
      inline_keyboard: [
        [
          { text: "🎨 Цветовые пятна", callback_data: 'day_4_technique_0' },
          { text: "🌀 Контуры и формы", callback_data: 'day_4_technique_1' }
        ],
        [
          { text: "🌳 Детали природы", callback_data: 'day_4_technique_2' },
          { text: "🏛️ Архитектурные линии", callback_data: 'day_4_technique_3' }
        ],
        [
          { text: "🔄 Взгляд ребенка", callback_data: 'day_4_technique_4' },
          { text: "🖼️ Картина как медитация", callback_data: 'day_4_technique_5' }
        ],
        [
          { text: "❓ Помощь в выборе", callback_data: 'day_4_help_choose' }
        ]
      ]
    }.to_json
  end

  def day_4_observation_timer_markup
    {
      inline_keyboard: [
        [
          { text: "⏱️ 3 минуты", callback_data: 'day_4_timer_3' },
          { text: "⏱️ 5 минут", callback_data: 'day_4_timer_5' }
        ],
        [
          { text: "⏱️ 7 минут", callback_data: 'day_4_timer_7' },
          { text: "⏰ Свой таймер", callback_data: 'day_4_timer_custom' }
        ]
      ]
    }.to_json
  end

  def day_4_practice_completion_markup
    {
      inline_keyboard: [
        [
          { text: "✅ Завершить практику", callback_data: 'day_4_practice_complete' }
        ],
        [
          { text: "🔄 Наблюдать другой объект", callback_data: 'day_4_practice_restart' },
          { text: "❌ Прервать", callback_data: 'day_4_practice_cancel' }
        ]
      ]
    }.to_json
  end

  def day_4_challenges_markup
    {
      inline_keyboard: [
        [
          { text: "🌀 Глаза устают", callback_data: 'day_4_challenge_0' },
          { text: "😣 Трудно концентрироваться", callback_data: 'day_4_challenge_1' }
        ],
        [
          { text: "💭 Мысли мешают", callback_data: 'day_4_challenge_2' },
          { text: "👁️ Не вижу ничего особенного", callback_data: 'day_4_challenge_3' }
        ],
        [
          { text: "✅ Никаких трудностей", callback_data: 'day_4_no_challenges' }
        ]
      ]
    }.to_json
  end

  def day_4_final_completion_markup
    {
      inline_keyboard: [
        [
          { text: "🎯 Завершить День 4", callback_data: 'day_4_complete_exercise' },
          { text: "🔄 Повторить практику", callback_data: 'day_4_restart_practice' }
        ],
        [
          { text: "📝 Сделать заметку", callback_data: 'day_4_make_note' }
        ]
      ]
    }.to_json
  end
  
  
  # День 4
  def day_4_exercise_consent_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Да, готов(а)!", callback_data: 'start_day_4_exercise' },
          { text: "#{EMOJI[:warning]} Нет, позже", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end
  
  def day_4_exercise_completed_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Я выполнил(а) упражнение", callback_data: 'day_4_exercise_completed' }
        ]
      ]
    }.to_json
  end
  
  # День 5
  def start_day_5_exercise_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:exercise]} Начать упражнение", callback_data: 'start_day_5_exercise' }
        ]
      ]
    }.to_json
  end
  
  def day_5_activity_types_markup
    {
      inline_keyboard: [
        [
          { text: "🚶 Прогулка", callback_data: 'day_5_activity_0' },
          { text: "💃 Танцы", callback_data: 'day_5_activity_1' }
        ],
        [
          { text: "🧘 Йога/растяжка", callback_data: 'day_5_activity_2' },
          { text: "🏋️ Силовая", callback_data: 'day_5_activity_3' }
        ],
        [
          { text: "🏃 Кардио", callback_data: 'day_5_activity_4' },
          { text: "🤸 Функциональная", callback_data: 'day_5_activity_5' }
        ],
        [
          { text: "❓ Помощь в выборе", callback_data: 'day_5_help_choose' }
        ]
      ]
    }.to_json
  end

  def day_5_duration_markup
    {
      inline_keyboard: [
        [
          { text: "⏱️ 10 минут", callback_data: 'day_5_duration_10' },
          { text: "⏱️ 20 минут", callback_data: 'day_5_duration_20' }
        ],
        [
          { text: "⏱️ 30 минут", callback_data: 'day_5_duration_30' },
          { text: "⏰ Свое время", callback_data: 'day_5_duration_custom' }
        ]
      ]
    }.to_json
  end

  def day_5_activity_completion_markup
    {
      inline_keyboard: [
        [
          { text: "✅ Завершить активность", callback_data: 'day_5_activity_complete' }
        ],
        [
          { text: "🔄 Сменить активность", callback_data: 'day_5_activity_restart' },
          { text: "❌ Прервать", callback_data: 'day_5_activity_cancel' }
        ]
      ]
    }.to_json
  end

  def day_5_mood_changes_markup
    {
      inline_keyboard: [
        [
          { text: "😊 Значительно лучше", callback_data: 'day_5_mood_0' },
          { text: "🙂 Немного лучше", callback_data: 'day_5_mood_1' }
        ],
        [
          { text: "😐 Без изменений", callback_data: 'day_5_mood_2' },
          { text: "😔 Хуже (усталость)", callback_data: 'day_5_mood_3' }
        ],
        [
          { text: "📝 Описать подробнее", callback_data: 'day_5_mood_describe' }
        ]
      ]
    }.to_json
  end

  def day_5_final_completion_markup
    {
      inline_keyboard: [
        [
          { text: "🎯 Завершить День 5", callback_data: 'day_5_complete_exercise' },
          { text: "🔄 Добавить еще активность", callback_data: 'day_5_add_more_activity' }
        ],
        [
          { text: "📝 Сделать заметку", callback_data: 'day_5_make_note' }
        ]
      ]
    }.to_json
  end
  
  def self.day_5_challenges_markup
    {
      inline_keyboard: [
        [
          { text: "🌀 Нет энергии или мотивации", callback_data: 'day_5_challenge_0' },
          { text: "😣 Тело болит или дискомфортно", callback_data: 'day_5_challenge_1' }
        ],
        [
          { text: "💭 Постоянно отвлекают мысли", callback_data: 'day_5_challenge_2' },
          { text: "⏰ Нет времени или места", callback_data: 'day_5_challenge_3' }
        ],
        [
          { text: "✅ Никаких трудностей", callback_data: 'day_5_no_challenges' }
        ]
      ]
    }.to_json
  end
  
  # Новый метод для вертикального форматирования
  def self.day_5_challenges_vertical_markup
    {
      inline_keyboard: [
        [
          { text: "🌀 Нет энергии или мотивации", callback_data: 'day_5_challenge_0' }
        ],
        [
          { text: "😣 Тело болит или дискомфортно", callback_data: 'day_5_challenge_1' }
        ],
        [
          { text: "💭 Постоянно отвлекают мысли", callback_data: 'day_5_challenge_2' }
        ],
        [
          { text: "⏰ Нет времени или места", callback_data: 'day_5_challenge_3' }
        ],
        [
          { text: "✅ Никаких трудностей", callback_data: 'day_5_no_challenges' }
        ]
      ]
    }.to_json
  end

  # Метод для предложения дня 5
  def self.day_5_start_proposal_markup
    { inline_keyboard: [[{ text: "🏃 Начать День 5", callback_data: 'start_day_5_from_proposal' }]] }.to_json
  end
  
  # День 6
  def self.day_6_exercise_completed_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Я отдохнул и готов продолжить", callback_data: 'day_6_exercise_completed' }
        ]
      ]
    }.to_json
  end
  
  # Метод для предложения дня 6
  def self.day_6_start_proposal_markup
    { inline_keyboard: [[{ text: "😌 Начать День 6", callback_data: 'start_day_6_from_proposal' }]] }.to_json
  end
  
  # День 7
  def day_7_reflection_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:back]} Отменить рефлексию", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end
  
  def complete_program_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Завершить неделю", callback_data: 'complete_day_7' }
        ]
      ]
    }.to_json
  end
  
  # День 8
  def day_8_content_markup
    {
      inline_keyboard: [
        [
          { text: "🛑 Начать практику остановки мыслей", callback_data: 'start_day_8_content' }
        ],
        [
          { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end

  def day_8_stop_signals_markup
    {
      inline_keyboard: [
        [
          { text: "🗣️ Мысленная команда", callback_data: 'day_8_stop_signal_0' },
          { text: "🛑 Визуальный образ", callback_data: 'day_8_stop_signal_1' }
        ],
        [
          { text: "👏 Физический сигнал", callback_data: 'day_8_stop_signal_2' },
          { text: "🔊 Звуковой сигнал", callback_data: 'day_8_stop_signal_3' }
        ],
        [
          { text: "🌬️ Дыхательный стоп", callback_data: 'day_8_stop_signal_4' },
          { text: "✋ Движение-стоп", callback_data: 'day_8_stop_signal_5' }
        ],
        [
          { text: "❓ Помогите выбрать", callback_data: 'day_8_help_choose_signal' }
        ]
      ]
    }.to_json
  end

  def day_8_distraction_strategies_markup
    {
      inline_keyboard: [
        [
          { text: "🌬️ Дыхание 4-7-8", callback_data: 'day_8_distraction_0' },
          { text: "👁️ Сенсорное сканирование", callback_data: 'day_8_distraction_1' }
        ],
        [
          { text: "🏃 Физическая активность", callback_data: 'day_8_distraction_2' },
          { text: "🔢 Счет или алфавит", callback_data: 'day_8_distraction_3' }
        ],
        [
          { text: "🎨 Креативная задача", callback_data: 'day_8_distraction_4' },
          { text: "🌳 Внешний фокус", callback_data: 'day_8_distraction_5' }
        ]
      ]
    }.to_json
  end

  def day_8_practice_completion_markup
    {
      inline_keyboard: [
        [
          { text: "✅ Завершить практику", callback_data: 'day_8_practice_complete' }
        ],
        [
          { text: "🔄 Начать заново", callback_data: 'day_8_practice_restart' },
          { text: "💭 Сменить мысль", callback_data: 'day_8_change_thought' }
        ]
      ]
    }.to_json
  end

  def day_8_challenges_markup
    {
      inline_keyboard: [
        [
          { text: "🌀 Мысль возвращается", callback_data: 'day_8_challenge_0' }
        ],
        [
          { text: "😳 Чувствую себя глупо", callback_data: 'day_8_challenge_1' }
        ],
        [
          { text: "🤔 Не могу выбрать мысль", callback_data: 'day_8_challenge_2' }
        ],
        [
          { text: "🔄 Стоп-сигнал не работает", callback_data: 'day_8_challenge_3' }
        ],
        [
          { text: "✅ Никаких трудностей", callback_data: 'day_8_no_challenges' }
        ]
      ]
    }.to_json
  end

  def day_8_final_completion_markup
    {
      inline_keyboard: [
        [
          { text: "🎯 Завершить День 8", callback_data: 'day_8_complete_exercise' },
          { text: "🔄 Повторить практику", callback_data: 'day_8_restart_practice' }
        ]
      ]
    }.to_json
  end

  # И обновим старые методы для совместимости:
  def day_8_consent_markup
    # Перенаправляем на новый метод
    day_8_content_markup
  end

  def day_8_stopped_thought_first_try_markup
    # Этот метод больше не используется в новом стиле
    {
      inline_keyboard: [
        [
          { text: "⚠️ Используйте новую систему", callback_data: 'start_day_8_content' }
        ]
      ]
    }.to_json
  end

  def day_8_distraction_options_markup
    # Перенаправляем на новый метод
    day_8_distraction_strategies_markup
  end

  def day_8_exercise_completed_markup
    # Перенаправляем на новый метод
    day_8_final_completion_markup
  end
  
  # День 9
    def day_9_content_markup
    {
      inline_keyboard: [
        [
          { text: "🧠 Начать когнитивный анализ", callback_data: 'start_day_9_content' }
        ],
        [
          { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end

  def day_9_input_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:back]} Отменить ввод", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end

  def day_9_back_to_menu_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Завершить анализ", callback_data: 'complete_day_9' }
        ]
      ]
    }.to_json
  end

  def day_9_probability_markup
    {
      inline_keyboard: [
        [
          { text: "1️⃣", callback_data: 'day_9_probability_1' },
          { text: "2️⃣", callback_data: 'day_9_probability_2' },
          { text: "3️⃣", callback_data: 'day_9_probability_3' },
          { text: "4️⃣", callback_data: 'day_9_probability_4' },
          { text: "5️⃣", callback_data: 'day_9_probability_5' }
        ],
        [
          { text: "6️⃣", callback_data: 'day_9_probability_6' },
          { text: "7️⃣", callback_data: 'day_9_probability_7' },
          { text: "8️⃣", callback_data: 'day_9_probability_8' },
          { text: "9️⃣", callback_data: 'day_9_probability_9' },
          { text: "🔟", callback_data: 'day_9_probability_10' }
        ],
        [
          { text: "❓ Помощь с оценкой", callback_data: 'day_9_help_probability' }
        ]
      ]
    }.to_json
  end

  def day_9_facts_pro_markup
    {
      inline_keyboard: [
        [
          { text: "✅ Ввести факты «за»", callback_data: 'day_9_enter_facts_pro' }
        ],
        [
          { text: "❓ Помощь с фактами", callback_data: 'day_9_help_facts' }
        ]
      ]
    }.to_json
  end

  def day_9_facts_con_markup
    {
      inline_keyboard: [
        [
          { text: "❌ Ввести факты «против»", callback_data: 'day_9_enter_facts_con' }
        ],
        [
          { text: "❓ Помощь с фактами", callback_data: 'day_9_help_facts' }
        ]
      ]
    }.to_json
  end

  def day_9_reframing_markup
    {
      inline_keyboard: [
        [
          { text: "💡 Ввести рефрейминг", callback_data: 'day_9_enter_reframe' }
        ],
        [
          { text: "❓ Помощь с рефреймингом", callback_data: 'day_9_help_reframe' }
        ]
      ]
    }.to_json
  end

  def day_9_cognitive_distortions_markup
    {
      inline_keyboard: [
        [
          { text: "🌀 Катастрофизация", callback_data: 'day_9_distortion_0' },
          { text: "⚫️⚪️ Чёрно-белое", callback_data: 'day_9_distortion_1' }
        ],
        [
          { text: "⬇️ Обесценивание", callback_data: 'day_9_distortion_2' },
          { text: "🔮 Чтение мыслей", callback_data: 'day_9_distortion_3' }
        ],
        [
          { text: "♾️ Сверхобобщение", callback_data: 'day_9_distortion_4' },
          { text: "🎯 Персонализация", callback_data: 'day_9_distortion_5' }
        ]
      ]
    }.to_json
  end

  def day_9_continue_markup
    {
      inline_keyboard: [
        [
          { text: "🔄 Продолжить анализ", callback_data: 'continue_day_9_content' },
          { text: "📊 Показать прогресс", callback_data: 'day_9_show_current' }
        ]
      ]
    }.to_json
  end

  def day_9_final_completion_markup
    {
      inline_keyboard: [
        [
          { text: "🎯 Завершить День 9", callback_data: 'day_9_complete_exercise' },
          { text: "🔄 Новый анализ", callback_data: 'day_9_restart_analysis' }
        ],
        [
          { text: "📚 Все мои анализы", callback_data: 'show_all_anxious_thoughts' },
          { text: "📊 Текущий прогресс", callback_data: 'day_9_show_current' }
        ]
      ]
    }.to_json
  end
  
  # День 10
  def day_10_content_markup
    {
      inline_keyboard: [
        [
          { text: "🎭 Начать развитие эмоционального интеллекта", callback_data: 'start_day_10_content' }
        ],
        [
          { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end

  def day_10_core_emotions_markup
    {
      inline_keyboard: [
        [
          { text: "😊 Радость", callback_data: 'day_10_emotion_0' },
          { text: "😔 Грусть", callback_data: 'day_10_emotion_1' }
        ],
        [
          { text: "😠 Гнев", callback_data: 'day_10_emotion_2' },
          { text: "😨 Тревога/Страх", callback_data: 'day_10_emotion_3' }
        ],
        [
          { text: "😳 Стыд", callback_data: 'day_10_emotion_4' },
          { text: "😞 Вина", callback_data: 'day_10_emotion_5' }
        ]
      ]
    }.to_json
  end

  def day_10_diary_start_markup
    {
      inline_keyboard: [
        [
          { text: "📔 Начать заполнение дневника", callback_data: 'day_10_start_diary' }
        ],
        [
          { text: "❓ Помощь с выбором ситуации", callback_data: 'day_10_help_choose_situation' },
          { text: "📚 Посмотреть мои записи", callback_data: 'day_10_show_entries' }
        ]
      ]
    }.to_json
  end

  def day_10_final_completion_markup
    {
      inline_keyboard: [
        [
          { text: "🎯 Завершить День 10", callback_data: 'day_10_complete_exercise' },
          { text: "🔄 Новый дневник", callback_data: 'day_10_restart_diary' }
        ],
        [
          { text: "📚 Все мои записи", callback_data: 'day_10_view_all_entries' },
          { text: "📊 Текущий прогресс", callback_data: 'day_10_show_entries' }
        ]
      ]
    }.to_json
  end

  # Обновляем старые методы для совместимости
  def day_10_start_exercise_markup
    day_10_content_markup
  end

  def day_10_exercise_completed_markup
    {
      inline_keyboard: [
        [
          { text: "✅ Завершить дневник и продолжить", callback_data: 'day_10_diary_completed' }
        ]
      ]
    }.to_json
  end

  def day_10_view_entries_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:calendar]} Посмотреть мои записи", callback_data: 'show_emotion_diary_entries' }
        ],
        [
          { text: "#{EMOJI[:check]} Я просмотрел(а) записи", callback_data: 'day_10_viewed_entries' }
        ]
      ]
    }.to_json
  end
  
  # День 11
  def day_11_content_markup
    {
      inline_keyboard: [
        [
          { text: "🌍 Начать технику заземления", callback_data: 'start_day_11_content' }
        ],
        [
          { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end

  def day_11_grounding_start_markup
    {
      inline_keyboard: [
        [
          { text: "🚀 Начать практику 5-4-3-2-1", callback_data: 'day_11_start_grounding' }
        ],
        [
          { text: "💡 Советы для эффективности", callback_data: 'day_11_help_tips' },
          { text: "🚨 Экстренный режим", callback_data: 'day_11_emergency_mode' }
        ]
      ]
    }.to_json
  end

  def day_11_input_markup
    {
      inline_keyboard: [
        [
          { text: "⏭️ Пропустить шаг", callback_data: 'day_11_skip_step' },
          { text: "🔄 Начать заново", callback_data: 'day_11_restart_grounding' }
        ]
      ]
    }.to_json
  end

  def day_11_challenges_markup
    {
      inline_keyboard: [
        [
          { text: "🔍 Не могу найти предметы", callback_data: 'day_11_challenge_0' }
        ],
        [
          { text: "💭 Мысли отвлекают", callback_data: 'day_11_challenge_1' }
        ],
        [
          { text: "😳 Чувствую себя глупо", callback_data: 'day_11_challenge_2' }
        ],
        [
          { text: "⏳ Не чувствую эффекта", callback_data: 'day_11_challenge_3' }
        ],
        [
          { text: "✅ Никаких трудностей", callback_data: 'day_11_no_challenges' }
        ]
      ]
    }.to_json
  end

  def day_11_final_completion_markup
    {
      inline_keyboard: [
        [
          { text: "🎯 Завершить День 11", callback_data: 'day_11_complete_exercise' },
          { text: "🔄 Новая практика", callback_data: 'day_11_restart_grounding' }
        ],
        [
          { text: "📚 Мои практики", callback_data: 'day_11_show_entries' },
          { text: "💡 Советы", callback_data: 'day_11_help_tips' }
        ]
      ]
    }.to_json
  end

  # Обновляем старые методы для совместимости
  def day_11_start_exercise_markup
    day_11_content_markup
  end

  def grounding_exercise_completed_markup
    {
      inline_keyboard: [
        [
          { text: "✅ Завершить практику", callback_data: 'day_11_complete_grounding' }
        ]
      ]
    }.to_json
  end
  
  # День 12
  def day_12_start_exercise_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:compassion]} Начать медитацию на самосострадание", callback_data: 'start_self_compassion_exercise' }
        ]
      ]
    }.to_json
  end
  
  def self_compassion_exercise_completed_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Я завершил(а) медитацию", callback_data: 'self_compassion_exercise_completed' }
        ]
      ]
    }.to_json
  end
  
  def day_12_menu_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:calendar]} Мои практики самосострадания", callback_data: 'view_self_compassion_practices' }
        ],
        [
          { text: "#{EMOJI[:check]} Сделать еще одну практику", callback_data: 'start_self_compassion_exercise' }
        ],
        [
          { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end
  
  def day_12_content_markup
  day_12_start_exercise_markup
end

def day_12_input_markup
  {
    inline_keyboard: [
      [
        { text: "⏭️ Пропустить шаг", callback_data: 'day_12_skip_step' },
        { text: "🔄 Начать заново", callback_data: 'day_12_restart_compassion' }
      ]
    ]
  }.to_json
end

def day_12_challenges_markup
  {
    inline_keyboard: [
      [
        { text: "💬 Не могу найти добрые слова", callback_data: 'day_12_challenge_0' }
      ],
      [
        { text: "🎭 Чувствую фальшь", callback_data: 'day_12_challenge_1' }
      ],
      [
        { text: "😔 Не верю, что заслуживаю", callback_data: 'day_12_challenge_2' }
      ],
      [
        { text: "🌀 Мысли возвращаются к проблеме", callback_data: 'day_12_challenge_3' }
      ]
    ]
  }.to_json
end

def day_12_final_completion_markup
  {
    inline_keyboard: [
      [
        { text: "🎯 Завершить День 12", callback_data: 'day_12_complete_exercise' },
        { text: "💝 Новая практика", callback_data: 'day_12_start_compassion' }
      ],
      [
        { text: "📚 Мои практики", callback_data: 'view_self_compassion_practices' },
        { text: "🏠 Главное меню", callback_data: 'back_to_main_menu' }
      ]
    ]
  }.to_json
end
  # День 13
  def day_13_start_exercise_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:procrastination]} Начать работу с прокрастинацией", callback_data: 'start_procrastination_exercise' }
        ]
      ]
    }.to_json
  end

      # День 14
    def day_14_start_exercise_markup
  {
    inline_keyboard: [
      [
        { text: "📖 Начать рефлексию 2 недель", callback_data: 'start_two_weeks_reflection' }
      ]
    ]
  }.to_json
end

def reflection_exercise_completed_markup
  {
    inline_keyboard: [
      [
        { text: "✅ Завершить рефлексию", callback_data: 'reflection_exercise_completed' }
      ]
    ]
  }.to_json
end

def day_15_start_exercise_markup
  {
    inline_keyboard: [
      [
        { text: "🤝 Начать практику доброты", callback_data: 'start_day_15_content' }
      ],
      [
        { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
      ]
    ]
  }.to_json
end

def day_15_completion_menu_markup
  {
    inline_keyboard: [
      [
        { text: "🤝 Новая практика", callback_data: 'day_15_start_new_practice' },
        { text: "🎯 Завершить День 15", callback_data: 'day_15_complete_exercise' }
      ]
    ]
  }.to_json
end

# Обновляем старый метод для совместимости
def day_15_final_completion_markup
  day_15_completion_menu_markup
end

    # Метод для предложения дня 14
    def self.day_14_start_proposal_markup
      { inline_keyboard: [[{ text: "#{EMOJI[:check]} Начать День 14", callback_data: 'start_day_14_from_proposal' }]] }.to_json
    end
  
  def procrastination_exercise_completed_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Завершить упражнение", callback_data: 'procrastination_exercise_completed' }
        ]
      ]
    }.to_json
  end
  
  def procrastination_first_step_completed_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Я сделал(а) первый шаг", callback_data: 'procrastination_first_step_done' }
        ]
      ]
    }.to_json
  end
  
  def day_13_menu_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:calendar]} Мои задачи", callback_data: 'view_my_procrastination_tasks' }
        ],
        [
          { text: "#{EMOJI[:check]} Новая задача", callback_data: 'start_procrastination_exercise' }
        ],
        [
          { text: "#{EMOJI[:check]} Отметить задачу выполненной", callback_data: 'mark_task_completed' }
        ],
        [
          { text: "#{EMOJI[:back]} Главное меню", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end
  
  # Тест Люшера
  def luscher_test_completed_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:info]} Показать интерпретацию", callback_data: 'show_luscher_interpretation' }
        ],
        [
          { text: "#{EMOJI[:back]} Назад в главное меню", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end
  
  def luscher_start_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Начать тест", callback_data: 'start_luscher_test' }
        ]
      ]
    }.to_json
  end
  
  # Завершение программы
  def final_program_completion_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Завершить программу", callback_data: 'complete_program_final' }
        ],
        [
          { text: "#{EMOJI[:warning]} Начать программу заново", callback_data: 'restart_self_help_program' }
        ],
        [
          { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end
  
  # Универсальные методы для генерации разметки
  
  # Генерация разметки для конкретного дня
  def day_specific_menu_markup(day_number)
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Продолжить День #{day_number}", callback_data: "continue_day_#{day_number}_content" }
        ],
        [
          { text: "#{EMOJI[:check]} Завершить День #{day_number}", callback_data: "complete_day_#{day_number}" }
        ],
        [
          { text: "#{EMOJI[:back]} Главное меню", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end
  
  # Генерация разметки для начала дня
  def day_start_proposal_markup(day_number)
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Начать День #{day_number}", callback_data: "start_day_#{day_number}_from_proposal" }
        ]
      ]
    }.to_json
  end
  
  # Динамические методы для дней (для совместимости со старым кодом)
  
  # День 2 предложение
  def self.day_2_start_proposal_markup
    { inline_keyboard: [[{ text: "#{EMOJI[:check]} Начать День 2", callback_data: 'start_day_2_from_proposal' }]] }.to_json
  end
  
  # День 3 предложение
  def self.day_3_start_proposal_markup
    { inline_keyboard: [[{ text: "#{EMOJI[:check]} Начать День 3", callback_data: 'start_day_3_from_proposal' }]] }.to_json
  end
  
  # День 4 предложение
  def self.day_4_start_proposal_markup
    { inline_keyboard: [[{ text: "#{EMOJI[:check]} Начать День 4", callback_data: 'start_day_4_from_proposal' }]] }.to_json
  end
  
  # День 5 предложение
  def self.day_5_start_proposal_markup
    { inline_keyboard: [[{ text: "#{EMOJI[:check]} Начать День 5", callback_data: 'start_day_5_from_proposal' }]] }.to_json
  end
  
  # День 6 предложение
  def self.day_6_start_proposal_markup
    { inline_keyboard: [[{ text: "#{EMOJI[:check]} Начать День 6", callback_data: 'start_day_6_from_proposal' }]] }.to_json
  end
  
  def self.day_7_reflection_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:back]} Отменить рефлексию", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end
  
  def self.complete_program_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Завершить неделю", callback_data: 'complete_day_7' }
        ]
      ]
    }.to_json
  end
  
  # Метод для предложения дня 7
  def self.day_7_start_proposal_markup
    { inline_keyboard: [[{ text: "📖 Начать День 7", callback_data: 'start_day_7_from_proposal' }]] }.to_json
  end
  
  # День 8 предложение
  def self.day_8_start_proposal_markup
    { inline_keyboard: [[{ text: "#{EMOJI[:check]} Начать День 8", callback_data: 'start_day_8_from_proposal' }]] }.to_json
  end
  
  # День 9 предложение
  def self.day_9_start_proposal_markup
    { inline_keyboard: [[{ text: "#{EMOJI[:check]} Начать День 9", callback_data: 'start_day_9_from_proposal' }]] }.to_json
  end
  
  # День 10 предложение
  def self.day_10_start_proposal_markup
    { inline_keyboard: [[{ text: "🎭 Начать День 10", callback_data: 'start_day_10_from_proposal' }]] }.to_json
  end
  
  # День 11 предложение
  def self.day_11_start_proposal_markup
    { inline_keyboard: [[{ text: "🌍 Начать День 11", callback_data: 'start_day_11_from_proposal' }]] }.to_json
  end
  
  # День 12 предложение
  def self.day_12_start_proposal_markup
    { inline_keyboard: [[{ text: "#{EMOJI[:check]} Начать День 12", callback_data: 'start_day_12_from_proposal' }]] }.to_json
  end
  
  # День 13 предложение
  def self.day_13_start_proposal_markup
    { inline_keyboard: [[{ text: "#{EMOJI[:check]} Начать День 13", callback_data: 'start_day_13_from_proposal' }]] }.to_json
  end

  def self.day_15_start_proposal_markup
    { inline_keyboard: [[{ text: "#{EMOJI[:check]} Начать День 15", callback_data: 'start_day_15_from_proposal' }]] }.to_json
  end

def self.day_16_start_proposal_markup
  { inline_keyboard: [[{ text: "#{EMOJI[:check]} Начать День 16", callback_data: 'start_day_16_from_proposal' }]] }.to_json
end

def day_16_start_exercise_markup
  {
    inline_keyboard: [
      [
        { text: "#{EMOJI[:check]} Начать упражнение", callback_data: 'start_day_16_exercise' }
      ]
    ]
  }.to_json
end

def day_16_exercise_completed_markup
  {
    inline_keyboard: [
      [
        { text: "#{EMOJI[:check]} Завершить упражнение", callback_data: 'day_16_exercise_completed' }
      ]
    ]
  }.to_json
end

def day_16_content_markup
  {
    inline_keyboard: [
      [
        { text: "🤝 Начать практику восстановления связей", callback_data: 'start_day_16_content' }
      ],
      [
        { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
      ]
    ]
  }.to_json
end

def day_16_menu_markup
  {
    inline_keyboard: [
      [
        { text: "#{EMOJI[:calendar]} Мои восстановленные связи", callback_data: 'view_reconnection_history' }
      ],
      [
        { text: "#{EMOJI[:back]} Главное меню", callback_data: 'back_to_main_menu' }
      ]
    ]
  }.to_json
end

# Для истории восстановления связей
def reconnection_history_markup
  {
    inline_keyboard: [
      [
        { text: "#{EMOJI[:calendar]} Все записи", callback_data: 'reconnection_history_all' },
        { text: "#{EMOJI[:brain]} Статистика", callback_data: 'reconnection_stats' }
      ],
      [
        { text: "#{EMOJI[:check]} Новая запись", callback_data: 'start_day_16_exercise' }
      ],
      [
        { text: "#{EMOJI[:back]} Назад", callback_data: 'back_to_day_16_menu' }
      ]
    ]
  }.to_json
end

def reconnection_stats_markup
  {
    inline_keyboard: [
      [
        { text: "#{EMOJI[:brain]} Общая статистика", callback_data: 'reconnection_general_stats' },
        { text: "#{EMOJI[:calendar]} По месяцам", callback_data: 'reconnection_monthly_stats' }
      ],
      [
        { text: "#{EMOJI[:info]} Форматы общения", callback_data: 'reconnection_format_stats' },
        { text: "#{EMOJI[:check]} Успешность", callback_data: 'reconnection_success_stats' }
      ],
      [
        { text: "#{EMOJI[:back]} Назад к записям", callback_data: 'view_reconnection_history' }
      ]
    ]
  }.to_json
end

# День 17 - Письмо самосострадания
def day_17_start_exercise_markup
  {
    inline_keyboard: [
      [
        { text: "#{EMOJI[:check]} Начать упражнение", callback_data: 'start_day_17_exercise' }
      ]
    ]
  }.to_json
end

def day_17_exercise_completed_markup
  {
    inline_keyboard: [
      [
        { text: "#{EMOJI[:check]} Завершить упражнение", callback_data: 'day_17_exercise_completed' }
      ]
    ]
  }.to_json
end

def day_17_simple_menu_markup
  {
    inline_keyboard: [
      [
        { text: "📚 Мои письма", callback_data: 'view_compassion_letters' }
      ],
      [
        { text: "✍️ Новое письмо", callback_data: 'start_day_17_exercise' }
      ],
      [
        { text: "#{EMOJI[:back]} Главное меню", callback_data: 'back_to_main_menu' }
      ]
    ]
  }.to_json
end

# Метод для предложения дня 17
def self.day_17_start_proposal_markup
  { inline_keyboard: [[{ text: "#{EMOJI[:check]} Начать День 17", callback_data: 'start_day_17_from_proposal' }]] }.to_json
end

# День 18
  def self.day_18_start_proposal_markup
    { inline_keyboard: [[{ text: "🌈 Начать День 18", callback_data: 'start_day_18_from_proposal' }]] }.to_json
  end
  
  def day_18_start_exercise_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:pleasure]} Начать упражнение", callback_data: 'start_day_18_exercise' }
        ]
      ]
    }.to_json
  end
  
  def day_18_exercise_completed_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Завершить упражнение", callback_data: 'day_18_exercise_completed' }
        ]
      ]
    }.to_json
  end
  
  def self.day_19_start_proposal_markup
    { inline_keyboard: [[{ text: "🧘‍♀️ Начать День 19", callback_data: 'start_day_19_from_proposal' }]] }.to_json
  end

  def day_18_simple_menu_markup
  {
    inline_keyboard: [
      [
        { text: "📚 Мои активности", callback_data: 'view_pleasure_activities' }
      ],
      [
        { text: "➕ Новая активность", callback_data: 'start_day_18_exercise' }
      ],
      [
        { text: "🏠 Главное меню", callback_data: 'back_to_main_menu' },
        { text: "➡️ Следующий день", callback_data: 'start_day_19_from_proposal' }
      ]
    ]
  }.to_json
end

# Обновляем старый метод для совместимости
def day_18_menu_markup
  day_18_simple_menu_markup
end

def day_20_content_markup
  {
    inline_keyboard: [
      [
        { text: "🦸 Начать работу со страхами", callback_data: 'start_day_20_content' }
      ],
      [
        { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
      ]
    ]
  }.to_json
end

  def self.day_20_start_proposal_markup
    { 
      inline_keyboard: [
        [
          { text: "🦸 Начать День 20", callback_data: 'start_day_20_from_proposal' }
        ]
      ] 
    }.to_json
  end

def day_22_start_proposal_markup
  {
    inline_keyboard: [
      [{ text: "🎯 Начать День 22: SMART цели", callback_data: "start_day_22_from_proposal" }]
    ]
  }.to_json
end

def self.day_23_start_proposal_markup
    {
      inline_keyboard: [
        [
          { text: "📊 Начать День 23", callback_data: "start_day_23_from_proposal" },
          { text: "⏰ Позже", callback_data: "back_to_main_menu" }
        ]
      ]
    }.to_json
  end
  
  def self.day_23_completion_markup
    {
      inline_keyboard: [
        [
          { text: "🎯 Следующий день", callback_data: "start_day_24_from_proposal" },
          { text: "📊 Мой прогресс", callback_data: "progress" }
        ],
        [
          { text: "📝 В дневник", callback_data: "start_emotion_diary" },
          { text: "🏠 В меню", callback_data: "back_to_main_menu" }
        ]
      ]
    }.to_json
  end

  def self.day_24_start_proposal_markup
    { 
      inline_keyboard: [
        [
          { text: "🛡️ Начать День 24: Предвосхищение", 
            callback_data: "start_day_24_from_proposal" }
        ]
      ] 
    }.to_json
  end

def self.day_25_start_proposal_markup
  { 
    inline_keyboard: [
      [
        { text: "🌌 Начать День 25: Вид сверху", 
          callback_data: "start_day_25_from_proposal" }
      ]
    ] 
  }.to_json
end

def self.day_25_start_proposal_markup
    { 
      inline_keyboard: [
        [
          { text: "🌌 Начать День 25: Вид сверху", 
            callback_data: "start_day_25_from_proposal" }
        ]
      ] 
    }.to_json
  end


# Добавьте метод для предложения дня 26:
def self.day_26_start_proposal_markup
  { 
    inline_keyboard: [
      [
        { text: "🔗 Начать День 26: Цепочка ценностей", 
          callback_data: "start_day_26_from_proposal" }
      ]
    ] 
  }.to_json
end

def self.day_27_start_proposal_markup
  { 
    inline_keyboard: [
      [
        { text: "🧠 Начать День 27: Нейрохакинг радости", 
          callback_data: "start_day_27_from_proposal" }
      ]
    ] 
  }.to_json
end

# Метод для предложения дня 27 (для единообразия)
def day_27_content_markup
  {
    inline_keyboard: [
      [
        { text: "🧠 Начать нейрохакинг", callback_data: 'start_day_27_content' }
      ],
      [
        { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
      ]
    ]
  }.to_json
end

def self.day_28_start_proposal_markup
  { 
    inline_keyboard: [
      [
        { text: "🧬 Начать День 28: Научный финал", 
          callback_data: "start_day_28_from_proposal" }
      ]
    ] 
  }.to_json
end

  def handle_self_help_input(state)
    log_info("Handling self-help input for state: #{state}")
      
    # Проверяем, не день ли 18
    if state&.start_with?('day_18')
      # Используем специальный обработчик для дня 18
      handler = Telegram::Handlers::Day18TextHandler.new(@bot, @user, @chat_id, @text)
      handler.process
      return
    end
      
    # Для остальных дней используем фасад
    facade = SelfHelp::Facade::SelfHelpFacade.new(@bot, @user, @chat_id)
    handled = facade.handle_day_input(@text, state)
      
    unless handled
      send_message(
        text: "Извините, я не понял ваш ответ. Пожалуйста, используйте кнопки меню.",
        reply_markup: TelegramMarkupHelper.back_to_main_menu_markup
      )
    end
  end

end
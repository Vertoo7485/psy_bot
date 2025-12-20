# app/services/telegram_markup_helper.rb
module TelegramMarkupHelper
  extend self
  
  # Основные константы для эмодзи
  EMOJI = {
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
  
  # День 2
  def day_2_start_exercise_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:yoga]} Начать медитацию", callback_data: 'start_day_2_exercise_audio' }
        ]
      ]
    }.to_json
  end
  
  def day_2_exercise_completed_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Я завершил(а) упражнение", callback_data: 'day_2_exercise_completed' }
        ]
      ]
    }.to_json
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
  
  def day_3_input_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:back]} Отменить ввод", callback_data: 'back_to_main_menu' }
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
  
  def day_5_exercise_completed_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Я выполнил(а) упражнение", callback_data: 'day_5_exercise_completed' }
        ]
      ]
    }.to_json
  end
  
  # День 6
  def day_6_exercise_completed_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Я отдохнул и готов продолжить", callback_data: 'day_6_exercise_completed' }
        ]
      ]
    }.to_json
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
  def day_8_consent_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Да, готов(а)!", callback_data: 'start_day_8_exercise' },
          { text: "#{EMOJI[:warning]} Нет, позже", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end
  
  def day_8_stopped_thought_first_try_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Я попробовал(а) остановить мысль", callback_data: 'day_8_stopped_thought_first_try' }
        ]
      ]
    }.to_json
  end
  
  def day_8_distraction_options_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:music]} Музыка", callback_data: 'day_8_distraction_music' },
          { text: "#{EMOJI[:video]} Видео", callback_data: 'day_8_distraction_video' }
        ],
        [
          { text: "#{EMOJI[:friend]} Друг", callback_data: 'day_8_distraction_friend' },
          { text: "#{EMOJI[:exercise]} Упражнения", callback_data: 'day_8_distraction_exercise' }
        ],
        [
          { text: "#{EMOJI[:book]} Книга", callback_data: 'day_8_distraction_book' }
        ]
      ]
    }.to_json
  end
  
  def day_8_exercise_completed_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Я выполнил(а) упражнение", callback_data: 'day_8_exercise_completed' }
        ]
      ]
    }.to_json
  end
  
  # День 9
  def day_9_menu_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:thought]} Ввести тревожную мысль", callback_data: 'day_9_enter_thought' }
        ],
        [
          { text: "#{EMOJI[:info]} Посмотреть текущий прогресс", callback_data: 'day_9_show_current' }
        ],
        [
          { text: "#{EMOJI[:calendar]} Все мои записи о мыслях", callback_data: 'show_all_anxious_thoughts' }
        ],
        [
          { text: "#{EMOJI[:check]} Завершить День 9", callback_data: 'complete_day_9' }
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
  
  # День 10
  def day_10_start_exercise_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:diary]} Начать заполнение Дневника эмоций", callback_data: 'start_day_10_exercise' }
        ],
        [
          { text: "#{EMOJI[:back]} Вернуться в главное меню", callback_data: 'back_to_main_menu' }
        ]
      ]
    }.to_json
  end
  
  def day_10_exercise_completed_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Я завершил(а) Дневник эмоций", callback_data: 'day_10_exercise_completed' }
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
  def day_11_start_exercise_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:grounding]} Начать упражнение 'Заземление 5-4-3-2-1'", callback_data: 'start_grounding_exercise' }
        ]
      ]
    }.to_json
  end
  
  def grounding_exercise_completed_markup
    {
      inline_keyboard: [
        [
          { text: "#{EMOJI[:check]} Я завершил(а) упражнение", callback_data: 'grounding_exercise_completed' }
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
            { text: "#{EMOJI[:reflection]} Начать рефлексию", 
              callback_data: 'start_day_14_exercise' }
          ]
        ]
      }.to_json
    end

    def reflection_exercise_completed_markup
      {
        inline_keyboard: [
          [
            { text: "#{EMOJI[:check]} Завершить рефлексию", 
              callback_data: 'reflection_exercise_completed' }
          ]
        ]
      }.to_json
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
  
  # День 7 предложение
  def self.day_7_start_proposal_markup
    { inline_keyboard: [[{ text: "#{EMOJI[:check]} Начать День 7", callback_data: 'start_day_7_from_proposal' }]] }.to_json
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
    { inline_keyboard: [[{ text: "#{EMOJI[:check]} Начать День 10", callback_data: 'start_day_10_from_proposal' }]] }.to_json
  end
  
  # День 11 предложение
  def self.day_11_start_proposal_markup
    { inline_keyboard: [[{ text: "#{EMOJI[:check]} Начать День 11", callback_data: 'start_day_11_from_proposal' }]] }.to_json
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
end
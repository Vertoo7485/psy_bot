# app/models/user.rb
class User < ApplicationRecord
  # Ассоциации
  has_many :test_results, dependent: :destroy
  has_many :tests, through: :test_results
  has_many :emotion_diary_entries, dependent: :destroy
  has_many :gratitude_entries, dependent: :destroy
  has_many :reflection_entries, dependent: :destroy
  has_many :anxious_thought_entries, dependent: :destroy
  has_many :user_sessions, dependent: :destroy
  has_one :active_session, -> { active }, class_name: 'UserSession'
  has_many :grounding_exercise_entries, dependent: :destroy
  has_many :self_compassion_practices, dependent: :destroy
  has_many :procrastination_tasks, dependent: :destroy
  has_many :reconnection_practices, dependent: :destroy
  has_many :compassion_letters, dependent: :destroy
  has_many :pleasure_activities, dependent: :destroy
  has_many :meditation_sessions, dependent: :destroy

  # Атрибуты
  attribute :current_diary_step, :string, default: nil
  attribute :diary_data, :json, default: {}
  attribute :self_help_program_step, :string, default: nil
  attribute :current_day_started_at, :datetime, default: nil
  attribute :last_day_completed_at, :datetime, default: nil
  attribute :completed_days, :integer, array: true, default: []

  # Валидации
  validates :telegram_id, presence: true, uniqueness: true

  # Scopes
  scope :with_telegram_id, ->(telegram_id) { where(telegram_id: telegram_id) }

  # Методы для работы с Telegram
  def self.find_or_create_from_telegram_message(from_data)
    find_or_create_by(telegram_id: from_data[:id]) do |user|
      user.first_name = from_data[:first_name]
      user.last_name = from_data[:last_name]
      user.username = from_data[:username]
    end
  end

  def meditation_stats
    begin
      # Проверяем, есть ли связь с MeditationSession
      if defined?(MeditationSession) && MeditationSession.column_names.include?('user_id')
        sessions = meditation_sessions.completed
        total = sessions.count
        total_minutes = sessions.sum(:duration_minutes)
        average_rating = sessions.average(:rating).to_f.round(1)
      else
        # Возвращаем дефолтные значения если таблицы нет
        total = 0
        total_minutes = 0
        average_rating = 0
      end
      
      {
        total: total,
        total_minutes: total_minutes,
        average_rating: average_rating,
        streak_days: 0 # временное значение
      }
    rescue => e
      Rails.logger.error "Error calculating meditation stats: #{e.message}"
      { total: 0, total_minutes: 0, average_rating: 0, streak_days: 0 }
    end
  end

  def calculate_meditation_streak
    return 0 if meditation_sessions.completed.empty?
    
    # Получаем даты всех завершенных медитаций
    dates = meditation_sessions.completed.pluck(:completed_at).map(&:to_date).uniq.sort.reverse
    
    streak = 0
    current_date = Date.current
    
    dates.each do |date|
      break unless date == current_date - streak.days
      streak += 1
    end
    
    streak
  end

  def in_self_help_program?
    # Пользователь в программе если step не nil и не 'not_started'
    self_help_program_step.present? && self_help_program_step != 'not_started'
  end

  def get_self_help_data(key)
    self_help_program_data&.[](key)
  end

  def store_self_help_data(key, value)
    current_data = self_help_program_data || {}
    current_data[key] = value
    update(self_help_program_data: current_data)
  end

  def self_help_state
    # Для обратной совместимости
    self_help_program_step
  end

  def pleasure_stats
    total = pleasure_activities.count
    completed = pleasure_activities.completed.count
    
    {
      total: total,
      completed: completed,
      completion_rate: total > 0 ? (completed.to_f / total * 100).round : 0
    }
  end
  
  # Получить рекомендации на основе истории
  def activity_recommendations
    # Получаем все завершенные активности
    completed_activities = pleasure_activities.completed
    
    if completed_activities.any?
      # Получаем самые частые типы активностей
      activity_types = completed_activities.pluck(:activity_type).compact
      
      if activity_types.any?
        most_common = activity_types.group_by(&:itself).transform_values(&:count).max_by(&:last)
        
        # Рекомендуем похожие активности
        similar_activities = {
          'reading' => ['art', 'learning', 'relaxation'],
          'music' => ['art', 'relaxation', 'nature'],
          'art' => ['music', 'reading', 'cooking'],
          'sports' => ['nature', 'games', 'relaxation'],
          'nature' => ['sports', 'relaxation', 'social'],
          'cooking' => ['art', 'social', 'games'],
          'games' => ['sports', 'social', 'learning'],
          'learning' => ['reading', 'games', 'art'],
          'social' => ['nature', 'games', 'cooking'],
          'relaxation' => ['nature', 'music', 'reading']
        }
        
        if most_common && similar_activities[most_common[0]]
          return similar_activities[most_common[0]].first(3)
        end
      end
    end
    
    # Дефолтные рекомендации
    ['reading', 'nature', 'relaxation']
  end

  def clear_day_data(day_number)
    day_prefix = "day_#{day_number}_"
    
    # Находим все ключи, начинающиеся с префикса дня
    day_keys = self_help_program_data.keys.select { |k| k.start_with?(day_prefix) }
    
    # Удаляем эти ключи
    day_keys.each do |key|
      self_help_program_data.delete(key)
    end
    
    # Сохраняем изменения
    save if day_keys.any?
    
    day_keys
  end

  def reconnection_stats
    {
      total: reconnection_practices.count,
      calls: reconnection_practices.by_format('звонок').count,
      messages: reconnection_practices.by_format('сообщение').count,
      letters: reconnection_practices.by_format('письмо').count,
      this_month: reconnection_practices.this_month.count,
      success_rate: calculate_success_rate
    }
  end

  # Методы для работы с дневником эмоций
  def start_diary_entry
    update(current_diary_step: 'situation', diary_data: {})
  end

  def update_diary_data(step, value)
    new_data = diary_data.merge(step => value)
    update(diary_data: new_data)
  end

  def complete_diary_entry
    update(current_diary_step: nil)
  end

  # Методы для программы самопомощи
  def self_help_state
    self_help_program_step
  end

  def set_self_help_step(step)
    update(self_help_program_step: step)
  end

  def store_self_help_data(key, value)
    new_data = self_help_program_data.merge(key => value)
    update(self_help_program_data: new_data)
  end

  def get_self_help_data(key)
    self_help_program_data[key]
  end

  def clear_self_help_program
    update(self_help_program_step: nil, self_help_program_data: {})
  end

  # Методы для работы с сессиями
  def get_or_create_session(session_type, initial_step = 'start')
    session = user_sessions.active.by_type(session_type).first
    
    unless session
      session = user_sessions.create!(
        session_type: session_type,
        last_successful_step: initial_step,
        last_activity_at: Time.current,
        current_data: {},
        message_queue: []
      )
    end
    
    session
  end

  def update_session_progress(step, data = {})
    return unless active_session
    
    active_session.update(
      last_successful_step: step,
      last_activity_at: Time.current,
      current_data: active_session.current_data.merge(data)
    )
  end

  def current_progress
    return {} unless active_session
    
    {
      step: active_session.last_successful_step,
      data: active_session.current_data,
      session_type: active_session.session_type
    }
  end

  # Проверки для дней программы самопомощи
  def can_start_day?(day_number)
    # Используем новую систему проверки вместо DayStateChecker
    can_start_day_program?(day_number)
  end

  def in_day_state?(day_number, state)
    self_help_state == "day_#{day_number}_#{state}"
  end

  def current_day_number
    match = self_help_state&.match(/day_(\d+)_/)
    match ? match[1].to_i : nil
  end

  def complete_self_help_day(day_number)
    set_self_help_step("day_#{day_number}_completed")
    set_self_help_step("awaiting_day_#{day_number + 1}_start") if day_number < 13
    complete_day_program(day_number)
  end

  # Проверяет, может ли пользователь начать день
  def can_start_day_program?(day_number)
    # День 1 всегда можно начать
    return true if day_number == 1
    
    errors = []
    
    # 1. Предыдущий день должен быть завершен
    unless completed_days.include?(day_number - 1)
      errors << "Сначала завершите День #{day_number - 1}"
    end
    
    # 2. Проверяем время с начала текущего дня (12 часов)
    if current_day_started_at
      time_passed = Time.current - current_day_started_at
      if time_passed < 12.hours
        hours_left = ((12.hours - time_passed) / 1.hour).ceil
        errors << "С момента начала текущего дня прошло недостаточно времени. Подождите #{hours_left} часов."
      end
    end
    
    # 3. Нельзя повторно начинать уже завершенный день
    if completed_days.include?(day_number)
      errors << "День #{day_number} уже завершен. Переходите к следующему дню."
    end
    
    errors.empty? ? true : errors
  end

  # Начать день в программе
  def start_day_program(day_number)
    # Очищаем старые данные дня
    clear_day_data(day_number)
    
    # Устанавливаем время начала нового дня
    self.current_day_started_at = Time.current
    save
  end

  # Завершить день в программе
  def complete_day_program(day_number)
    self.completed_days ||= []
    self.completed_days << day_number unless completed_days.include?(day_number)
    self.last_day_completed_at = Time.current
    # НЕ обнуляем current_day_started_at - нужно ждать 12 часов!
    save
  end

  # Получить следующий доступный день
  def next_available_day
    # Ищем первый незавершенный день
    (1..28).each do |day|
      return day unless completed_days.include?(day)
    end
    1 # Все дни завершены, начинаем с первого
  end

  # Получить прогресс
  def progress_percentage
    return 0 if completed_days.empty?
    (completed_days.size.to_f / 28 * 100).round(1)
  end

  # Форматированное время до следующего дня
  def formatted_time_until_next_day
    seconds = time_until_next_day
    return "сейчас" if seconds <= 0
    
    hours = seconds / 3600
    minutes = (seconds % 3600) / 60
    
    if hours > 0
      "#{hours} ч #{minutes} мин"
    else
      "#{minutes} мин"
    end
  end

  # Достаточно ли времени прошло с начала текущего дня?
  def enough_time_passed?
    return true unless current_day_started_at
    
    # 12 часов между днями
    time_passed = Time.current - current_day_started_at
    time_passed >= 12.hours
  end

  # Время до возможности начать следующий день (в секундах)
  def time_until_next_day
    return 0 unless current_day_started_at
    
    time_passed = Time.current - current_day_started_at
    if time_passed < 12.hours
      (12.hours - time_passed).ceil
    else
      0
    end
  end

  # ПРОСТОЙ СПОСОБ ДЛЯ ТЕСТИРОВАНИЯ: сбросить ограничение времени
  def reset_time_restriction!
    update(current_day_started_at: nil)
    true
  end

  def clear_self_help_program_data
    clear_self_help_program
    
    # Очищаем временные данные дней
    (1..13).each do |day|
      ['thought', 'probability', 'facts_pro', 'facts_con', 'reframe'].each do |key|
        store_self_help_data("day_#{day}_#{key}", nil)
      end
    end
    
    # Очищаем данные прогресса
    self.completed_days = []
    self.current_day_started_at = nil
    self.last_day_completed_at = nil
    save
  end

  private

  def self_help_program_data
    super || {}
  end

  def calculate_success_rate
    total = reconnection_practices.count
    return 0 if total.zero?
    
    successful = reconnection_practices.select { |p| p.success_score >= 2 }.count
    (successful.to_f / total * 100).round
  end
end
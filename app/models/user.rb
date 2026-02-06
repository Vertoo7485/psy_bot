# app/models/user.rb

require_dependency 'user_access'

class User < ApplicationRecord

  include UserAccess
  
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
  validates :access_level, inclusion: { in: ACCESS_LEVELS.values }

  # Scopes
  scope :with_telegram_id, ->(telegram_id) { where(telegram_id: telegram_id) }

  # Scopes для удобства работы с уровнями доступа
  scope :free_users, -> { where(access_level: 'free') }
  scope :premium_users, -> { where(access_level: 'premium') }
  scope :admin_users, -> { where(access_level: 'admin') }
  scope :active_users, -> { where(is_active: true) }
  scope :inactive_users, -> { where(is_active: false) }
  scope :with_active_subscription, -> { 
    premium_users
      .active_users
      .where('subscription_ends_at > ?', Time.current) 
  }
  scope :with_active_trial, -> {
    where('trial_ends_at > ?', Time.current)
    .where(access_level: 'premium')
  }
  scope :with_expired_subscription, -> {
    premium_users
      .active_users
      .where('subscription_ends_at <= ?', Time.current)
      .where('subscription_ends_at IS NOT NULL')
  }
  scope :with_expired_trial, -> {
    where('trial_ends_at <= ?', Time.current)
    .where(access_level: 'premium')
    .where('trial_ends_at IS NOT NULL')
  }
  
  # Callback: при создании пользователя устанавливаем trial на 3 дня
  after_create :set_initial_trial, if: :new_user_requires_trial?
  
  # Callback: проверяем доступ при обновлении подписки
  before_save :check_subscription_status
  
  # === МЕТОДЫ ДЛЯ УРОВНЕЙ ДОСТУПА ===
  
  # Проверка уровня доступа
  def free?
    access_level == 'free'
  end
  
  def premium?
    access_level == 'premium'
  end
  
  def admin?
    access_level == 'admin'
  end
  
  # Проверка активности доступа
  def trial_active?
    return false unless premium?
    trial_ends_at.present? && trial_ends_at > Time.current
  end
  
  def subscription_active?
    return false unless premium?
    subscription_ends_at.present? && subscription_ends_at > Time.current
  end
  
  def has_active_premium?
    premium? && is_active && (trial_active? || subscription_active?)
  end
  
  def can_access_self_help_program?
    # Админы всегда имеют доступ
    return true if admin?
    
    # Проверяем активный премиум доступ
    has_active_premium?
  end
  
  # === РАБОТА С ВРЕМЕНЕМ ===
  
  def days_until_trial_ends
    return 0 unless trial_ends_at && trial_ends_at > Time.current
    (trial_ends_at.to_date - Date.current).to_i
  end
  
  def days_until_subscription_ends
    return 0 unless subscription_ends_at && subscription_ends_at > Time.current
    (subscription_ends_at.to_date - Date.current).to_i
  end
  
  def trial_ended?
    trial_ends_at.present? && trial_ends_at <= Time.current
  end
  
  def subscription_ended?
    subscription_ends_at.present? && subscription_ends_at <= Time.current
  end
  
  # === АКТИВАЦИЯ/ДЕАКТИВАЦИЯ ===
  
  # Активация premium доступа
  def activate_premium!(days: SUBSCRIPTION_DAYS)
    update!(
      access_level: 'premium',
      subscription_ends_at: Time.current + days.days,
      premium_activated_at: Time.current,
      is_active: true,
      trial_ends_at: nil # Сбрасываем trial если был
    )
    
    Rails.logger.info "User #{id} activated premium for #{days} days"
    true
  end
  
  # Активация trial периода
  def activate_trial!(days: TRIAL_DAYS)
    update!(
      access_level: 'premium',
      trial_ends_at: Time.current + days.days,
      is_active: true,
      subscription_ends_at: nil, # Не устанавливаем подписку для trial
      premium_activated_at: nil
    )
    
    Rails.logger.info "User #{id} activated trial for #{days} days"
    true
  end
  
  # Деактивация premium доступа
  def deactivate_premium!
    update!(
      access_level: 'free',
      subscription_ends_at: nil,
      trial_ends_at: nil,
      is_active: false
    )
    
    Rails.logger.info "User #{id} deactivated premium access"
    true
  end
  
  # Продление подписки
  def extend_subscription!(days: SUBSCRIPTION_DAYS)
    new_ends_at = if subscription_ends_at && subscription_ends_at > Time.current
      # Если подписка еще активна, продлеваем от текущей даты окончания
      subscription_ends_at + days.days
    else
      # Иначе начинаем с текущего момента
      Time.current + days.days
    end
    
    update!(
      subscription_ends_at: new_ends_at,
      is_active: true
    )
    
    Rails.logger.info "User #{id} subscription extended for #{days} days, now ends at #{new_ends_at}"
    true
  end
  
  # Деактивация (без смены уровня)
  def deactivate!
    update!(is_active: false)
    Rails.logger.info "User #{id} deactivated"
  end
  
  # Активация (без смены уровня)
  def activate!
    update!(is_active: true)
    Rails.logger.info "User #{id} activated"
  end
  
  # === ИНФОРМАЦИЯ О ДОСТУПЕ ===
  
  def access_info
    if admin?
      ACCESS_MESSAGES[:admin]
    elsif free?
      ACCESS_MESSAGES[:free]
    elsif premium?
      info = ACCESS_MESSAGES[:premium]
      
      if trial_active?
        info += " (Trial, осталось #{days_until_trial_ends} дн.)"
      elsif subscription_active?
        info += " (Подписка, осталось #{days_until_subscription_ends} дн.)"
      elsif trial_ended?
        info += " (Trial истёк)"
      elsif subscription_ended?
        info += " (Подписка истекла)"
      else
        info += " (Неактивен)"
      end
      
      info += is_active ? " ✅" : " ❌"
      info
    end
  end
  
  def subscription_info
    return "Бесплатный доступ" if free?
    
    info = ""
    if trial_active?
      info += "🎁 Пробный период: #{days_until_trial_ends} дн. осталось"
    elsif subscription_active?
      info += "⭐️ Премиум подписка: #{days_until_subscription_ends} дн. осталось"
    elsif trial_ended?
      info += "⏰ Пробный период закончился"
    elsif subscription_ended?
      info += "📅 Подписка закончилась"
    end
    
    if subscription_ends_at
      info += "\nДействует до: #{subscription_ends_at.strftime('%d.%m.%Y')}"
    end
    
    info
  end
  
  # === МЕТОДЫ ДЛЯ АДМИНА ===
  
  # Назначить администратором
  def make_admin!
    update!(access_level: 'admin')
    Rails.logger.info "User #{id} promoted to admin"
  end
  
  # Сделать обычным пользователем
  def make_regular!
    update!(access_level: 'free')
    Rails.logger.info "User #{id} demoted to regular user"
  end

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
    can_start_day_program?(day_number)
  end

  def in_day_state?(day_number, state)
    self_help_state == "day_#{day_number}_#{state}"
  end

  def current_day_number
    match = self_help_state&.match(/day_(\d+)_/)
    match ? match[1].to_i : nil
  end

  def current_streak
    return 0 if completed_days.empty?
    
    sorted_days = completed_days.sort
    streak = 1
    
    (1...sorted_days.size).each do |i|
      if sorted_days[i] == sorted_days[i-1] + 1
        streak += 1
      else
        break
      end
    end
    
    streak
  end

  def formatted_progress
    percentage = progress_percentage
    completed = completed_days.size
    
    # Красивая прогресс-строка
    filled = "🟩" * (completed % 10)  # показываем последние 10 дней
    empty = "⬜" * (10 - (completed % 10))
    
    "#{filled}#{empty} #{completed}/28 (#{percentage}%)"
  end

  def complete_self_help_day(day_number)
    set_self_help_step("day_#{day_number}_completed")
    set_self_help_step("awaiting_day_#{day_number + 1}_start") if day_number < 13
    complete_day_program(day_number)
  end

  # Проверяет, может ли пользователь начать день
  def can_start_day_program?(day_number)
    Rails.logger.debug "[DEBUG] User##{id} can_start_day_program?(#{day_number}) called"
    
    # День 1 всегда можно начать
    if day_number == 1
      Rails.logger.debug "[DEBUG] Day 1 always allowed"
      return true
    end
    
    errors = []
    Rails.logger.debug "[DEBUG] Checking conditions for day #{day_number}"
    Rails.logger.debug "[DEBUG] User state: completed_days=#{completed_days.inspect}, current_day_started_at=#{current_day_started_at}, last_day_completed_at=#{last_day_completed_at}"
    
    # 1. Предыдущий день должен быть завершен
    unless completed_days.include?(day_number - 1)
      errors << "Сначала завершите День #{day_number - 1}"
      Rails.logger.debug "[DEBUG] Previous day #{day_number - 1} not completed"
    end
    
    # 2. Проверяем время с начала текущего дня (12 часов)
    if current_day_started_at
      time_passed = Time.current - current_day_started_at
      Rails.logger.debug "[DEBUG] Time since current_day_started_at: #{time_passed} seconds (#{time_passed / 3600} hours)"
      
      if time_passed < 12.hours
        hours_left = ((12.hours - time_passed) / 1.hour).ceil
        error_msg = "С момента начала текущего дня прошло недостаточно времени. Подождите #{hours_left} часов."
        errors << error_msg
        Rails.logger.debug "[DEBUG] Time restriction: #{hours_left} hours left"
      else
        Rails.logger.debug "[DEBUG] Time restriction passed (>12 hours)"
      end
    else
      Rails.logger.debug "[DEBUG] No current_day_started_at set"
    end
    
    # 3. Нельзя повторно начинать уже завершенный день
    if completed_days.include?(day_number)
      errors << "День #{day_number} уже завершен. Переходите к следующему дню."
      Rails.logger.debug "[DEBUG] Day #{day_number} already completed"
    end
    
    if errors.empty?
      Rails.logger.debug "[DEBUG] All checks passed for day #{day_number}"
      true
    else
      Rails.logger.debug "[DEBUG] Checks failed: #{errors.join(', ')}"
      errors
    end
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

  def set_initial_trial
    activate_trial!(days: TRIAL_DAYS)
    
    Rails.logger.info "Set #{TRIAL_DAYS}-day trial for new user #{id}"
    
    # Здесь можно добавить отправку приветственного сообщения
    # с информацией о trial
  end
  
  # Проверка, нужен ли trial новому пользователю
  def new_user_requires_trial?
    # Даём trial всем новым пользователям, кроме админов
    # (админа мы назначим отдельно через rake задачу)
    true
  end
  
  # Проверка статуса подписки при сохранении
  def check_subscription_status
    # Если подписка истекла и пользователь еще premium,
    # автоматически переводим на free
    if premium? && subscription_ends_at && subscription_ends_at <= Time.current
      self.access_level = 'free'
      self.is_active = false
      Rails.logger.info "Auto-downgraded user #{id} from premium to free (subscription expired)"
    end
    
    # Если trial истек и нет активной подписки,
    # автоматически переводим на free
    if premium? && trial_ends_at && trial_ends_at <= Time.current && 
       (!subscription_ends_at || subscription_ends_at <= Time.current)
      self.access_level = 'free'
      self.is_active = false
      Rails.logger.info "Auto-downgraded user #{id} from premium to free (trial expired)"
    end
  end

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
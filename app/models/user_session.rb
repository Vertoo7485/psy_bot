# app/models/user_session.rb
class UserSession < ApplicationRecord
  # Константы
  SESSION_TYPES = ['test', 'self_help', 'emotion_diary', 'gratitude', 'reflection', 'anxious_thought'].freeze
  SESSION_TIMEOUT_MINUTES = 10

  # Связи
  belongs_to :user

  # Валидации
  validates :session_type, inclusion: { in: SESSION_TYPES }
  validates :last_successful_step, presence: true
  validates :last_activity_at, presence: true

  # Сериализация
  serialize :current_data, JSON
  serialize :message_queue, JSON

  # Атрибуты по умолчанию
  attribute :current_data, default: {}
  attribute :message_queue, default: []
  attribute :retry_count, default: 0

  # Scopes
  scope :active, -> { where('last_activity_at > ?', SESSION_TIMEOUT_MINUTES.minutes.ago) }
  scope :for_user, ->(user) { where(user: user) }
  scope :by_type, ->(type) { where(session_type: type) }
  scope :recent, -> { order(last_activity_at: :desc) }

  # Callbacks
  before_validation :set_initial_last_activity, on: :create

  # Методы
  def touch_activity
    update(last_activity_at: Time.current)
  end

  def add_to_queue(message_data)
    queue = message_queue_array
    queue << {
      message: message_data,
      created_at: Time.current,
      retry_count: 0
    }
    update(message_queue: queue)
  end

  def clear_queue
    update(message_queue: [])
  end

  def next_queued_message
    return nil if message_queue_array.empty?

    message_queue_array.min_by { |m| m['retry_count'] }
  end

  def increment_retry(message_index)
    queue = message_queue_array
    return if queue[message_index].nil?

    queue[message_index]['retry_count'] += 1
    update(message_queue: queue)
  end

  def remove_from_queue(message_index)
    queue = message_queue_array
    queue.delete_at(message_index)
    update(message_queue: queue)
  end

  def active?
    last_activity_at > SESSION_TIMEOUT_MINUTES.minutes.ago
  end

  def complete
    update(
      last_successful_step: 'completed',
      current_data: {},
      message_queue: []
    )
  end

  def update_progress(step, data = {})
    update(
      last_successful_step: step,
      last_activity_at: Time.current,
      current_data: current_data.merge(data)
    )
  end

  def merge_data(new_data)
    update(current_data: current_data.merge(new_data))
  end

  private

  def set_initial_last_activity
    self.last_activity_at ||= Time.current
  end

  def message_queue_array
    message_queue.is_a?(Array) ? message_queue : []
  end
end
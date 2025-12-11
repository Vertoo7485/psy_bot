class UserSession < ApplicationRecord
  belongs_to :user
  
  # Типы сессий
  SESSION_TYPES = ['test', 'self_help', 'emotion_diary', 'gratitude', 'reflection', 'anxious_thought'].freeze
  
  validates :session_type, inclusion: { in: SESSION_TYPES }
  validates :last_successful_step, presence: true
  
  # Сериализация JSON полей
  serialize :current_data, JSON
  serialize :message_queue, JSON
  
  # По умолчанию пустые массивы/хэши
  attribute :current_data, default: {}
  attribute :message_queue, default: []
  
  # Scope для поиска активных сессий (менее 10 минут назад)
  scope :active, -> { where('last_activity_at > ?', 10.minutes.ago) }
  scope :for_user, ->(user) { where(user: user) }
  scope :by_type, ->(type) { where(session_type: type) }
  
  # Обновить активность
  def touch_activity
    update(last_activity_at: Time.current)
  end
  
  # Добавить сообщение в очередь на повторную отправку
  def add_to_queue(message_data)
    queue = message_queue || []
    queue << {
      message: message_data,
      created_at: Time.current,
      retry_count: 0
    }
    update(message_queue: queue)
  end
  
  # Очистить очередь
  def clear_queue
    update(message_queue: [])
  end
  
  # Получить следующее сообщение для повторной отправки
  def next_queued_message
    return nil if message_queue.blank?
    
    message_queue.min_by { |m| m['retry_count'] }
  end
  
  # Инкрементировать счетчик попыток для сообщения
  def increment_retry(message_index)
    queue = message_queue
    return if queue[message_index].nil?
    
    queue[message_index]['retry_count'] += 1
    update(message_queue: queue)
  end
  
  # Удалить сообщение из очереди (после успешной отправки)
  def remove_from_queue(message_index)
    queue = message_queue
    queue.delete_at(message_index)
    update(message_queue: queue)
  end
  
  # Проверить, активна ли сессия
  def active?
    last_activity_at > 10.minutes.ago
  end
  
  # Завершить сессию
  def complete
    update(
      last_successful_step: 'completed',
      current_data: {},
      message_queue: []
    )
  end
end
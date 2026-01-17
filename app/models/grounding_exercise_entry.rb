# app/models/grounding_exercise_entry.rb
class GroundingExerciseEntry < ApplicationRecord
  belongs_to :user
  
  # Константы
  MIN_ITEM_LENGTH = 2
  MAX_ITEMS_PER_SENSE = 10
  
  # Валидации
  validates :user_id, :entry_date, presence: true
  validates :entry_date, uniqueness: { scope: :user_id, message: "уже есть запись на эту дату" }
  
  # Сериализация массивов (исправленный синтаксис для Rails 7.1)
  serialize :seen, type: Array, coder: JSON
  serialize :touched, type: Array, coder: JSON
  serialize :heard, type: Array, coder: JSON
  serialize :smelled, type: Array, coder: JSON
  serialize :tasted, type: Array, coder: JSON
  
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_date, ->(date) { where(entry_date: date) }
  scope :by_user, ->(user) { where(user: user) }
  
  # Методы
  def summary
    "👁️ #{seen_count} | ✋ #{touched_count} | 👂 #{heard_count} | 👃 #{smelled_count} | 👅 #{tasted_count}"
  end
  
  def seen_count
    seen.is_a?(Array) ? seen.length : 0
  end
  
  def touched_count
    touched.is_a?(Array) ? touched.length : 0
  end
  
  def heard_count
    heard.is_a?(Array) ? heard.length : 0
  end
  
  def smelled_count
    smelled.is_a?(Array) ? smelled.length : 0
  end
  
  def tasted_count
    tasted.is_a?(Array) ? tasted.length : 0
  end
  
  def total_items
    seen_count + touched_count + heard_count + smelled_count + tasted_count
  end
  
  # Валидация элементов
  def validate_sense_items
    validate_sense_array(:seen, 5)
    validate_sense_array(:touched, 4)
    validate_sense_array(:heard, 3)
    validate_sense_array(:smelled, 2)
    validate_sense_array(:tasted, 1)
  end
  
  private
  
  def validate_sense_array(attribute, expected_min)
    items = send(attribute)
    return unless items.is_a?(Array)
    
    if items.any? { |item| item.to_s.length < MIN_ITEM_LENGTH }
      errors.add(attribute, "должен содержать элементы длиной минимум #{MIN_ITEM_LENGTH} символа")
    end
    
    if items.length > MAX_ITEMS_PER_SENSE
      errors.add(attribute, "не может содержать более #{MAX_ITEMS_PER_SENSE} элементов")
    end
  end
end
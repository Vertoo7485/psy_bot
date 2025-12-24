# app/models/meditation_session.rb

class MeditationSession < ApplicationRecord
  belongs_to :user
  
  validates :duration_minutes, numericality: { only_integer: true, greater_than: 0 }
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5, allow_nil: true }
  
  # Техники медитации
  TECHNIQUES = {
    'breathing_anchor' => '🌬️ Дыхание-Якорь',
    'self_compassion' => '💖 Самосострадание',
    'grounding' => '🌳 Заземление',
    'body_scan' => '🔍 Сканирование тела',
    'loving_kindness' => '❤️ Доброта',
    'mantra' => '📿 Мантра'
  }.freeze
  
  # Scopes для удобства
  scope :completed, -> { where.not(completed_at: nil) }
  scope :recent, -> { order(completed_at: :desc) }
  scope :this_week, -> { where(completed_at: 1.week.ago..Time.current) }
  
  # Метод для отображения названия техники
  def technique_name
    TECHNIQUES[technique] || technique
  end
  
  # Форматированная дата
  def formatted_date
    completed_at.strftime('%d.%m.%Y %H:%M')
  end
  
  # Время в формате "5 минут"
  def formatted_duration
    "#{duration_minutes} минут"
  end
end
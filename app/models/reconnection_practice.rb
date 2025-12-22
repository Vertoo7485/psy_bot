# app/models/reconnection_practice.rb
class ReconnectionPractice < ApplicationRecord
  belongs_to :user
  
  # Валидации
  validates :entry_date, presence: true
  validates :reconnected_person, presence: true, length: { maximum: 100 }
  validates :communication_format, presence: true, inclusion: { in: %w[звонок сообщение письмо] }
  validates :reflection_text, length: { maximum: 2000 }
  validates :integration_plan, length: { maximum: 1000 }
  
  # Scopes для удобства
  scope :recent, -> { order(entry_date: :desc, created_at: :desc) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :by_format, ->(format) { where(communication_format: format) }
  scope :this_month, -> { where(entry_date: Date.current.beginning_of_month..Date.current.end_of_month) }
  
  # Методы для удобства
  def format_emoji
    case communication_format
    when 'звонок' then '📞'
    when 'сообщение' then '💬'
    when 'письмо' then '✉️'
    else '📱'
    end
  end
  
  def summary
    "#{format_emoji} #{reconnected_person} (#{entry_date.strftime('%d.%m.%Y')})"
  end
  
  def success_score
    score = 0
    score += 2 if reflection_text.present? && reflection_text.length > 50
    score += 1 if integration_plan.present?
    score += 1 if conversation_start.present?
    score
  end
  
  def success_level
    case success_score
    when 0..1 then 'начало'
    when 2..3 then 'хорошо'
    when 4 then 'отлично'
    end
  end
end
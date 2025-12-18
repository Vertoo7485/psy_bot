# app/models/emotion_diary_entry.rb
class EmotionDiaryEntry < ApplicationRecord
  # Константы
  MAX_FIELD_LENGTH = 2000

  # Связи
  belongs_to :user

  # Валидации
  validates :date, presence: true
  validates :situation, presence: true, length: { maximum: MAX_FIELD_LENGTH }
  validates :thoughts, presence: true, length: { maximum: MAX_FIELD_LENGTH }
  validates :emotions, presence: true, length: { maximum: MAX_FIELD_LENGTH }
  validates :behavior, presence: true, length: { maximum: MAX_FIELD_LENGTH }
  validates :evidence_against, presence: true, length: { maximum: MAX_FIELD_LENGTH }
  validates :new_thoughts, presence: true, length: { maximum: MAX_FIELD_LENGTH }

  # Scopes
  scope :recent, -> { order(date: :desc) }
  scope :by_user, ->(user) { where(user: user) }
  scope :by_date_range, ->(start_date, end_date) { where(date: start_date..end_date) }

  # Методы
  def summary
    {
      date: date,
      situation: situation.truncate(50),
      emotions: emotions.truncate(30)
    }
  end

  def full_entry
    {
      date: date,
      situation: situation,
      thoughts: thoughts,
      emotions: emotions,
      behavior: behavior,
      evidence_against: evidence_against,
      new_thoughts: new_thoughts
    }
  end
end
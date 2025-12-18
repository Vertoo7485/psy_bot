# app/models/self_compassion_practice.rb
class SelfCompassionPractice < ApplicationRecord
  # Константы
  MIN_FIELD_LENGTH = 3

  # Связи
  belongs_to :user

  # Валидации
  validates :entry_date, presence: true
  validates :current_difficulty, presence: true, length: { minimum: MIN_FIELD_LENGTH }
  validates :common_humanity, presence: true, length: { minimum: MIN_FIELD_LENGTH }
  validates :kind_words, presence: true, length: { minimum: MIN_FIELD_LENGTH }
  validates :mantra, presence: true, length: { minimum: MIN_FIELD_LENGTH }

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_user, ->(user) { where(user: user) }

  # Методы
  def display_name
    "Практика самосострадания от #{entry_date.strftime('%d.%m.%Y')}"
  end

  def summary
    {
      date: entry_date,
      difficulty: current_difficulty.truncate(50),
      mantra: mantra.truncate(50)
    }
  end

  def full_practice
    {
      current_difficulty: current_difficulty,
      common_humanity: common_humanity,
      kind_words: kind_words,
      mantra: mantra
    }
  end
end
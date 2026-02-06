# app/models/gratitude_entry.rb
class GratitudeEntry < ApplicationRecord
  # Константы
  MAX_ENTRY_TEXT_LENGTH = 2000

  # Связи
  belongs_to :user

  # Валидации
  validates :entry_date, presence: true
  validates :entry_text, presence: true, length: { maximum: MAX_ENTRY_TEXT_LENGTH }

  # Scopes
  scope :recent, -> { order(entry_date: :desc) }
  scope :by_user, ->(user) { where(user: user) }
  scope :by_date, ->(date) { where(entry_date: date) }

  # Методы
  def display_text
    entry_text.truncate(100)
  end
end
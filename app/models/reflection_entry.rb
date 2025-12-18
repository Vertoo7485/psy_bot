# app/models/reflection_entry.rb
class ReflectionEntry < ApplicationRecord
  # Константы
  MAX_ENTRY_TEXT_LENGTH = 5000

  # Связи
  belongs_to :user

  # Валидации
  validates :entry_date, presence: true
  validates :entry_text, presence: true, length: { maximum: MAX_ENTRY_TEXT_LENGTH }

  # Scopes
  scope :recent, -> { order(entry_date: :desc) }
  scope :by_user, ->(user) { where(user: user) }
  scope :by_date_range, ->(start_date, end_date) { where(entry_date: start_date..end_date) }

  # Методы
  def display_text
    entry_text.truncate(100)
  end

  def summary
    {
      date: entry_date,
      text_preview: entry_text.truncate(50)
    }
  end
end
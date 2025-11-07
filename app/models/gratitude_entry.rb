# app/models/gratitude_entry.rb
class GratitudeEntry < ApplicationRecord
  belongs_to :user

  validates :entry_date, presence: true
  validates :entry_text, presence: true

  # Опционально: можно добавить валидацию, что запись за день только одна
  # validates :entry_date, uniqueness: { scope: :user_id }
end

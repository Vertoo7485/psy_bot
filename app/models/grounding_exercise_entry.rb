# app/models/grounding_exercise_entry.rb
class GroundingExerciseEntry < ApplicationRecord
  # Константы
  MIN_ITEM_LENGTH = 3

  # Связи
  belongs_to :user

  # Валидации
  validates :entry_date, presence: true
  validates :seen, presence: true, length: { minimum: MIN_ITEM_LENGTH }
  validates :touched, presence: true, length: { minimum: MIN_ITEM_LENGTH }
  validates :heard, presence: true, length: { minimum: MIN_ITEM_LENGTH }
  validates :smelled, presence: true, length: { minimum: MIN_ITEM_LENGTH }
  validates :tasted, presence: true, length: { minimum: MIN_ITEM_LENGTH }

  # Сериализация
  serialize :seen, Array
  serialize :touched, Array
  serialize :heard, Array
  serialize :smelled, Array
  serialize :tasted, Array

  # Scopes
  scope :recent, -> { order(entry_date: :desc) }
  scope :by_user, ->(user) { where(user: user) }

  # Методы
  def summary
    {
      date: entry_date,
      seen_count: seen.is_a?(Array) ? seen.size : 0,
      heard_count: heard.is_a?(Array) ? heard.size : 0
    }
  end

  def all_senses
    {
      seen: seen,
      touched: touched,
      heard: heard,
      smelled: smelled,
      tasted: tasted
    }
  end
end
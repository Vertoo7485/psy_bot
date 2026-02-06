# app/models/anxious_thought_entry.rb
class AnxiousThoughtEntry < ApplicationRecord
  # Константы
  PROBABILITY_RANGE = (1..10).freeze
  MIN_THOUGHT_LENGTH = 3
  MAX_THOUGHT_LENGTH = 1000
  MAX_FACTS_LENGTH = 2000
  MAX_REFRAIN_LENGTH = 2000

  # Связи
  belongs_to :user

  # Валидации
  validates :entry_date, presence: true
  validates :thought, presence: true, 
                      length: { minimum: MIN_THOUGHT_LENGTH, maximum: MAX_THOUGHT_LENGTH }
  validates :probability, presence: true, 
                         numericality: { 
                           only_integer: true, 
                           in: PROBABILITY_RANGE 
                         }
  validates :facts_pro, presence: true, length: { maximum: MAX_FACTS_LENGTH }
  validates :facts_con, presence: true, length: { maximum: MAX_FACTS_LENGTH }
  validates :reframe, presence: true, length: { maximum: MAX_REFRAIN_LENGTH }

  # Scopes
  scope :recent, -> { order(entry_date: :desc) }
  scope :by_user, ->(user) { where(user: user) }
  scope :from_date, ->(date) { where(entry_date: date) }

  # Методы
  def display_name
    "Мысль от #{entry_date.strftime('%d.%m.%Y')}"
  end

  def summary
    {
      thought: thought.truncate(50),
      probability: probability,
      date: entry_date
    }
  end
end
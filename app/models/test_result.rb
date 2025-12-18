# app/models/test_result.rb
class TestResult < ApplicationRecord
  # Связи
  belongs_to :user
  belongs_to :test
  has_many :answers, dependent: :destroy

  # Сериализация
  serialize :luscher_choices, Array, coder: JSON

  # Валидации
  validates :user, :test, presence: true
  validates :score, numericality: { only_integer: true, allow_nil: true }

  # Scopes
  scope :completed, -> { where.not(completed_at: nil) }
  scope :incomplete, -> { where(completed_at: nil) }
  scope :by_user, ->(user) { where(user: user) }
  scope :by_test, ->(test) { where(test: test) }
  scope :recent, -> { order(created_at: :desc) }

  # Методы
  def completed?
    completed_at.present?
  end

  def total_score
    answers.sum { |answer| answer.answer_option.value }
  end

  def calculate_and_update_score
    update(score: total_score, completed_at: Time.current)
  end

  def luscher_choices_array
    luscher_choices.is_a?(Array) ? luscher_choices : []
  end
end
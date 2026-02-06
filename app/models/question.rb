# app/models/question.rb
class Question < ApplicationRecord
  # Enum
  enum part: { current: 1, usual: 2 }

  # Связи
  belongs_to :test
  has_many :answer_options, dependent: :destroy
  has_many :answers, through: :answer_options

  # Валидации
  validates :text, presence: true
  validates :part, presence: true

  # Scopes
  scope :by_test, ->(test) { where(test: test) }
  scope :ordered, -> { order(:id) }
  scope :by_part, ->(part) { where(part: part) }

  # Методы
  def answer_options_ordered
    answer_options.order(:id)
  end
end
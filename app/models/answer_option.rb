# app/models/answer_option.rb
class AnswerOption < ApplicationRecord
  belongs_to :question
  has_many :answers, dependent: :destroy

  validates :text, presence: true
  validates :value, presence: true, numericality: { only_integer: true }
end
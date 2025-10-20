class AnswerOption < ApplicationRecord
  belongs_to :question

  belongs_to :question
  has_many :answers, dependent: :destroy
end

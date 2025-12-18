# app/models/answer.rb
class Answer < ApplicationRecord
  belongs_to :test_result
  belongs_to :question
  belongs_to :answer_option

  validates :test_result, :question, :answer_option, presence: true
end
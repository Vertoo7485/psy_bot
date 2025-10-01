class Answer < ApplicationRecord
  belongs_to :test_result
  belongs_to :question
  belongs_to :answer_option
end

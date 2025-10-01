class Question < ApplicationRecord
  belongs_to :test

  has_many :answer_options
  has_many :answers
end

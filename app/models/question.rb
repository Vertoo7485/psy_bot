class Question < ApplicationRecord
  belongs_to :test

  has_many :answer_options
  has_many :answers

  enum part: { current: 1, usual: 2 }
end

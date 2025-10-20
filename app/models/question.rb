class Question < ApplicationRecord
  belongs_to :test

  has_many :answer_options, dependent: :destroy
  has_many :answers, dependent: :destroy

  enum part: { current: 1, usual: 2 }
end

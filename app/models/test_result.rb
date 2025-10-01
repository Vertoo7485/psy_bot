class TestResult < ApplicationRecord
  belongs_to :user
  belongs_to :test

  has_many :answers
end

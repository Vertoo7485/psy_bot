class Test < ApplicationRecord

  has_many :questions
  has_many :test_results
  has_many :users, through: :test_results
end

class Test < ApplicationRecord

  has_many :questions, dependent: :destroy
  has_many :test_results, dependent: :destroy
  has_many :users, through: :test_results
end

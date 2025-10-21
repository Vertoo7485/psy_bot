class Test < ApplicationRecord

  has_many :questions, dependent: :destroy
  has_many :test_results, dependent: :destroy
  has_many :users, through: :test_results

  enum test_type: { standard: 0, luscher: 1 }
end

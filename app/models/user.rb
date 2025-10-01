class User < ApplicationRecord

  has_many :test_results
  has_many :tests, through: :test_results
end

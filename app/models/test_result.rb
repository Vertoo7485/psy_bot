class TestResult < ApplicationRecord
  belongs_to :user
  belongs_to :test

  has_many :answers, dependent: :destroy

  serialize :luscher_choices, Array, coder: JSON # Указываем coder: JSON

end

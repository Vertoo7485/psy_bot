class TestResult < ApplicationRecord
  belongs_to :user
  belongs_to :test

  has_many :answers, dependent: :destroy

  serialize :luscher_choices, Array, coder: JSON # Указываем coder: JSON

  # Добавляем стадию теста Люшера
  enum luscher_stage: { not_started: 0, stage_one: 1, stage_two: 2, completed: 3 }

end

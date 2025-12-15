class GroundingExerciseEntry < ApplicationRecord
  belongs_to :user
  
  validates :entry_date, presence: true
  validates :seen, presence: true, length: { minimum: 3 }
  validates :touched, presence: true, length: { minimum: 3 }
  validates :heard, presence: true, length: { minimum: 3 }
  validates :smelled, presence: true, length: { minimum: 3 }
  validates :tasted, presence: true, length: { minimum: 3 }
  
  # Сериализация массивов (если храним как JSON)
  serialize :seen, Array
  serialize :touched, Array
  serialize :heard, Array
  serialize :smelled, Array
  serialize :tasted, Array
end
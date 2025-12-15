class SelfCompassionPractice < ApplicationRecord
  belongs_to :user
  
  validates :entry_date, presence: true
  validates :current_difficulty, presence: true, length: { minimum: 3 }
  validates :common_humanity, presence: true, length: { minimum: 3 }
  validates :kind_words, presence: true, length: { minimum: 3 }
  validates :mantra, presence: true, length: { minimum: 3 }
  
  scope :recent, -> { order(created_at: :desc) }
  scope :by_user, ->(user) { where(user: user) }
  
  def display_name
    "Практика самосострадания от #{entry_date.strftime('%d.%m.%Y')}"
  end
end
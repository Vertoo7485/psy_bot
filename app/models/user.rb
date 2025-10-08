class User < ApplicationRecord

  has_many :test_results
  has_many :tests, through: :test_results
  has_many :emotion_diary_entries

  attribute :current_diary_step, :string, default: nil  # nil, 'situation', 'thoughts' и т.д.
  attribute :diary_data, :json, default: {}
end

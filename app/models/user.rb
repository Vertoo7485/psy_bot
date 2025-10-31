class User < ApplicationRecord

  has_many :test_results
  has_many :tests, through: :test_results
  has_many :emotion_diary_entries, dependent: :destroy

  attribute :current_diary_step, :string, default: nil  # nil, 'situation', 'thoughts' и т.д.
  attribute :diary_data, :json, default: {}

    def self.find_or_create_from_telegram_message(from_data)
    find_or_create_by(telegram_id: from_data[:id]) do |u|
      u.first_name = from_data[:first_name]
      u.last_name = from_data[:last_name]
      u.username = from_data[:username]
    end
  end
end

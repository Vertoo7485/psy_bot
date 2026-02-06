# app/models/setting.rb
class Setting < ApplicationRecord
  # Валидации
  validates :key, presence: true, uniqueness: true

  # Scopes
  scope :by_key, ->(key) { where(key: key) }

  # Методы класса
  class << self
    def get(key, default = nil)
      find_by(key: key)&.value || default
    end

    def set(key, value)
      setting = find_or_initialize_by(key: key)
      setting.value = value
      setting.save!
    end
  end
end
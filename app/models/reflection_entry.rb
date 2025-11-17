class ReflectionEntry < ApplicationRecord
  belongs_to :user
  validates :entry_date, presence: true
  validates :entry_text, presence: true
end

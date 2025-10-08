class EmotionDiaryEntry < ApplicationRecord
      belongs_to :user

      validates :date, presence: true
      validates :situation, presence: true
      validates :thoughts, presence: true
      validates :emotions, presence: true
      validates :behavior, presence: true
      validates :evidence_against, presence: true
      validates :new_thoughts, presence: true
    end
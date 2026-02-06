class CompassionLetter < ApplicationRecord
  belongs_to :user
  
  validates :entry_date, presence: true
  
  # Scopes для удобной фильтрации
  scope :recent, -> { order(created_at: :desc) }
  scope :by_date, ->(date) { where(entry_date: date) }
  scope :this_month, -> { where(entry_date: Date.current.beginning_of_month..Date.current.end_of_month) }
  
  # Метод для предварительного просмотра
  def preview
    situation_text.to_s.truncate(100)
  end
  
  # Метод для получения полного письма
  def formatted_letter
    <<~TEXT
      📅 #{entry_date.strftime('%d.%m.%Y')}
      
      💭 Ситуация:
      #{situation_text}
      
      🤗 Понимание:
      #{understanding_text}
      
      💝 Поддержка:
      #{kindness_text}
      
      🧠 Совет:
      #{advice_text}
      
      ✨ Завершение:
      #{closure_text}
    TEXT
  end
end
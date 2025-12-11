class AnxiousThoughtEntry < ApplicationRecord
  # 1. Связь с пользователем
  belongs_to :user
  
  # 2. Валидации (проверки данных перед сохранением)
  validates :entry_date, presence: true
  validates :thought, presence: true, length: { minimum: 3, maximum: 1000 }
  validates :probability, presence: true, 
                          numericality: { 
                            only_integer: true, 
                            greater_than_or_equal_to: 1, 
                            less_than_or_equal_to: 10 
                          }
  validates :facts_pro, presence: true, length: { maximum: 2000 }
  validates :facts_con, presence: true, length: { maximum: 2000 }
  validates :reframe, presence: true, length: { maximum: 2000 }
  
  # 3. Метод для красивого отображения
  def display_name
    "Мысль от #{entry_date.strftime('%d.%m.%Y')}"
  end
  
  # 4. Scope для удобной выборки
  scope :recent, -> { order(entry_date: :desc) }
  scope :by_user, ->(user) { where(user: user) }
end
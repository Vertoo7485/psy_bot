class Test < ApplicationRecord
  # Допустимые типы тестов
  TEST_TYPES = ['standard', 'luscher', 'anxiety', 'depression', 'eq', 'quiz'].freeze
  
  # Связи
  has_many :questions, dependent: :destroy
  has_many :test_results, dependent: :destroy
  has_many :users, through: :test_results

  # Валидации
  validates :name, presence: true, uniqueness: true
  validates :test_type, inclusion: { in: TEST_TYPES }

  # Scopes
  scope :by_type, ->(type) { where(test_type: type) }
  scope :by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }

  # Методы класса
  class << self
    def find_by_type_name(type_name)
      type_name = type_name.to_s.downcase
      
      case type_name
      when 'anxiety', 'тревожность'
        find_by(test_type: 'anxiety') || 
        find_by("name ILIKE ?", "%тревожности%") ||
        find_by("name ILIKE ?", "%anxiety%")
      when 'depression', 'депрессия'
        find_by(test_type: 'depression') ||
        find_by("name ILIKE ?", "%депрессии%") ||
        find_by("name ILIKE ?", "%depression%")
      when 'eq', 'эмоциональный интеллект'
        find_by(test_type: 'eq') ||
        find_by("name ILIKE ?", "%эмоциональн%интеллект%") ||
        find_by("name ILIKE ?", "%eq%")
      when 'standard', 'quiz'
        where(test_type: ['standard', 'quiz']).first
      when 'luscher', 'люшера'
        find_by(test_type: 'luscher')
      else
        find_by(test_type: type_name) ||
        find_by("name ILIKE ?", "%#{type_name}%")
      end
    end
  end

  # Методы экземпляра
  def first_question
    questions.order(:order_index, :id).first
  end

  def questions_count
    questions.count
  end
end

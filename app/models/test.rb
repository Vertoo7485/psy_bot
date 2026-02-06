# app/models/test.rb
class Test < ApplicationRecord
  # Enum
  enum test_type: { standard: 0, luscher: 1 }

  # Связи
  has_many :questions, dependent: :destroy
  has_many :test_results, dependent: :destroy
  has_many :users, through: :test_results

  # Валидации
   validates :name, presence: true, uniqueness: true
   validates :test_type, inclusion: { in: %w[quiz luscher], allow_nil: true }

  # Scopes
  scope :by_type, ->(type) { where(test_type: type) }
  scope :by_name, ->(name) { where(name: name) }
  scope :quiz_tests, -> { where(test_type: 'quiz') }
  scope :luscher_tests, -> { where(test_type: 'luscher') }

  # Методы класса
  class << self
    def anxiety_test
      find_by(name: "Тест Тревожности", test_type: :standard)
    end

    def depression_test
      find_by(name: "Тест Депрессии (PHQ-9)", test_type: :standard)
    end

    def eq_test
      find_by(name: "Тест EQ (Эмоциональный Интеллект)", test_type: :standard)
    end

    def quiz_test?
      test_type == 'quiz'
    end
    
    def luscher_test?
      test_type == 'luscher'
    end

    def luscher_test
      find_by(test_type: :luscher)
    end

    def find_by_type_name(type_name)
      case type_name.to_sym
      when :anxiety then anxiety_test
      when :depression then depression_test
      when :eq then eq_test
      when :luscher then luscher_test
      else nil
      end
    end
  end

  # Методы экземпляра
  def first_question
    questions.ordered.first
  end

  def questions_count
    questions.count
  end

  def standard?
    test_type == 'standard'
  end

  def luscher?
    test_type == 'luscher'
  end
end
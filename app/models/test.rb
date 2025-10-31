class Test < ApplicationRecord

  has_many :questions, dependent: :destroy
  has_many :test_results, dependent: :destroy
  has_many :users, through: :test_results

  enum test_type: { standard: 0, luscher: 1 }

  # Скоупы для удобного поиска тестов
  scope :anxiety_test, -> { find_by(name: "Тест Тревожности", test_type: :standard) }
  scope :depression_test, -> { find_by(name: "Тест Депрессии (PHQ-9)", test_type: :standard) }
  scope :eq_test, -> { find_by(name: "Тест EQ (Эмоциональный Интеллект)", test_type: :standard) }
  scope :luscher_test, -> { find_by(name: "8-ми цветовой тест Люшера", test_type: :luscher) }

  # Универсальный метод для поиска теста по типу
  def self.find_by_type_name(type_name)
    case type_name.to_sym
    when :anxiety then anxiety_test
    when :depression then depression_test
    when :eq then eq_test
    when :luscher then luscher_test
    else nil
    end
  end
end

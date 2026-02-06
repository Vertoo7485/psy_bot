# app/models/test_result.rb
class TestResult < ApplicationRecord
  include PostgresqlArrayHelper
  # Связи с опциями для PostgreSQL оптимизации
  belongs_to :user
  belongs_to :test
  
  # Для подсчета баллов используем counter_cache если нужно
  has_many :answers, dependent: :destroy

  
  # Валидации
  validates :user, :test, presence: true
  validates :score, numericality: { 
    only_integer: true, 
    allow_nil: true,
    greater_than_or_equal_to: 0
  }
  
  validates :completed_at, presence: true, if: :score_present?
  
  # Scopes для PostgreSQL оптимизации
  scope :completed, -> { where.not(completed_at: nil).order(completed_at: :desc) }
  scope :incomplete, -> { where(completed_at: nil).order(created_at: :desc) }
  scope :by_user, ->(user) { where(user: user).includes(:test) }
  scope :by_test, ->(test) { where(test: test).includes(:user) }
  scope :recent, -> { order(created_at: :desc).limit(50) }
  scope :luscher_tests, -> { 
    joins(:test).where(tests: { test_type: :luscher }) 
  }
  
  scope :recent, -> { order(created_at: :desc).limit(50) }
  
  # Scopes для аналитики
  scope :last_week, -> { 
    where(completed_at: 1.week.ago..Time.current) 
  }
  
  scope :with_scores, -> {
    where.not(score: nil).where('score > 0')
  }
  
  scope :high_scores, ->(threshold = 70) {
    where('score >= ?', threshold)
  }
  
  scope :low_scores, ->(threshold = 30) {
    where('score <= ?', threshold)
  }
  
  # Методы экземпляра
  def completed?
    completed_at.present?
  end
  
  # ОПТИМИЗИРОВАННЫЙ ПОДСЧЕТ БАЛЛОВ - без N+1
  def total_score
    # Вариант 1: Использовать кэшированное значение если есть
    return score if score.present? && completed?
    
    # Вариант 2: JOIN запрос для PostgreSQL (быстрее всего)
    calculate_score_with_join
  end
  
  # Оптимизированный подсчет через JOIN
  def calculate_score_with_join
    answers.joins(:answer_option)
           .sum('answer_options.value::integer')
  rescue => e
    # Fallback на обычный метод
    Rails.logger.error("Error calculating score with join: #{e.message}")
    calculate_score_with_includes
  end
  
  # Метод с предзагрузкой для надежности
  def calculate_score_with_includes
    answers.includes(:answer_option).sum do |answer|
      answer.answer_option&.value.to_i
    end
  end
  
  # Использование PostgreSQL функции (самый быстрый вариант)
  def calculate_score_with_postgres_function
    sql = "SELECT calculate_test_score(#{id})"
    result = ActiveRecord::Base.connection.execute(sql)
    result[0]['calculate_test_score'].to_i
  rescue => e
    Rails.logger.error("PostgreSQL function error: #{e.message}")
    calculate_score_with_join
  end
  
  # Обновление счета с оптимизацией
  def calculate_and_update_score
    new_score = calculate_score_with_join
    update_columns(
      score: new_score,
      completed_at: Time.current,
      updated_at: Time.current
    )
    
    # Обновляем материализованное представление если оно есть
    refresh_statistics_view if defined?(refresh_statistics_view)
    
    new_score
  end
  
  # Для сериализации в JSON API
  def as_json(options = {})
    super(options.merge(
      methods: [:completed?, :test_name, :user_name],
      include: {
        test: { only: [:id, :name, :description] }
      }
    ))
  end
  
  # Виртуальные аттрибуты для удобства
  def test_name
    test&.name
  end
  
  def user_name
    user&.full_name || user&.telegram_username
  end
  
  def luscher_choices=(value)
    case value
    when String
      # Если строка, пытаемся парсить
      super(value.split(',').map(&:strip))
    when Array
      # Если массив - используем как есть
      super(value)
    when nil
      super([])
    else
      raise ArgumentError, "luscher_choices must be a String, Array, or nil"
    end
  end

  # Проверка, является ли это результатом теста Люшера
  def luscher_test?
    test&.test_type == 'luscher'
  end
  
  # Проверка завершенности теста Люшера
  def luscher_completed?
    return false unless luscher_test?
    
    # Для теста Люшера проверяем, что выбрано 8 цветов
    if completed_at.present?
      true
    else
      luscher_choices_array.length >= 8
    end
  end

  # Добавление цвета в массив с валидацией
  def add_luscher_color(color_code)
    return false unless luscher_test?
    return false unless LuscherTestService::COLOURS.any? { |c| c[:code] == color_code }
    
    current_choices = luscher_choices_array
    
    # Проверяем, что цвет еще не выбран
    unless current_choices.include?(color_code)
      new_choices = current_choices + [color_code]
      update(luscher_choices: new_choices)
      
      # Автоматически помечаем как завершенный, если выбрано 8 цветов
      if new_choices.length >= 8 && completed_at.nil?
        update(completed_at: Time.current)
      end
      
      true
    else
      false
    end
  end

  # Получение порядка цветов в читаемом формате
  def luscher_choices_readable
    luscher_choices_array.map do |color_code|
      color = LuscherTestService::COLOURS.find { |c| c[:code] == color_code }
      color ? color[:name] : color_code
    end
  end

  def luscher_choices_array
    # PostgreSQL автоматически возвращает массив
    luscher_choices || []
  end
  # Метод для статистики
  def score_percentage
    return 0 unless score.present? && test&.max_score.present?
    
    ((score.to_f / test.max_score.to_f) * 100).round(2)
  end
  
  # Классовые методы для аналитики
  class << self
    # Средний балл по тесту
    def average_score_for_test(test_id)
      where(test_id: test_id, score: 1..Float::INFINITY)
        .average(:score)
        .to_f
        .round(2)
    end
    
    # Распределение баллов
    def score_distribution(test_id)
      select('score, COUNT(*) as count')
        .where(test_id: test_id)
        .where.not(score: nil)
        .group(:score)
        .order(:score)
        .each_with_object({}) do |result, hash|
          hash[result.score] = result.count
        end
    end
    
    # Последние результаты пользователя
    def user_recent_results(user_id, limit = 5)
      where(user_id: user_id)
        .completed
        .includes(:test)
        .order(completed_at: :desc)
        .limit(limit)
    end
    
    # Статистика завершения тестов
    def completion_stats
      total = count
      completed_count = completed.count
      
      {
        total: total,
        completed: completed_count,
        completion_rate: total.zero? ? 0 : ((completed_count.to_f / total) * 100).round(2)
      }
    end
  end
  
  private
  
  def score_present?
    score.present?
  end
  
  # Колбэки для оптимизации
  before_save :update_timestamps, if: :score_changed?
  
  def update_timestamps
    self.completed_at ||= Time.current if score.present?
  end
  
  after_commit :update_user_statistics, on: [:create, :update]
  
  def update_user_statistics
    # Можно добавить обновление статистики пользователя
    # user.update_test_statistics если нужно
  end
  
  after_commit :clear_cache, on: [:create, :update, :destroy]
  
  def clear_cache
    # Очистка кэша если используете
    Rails.cache.delete("user_#{user_id}_test_results")
    Rails.cache.delete("test_#{test_id}_statistics")
  end
end
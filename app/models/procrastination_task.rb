class ProcrastinationTask < ApplicationRecord
  belongs_to :user
  
  validates :entry_date, presence: true
  validates :task, presence: true, length: { minimum: 3 }
  validates :first_step, presence: true, length: { minimum: 3 }
  
  # Сериализация массива шагов
  serialize :steps, Array
  
  scope :completed, -> { where(completed: true) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_user, ->(user) { where(user: user) }
  
  def display_name
    "Задача от #{entry_date.strftime('%d.%m.%Y')}: #{task.truncate(30)}"
  end
  
  def steps_array
    steps.is_a?(Array) ? steps : []
  end
end
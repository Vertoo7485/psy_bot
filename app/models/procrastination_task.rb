# app/models/procrastination_task.rb
class ProcrastinationTask < ApplicationRecord
  # Константы
  MIN_TASK_LENGTH = 3
  MIN_STEP_LENGTH = 3

  # Связи
  belongs_to :user

  # Валидации
  validates :entry_date, presence: true
  validates :task, presence: true, length: { minimum: MIN_TASK_LENGTH }
  validates :first_step, presence: true, length: { minimum: MIN_STEP_LENGTH }

  # Сериализация
  serialize :steps, type: Array, coder: JSON

  # Scopes
  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_user, ->(user) { where(user: user) }
  scope :by_completion, ->(completed) { where(completed: completed) }

  # Методы
  def display_name
    "Задача от #{entry_date.strftime('%d.%m.%Y')}: #{task.truncate(30)}"
  end

  def steps_array
    steps.is_a?(Array) ? steps : []
  end

  def mark_completed
    update(completed: true)
  end

  def summary
    {
      task: task,
      date: entry_date,
      completed: completed,
      first_step: first_step,
      steps_count: steps_array.size
    }
  end
end
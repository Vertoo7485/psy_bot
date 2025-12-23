# app/models/pleasure_activity.rb

class PleasureActivity < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true
  validates :feelings_before, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5, allow_nil: true }
  validates :feelings_after, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5, allow_nil: true }
  validates :duration_minutes, numericality: { only_integer: true, greater_than: 0, allow_nil: true }
  
  # Типы активностей для классификации
  ACTIVITY_TYPES = {
    'reading' => '📚 Чтение',
    'music' => '🎵 Музыка',
    'art' => '🎨 Творчество',
    'sports' => '🏃 Спорт',
    'nature' => '🌳 Природа',
    'cooking' => '🍳 Кулинария',
    'games' => '🎮 Игры',
    'learning' => '🧠 Обучение',
    'social' => '👥 Общение',
    'relaxation' => '🧘‍♀️ Релаксация',
    'other' => '✨ Другое'
  }.freeze
  
  # Scopes для удобства
  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
  scope :recent, -> { order(created_at: :desc) }
  
  # Метод для вычисления улучшения настроения
  def mood_improvement
    return nil if feelings_before.nil? || feelings_after.nil?
    feelings_after - feelings_before
  end
  
  # Метод для формата даты
  def formatted_date
    created_at.strftime('%d.%m.%Y')
  end
  
  # Метод для отображения типа активности
  def type_emoji
    case activity_type
    when 'reading' then '📚'
    when 'music' then '🎵'
    when 'art' then '🎨'
    when 'sports' then '🏃'
    when 'nature' then '🌳'
    when 'cooking' then '🍳'
    when 'games' then '🎮'
    when 'learning' then '🧠'
    when 'social' then '👥'
    when 'relaxation' then '🧘‍♀️'
    else '✨'
    end
  end
end
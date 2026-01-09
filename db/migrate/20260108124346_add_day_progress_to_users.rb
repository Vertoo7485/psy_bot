class AddDayProgressToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :current_day_started_at, :datetime
    add_column :users, :last_day_completed_at, :datetime
    add_column :users, :completed_days, :integer, array: true, default: []
    
    # Добавляем индекс для быстрого поиска завершенных дней
    add_index :users, :completed_days, using: 'gin'
  end
end
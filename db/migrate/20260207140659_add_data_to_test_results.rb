class AddDataToTestResults < ActiveRecord::Migration[7.1]
  def change
    add_column :test_results, :data, :jsonb, default: {}
    
    # Добавляем индекс для поиска по данным
    add_index :test_results, :data, using: :gin
  end
end

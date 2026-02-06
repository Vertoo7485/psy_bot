class AddTestTypeToTests < ActiveRecord::Migration[7.1]
  def change
    add_column :tests, :test_type, :integer, default: 0, null: false
  end
end

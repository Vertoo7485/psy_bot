class AddDiaryFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :current_diary_step, :string
    add_column :users, :diary_data, :json
  end
end

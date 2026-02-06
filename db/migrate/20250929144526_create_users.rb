class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.integer :telegram_id
      t.string :first_name
      t.string :last_name
      t.string :username

      t.timestamps
    end
    add_index :users, :telegram_id, unique: true
  end
end

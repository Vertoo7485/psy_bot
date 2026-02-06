class CreateAnxiousThoughtEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :anxious_thought_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.date :entry_date
      t.text :thought
      t.integer :probability
      t.text :facts_pro
      t.text :facts_con
      t.text :reframe

      t.timestamps
    end

    add_index :anxious_thought_entries, [:user_id, :entry_date]
  end
end

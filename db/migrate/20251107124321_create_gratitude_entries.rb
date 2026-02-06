class CreateGratitudeEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :gratitude_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.date :entry_date
      t.text :entry_text

      t.timestamps
    end
  end
end

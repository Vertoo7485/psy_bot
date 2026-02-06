class CreateSelfCompassionPractices < ActiveRecord::Migration[7.1]
  def change
    create_table :self_compassion_practices do |t|
      t.references :user, null: false, foreign_key: true
      t.date :entry_date
      t.text :current_difficulty
      t.text :common_humanity
      t.text :kind_words
      t.text :physical_comfort
      t.text :mantra
      t.text :feelings_after

      t.timestamps
    end
  end
end

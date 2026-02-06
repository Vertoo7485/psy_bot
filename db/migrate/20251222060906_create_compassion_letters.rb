class CreateCompassionLetters < ActiveRecord::Migration[7.1]
  def change
    create_table :compassion_letters do |t|
      t.references :user, null: false, foreign_key: true
      t.date :entry_date
      t.text :situation_text
      t.text :understanding_text
      t.text :kindness_text
      t.text :advice_text
      t.text :closure_text
      t.text :full_text

      t.timestamps
    end
  end
end

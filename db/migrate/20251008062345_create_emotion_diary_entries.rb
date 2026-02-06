class CreateEmotionDiaryEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :emotion_diary_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.text :situation
      t.text :thoughts
      t.text :emotions
      t.text :behavior
      t.text :evidence_against
      t.text :new_thoughts

      t.timestamps
    end
  end
end

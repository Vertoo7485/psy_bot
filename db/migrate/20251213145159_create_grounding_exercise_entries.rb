class CreateGroundingExerciseEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :grounding_exercise_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.date :entry_date
      t.text :seen
      t.text :touched
      t.text :heard
      t.text :smelled
      t.text :tasted
      t.text :feelings

      t.timestamps
    end
  end
end

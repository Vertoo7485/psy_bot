class CreatePleasureActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :pleasure_activities do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :activity_type
      t.integer :duration
      t.boolean :completed
      t.datetime :completed_at
      t.integer :feelings_before
      t.integer :feelings_after

      t.timestamps
    end
  end
end

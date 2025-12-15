class CreateProcrastinationTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :procrastination_tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.date :entry_date
      t.text :task
      t.text :reason
      t.text :steps
      t.text :first_step
      t.boolean :completed
      t.text :feelings_after

      t.timestamps
    end
  end
end

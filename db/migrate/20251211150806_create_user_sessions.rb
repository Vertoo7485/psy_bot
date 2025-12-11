class CreateUserSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :user_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :last_activity_at
      t.string :last_successful_step
      t.text :current_data
      t.string :session_type
      t.text :message_queue
      t.integer :retry_count

      t.timestamps
    end
  end
end

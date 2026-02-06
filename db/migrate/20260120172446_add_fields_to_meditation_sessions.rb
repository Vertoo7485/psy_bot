class AddFieldsToMeditationSessions < ActiveRecord::Migration[7.1]
  def change
    add_reference :meditation_sessions, :user, null: false, foreign_key: true
    add_column :meditation_sessions, :duration_minutes, :integer
    add_column :meditation_sessions, :rating, :integer
    add_column :meditation_sessions, :notes, :text
    add_column :meditation_sessions, :technique, :string
    add_column :meditation_sessions, :completed_at, :datetime
  end
end

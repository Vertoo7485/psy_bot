class CreateReconnectionPractices < ActiveRecord::Migration[7.1]
  def change
    create_table :reconnection_practices do |t|
      t.references :user, null: false, foreign_key: true
      t.date :entry_date
      t.string :reconnected_person
      t.string :communication_format
      t.text :conversation_start
      t.text :reflection_text
      t.text :integration_plan

      t.timestamps
    end
  end
end

class AddSelfHelpProgramToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :self_help_program_step, :string
    add_column :users, :self_help_program_data, :jsonb, default: {}, null: false
  end
end

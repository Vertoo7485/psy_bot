class AddPartToQuestions < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :part, :integer
  end
end

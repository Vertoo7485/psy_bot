class AddLuscherFieldsToTestResults < ActiveRecord::Migration[7.1]
  def change
    add_column :test_results, :luscher_choices, :text
    add_column :test_results, :luscher_stage, :integer
  end
end

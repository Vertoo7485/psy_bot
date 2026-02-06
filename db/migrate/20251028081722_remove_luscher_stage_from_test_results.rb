class RemoveLuscherStageFromTestResults < ActiveRecord::Migration[7.1]
  def change
    remove_column :test_results, :luscher_stage, :integer
  end
end

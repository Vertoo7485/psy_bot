class AddReflectionToPleasureActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :pleasure_activities, :reflection, :text
  end
end

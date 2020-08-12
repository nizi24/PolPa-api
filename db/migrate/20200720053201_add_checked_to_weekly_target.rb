class AddCheckedToWeeklyTarget < ActiveRecord::Migration[6.0]
  def change
    add_column :weekly_targets, :checked, :boolean, default: false
    add_index :weekly_targets, [:user_id, :checked]
  end
end

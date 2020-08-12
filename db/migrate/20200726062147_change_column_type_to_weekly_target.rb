class ChangeColumnTypeToWeeklyTarget < ActiveRecord::Migration[6.0]
  def change
    remove_column :weekly_targets, :target_time, :time
    remove_column :weekly_targets, :progress, :time
    add_column :weekly_targets, :target_time, :datetime, default: '2000-01-01 00:00:00'
    add_column :weekly_targets, :progress, :datetime, default: '2000-01-01 00:00:00'
  end
end

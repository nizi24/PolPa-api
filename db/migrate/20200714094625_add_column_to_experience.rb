class AddColumnToExperience < ActiveRecord::Migration[6.0]
  def change
    add_column :experiences, :current_continuation_days, :integer, default: 1
    add_column :experiences, :max_continuation_days, :integer, default: 1
  end
end

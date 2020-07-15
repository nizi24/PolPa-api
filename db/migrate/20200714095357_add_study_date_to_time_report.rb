class AddStudyDateToTimeReport < ActiveRecord::Migration[6.0]
  def change
    add_column :time_reports, :study_date, :datetime, null: false
    add_index :time_reports, [:user_id, :study_date]
  end
end

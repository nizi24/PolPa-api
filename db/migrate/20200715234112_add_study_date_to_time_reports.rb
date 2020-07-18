class AddStudyDateToTimeReports < ActiveRecord::Migration[6.0]
  def change
    add_column :time_reports, :study_date, :datetime, null: false
  end
end

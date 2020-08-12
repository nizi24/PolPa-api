class CreateTimeReports < ActiveRecord::Migration[6.0]
  def change
    create_table :time_reports do |t|
      t.references :user, null: false, foreign_key: true
      t.time "study_time", null: false
      t.text "memo"

      t.timestamps
    end
  end
end

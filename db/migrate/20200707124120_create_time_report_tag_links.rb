class CreateTimeReportTagLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :time_report_tag_links do |t|
      t.references :time_report, null: false
      t.references :tag, null: false

      t.timestamps
    end
    add_index :time_report_tag_links, [ :time_report_id, :tag_id ], unique: true
  end
end

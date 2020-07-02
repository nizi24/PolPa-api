class CreateExperienceRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :experience_records do |t|
      t.references :user, null: false, foreign_key: true
      t.references :time_report, foreign_key: true
      t.integer :experience_point, null: false
      t.float :bonus_multiplier, default: 1

      t.timestamps
    end
  end
end

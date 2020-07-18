class CreateWeeklyTargetExperienceRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :weekly_target_experience_records do |t|
      t.references :user, null: false, foreign_key: true
      t.references :weekly_target, null: false, foreign_key: true
      t.integer :experience_point, null: false

      t.timestamps
    end
  end
end

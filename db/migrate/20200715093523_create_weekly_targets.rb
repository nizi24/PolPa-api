class CreateWeeklyTargets < ActiveRecord::Migration[6.0]
  def change
    create_table :weekly_targets do |t|
      t.references :user, null: false, foreign_key: true
      t.time :target_time, null: false
      t.datetime :start_date,
        default: Time.current.beginning_of_week.since(4.hours)
        # Migrationを実行した時刻になる
      t.datetime :end_date,
        default: Time.current.end_of_week.since(4.hours)
      t.boolean :achieve, default: false
      t.time :progress, default: '0:00'

      t.timestamps
    end
    add_index :weekly_targets, [ :user_id, :start_date, :end_date ],
      unique: true
  end
end

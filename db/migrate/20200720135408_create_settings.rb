class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :comment_notice, default: true
      t.boolean :comment_like_notice, default: true
      t.boolean :time_report_like_notice, default: true
      t.boolean :follow_notice, default: true

      t.timestamps
    end
  end
end

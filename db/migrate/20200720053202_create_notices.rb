class CreateNotices < ActiveRecord::Migration[6.0]
  def change
    create_table :notices do |t|
      t.integer :action_user_id, null: false
      t.integer :received_user_id, null: false
      t.references :noticeable, polymorphic: true
      t.string :like_type
      t.integer :time_report_id
      t.boolean :checked, default: false

      t.timestamps
    end
  end
end

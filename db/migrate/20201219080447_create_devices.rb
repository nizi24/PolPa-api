class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.references :user, null: false, foreign_key: true
      t.string :firebase_registration_token

      t.timestamps
    end
  end
end

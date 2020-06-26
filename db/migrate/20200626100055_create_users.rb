class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :uid
      t.string :screen_name, null: false

      t.timestamps
    end

    add_index :users, "LOWER(email)", unique: true
    add_index :users, :screen_name, unique: true
  end
end

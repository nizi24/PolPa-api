class CreateUserTagRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :user_tag_relationships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tag, null: false

      t.timestamps
    end
    add_index :user_tag_relationships, [:user_id, :tag_id], unique: true,
      name: 'user_tag_relationships_unique_index  '
  end
end

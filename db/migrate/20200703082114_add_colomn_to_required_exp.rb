class AddColomnToRequiredExp < ActiveRecord::Migration[6.0]
  def change
    add_column :required_exps, :total_experience, :integer, null: false
  end
end

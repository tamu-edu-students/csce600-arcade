class AddRanksToBees < ActiveRecord::Migration[7.2]
  def change
    add_column :bees, :ranks, :jsonb
  end
end

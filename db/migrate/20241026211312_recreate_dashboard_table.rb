class RecreateDashboardTable < ActiveRecord::Migration[6.1]
  def change
    create_table :dashboards do |t|
      t.integer :user_id
      t.integer :game_id
      t.date :played_on
      t.integer :score
      t.integer :streak_count, default: 0
      t.boolean :streak_record, default: false
      t.timestamps
    end

    # Add foreign key constraints
    add_foreign_key :dashboards, :users, column: :user_id, on_delete: :cascade
    add_foreign_key :dashboards, :games, column: :game_id, on_delete: :cascade

    # Add indices
    add_index :dashboards, :user_id
    add_index :dashboards, :game_id
  end
end


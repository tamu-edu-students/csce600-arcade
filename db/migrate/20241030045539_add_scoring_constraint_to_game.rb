class AddScoringConstraintToGame < ActiveRecord::Migration[7.2]
  def change
    add_column :games, :single_score_per_day, :boolean, default: false
  end
end

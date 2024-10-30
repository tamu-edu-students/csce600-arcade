class UpdateScoringConstraintForWordle < ActiveRecord::Migration[7.2]
  def change
    Game.where(name: 'Wordle').update(single_score_per_day: true)
  end
end

class UpdateGameWordlePath < ActiveRecord::Migration[7.2]
  def up
    Game.where(name: "Wordle").update_all(game_path: "wordles_play_path")
  end
end

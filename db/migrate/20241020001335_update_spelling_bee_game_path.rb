class UpdateSpellingBeeGamePath < ActiveRecord::Migration[7.2]
  def change
    Game.where(name: 'Spelling Bee').update(game_path: 'bees_play_path')
  end
end

# spec/models/game_spec.rb
require 'rails_helper'

RSpec.describe Game, type: :model do
  before do
    Game.destroy_all
  end

  describe "all_games" do
    it "returns all game names" do
      Game.create!(name: "Test Game 1")
      Game.create!(name: "Test Game 2")
      expect(Game.all_games).to eq(Game.all.map { |g| g.name })
      Game.destroy_all
    end
  end
end

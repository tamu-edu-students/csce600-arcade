# spec/models/game_spec.rb
require 'rails_helper'

RSpec.describe Game, type: :model do
  before do
    Game.destroy_all
  end

  describe "game_roles" do
    it "returns all game roles" do
      expect(Role.game_roles).to eq([ "Puzzle Aesthetician", "Puzzle Setter" ])
    end
  end

  describe "role_color" do
    it "returns color for a known game" do
      expect(Role.role_color("Wordle")).to eq("rgba(0, 128, 0, 0.4)")
    end

    it "returns gray for unknown game" do
      expect(Role.role_color("some game")).to eq("rgba(0, 0, 0, 0.4)")
    end
  end
end

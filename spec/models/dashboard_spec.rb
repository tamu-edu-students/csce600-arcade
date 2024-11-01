require 'rails_helper'

RSpec.describe Dashboard, type: :model do
  before do
    Dashboard.destroy_all
    Game.create(id: -1, name: 'Test Dummy Game', game_path: 'test_game_path')
  end
  let(:user) do
    User.create!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
  end
  let(:streak_record) do
    Dashboard.create!(user_id: user.id, game_id: -1, streak_record: true, streak_count: 5)
  end

  describe "streak_record_cannot_be_changed" do
    it "fails to update streak record once created" do
        streak_record.update(streak_record: false)
        expect(streak_record.errors.full_messages).to include("Streak record cannot be modified once set")
    end
  end
end

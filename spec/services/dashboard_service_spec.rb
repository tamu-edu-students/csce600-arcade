# spec/services/settings_service_spec.rb
require 'rails_helper'

RSpec.describe DashboardService, type: :service do
    before do
        User.destroy_all
        Game.create(id: -1, name: 'Test Dummy Game', game_path: 'test_game_path')
    end
    
    let(:user) do
        User.create!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
    end
    let!(:wordle_type_game) do 
        Game.create(name: 'Test Wordle Game', game_path: 'test_game_path', single_score_per_day: true) 
    end
    let!(:sbee_type_game) do 
        Game.create(name: 'Test Wordle Game', game_path: 'test_game_path') 
    end


    describe "call - first time single score a day game" do
        before do
            DashboardService.new(user.id, wordle_type_game.id, 1).call
        end
        it "creates a streak record first time play of a game" do
            streak_record = Dashboard.where(user_id: user.id, streak_record: true)
            expect(streak_record).not_to be_nil
        end
        it "sets the streak count to 1 for first time play" do
            streak_count = Dashboard.where(user_id: user.id, streak_record: true).first&.streak_count
            expect(streak_count).to eq(1)
        end
        it "creates a play record for first time play of a game" do
            play_record = Dashboard.where(user_id: user.id, game_id: wordle_type_game.id)
            expect(play_record).not_to be_nil
        end
        it "sets the play record date to today on creation" do
            play_date = Dashboard.where(user_id: user.id, game_id: wordle_type_game.id).first&.played_on
            expect(play_date).to eq(Date.today)
        end
        it "sets the play record score to the supplied score on creation" do
            play_score = Dashboard.where(user_id: user.id, game_id: wordle_type_game.id).first&.score
            expect(play_score).to eq(1)
        end
    end

    describe "call - second time single score a day game" do
        before do
            DashboardService.new(user.id, wordle_type_game.id, 1).call
        end
        it "doesn't recreate a streak record second time play of a game" do
            streak_record = Dashboard.where(user_id: user.id, streak_record: true).size
            expect(streak_record).to eq(1)
        end
        it "doesn't increment streak count for same day replay" do
            streak_count = Dashboard.where(user_id: user.id, streak_record: true).first&.streak_count
            expect(streak_count).to eq(1)
        end
        it "doesn't create a second play record for second time play of a game" do
            play_record = Dashboard.where(user_id: user.id, game_id: wordle_type_game.id, streak_record: false).size
            expect(play_record).to eq(1)
        end
    end

    describe "call - second time non single score a day game" do
        before do
            DashboardService.new(user.id, sbee_type_game.id, 5).call
            DashboardService.new(user.id, sbee_type_game.id, 5).call
        end
        it "doesn't recreate a streak record" do
            streak_record = Dashboard.where(user_id: user.id, streak_record: true).size
            expect(streak_record).to eq(1)
        end
        it "doesn't increment streak count for same day replay" do
            streak_count = Dashboard.where(user_id: user.id, streak_record: true).first&.streak_count
            expect(streak_count).to eq(1)
        end
        it "doesn't create a second play record for second time play of a game" do
            play_record = Dashboard.where(user_id: user.id, game_id: sbee_type_game.id, streak_record: false).size
            expect(play_record).to eq(1)
        end
        it "score is cumulative on each day's play record" do
            play_record = Dashboard.where(user_id: user.id, game_id: sbee_type_game.id, streak_record: false).first&.score
            expect(play_record).to eq(10)
        end
    end

    describe "call - second time non single score a day game" do
        before do
            DashboardService.new(user.id, sbee_type_game.id, 5).call
            DashboardService.new(user.id, sbee_type_game.id, 5).call
        end
        it "doesn't recreate a streak record" do
            streak_record = Dashboard.where(user_id: user.id, streak_record: true).size
            expect(streak_record).to eq(1)
        end
        it "doesn't increment streak count for same day replay" do
            streak_count = Dashboard.where(user_id: user.id, streak_record: true).first&.streak_count
            expect(streak_count).to eq(1)
        end
        it "doesn't create a second play record for second time play of a game" do
            play_record = Dashboard.where(user_id: user.id, game_id: sbee_type_game.id, streak_record: false).size
            expect(play_record).to eq(1)
        end
        it "score is cumulative on each day's play record" do
            play_record = Dashboard.where(user_id: user.id, game_id: sbee_type_game.id, streak_record: false).first&.score
            expect(play_record).to eq(10)
        end
    end

    describe "call - streak resets to 1 if a play day has been missed" do
        before do
            Dashboard.create!(user_id: user.id, game_id: wordle_type_game.id, played_on: Date.today-2, score: 1)
            Dashboard.create!(user_id: user.id, game_id: -1, streak_record: true, streak_count: 5)
            DashboardService.new(user.id, wordle_type_game.id, 5).call
        end
        it "streak count reset to 1 since 'yesterday' play skipped" do
            streak_record = Dashboard.where(user_id: user.id, streak_record: true).first&.streak_count
            expect(streak_record).to eq(1)
        end
    end

    describe "call - streak increments by 1 if a play day has been not been missed" do
        before do
            Dashboard.create!(user_id: user.id, game_id: wordle_type_game.id, played_on: Date.yesterday, score: 1)
            Dashboard.create!(user_id: user.id, game_id: -1, streak_record: true, streak_count: 5)
            DashboardService.new(user.id, wordle_type_game.id, 5).call
        end
        it "streak count increments correclty" do
            streak_record = Dashboard.where(user_id: user.id, streak_record: true).first&.streak_count
            expect(streak_record).to eq(6)
        end
    end



end
require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
    before do
        User.destroy_all
        Game.create(id: -1, name: 'Test Dummy Game', game_path: 'test_game_path')
    end

    let(:user) do
        User.create!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
    end
    let!(:game_1) do
        Game.create(name: 'Test Game 1', game_path: 'test_game_path', single_score_per_day: true)
    end
    let!(:game_2) do
        Game.create(name: 'Test Game 2', game_path: 'test_game_path')
    end

    before do
        Dashboard.create!(user_id: user.id, game_id: game_1.id, played_on: Date.today-4, score: 1)
        Dashboard.create!(user_id: user.id, game_id: game_1.id, played_on: Date.today-3, score: 0)
        Dashboard.create!(user_id: user.id, game_id: game_1.id, played_on: Date.today-2, score: 1)
        Dashboard.create!(user_id: user.id, game_id: game_1.id, played_on: Date.today-1, score: 0)
        Dashboard.create!(user_id: user.id, game_id: game_1.id, played_on: Date.today, score: 1)

        Dashboard.create!(user_id: user.id, game_id: game_2.id, played_on: Date.today-2, score: 15)
        Dashboard.create!(user_id: user.id, game_id: game_2.id, played_on: Date.today-1, score: 15)

        Dashboard.create!(user_id: user.id, game_id: -1, streak_record: true, streak_count: 5)

        session[:user_id] = user.id
    end

    describe "show" do
        it "summarizes all the cumulative dashboard stats" do
            expected_response = {
                "total_games_played"=>7,
                "last_played_on"=>"today",
                "streak"=>5,
                1=>{
                    "name"=>"Test Game 1",
                    "last_played_on"=>"today",
                    "score"=>3
                },
                2=>{
                    "name"=>"Test Game 2",
                    "last_played_on"=>"1 days ago",
                    "score"=>30
                }
            }
            get :show, params: { id: user.id }
            expect(assigns(:dashboard_details)).to eq(expected_response)
        end
    end

    describe "game_history" do
        it 'sets the game' do
            get :game_history, params: { game_id: game_1.id }
            expect(assigns(:game)).to eq(game_1)
        end
        it 'sets the game_history' do
            get :game_history, params: { game_id: game_1.id }
            expect(assigns(:game_history).size).to eq(5)
        end
    end
end

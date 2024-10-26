# require 'rails_helper'

# RSpec.describe DashboardController, type: :controller do
#   let(:user) { double('User', id: 1) }

#   before do
#     # Mock the logged_in? method to simulate a logged-in user
#     allow(controller).to receive(:logged_in?).and_return(true)

#     # Mock current_user to return the simulated user
#     allow(controller).to receive(:current_user).and_return(user)

#     # Mock time_ago_in_words to return a static value
#     allow(controller).to receive(:time_ago_in_words).and_return('12h ago')

#     # Perform the GET request
#     get :show
#   end

#   describe 'GET #show' do
#     it 'renders the show template' do
#       expect(response).to render_template(:show)
#     end

#     it 'assigns @dummy_dashboard' do
#       expect(assigns(:dummy_dashboard)).not_to be_nil
#       expect(assigns(:dummy_dashboard)[:user_id]).to eq(1)
#       expect(assigns(:dummy_dashboard)[:total_games_played]).to eq(950)
#       expect(assigns(:dummy_dashboard)[:total_games_won]).to eq(450)
#       expect(assigns(:dummy_dashboard)[:last_played]).to eq('12h ago')
#     end

#     it 'assigns @dummy_games' do
#       expect(assigns(:dummy_games)).not_to be_nil
#       expect(assigns(:dummy_games).size).to eq(3)
#       expect(assigns(:dummy_games).first[:name]).to eq('Spelling Bee')
#     end
#   end
# end

# RSpec.describe Dashboard, type: :model do
#   let(:game_won) { double('Game', won?: true, played_on: Time.parse('2024-09-27')) }
#   let(:game_lost) { double('Game', won?: false, played_on: Time.parse('2024-09-28')) }

#   let(:dashboard) { Dashboard.create(total_games_played: 5, total_games_won: 3, last_played: nil) }

#   describe '#update_statistics' do
#     it 'increments total games played' do
#       expect { dashboard.update_statistics(game_won) }.to change { dashboard.total_games_played }.by(1)
#     end

#     it 'increments total games won if the game is won' do
#       expect { dashboard.update_statistics(game_won) }.to change { dashboard.total_games_won }.by(1)
#     end

#     it 'does not increment total games won if the game is lost' do
#       expect { dashboard.update_statistics(game_lost) }.not_to change { dashboard.total_games_won }
#     end

#     it 'updates the last played date' do
#       dashboard.update_statistics(game_won)
#       expect(dashboard.last_played).to eq(game_won.played_on)
#     end

#     it 'saves the dashboard record' do
#       expect(dashboard).to receive(:save)
#       dashboard.update_statistics(game_won)
#     end
#   end

#   describe '#time_ago_in_words' do
#     let(:controller) { DashboardController.new }

#     it 'returns minutes ago for times less than 60 minutes' do
#       time_ago = Time.now - 45.minutes
#       expect(controller.send(:time_ago_in_words, time_ago)).to eq("45m ago")
#     end

#     it 'returns hours ago for times between 60 and 1440 minutes' do
#       time_ago = Time.now - 3.hours
#       expect(controller.send(:time_ago_in_words, time_ago)).to eq("3h ago")
#     end

#     it 'returns days ago for times greater than or equal to 1440 minutes' do
#       time_ago = Time.now - 3.days
#       expect(controller.send(:time_ago_in_words, time_ago)).to eq("3d ago")
#     end
#   end
# end

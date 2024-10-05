require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:user) { double('User', id: 1) }

  before do
    # Mock the logged_in? method to simulate a logged-in user
    allow(controller).to receive(:logged_in?).and_return(true)

    # Mock current_user to return the simulated user
    allow(controller).to receive(:current_user).and_return(user)

    # Mock time_ago_in_words to return a static value
    allow(controller).to receive(:time_ago_in_words).and_return('12h ago')

    # Perform the GET request
    get :show
  end

  describe 'GET #show' do
    it 'renders the show template' do
      expect(response).to render_template(:show)
    end

    it 'assigns @dummy_dashboard' do
      expect(assigns(:dummy_dashboard)).not_to be_nil
      expect(assigns(:dummy_dashboard)[:total_games_played]).to eq(950)
      expect(assigns(:dummy_dashboard)[:total_games_won]).to eq(450)
      expect(assigns(:dummy_dashboard)[:last_played]).to eq('12h ago')
    end

    it 'assigns @dummy_games' do
      expect(assigns(:dummy_games)).not_to be_nil
      expect(assigns(:dummy_games).size).to eq(3)
      expect(assigns(:dummy_games).first[:name]).to eq('Spelling Bee')
    end
  end
end

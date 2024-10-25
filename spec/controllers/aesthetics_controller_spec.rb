require 'rails_helper'

RSpec.describe AestheticsController, type: :controller do
  before do
    Game.destroy_all
  end
  let!(:game) { Game.create(id: 1, name: "Example Game") }
  let!(:aesthetic) { Aesthetic.create(game_id: 1, colors: ['#000000'], labels: ['color'] , font: "Verdana") }
  let!(:user) { User.create(id: 1, email: "test@tamu.edu") }

  before do
    allow(controller).to receive(:logged_in?).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #edit' do
    it 'assigns the requested aesthetic to @aesthetic' do
      get :edit, params: { id: aesthetic.id }
      expect(assigns(:aesthetic)).to eq(aesthetic)
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      let(:valid_params) { { aesthetic: { colors: ['#000001'], font: 'Arial' } } }

      it 'updates the requested aesthetic' do
        patch :update, params: { id: aesthetic.id, aesthetic: valid_params[:aesthetic] }
        aesthetic.reload
        expect(aesthetic.colors[0]).to eq('#000001')
      end

      it 'sets a flash notice' do
        patch :update, params: { id: aesthetic.id, aesthetic: valid_params[:aesthetic] }
        expect(flash[:notice]).to eq('Aesthetic was successfully updated.')
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { aesthetic: { font: nil } } }
      
      it 'does not update the aesthetic' do
        patch :update, params: { id: aesthetic.id, aesthetic: invalid_params[:aesthetic] }
        aesthetic.reload
        expect(aesthetic.font).to eq('Verdana')
      end
  
      context 'with invalid hex color' do
        let(:invalid_params) { { aesthetic: { font: nil, colors: ['not a valid hex'] } } }
        
        it 'does not update colors' do
          patch :update, params: { id: aesthetic.id, aesthetic: invalid_params[:aesthetic] }
          aesthetic.reload
          expect(aesthetic.colors[0]).to eq('#000000')
        end
      end
    end
  end

  describe 'PATCH #reload_demo' do
    let(:valid_params) { { aesthetic: { colors: ['#000000'], font: 'Arial' } } }

    it 'reloads demo' do
      patch :reload_demo, params: { game_id: game.id, id: aesthetic.id, aesthetic: valid_params[:aesthetic] }
      aesthetic.reload
      expect(aesthetic.colors[0]).to eq('#000000')
    end

    context 'invalid params for reload' do
      let(:invalid_params) { { aesthetic: { font: nil, colors: ['not a valid hex'] } } }
      it 'fails if params is wrong' do
        patch :reload_demo, params: { game_id: game.id, id: aesthetic.id, aesthetic: invalid_params[:aesthetic] }
        aesthetic.reload
        expect(response.body).to include(/Font can't be blank/)
      end
    end
  end
end

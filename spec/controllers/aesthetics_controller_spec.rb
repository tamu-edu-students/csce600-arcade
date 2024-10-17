require 'rails_helper'

RSpec.describe AestheticsController, type: :controller do
  let!(:game) { Game.create(id: 1, name: "Example Game") }
  let!(:aesthetic) { Aesthetic.create(game_id: 1, primary_clr: "#FFFFFF", secondary_clr: "#000000", font_clr: "#FF0000", font: "Arial") }
  let!(:user) { User.create(id: 1, email:"test@tamu.edu") }

  before do
    allow(controller).to receive(:logged_in?).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    it 'renders the show template' do
      get :show, params: { game_id: game.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested aesthetic to @aesthetic' do
      get :edit, params: { game_id: game.id }
      expect(assigns(:aesthetic)).to eq(aesthetic)
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      let(:valid_params) { { aesthetic: { primary_clr: '#000000', secondary_clr: '#FFFFFF', font_clr: '#FF0000', font: 'Arial' } } }

      it 'updates the requested aesthetic' do
        patch :update, params: { game_id: game.id, id: aesthetic.id, aesthetic: valid_params[:aesthetic] }
        aesthetic.reload
        expect(aesthetic.primary_clr).to eq('#000000')
      end

      it 'redirects to the aesthetic' do
        patch :update, params: { game_id: game.id, id: aesthetic.id, aesthetic: valid_params[:aesthetic] }
        expect(response).to redirect_to(aesthetic)
      end

      it 'sets a flash notice' do
        patch :update, params: { game_id: game.id, id: aesthetic.id, aesthetic: valid_params[:aesthetic] }
        expect(flash[:notice]).to eq('Aesthetic was successfully updated.')
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { aesthetic: { primary_clr: nil, secondary_clr: nil, font_clr: nil, font: nil } } }
  
      it 'does not update the aesthetic' do
        original_primary_clr = aesthetic.primary_clr
        patch :update, params: { game_id: game.id, id: aesthetic.id, aesthetic: invalid_params[:aesthetic] }
        aesthetic.reload
        expect(aesthetic.primary_clr).to eq(original_primary_clr)
      end
    end
  end
end
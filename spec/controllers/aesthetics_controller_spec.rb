require 'rails_helper'

RSpec.describe AestheticsController, type: :controller do
  before do
    Game.destroy_all
  end
  let!(:game) { Game.create(id: 1, name: "Example Game") }
  let!(:aesthetic) { Aesthetic.create(game_id: 1, colors: [{label: 'Color', color: '#000000'}] , font: "Verdana") }
  let!(:user) { User.create(id: 1, email: "test@tamu.edu") }

  before do
    allow(controller).to receive(:logged_in?).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #edit' do
    it 'assigns the requested aesthetic to @aesthetic' do
      get :edit, params: { game_id: game.id }
      expect(assigns(:aesthetic)).to eq(aesthetic)
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      let(:valid_params) { { aesthetic: { colors: [{label: 'Color', color: '#000001'}], font: 'Arial' } } }

      it 'updates the requested aesthetic' do
        patch :update, params: { id: aesthetic.id, aesthetic: valid_params[:aesthetic] }
        aesthetic.reload
        expect(aesthetic.colors[0]['color']).to eq('#000001')
      end

      it 'sets a flash notice' do
        patch :update, params: { id: aesthetic.id, aesthetic: valid_params[:aesthetic] }
        expect(flash[:notice]).to eq('Aesthetic was successfully updated.')
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { aesthetic: { font: nil } } }

      it 'does not update the aesthetic' do
        patch :update, params: {id: aesthetic.id, aesthetic: invalid_params[:aesthetic] }
        aesthetic.reload
        expect(aesthetic.font).to eq('Verdana')
      end
    end
  end

  describe 'PATCH #reload_demo' do
    let(:valid_params) { { aesthetic: { primary_clr: '#000000', secondary_clr: '#FFFFFF', font_clr: '#FF0000', font: 'Arial' } } }

    it 'reloads demo' do
      patch :reload_demo, params: { game_id: game.id, id: aesthetic.id, aesthetic: valid_params[:aesthetic] }
      aesthetic.reload
      expect(aesthetic.primary_clr).to eq('#000000')
    end
  end
end

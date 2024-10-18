# spec/controllers/wordles_controller_spec.rb
require 'rails_helper'

RSpec.describe WordlesController, type: :controller do
    before do
        User.destroy_all
        Wordle.destroy_all
    
        Wordle.create(play_date: Date.today, word: 'apple')
        Wordle.create(play_date: Date.today+1, word: 'baked')
        Wordle.create(play_date: Date.today+2, word: 'cared')
      end

  let(:puzzle_setter) { User.create(first_name: 'Test', last_name: 'User', email: 'test@example.com') }
  let(:member) { User.create(first_name: 'Test2', last_name: 'User', email: 'test2@example.com') }

  before do
    Role.find_or_create_by!(user_id: member.id, role: "Member")
    session[:user_id] = member.id
  end

  describe 'GET #index' do
    it 'redirects to play path if no Puzzle Setters are enabled' do
      get :index
      expect(response).to redirect_to(wordles_play_path)
    end

    it 'redirects to play path if user is not a Puzzle Setter' do
      Role.find_or_create_by!(user_id: puzzle_setter.id, role: "Puzzle Setter")
      get :index
      expect(response).to redirect_to(wordles_play_path)
    end
  end
  
  describe 'DELETE #destroy' do
    before do
      allow(controller).to receive(:check_session_id)
    end
    it 'actually does the delete' do
      wordle = Wordle.create(play_date: Date.today+1000, word: 'floop')
      delete :destroy, params: { id: wordle.id }
      expect(Wordle.find_by(id: wordle.id)).to be_nil
    end
  end

  describe 'PATCH/PUT #update' do
    before do
      allow(controller).to receive(:check_session_id)
    end
    it 'actually does the update' do
      wordle = Wordle.create(play_date: Date.today+1000, word: 'floop')
      patch :update, params: { id: wordle.id, wordle: { word: 'ploof' } }
      wordle.reload
      expect(wordle.word).to eq('ploof')
    end
  end

  describe 'POST #create' do
    before do
      allow(controller).to receive(:check_session_id)
    end
    it 'actually does the create' do
      expect(Wordle.find_by(word: "ploof")).to be_nil
      post :create, params: {
        wordle: {
          play_date: Date.today,
          word: "ploof"
        }
      }
      expect(Wordle.find_by(word: "ploof")).not_to be_nil
    end
  end
end

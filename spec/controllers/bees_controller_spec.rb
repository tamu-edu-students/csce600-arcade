# spec/controllers/bees_controller_spec.rb
require 'rails_helper'

RSpec.describe BeesController, type: :controller do
  before do
    Bee.destroy_all
    allow(controller).to receive(:logged_in?).and_return(true)
  end

  describe "index" do
    before do
      allow(WordsService).to receive(:words).and_return(Array.new(25, ''))
    end

    it 'does index stuff' do
      get :index
      expect(assigns(:bees).length).to eq(7)
    end
  end

  describe "edit" do
    before do
      allow(WordsService).to receive(:words).and_return(Array.new(25, ''))
    end
    it 'edits' do
      bee = Bee.create(play_date: Date.today, letters: "abcdefg")
      get :edit, params: { id: bee.id }
      expect(assigns(:bee)).to eq(bee)
    end
  end

  describe "update" do
    context 'good update' do
      it 'updates the bee' do
        bee = Bee.create(play_date: Date.today, letters: "abcdefg")
        put :update, params: { id: bee.id, bee: { letters: "abcdefi" } }
        expect(Bee.find_by(id: bee.id).letters).to eq("abcdefi")
      end
    end

    context 'bad update' do
      it 'no up' do
        bee = Bee.create(play_date: Date.today, letters: "abcdefg")
        put :update, params: { id: bee.id, bee: { letters: "abcdeff" } }
        expect(flash[:alert]).to include(/Invalid update/)
      end

      it 'no up 1' do
        bee = Bee.create(play_date: Date.today, letters: "abcdefg")
        put :update, params: { id: bee.id, bee: { letters: "abc44ff" } }
        expect(flash[:alert]).to include(/Invalid update/)
      end
    end
  end

  describe 'play' do
    it 'plays' do
      bee = Bee.create(play_date: Date.today, letters: 'XZQPLMV')
      sb = Game.create(name: "Spelling Bee")
      Aesthetic.create(game_id: sb.id)
      get :play
      expect(assigns(:bee)).to eq(bee)
    end

    it 'makes and plays' do
      allow(WordsService).to receive(:words).and_return(Array.new(25, ''))
      sb = Game.create(name: "Spelling Bee")
      Aesthetic.create(game_id: sb.id)
      get :play
      expect(assigns(:bee).play_date).to eq(Date.today)
    end
  end

  describe "submit_guess" do
    it 'submits guess to service' do
      session[:sbwords] = []
      session[:sbscore] = 0
      bee = Bee.create(play_date: Date.today, letters: 'AUCRHIT')
      puts bee.errors.full_messages
      get :submit_guess, params: { sbword: "CHAIR" }
      expect(session[:sbscore]).to eq(2)
    end
  end
end

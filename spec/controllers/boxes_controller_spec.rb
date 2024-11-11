# spec/controllers/boxes_controller_spec.rb
require 'rails_helper'

RSpec.describe BoxesController, type: :controller do
  before do
    LetterBox.destroy_all
    allow(controller).to receive(:logged_in?).and_return(true)
  end

  describe 'edit' do
    it 'redirects to the puzzle setter page' do
      lb = LetterBox.create!(play_date: Date.today, letters: "cluesitojxnk")
      game = Game.create!(name: "Letter Boxed")
      Aesthetic.find_or_create_by(
        id: -1,
        game_id: game.id,
        labels: [ "Font" ],
        colors: [ '#000000' ],
        font: 'Verdana, sans-serif'
      )
      patch :edit, params: { id: lb.id }
      expect(assigns(:valid_words)).to eq(WordsService.words(lb.letters))
    end
  end

  describe 'update' do
    it 'prevents invalid updates' do
      lb = LetterBox.create!(play_date: Date.today, letters: "cluesitojxnk")
      game = Game.create!(name: "Letter Boxed")
      Aesthetic.find_or_create_by(
        id: -1,
        game_id: game.id,
        labels: [ "Font" ],
        colors: [ '#000000' ],
        font: 'Verdana, sans-serif'
      )
      patch :update, params: { id: lb.id, letter_box: { letters: "=bcdefghijk=" } }
      expect(flash[:alert]).to eq("Invalid update")
    end

    it 'modifies letters for the game' do
      lb = LetterBox.create!(play_date: Date.today, letters: "cluesitojxnk")
      game = Game.create!(name: "Letter Boxed")
      Aesthetic.find_or_create_by(
        id: -1,
        game_id: game.id,
        labels: [ "Font" ],
        colors: [ '#000000' ],
        font: 'Verdana, sans-serif'
      )
      patch :update, params: { id: lb.id, letter_box: { letters: "abcdefghijkl" } }
      expect(lb.reload.letters).to eq("abcdefghijkl")
    end
  end

  describe 'play' do
    it 'plays' do
      lb = LetterBox.create!(play_date: Date.today, letters: "cluesitojxnk")
      game = Game.create!(name: "Letter Boxed")
      Aesthetic.find_or_create_by(
        id: -1,
        game_id: game.id,
        labels: [ "Font" ],
        colors: [ '#000000' ],
        font: 'Verdana, sans-serif'
      )
      get :play
      expect(assigns(:letter_box)).to eq(lb)
    end
  end

  describe "submit_word" do
    before do
      session[:lbwords] = [ "cab" ]
      session[:lbscore] = 1
      session[:used_letters] = [ 'c', 'a', 'b' ]
    end

    it 'works' do
      lb = LetterBox.create!(play_date: Date.today, letters: "abcdefghijkl")
      get :submit_word, params: { lbword: "bag" }
      expect(assigns(:letter_box)).to eq(lb)
    end

    it "ends the game" do
      LetterBox.create!(play_date: Date.today, letters: "abcdefghijkl")
      session[:used_letters] = [ 'c', 'd', 'e', 'f', 'h', 'i', 'j', 'k', 'l' ]
      get :submit_word, params: { lbword: "bag" }
      expect(assigns(:game_won)).to eq(true)
    end

    it "updates the dashboard" do
      LetterBox.create!(play_date: Date.today, letters: "abcdefghijkl")
      Game.create!(name: "Letter Boxed")
      user = User.create!(first_name: 'Dummy', last_name: 'User', email: 'dummy@email.com')
      session[:user_id] = user.id
      allow(DashboardService).to receive(:new).and_return(double(call: true))
      session[:used_letters] = [ 'c', 'd', 'e', 'f', 'h', 'i', 'j', 'k', 'l' ]
      expect(controller).to receive(:update_stats).and_call_original
      get :submit_word, params: { lbword: "bag" }
    end
  end

  describe "reset" do
    before do
      session[:lbwords] = [ "cab" ]
      session[:lbscore] = 1
      session[:used_letters] = [ 'c', 'a', 'b' ]
    end

    it 'resets game' do
      get :reset
      expect(session[:lbwords]).to eq([])
      expect(session[:lbscore]).to eq(0)
      expect(session[:used_letters]).to eq([])
    end
  end
end

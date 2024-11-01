# spec/controllers/boxes_controller_spec.rb
require 'rails_helper'

RSpec.describe BoxesController, type: :controller do
  before do
    LetterBox.destroy_all
    allow(controller).to receive(:logged_in?).and_return(true)
  end

  describe 'play' do
    it 'plays' do
      boxed = LetterBox.create!(play_date: Date.today, letters: "clu-esi-toj-xnk")
      lb = Game.create!(name: "Letter Boxed")
      Aesthetic.find_or_create_by(
        id: -1,
        game_id: lb.id,
        labels: [ "Font" ],
        colors: [ '#000000' ],
        font: 'Verdana, sans-serif'
      )
      get :play
      expect(assigns(:letter_box)).to eq(boxed)
    end
  end

  describe "submit_word" do
    it 'works' do
      lb = LetterBox.create(play_date: Date.today, letters: "abcdefg")
      session[:lbwords] = [ "cab" ]
      session[:lbscore] = 1
      session[:used_letters] = [ 'c', 'a', 'b' ]
      get :submit_word, params: { lbword: "bag" }
      expect(assigns(:letter_box)).to eq(lb)
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

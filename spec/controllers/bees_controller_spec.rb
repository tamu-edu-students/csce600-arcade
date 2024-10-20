# spec/controllers/bees_controller_spec.rb
require 'rails_helper'

RSpec.describe BeesController, type: :controller do
  before do
    Bee.destroy_all
    allow(controller).to receive(:logged_in?).and_return(true)
  end

  describe "#dictionary_check" do
    let(:valid_word) { 'foot' }
    let(:invalid_word) { 'xyzzy' }

    it "returns true for a valid word in the dictionary" do
      allow(HTTP).to receive(:get).and_return(
          double(status: double(success?: true), parse: [ {} ])
      )
      expect(controller.send(:dictionary_check, valid_word)).to be true
    end

    it "returns false for an invalid word not in the dictionary" do
      allow(HTTP).to receive(:get).and_return(
          double(status: double(success?: true), parse: [])
      )
      expect(controller.send(:dictionary_check, invalid_word)).to be false
    end
  end

  describe "#valid_word?" do
    let(:valid_letters) { %w[A B C D O F] }
    let(:center_letter) { 'T' }
    before do
      session[:sbwords] = []
    end
    it "returns true for a valid word" do
      allow(controller).to receive(:dictionary_check).and_return(true)
      expect(controller.send(:valid_word?, 'BATT', valid_letters, center_letter)).to be true
    end
    it "returns false if the word does not include the center letter" do
      allow(controller).to receive(:dictionary_check).and_return(true)
      expect(controller.send(:valid_word?, 'FOOD', valid_letters, center_letter)).to be false
      expect(flash[:sb]).to eq("The word must include the center letter 'T'.")
    end
    it "returns false if the word contains invalid letters" do
      allow(controller).to receive(:dictionary_check).and_return(true)
      expect(controller.send(:valid_word?, 'CAXT', valid_letters, center_letter)).to be false
      expect(flash[:sb]).to eq("The word must be composed of the letters: A, B, C, D, O, F.")
    end
    it "returns false if the word is not in the dictionary" do
      allow(controller).to receive(:dictionary_check).and_return(false)
      expect(controller.send(:valid_word?, 'BATT', valid_letters, center_letter)).to be false
      expect(flash[:sb]).to eq("The word 'BATT' is not in the dictionary.")
    end
  end

  describe "index" do
    it 'does index stuff' do
      Bee.create(play_date: Date.today, letters: "abcdefg")
      get :index
      expect(assigns(:bees).length).to eq(7)
    end
  end

  describe "edit" do
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
  end

  describe "submit_guess" do
    context 'in correct guess' do
      before do
        allow(controller).to receive(:valid_word?).and_return(false)
      end
        it 'works' do
          bee = Bee.create(play_date: Date.today, letters: "abcdefg")
          get :submit_guess, params: { sbword: "WATERMELON" }
          expect(assigns(:bee)).to eq(bee)
        end
    end

    context 'correct guess' do
      before do
        allow(controller).to receive(:valid_word?).and_return(true)
      end
        it 'works' do
          bee = Bee.create(play_date: Date.today, letters: "abcdefg")
          get :submit_guess, params: { sbword: "WATERMELON" }
          expect(session[:sbwords]).to include("WATERMELON")
        end
    end

    context 'already guess' do
      before do
        allow(controller).to receive(:valid_word?).and_return(true)
        session[:sbwords] = [ "WATERMELON" ]
      end
        it 'works' do
          bee = Bee.create(play_date: Date.today, letters: "abcdefg")
          get :submit_guess, params: { sbword: "WATERMELON" }
          expect(flash[:sb]).to include(/You have already guessed that!/)
        end
    end
  end

  describe "#calculate_score" do
    it 'calcs score' do
      expect(controller.send(:calculate_score, "LARRY")).to eq(2)
    end
  end

  describe "reset session" do
    before do
      session[:sbwords] = [ "SOME", "RANDOM", "WORDS" ]
      session[:sbscore] = 100000
    end
    it 'resets session' do
      controller.send(:reset_spelling_bee_session)
      expect(session[:sbwords]).to be_nil
      expect(session[:sbscore]).to be_nil
    end
  end
end

# spec/helpers/wordles_helper_spec.rb
require 'rails_helper'

RSpec.describe WordlesHelper, type: :helper do
  before do
    allow_any_instance_of(WordlesHelper).to receive(:updateStats).and_return(nil)
  end
  let(:wordle) { Wordle.create(play_date: Date.today, word: "BROWN") }

  before(:each) do
    session[:user_id] = 1
    @wordle = wordle
    helper.reset_game_session(@wordle)
  end

  describe 'reset_game_session' do
    it "reinitializes all wordle-related session information" do
      helper.reset_game_session(@wordle)
      expect(session[:wordle_attempts]).to eq(0)
      expect(session[:wordle_alphabet_used]).to be_empty
      expect(session[:wordle_words_guessed]).to be_empty
      expect(session[:user_id]).to eq(1)
    end
  end

  describe 'check_word' do
    it "identifies a correctly guessed word" do
      results = [ "green", "green", "green", "green", "green" ]
      expect(helper.check_word(@wordle.word)).to match(results)
    end

    it "identifies an incorrectly guessed word" do
      results = [ "grey", "grey", "grey", "grey", "grey" ]
      expect(helper.check_word("metal")).to match(results)
    end

    it "identifies correct letters with wrong positions" do
      results = [ "yellow", "yellow", "green", "yellow", "grey" ]
      expect(helper.check_word("nworm")).to match(results)
    end
  end

  describe "validate_guess" do
    it "populates an error message if the guessed word is blank" do
      helper.validate_guess("")
      expect(@wordle.errors.full_messages).to include(/cannot be blank/)
    end

    it "populates an error message if the guessed word is shorter than 5 characters" do
      helper.validate_guess("abc")
      expect(@wordle.errors.full_messages).to include(/must be 5 characters long/)
    end

    it "populates an error message if the guessed word is longer than 5 characters" do
      helper.validate_guess("abcdefg")
      expect(@wordle.errors.full_messages).to include(/must be 5 characters long/)
    end

    it "populates an error message if the guessed word contains non-alphabet characters" do
      helper.validate_guess("abc4!")
      expect(@wordle.errors.full_messages).to include(/must only contain English alphabets/)
    end

    it "must not be a word that has already been guessed" do
      session[:wordle_words_guessed] = Set.new([ "mason" ])
      helper.validate_guess("mason")
    end
  end

  describe "make_guess" do
    it "increments attempts on a guess" do
      helper.make_guess("mason")
      expect(session[:wordle_attempts]).to eq(1)
    end

    it "populates an error message if attempts exceed 6" do
      session[:wordle_attempts] = 7
      helper.make_guess("apple")
      expect(session[:game_status]).to include(/lost/)
    end

    it "doesnt increase guess count for invalid word" do
      allow(helper).to receive(:validate_guess).and_return(false)
      session[:wordle_attempts] = 1
      helper.make_guess("the constitution")
      expect(session[:wordle_attempts]).to eq(1)
    end
  end
end

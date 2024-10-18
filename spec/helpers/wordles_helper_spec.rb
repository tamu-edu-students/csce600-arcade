require 'rails_helper'

RSpec.describe WordlesHelper, type: :helper do
  let(:wordle) { Wordle.create(play_date: Date.today, word: "brown") }

  before(:each) do
    allow(HTTP).to receive(:get).and_return(double(status: double(success?: true), parse: [{"shortdef" => ["not satisfied or fulfilled", "not having met"]}]))
    session[:user_id] = 1
    @wordle = wordle
    helper.reset_game_session(@wordle)
  end

  describe 'reset_game_session' do
    before do
      session[:wordle_attempts] = 3
      session[:wordle_alphabet_used] = Set['a', 'p', 'l', 'e']
      session[:wordle_words_guessed] = Set["apple", "zebra"]
    end

    it "reinitializes all wordle-related session information" do
      helper.reset_game_session(@wordle)
      expect(session[:wordle_attempts]).to eq(0)
      expect(session[:wordle_alphabet_used]).to be_empty
      expect(session[:wordle_words_guessed]).to be_empty
      expect(session[:user_id]).not_to be_nil
      expect(session[:user_id]).to eq(1)
    end
  end

  describe 'delete_game_session' do
    before do
      session[:wordle_attempts] = 3
      session[:wordle_alphabet_used] = Set['a', 'p', 'l', 'e']
      session[:wordle_words_guessed] = Set["apple", "zebra"]
    end

    it "deletes all wordle-related session information" do
      helper.delete_game_session
      expect(session[:wordle_attempts]).to be_nil
      expect(session[:wordle_alphabet_used]).to be_nil
      expect(session[:wordle_words_guessed]).to be_nil
      expect(session[:user_id]).not_to be_nil
    end
  end

  describe 'get_definition' do
    it "returns a valid definition when the API call is successful" do
      allow(HTTP).to receive(:get).and_return(double(status: double(success?: true), parse: [{"shortdef" => ["A valid definition"]}]))
      
      result = helper.get_definition('word')
      
      expect(result).to eq(["A valid definition"])
    end

    it "populates an error message if the API call fails" do
      allow(HTTP).to receive(:get).and_return(double(status: double(success?: false)))
      
      helper.get_definition('word')
      
      expect(@wordle.errors.full_messages).to include(/API call failed with status code/)
    end
  end

  describe 'check_word' do
    it "identifies a correctly guessed word" do
      results = ["green", "green", "green", "green", "green"]
      expect(helper.check_word(@wordle.word)).to match(results)
    end

    it "identifies an incorrectly guessed word" do
      results = ["grey", "grey", "grey", "grey", "grey"]
      expect(helper.check_word("metal")).to match(results)
    end

    it "identifies correct letters with wrong positions" do
      results = ["yellow", "yellow", "green", "yellow", "grey"]
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

    it "must not contain letters that have already been used" do
      session[:wordle_alphabet_used] = Set.new(["a"])
      helper.validate_guess("mason")
      expect(@wordle.errors.full_messages).to include(/Letter a already used/)
    end

    it "must not be a word that has already been guessed" do
      session[:wordle_words_guessed] = Set.new(["mason"])
      helper.validate_guess("mason")
      expect(@wordle.errors.full_messages).to include(/mason has already been guessed/)
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
      expect(@wordle.errors.full_messages).to include(/Exceeded maximum attempts/)
    end
  end
end

require 'rails_helper'

RSpec.describe WordleValidGuessesController, type: :controller do
  before do
    WordleValidGuess.create(word: "abcde")
    WordleValidGuess.create(word: "bcdef")
    WordleValidGuess.create(word: "cdefg")
  end
  let(:user) do
    User.create!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
  end
  before do
    session[:user_id] = user.id
  end

  describe "index" do
    it "returns all the valid guesses in the database" do
      get :index
      expect(assigns(:wordle_valid_guesses).size).to eq(3)
    end
  end

  describe "add_guesses" do
    it "appends records to the database" do
      patch :add_guesses, params: { "new_words_guesses"=>[ "apple" ] }
      expect(WordleValidGuess.all.size).to eq(4)
    end

    it "rolls back on an error" do
        patch :add_guesses, params: { "new_words_guesses"=>[ "abcde" ] }
        expect(WordleValidGuess.all.size).to eq(3)
    end
  end

  describe "overwrite_guesses" do
    it "replaces records to the database" do
      patch :overwrite_guesses, params: { "new_words_guesses"=>[ "apple" ] }
      expect(WordleValidGuess.all.size).to eq(1)
    end
  end

  describe "validation" do
    it "rejects words different from length 5" do
      patch :add_guesses, params: { "new_words_guesses"=>[ "ape" ] }
      expect(response.status).to eq(500)
    end

    it "rejects words when not an array" do
        patch :add_guesses, params: { "new_words_guesses"=>"ape" }
        expect(response.status).to eq(500)
      end
  end

  describe "create" do
    it "does the create" do
        post :create, params: {
            wordle_valid_guess: {
              word: "apple"
            }
          }, format: :json
      expect(WordleValidGuess.find_by(word: 'apple')).not_to be_nil
    end

    it "fails on a dupliate error on create" do
        post :create, params: {
            wordle_valid_guess: {
              word: "abcde"
            }
          }, format: :html
          expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "update" do
    it "does the update" do
        id = WordleValidGuess.find_by(word: 'abcde').id
        post :update, params: {
            id: id,
            wordle_valid_guess: {
              word: "apple"
            }
          }, format: :json
      expect(WordleValidGuess.find_by(id: id).word).to eq("apple")
    end

    it "fails on a duplicate word" do
        id = WordleValidGuess.find_by(word: 'abcde').id
        post :update, params: {
            id: id,
            wordle_valid_guess: {
              word: "bcdef"
            }
          }, format: :json
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be false
    end
  end
end

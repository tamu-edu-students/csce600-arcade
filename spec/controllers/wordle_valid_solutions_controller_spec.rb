require 'rails_helper'

RSpec.describe WordleValidSolutionsController, type: :controller do
  before do
    WordleValidSolution.create(word: "abcde")
    WordleValidSolution.create(word: "bcdef")
    WordleValidSolution.create(word: "cdefg")
  end
  let(:user) do
    User.create!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
  end
  before do
    session[:user_id] = user.id
  end

  describe "index" do
    it "returns all the valid solutions in the database" do
      get :index
      expect(assigns(:wordle_valid_solutions).size).to eq(3)
    end
  end

  describe "new" do
    it "initializes a new word solution" do
      get :new
      expect(assigns(:wordle_valid_solution)).to be_a_new(WordleValidSolution)
    end
  end

  describe "add_solutions" do
    it "appends records to the database" do
      patch :add_solutions, params: { "new_words_solutions"=>[ "apple" ] }
      expect(WordleValidSolution.all.size).to eq(4)
    end

    it "rolls back on an error" do
        patch :add_solutions, params: { "new_words_solutions"=>[ "abcde" ] }
        expect(WordleValidSolution.all.size).to eq(3)
    end
  end

  describe "overwrite_solutions" do
    it "replaces records to the database" do
      patch :overwrite_solutions, params: { "new_words_solutions"=>[ "apple" ] }
      expect(WordleValidSolution.all.size).to eq(1)
    end
  end

  describe "validation" do
    it "rejects words different from length 5" do
      patch :add_solutions, params: { "new_words_solutions"=>[ "ape" ] }
      expect(response.status).to eq(500)
    end

    it "rejects words when not an array" do
        patch :add_solutions, params: { "new_words_solutions"=>"ape" }
        expect(response.status).to eq(500)
      end
  end

  describe "create" do
    it "does the create" do
        post :create, params: {
            wordle_valid_solution: {
              word: "apple"
            }
          }, format: :html
      expect(WordleValidSolution.find_by(word: 'apple')).not_to be_nil
    end

    it "fails on a dupliate error on create" do
        post :create, params: {
            wordle_valid_solution: {
              word: "abcde"
            }
          }, format: :html
          expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "update" do
    it "does the update" do
        id = WordleValidSolution.find_by(word: 'abcde').id
        post :update, params: {
            id: id,
            wordle_valid_solution: {
              word: "apple"
            }
          }, format: :json
      expect(WordleValidSolution.find_by(id: id).word).to eq("apple")
    end

    it "fails on a duplicate word" do
        id = WordleValidSolution.find_by(word: 'abcde').id
        post :update, params: {
            id: id,
            wordle_valid_solution: {
              word: "bcdef"
            }
          }, format: :json
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be false
    end
  end

  describe "destroy" do
    it "does a destroy" do
      id = WordleValidSolution.find_by(word: 'abcde').id
      delete :destroy, params: { id: id }, format: :json
      expect(WordleValidSolution.find_by(id: id)).to be_nil
    end
  end
end

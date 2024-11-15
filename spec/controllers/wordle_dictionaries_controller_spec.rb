# spec/controllers/wordle_dictionaries_controllerspec.rb
require 'rails_helper'

RSpec.describe WordleDictionariesController, type: :controller do
  before do
    WordleDictionary.create!(word: 'apple', is_valid_solution: true)
    WordleDictionary.create!(word: 'avail', is_valid_solution: true)
    WordleDictionary.create!(word: 'brave', is_valid_solution: true)
    WordleDictionary.create!(word: 'stage', is_valid_solution: true)
    WordleDictionary.create!(word: 'aaaaa', is_valid_solution: false)
    WordleDictionary.create!(word: 'bbbbb', is_valid_solution: false)
    WordleDictionary.create!(word: 'ccccc', is_valid_solution: false)

    WordleDictionaryBackup.create!(word: 'apple', is_valid_solution: true)
    WordleDictionaryBackup.create!(word: 'ccccc', is_valid_solution: false)
  end

  let!(:game) { Game.create(id: 1, name: "Wordle") }
  let(:puzzle_setter) { User.create(first_name: 'Test', last_name: 'User', email: 'test@example.com') }
  let(:member) { User.create(first_name: 'Test2', last_name: 'User2', email: 'test2@example.com') }

  before do
    Role.find_or_create_by!(user_id: member.id, role: "Member")
    session[:user_id] = member.id
  end

  describe 'GET #index permissions' do
    it 'redirects to play path if no Puzzle Setters are enabled' do
      get :index
      expect(response).to redirect_to(welcome_path)
    end

    it 'redirects to play path if user is not a Puzzle Setter' do
      Role.find_or_create_by!(user_id: puzzle_setter.id, role: "Puzzle Setter")
      get :index
      expect(response).to redirect_to(wordles_play_path)
    end

    it 'redirects to play path if user is a guest' do
      session[:guest] = true
      get :index
      expect(response).to redirect_to(wordles_play_path)
    end
  end

  describe 'GET #index' do
    before do
      allow(controller).to receive(:check_session_id)
    end
    render_views
    it 'sets @wordle_dictionaries for html requests' do
      get :index, format: :html
      expect(assigns(:wordle_dictionaries).size).to eq(WordleDictionary.all.size)
    end
    it 'sets @wordle_dictionaries for json requests' do
      get :index, format: :json
      expect(assigns(:wordle_dictionaries).size).to eq(WordleDictionary.all.size)
    end
    it 'sorts words in ASC order by default' do
      get :index, format: :html
      expect(assigns(:wordle_dictionaries)&.map { |wordDict| wordDict.word }).to eq([ "aaaaa", "apple", "avail", "bbbbb", "brave", "ccccc", "stage" ])
    end
      it 'sorts words in DESC order when requested, json' do
      get :index, format: :json, params: { sort_order: "desc" }
      expect(assigns(:wordle_dictionaries)&.map { |wordDict| wordDict.word }).to eq([ "stage", "ccccc", "brave", "bbbbb", "avail", "apple", "aaaaa" ])
    end
      it 'returns only valid words when requested, json' do
      get :index, format: :json, params: { only_solutions: true }
      expect(assigns(:wordle_dictionaries)&.map { |wordDict| wordDict.word }).to eq([ "apple", "avail", "brave", "stage" ])
    end
      it 'returns only words matching partial input when requested, json' do
      get :index, format: :json, params: { word_part: "a" }
      expect(assigns(:wordle_dictionaries)&.map { |wordDict| wordDict.word }).to eq([ "aaaaa", "apple", "avail" ])
    end
      it 'returns only valid solutions matching partial input and sorted DESC when requested, json' do
      get :index, format: :json, params: { word_part: "a", only_solutions: true, sort_order: "desc" }
      expect(assigns(:wordle_dictionaries)&.map { |wordDict| wordDict.word }).to eq([ "avail", "apple" ])
    end
  end

  describe 'PATCH #amend_dict' do
    before do
      allow(controller).to receive(:check_session_id)
    end
    it 'returns an error if required params are missing' do
      patch :amend_dict, params: {}
      expect(response.body).to include('Please provide a list of valid words and select an update option')
    end
    it 'adds new solutions to the dictionary when requested' do
      patch :amend_dict, params: { new_words: "limit\nerror", update_opt: "add", valid_solutions: true }
      expect(WordleDictionary.where(is_valid_solution: true).size).to eq(6)
    end
    it 'replaces new solutions to the dictionary when requested' do
      patch :amend_dict, params: { new_words: "limit\nerror", update_opt: "replace", valid_solutions: true }
      expect(WordleDictionary.where(is_valid_solution: true).size).to eq(2)
    end
    it 'removes words from the dictionary when requested' do
      patch :amend_dict, params: { new_words: "apple\navail", update_opt: "remove", valid_solutions: true }
      expect(WordleDictionary.where(is_valid_solution: true)).not_to include("apple")
    end
    it 'on addition, updates non solution to solution in the dictionary when requested' do
      patch :amend_dict, params: { new_words: "limit\nerror\naaaaa", update_opt: "add", valid_solutions: true }
      expect(WordleDictionary.where(is_valid_solution: true)&.map { |wordDict| wordDict.word }).to include("aaaaa")
    end
    it 'on an error, database changes are rolled back' do
      patch :amend_dict, params: { new_words: "invalidword", update_opt: "replace", valid_solutions: true }
      expect(WordleDictionary.all.size).to eq(7)
    end
  end

  describe 'PATCH #reset_dict' do
    before do
      allow(controller).to receive(:check_session_id)
    end
    it 'resets the dictionary to the backup when requested' do
      patch :reset_dict
      expect(WordleDictionary.all.size).to eq(2)
    end
  end
end

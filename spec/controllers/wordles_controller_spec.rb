# spec/controllers/wordles_controller_spec.rb
require 'rails_helper'

RSpec.describe WordlesController, type: :controller do
    before do
        User.destroy_all
        Wordle.destroy_all

        Wordle.create(play_date: Date.today, word: 'apple')
        Wordle.create(play_date: Date.today+1, word: 'baked')
        Wordle.create(play_date: Date.today+2, word: 'cared')
        Wordle.create(play_date: Date.today+3, word: 'drone')
        Wordle.create(play_date: Date.today+4, word: 'eagle')
    end
    let(:puzzle_setter) do User.create(first_name: 'Test', last_name: 'User', email: 'test@example.com') end
    let(:member) do User.create(first_name: 'Test2', last_name: 'User', email: 'test2@example.com') end

    before do
        Role.find_or_create_by!(user_id: member.id, role: "Member")
        session[:user_id] = member.id
    end

    describe 'index' do
        it 'redirects with an error if there are no Puzzle Setters enabled' do
            get :index
            expect(response).to redirect_to(welcome_path)
        end

        it 'redirects with an error if the user is not a Puzzle Setter' do
            Role.find_or_create_by!(user_id: puzzle_setter.id, role: "Puzzle Setter")
            get :index
            expect(response).to redirect_to(welcome_path)
        end
    end

    describe "new" do
        it "assigns to @wordle" do
            Role.find_or_create_by!(user_id: puzzle_setter.id, role: "Puzzle Setter")
            session[:user_id] = puzzle_setter.id
            get :new
            expect(assigns(:wordle)).to be_a_new(Wordle)
        end
    end

    describe "deletes" do
        before do
            allow(controller).to receive(:check_session_id)
        end
        it 'actually does the delete' do
            wordle = Wordle.create(play_date: Date.today+1000, word: 'floop')
            delete :destroy, params: { id: wordle.id }
            expect(Wordle.find_by(id: wordle.id)).to be_nil
        end
    end

    describe "updates" do
        before do
            allow(controller).to receive(:check_session_id)
        end
        it 'actually does the update' do
            wordle = Wordle.create(play_date: Date.today+1000, word: 'floop')
            get :update, params: {
                id: wordle.id,
                wordle: {
                    word: 'ploof'
                }
            }
            expect(Wordle.find_by(id: wordle.id)).not_to be_nil
            expect(Wordle.find_by(id: wordle.id).word).to match "ploof"
            wordle.destroy!
        end
    end

    describe "creates" do
        before do
            allow(controller).to receive(:check_session_id)
        end
        it 'actually does the create' do
            expect(Wordle.find_by(word: "ploof")).to be_nil
            get :create, params: {
                wordle: {
                    play_date: Date.today,
                    word: "ploof"
                }
            }
            expect(Wordle.find_by(word: "ploof")).not_to be_nil
        end
    end

    describe "index" do
        before do
            allow(controller).to receive(:check_session_id)
        end
        it "fetches all words" do
            get :index
            expect(assigns(:wordles)).to eq(Wordle.all)
        end
    end
end

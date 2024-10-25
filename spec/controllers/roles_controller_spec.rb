# spec/controllers/settings_controller_spec.rb
require 'rails_helper'

RSpec.describe RolesController, type: :controller do
  before do
    User.destroy_all
    Role.destroy_all
  end

  describe 'index' do
    it 'redirects to games if no user' do
      user = User.find_or_create_by!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
      session[:user_id] = user.id
      patch :index
      expect(response).to redirect_to(games_path)
    end

    it 'sets the user being edited' do
      user = User.find_or_create_by!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
      session[:user_id] = user.id
      patch :index, params: { user_id: user.id }
      expect(assigns(:managing_user)).to eq(user)
    end
  end

  describe 'create' do
    it 'sets admin appropriately' do
      user = User.find_or_create_by!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
      session[:user_id] = user.id
      Role.find_or_create_by!(user_id: user.id, role: "Member")
      Settings.find_or_create_by!(user_id: user.id, active_roles: "")

      patch :create, params: { role: "System Admin", user_id: user.id }
      expect(Role.where(user_id: user.id).length).to eq(2)
    end

    it 'adds game roles appropriately' do
      user = User.find_or_create_by!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
      session[:user_id] = user.id
      Game.create!(name: "Wordle")
      Role.find_or_create_by!(user_id: user.id, role: "Member")
      Settings.find_or_create_by!(user_id: user.id, active_roles: "")

      patch :create, params: { role: "System Admin", user_id: user.id, game: "Wordle" }
      expect(Role.where(user_id: user.id).length).to eq(2)
    end
  end

  describe 'destroy' do
    it 'deletes admin appropriately' do
      user = User.find_or_create_by!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
      session[:user_id] = user.id
      admin = Role.find_or_create_by!(user_id: user.id, role: "System Admin")
      Role.find_or_create_by!(user_id: user.id, role: "Member")
      Settings.find_or_create_by!(user_id: user.id, active_roles: "")

      patch :destroy, params: { id: admin.id, role: "System Admin", user_id: user.id }
      expect(Role.where(user_id: user.id).length).to eq(1)
    end

    it 'deletes aestheticians and setters appropriately' do
      user = User.find_or_create_by!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
      session[:user_id] = user.id
      game = Game.create!(name: "Wordle")
      Role.find_or_create_by!(user_id: user.id, role: "Puzzle Aesthetician", game_id: game.id)
      Role.find_or_create_by!(user_id: user.id, role: "Member")
      Settings.find_or_create_by!(user_id: user.id, active_roles: "")

      patch :destroy, params: { id: "destroy_many", role: "Puzzle Aesthetician", user_id: user.id }
      expect(Role.where(user_id: user.id).length).to eq(1)
    end

    it 'deletes aestheticians/setters appropriately' do
      user = User.find_or_create_by!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
      session[:user_id] = user.id
      game = Game.create!(name: "Wordle")
      Role.find_or_create_by!(user_id: user.id, role: "Puzzle Setter", game_id: game.id)
      aesthetician = Role.find_or_create_by!(user_id: user.id, role: "Puzzle Aesthetician", game_id: game.id)
      Role.find_or_create_by!(user_id: user.id, role: "Member")
      Settings.find_or_create_by!(user_id: user.id, active_roles: "")

      patch :destroy, params: { id: aesthetician.id, user_id: user.id }
      expect(Role.where(user_id: user.id).length).to eq(2)
    end
  end
end

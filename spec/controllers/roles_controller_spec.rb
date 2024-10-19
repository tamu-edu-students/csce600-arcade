# spec/controllers/settings_controller_spec.rb
require 'rails_helper'

RSpec.describe RolesController, type: :controller do
  before do
    User.destroy_all
    Role.destroy_all
  end

  describe 'update_roles' do
    it 'sets admin appropriately' do
      user = User.find_or_create_by!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
      session[:user_id] = user.id
      Role.find_or_create_by!(user_id: user.id, role: "Member")
      Settings.find_or_create_by!(user_id: user.id, active_roles: "")

      patch :update_roles, params: { user_roles: { user.id => [ "System Admin", "Member" ] } }
      expect(response).to redirect_to(users_path)
      expect(Role.where(user_id: user.id).length).to eq(2)
    end

    it 'deletes admin appropriately' do
      user = User.find_or_create_by!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
      session[:user_id] = user.id
      Role.find_or_create_by!(user_id: user.id, role: "System Admin")
      Role.find_or_create_by!(user_id: user.id, role: "Member")
      Settings.find_or_create_by!(user_id: user.id, active_roles: "")

      patch :update_roles, params: { user_roles: { user.id => [ "Member" ] } }
      expect(response).to redirect_to(users_path)
      expect(Role.where(user_id: user.id).length).to eq(1)
    end

    it 'deletes user if Member is removed' do
      user = User.find_or_create_by!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
      session[:user_id] = user.id
      Role.find_or_create_by!(user_id: user.id, role: "Member")
      Settings.find_or_create_by!(user_id: user.id, active_roles: "")

      patch :update_roles, params: { user_roles: { user.id => [ "System Admin" ] } }
      expect(User.find_by(id: user.id)).to be_nil
    end

    it 'deletes aestheticians and setters appropriately' do
      user = User.find_or_create_by!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
      session[:user_id] = user.id
      game = Game.create!(name: "Wordle")
      Role.find_or_create_by!(user_id: user.id, role: "Puzzle Aesthetician", game_id: game.id)
      Role.find_or_create_by!(user_id: user.id, role: "Member")
      Settings.find_or_create_by!(user_id: user.id, active_roles: "")

      patch :update_roles, params: { user_roles: { user.id => [ "Member" ] } }
      expect(response).to redirect_to(users_path)
      expect(Role.where(user_id: user.id).length).to eq(1)
    end

    it 'deletes aestheticians appropriately' do
      user = User.find_or_create_by!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
      session[:user_id] = user.id
      game = Game.create!(name: "Wordle")
      Role.find_or_create_by!(user_id: user.id, role: "Puzzle Setter", game_id: game.id)
      Role.find_or_create_by!(user_id: user.id, role: "Puzzle Aesthetician", game_id: game.id)
      Role.find_or_create_by!(user_id: user.id, role: "Member")
      Settings.find_or_create_by!(user_id: user.id, active_roles: "")

      patch :update_roles, params: { user_roles: { user.id => [ "Member" ] }, user_roles_games: { user.id=> { "Puzzle Setter"=>[ "Wordle" ] } } }
      expect(response).to redirect_to(users_path)
      expect(Role.where(user_id: user.id).length).to eq(2)
    end

    it 'deletes setters appropriately' do
      user = User.find_or_create_by!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
      session[:user_id] = user.id
      game = Game.create!(name: "Wordle")
      Role.find_or_create_by!(user_id: user.id, role: "Puzzle Setter", game_id: game.id)
      Role.find_or_create_by!(user_id: user.id, role: "Puzzle Aesthetician", game_id: game.id)
      Role.find_or_create_by!(user_id: user.id, role: "Member")
      Settings.find_or_create_by!(user_id: user.id, active_roles: "")

      patch :update_roles, params: { user_roles: { user.id => [ "Member" ] }, user_roles_games: { user.id=> { "Puzzle Aesthetician"=>[ "Wordle" ] } } }
      expect(response).to redirect_to(users_path)
      expect(Role.where(user_id: user.id).length).to eq(2)
    end

    it 'deletes multiples appropriately' do
      user = User.find_or_create_by!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
      session[:user_id] = user.id
      wordle = Game.create!(name: "Wordle")
      bee = Game.create!(name: "Spelling Bee")
      Role.find_or_create_by!(user_id: user.id, role: "Puzzle Aesthetician", game_id: wordle.id)
      Role.find_or_create_by!(user_id: user.id, role: "Puzzle Aesthetician", game_id: bee.id)
      Role.find_or_create_by!(user_id: user.id, role: "Member")
      Settings.find_or_create_by!(user_id: user.id, active_roles: "")

      patch :update_roles, params: { user_roles: { user.id => [ "Member" ] }, user_roles_games: { user.id=> { "Puzzle Aesthetician"=>[ "Wordle" ] } } }
      expect(response).to redirect_to(users_path)
      expect(Role.where(user_id: user.id).length).to eq(2)
    end

    it 'adds game roles appropriately' do
      user = User.find_or_create_by!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
      session[:user_id] = user.id
      Game.create!(name: "Wordle")
      Role.find_or_create_by!(user_id: user.id, role: "Member")
      Settings.find_or_create_by!(user_id: user.id, active_roles: "")

      patch :update_roles, params: { user_roles: { user.id => [ "Member" ] }, user_roles_games: { user.id=> { "Puzzle Aesthetician"=>[ "Wordle" ] } } }
      expect(response).to redirect_to(users_path)
      expect(Role.where(user_id: user.id).length).to eq(2)
    end
  end
end

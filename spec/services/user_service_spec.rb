require 'rails_helper'

RSpec.describe UserService do
  before do
    User.destroy_all
  end
  describe 'find or create user' do
    let(:auth) do
      {
        "info" => {
          "email" => "test@tamu.edu",
          "name" => "Test User"
        }
      }
    end

     context 'when no user' do
       before do
         allow(UserRepository).to receive(:find_by_email).with(auth["info"]["email"]).and_return(nil)
         allow(UserRepository).to receive(:create_user).with(
           email: auth["info"]["email"],
           first_name: "Test",
           last_name: "User"
         ).and_return(User.create(email: auth["info"]["email"], first_name: "Test", last_name: "User"))
         allow(Role).to receive(:create)
       end

       it 'creates new user' do
         user = UserService.find_or_create_user(auth)

         expect(user.email).to eq("test@tamu.edu")
         expect(UserRepository).to have_received(:create_user)
         # expect(Role).to have_received(:create).with(user_id: user.id, role: "Member")
       end
    end

    context 'when user' do
      let(:existing_user) { User.create(email: "test@tamu.edu", first_name: "Test", last_name: "User") }

      before do
        allow(UserRepository).to receive(:find_by_email).with(auth["info"]["email"]).and_return(existing_user)
        allow(UserRepository).to receive(:create_user)
      end

      it 'returns user' do
        user = UserService.find_or_create_user(auth)

        expect(user).to eq(existing_user)
        expect(UserRepository).not_to have_received(:create_user)
      end
    end
  end

  describe 'spotify_user' do
    let(:auth) do
      {
        "extra" => {
          "raw_info" => {
            "id" => "test_spotify_user",
            "display_name" => "Test User"
          }
        }
      }
    end

    context 'when no user exists' do
      before do
        allow(UserRepository).to receive(:find_by_su).with(auth["extra"]["raw_info"]["id"]).and_return(nil)
        allow(UserRepository).to receive(:create_spotify).with(
          spotify_username: auth["extra"]["raw_info"]["id"],
          first_name: "Test",
          last_name: "User"
        ).and_return(User.create(spotify_username: auth["extra"]["raw_info"]["id"], first_name: "Test", last_name: "User"))
        allow(Role).to receive(:create!)
      end

      it 'creates a new user' do
        user = UserService.spotify_user(auth)

        expect(user.spotify_username).to eq("test_spotify_user")
        expect(UserRepository).to have_received(:create_spotify)
        expect(Role).to have_received(:create!).with(user_id: user.id, role: "Member")
      end
    end

    context 'when user exists' do
      let(:existing_user) { User.create(spotify_username: "test_spotify_user", first_name: "Test", last_name: "User") }

      before do
        allow(UserRepository).to receive(:find_by_su).with(auth["extra"]["raw_info"]["id"]).and_return(existing_user)
        allow(UserRepository).to receive(:create_spotify)
      end

      it 'returns the existing user' do
        user = UserService.spotify_user(auth)

        expect(user).to eq(existing_user)
        expect(UserRepository).not_to have_received(:create_spotify)
      end
    end
  end

  describe 'github_user' do
    let(:auth) do
      {
        "info" => {
          "nickname" => "test_github_user",
          "name" => "Test User"
        }
      }
    end

    context 'when no user exists' do
      before do
        allow(UserRepository).to receive(:find_by_gu).with(auth["info"]["nickname"]).and_return(nil)
        allow(UserRepository).to receive(:create_github).with(
          github_username: auth["info"]["nickname"],
          first_name: "Test",
          last_name: "User"
        ).and_return(User.create(github_username: auth["info"]["nickname"], first_name: "Test", last_name: "User"))
        allow(Role).to receive(:create!)
      end

      it 'creates a new user' do
        user = UserService.github_user(auth)

        expect(user.github_username).to eq("test_github_user")
        expect(UserRepository).to have_received(:create_github)
        expect(Role).to have_received(:create!).with(user_id: user.id, role: "Member")
      end
    end

    context 'when user exists' do
      let(:existing_user) { User.create(github_username: "test_github_user", first_name: "Test", last_name: "User") }

      before do
        allow(UserRepository).to receive(:find_by_gu).with(auth["info"]["nickname"]).and_return(existing_user)
        allow(UserRepository).to receive(:create_github)
      end

      it 'returns the existing user' do
        user = UserService.github_user(auth)

        expect(user).to eq(existing_user)
        expect(UserRepository).not_to have_received(:create_github)
      end
    end

    context 'when auth name is nil' do
      before do
        auth["info"]["name"] = nil
        allow(UserRepository).to receive(:find_by_gu).with(auth["info"]["nickname"]).and_return(nil)
        allow(UserRepository).to receive(:create_github).with(
          github_username: auth["info"]["nickname"],
          first_name: "New",
          last_name: "User"
        ).and_return(User.create(github_username: auth["info"]["nickname"], first_name: "New", last_name: ""))
        allow(Role).to receive(:create!)
      end

      it 'creates a new user with first name "Hello"' do
        user = UserService.github_user(auth)

        expect(user.first_name).to eq("New")
      end
    end
  end

  describe 'find by id' do
    let(:user_id) { 1 }
    let(:user) { User.new(id: user_id, email: "test@tamu.edu", first_name: "Test", last_name: "User") }

    before do
      allow(UserRepository).to receive(:find_by_id).with(user_id).and_return(user)
    end

    it 'returns user' do
      found_user = UserService.find_user_by_id(user_id)

      expect(found_user).to eq(user)
    end
  end

  describe 'fetch all' do
    let!(:users) do
      [
        User.new(id: 1, email: "test@tamu.edu", first_name: "Test", last_name: "User"),
        User.new(id: 2, email: "test1@tamu.edu", first_name: "Test", last_name: "User1")
      ]
    end

    before do
      allow(UserRepository).to receive(:fetch_all).and_return(users)
    end

    it 'returns users' do
      fetched_users = UserService.fetch_all

      expect(fetched_users).to match_array(users)
    end
  end
end

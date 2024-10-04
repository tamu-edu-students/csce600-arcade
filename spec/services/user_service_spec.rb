require 'rails_helper'

RSpec.describe UserService do
  describe 'find or create user' do
    let(:auth) do
      {
        "uid" => "1",
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
           uid: auth["uid"],
           email: auth["info"]["email"],
           first_name: "Test",
           last_name: "User"
         ).and_return(User.create(uid: auth["uid"], email: auth["info"]["email"], first_name: "Test", last_name: "User"))
         allow(Role).to receive(:create)
       end

       it 'creates new user' do
         user = UserService.find_or_create_user(auth)

         expect(user.uid).to eq("1")
         expect(user.email).to eq("test@tamu.edu")
         expect(UserRepository).to have_received(:create_user)
         # expect(Role).to have_received(:create).with(user_id: user.id, role: "Member")
       end
    end

    context 'when user' do
      let(:existing_user) { User.create(uid: "1", email: "test@tamu.edu", first_name: "Test", last_name: "User") }

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

  describe 'find by id' do
    let(:user_id) { 1 }
    let(:user) { User.new(id: user_id, uid: "1", email: "test@tamu.edu", first_name: "Test", last_name: "User") }

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
        User.new(id: 1, uid: "1", email: "test@tamu.edu", first_name: "Test", last_name: "User"),
        User.new(id: 2, uid: "2", email: "test1@tamu.edu", first_name: "Test", last_name: "User1")
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

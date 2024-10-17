require 'rails_helper'

RSpec.describe UserRepository do
  before do
    User.destroy_all
  end
  let!(:user) { User.create(email: 'test@tamu.edu', first_name: 'Test', last_name: 'User', spotify_username: 'test_spotify', github_username: 'test_github') }
  describe 'find by id' do
    it 'returns user' do
      found_user = UserRepository.find_by_id(user.id)
      expect(found_user).to eq(user)
    end

    it 'returns nil' do
      expect(UserRepository.find_by_id(-1)).to be_nil
    end
  end

  describe 'find by email' do
    it 'returns user' do
      found_user = UserRepository.find_by_email('test@tamu.edu')
      expect(found_user).to eq(user)
    end

    it 'returns nil' do
      expect(UserRepository.find_by_email('not_test@tamu.edu')).to be_nil
    end
  end

  describe 'find by spotify' do
    it 'returns user' do
      found_user = UserRepository.find_by_su('test_spotify')
      expect(found_user).to eq(user)
    end

    it 'returns nil' do
      expect(UserRepository.find_by_su('not_test_spotify')).to be_nil
    end
  end

  describe 'find by github' do
    it 'returns user' do
      found_user = UserRepository.find_by_gu('test_github')
      expect(found_user).to eq(user)
    end

    it 'returns nil' do
      expect(UserRepository.find_by_gu('not_test_github')).to be_nil
    end
  end

  describe 'crete' do
    it 'creat user' do
      new_user = UserRepository.create_user(email: 'new@tamu.edu', first_name: 'New', last_name: 'User')
      expect(new_user).to be_persisted
    end
  end

  describe 'crete spotify' do
    it 'creat new spotify' do
      new_user = UserRepository.create_spotify(spotify_username: 'test_spotify_more', first_name: 'New', last_name: 'User')
      expect(new_user).to be_persisted
    end
  end

  describe 'crete github' do
    it 'creat new github' do
      new_user = UserRepository.create_github(github_username: 'test_github_more', first_name: 'New', last_name: 'User')
      expect(new_user).to be_persisted
    end
  end

  describe 'fetch all' do
    it 'returns all users' do
      users = UserRepository.fetch_all
      expect(users).to include(user)
    end
  end
end

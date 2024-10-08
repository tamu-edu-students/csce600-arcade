require 'rails_helper'

RSpec.describe UserRepository do
  before do
    User.destroy_all
  end
  let!(:user) { User.create(uid: '1', email: 'test@tamu.edu', first_name: 'Test', last_name: 'User') }

  describe 'find by uid' do
    it 'returns user' do
      found_user = UserRepository.find_by_uid('1')
      expect(found_user).to eq(user)
    end

    it 'returns nil' do
      expect(UserRepository.find_by_uid('not 1')).to be_nil
    end
  end

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

  describe 'crete' do
    it 'creat user' do
      new_user = UserRepository.create_user(uid: '2', email: 'new@tamu.edu', first_name: 'New', last_name: 'User')
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

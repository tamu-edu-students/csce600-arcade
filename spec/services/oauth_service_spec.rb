require 'rails_helper'

RSpec.describe OauthService do
  let(:auth_google) do
    { "provider" => "google_oauth2", "info" => { "email" => "test_email@gmail.com", "name" => "Test User" } }
  end

  let(:auth_github) do
    { "provider" => "github", "info" => { "nickname" => "test_github", "name" => "Test User" } }
  end

  let(:auth_spotify) do
    { "provider" => "spotify", "extra" => { "raw_info" => { "id" => "test_spotify", "display_name" => "Test User" } } }
  end

  before do
    user = User.create(id: 1)
  end

  describe '#connect_user' do
    it 'calls existing_user' do
        service = OauthService.new(auth_google, 1)
        expect(service).to receive(:existing_user)
        service.connect_user
    end

    it 'calls new_user' do
        service = OauthService.new(auth_google)
        expect(service).to receive(:new_user)
        service.connect_user
    end
  end

  describe '#existing_user' do
    it 'returns success when connecting a new account' do
      service = OauthService.new(auth_google, 1)
      result = service.connect_user
      expect(result[:success]).to be_truthy
    end

    it 'returns failure if account already exists' do
        User.create(email: "test_email@gmail.com")
        service = OauthService.new(auth_google, 1)
        result = service.send(:existing_user)
        expect(result[:success]).to be_falsy
    end

    it 'gets github info' do
        service = OauthService.new(auth_github, 1)
        result = service.send(:existing_user)
        expect(result[:success]).to be_truthy
    end

    it 'gets spotify info' do
        service = OauthService.new(auth_spotify, 1)
        result = service.send(:existing_user)
        expect(result[:success]).to be_truthy
    end
  end

  describe 'new gmail user' do
    it 'connects if valid' do
        service = OauthService.new(auth_google)
        result = service.connect_user
        expect(result[:success]).to be_truthy
    end
  end

  describe 'new github user' do
    it 'connects if valid' do
        service = OauthService.new(auth_github)
        result = service.connect_user
        expect(result[:success]).to be_truthy
    end
  end

  describe 'new spotify user' do
    it 'connects if valid' do
        service = OauthService.new(auth_spotify)
        result = service.connect_user
        expect(result[:success]).to be_truthy
    end

    it 'fails if invalid' do
        service = OauthService.new(auth_spotify)
        invalid_user = double('User', valid?: false)
        allow(service).to receive(:find_or_create_user).and_return(invalid_user)
        result = service.connect_user
        expect(result[:success]).to be_falsy
    end
  end
end

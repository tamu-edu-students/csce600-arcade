require 'rails_helper'

RSpec.describe UserService do
  before do
    User.destroy_all
  end

  describe 'connections' do
    let(:user) { User.new(id: 1, email: "test@tamu.edu", github_username: "testgit", spotify_username: "testspot", first_name: "Test", last_name: "User") }
    it 'connects' do
      auths =  UserService.fetch_connected_auths(user)
      expect(auths["email"]).to eq("test@tamu.edu")
      expect(auths["github"]).to eq("testgit")
      expect(auths["spotify"]).to eq("testspot")
    end
  end
end

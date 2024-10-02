require 'test_helper'
require 'action_controller'

class UserRepositoryTest < ActiveSupport::TestCase
  def setup
    @user_repo = UserRepository.new
  end

  test "should create user with valid params" do
    params = ActionController::Parameters.new(name: "New Repo User", email: "newrepo@example.com", session: "active", roleId: "player")
    user = @user_repo.create(params)
    assert_not_nil user
    assert_equal "New Repo User", user.name
  end

  test "should not create user with missing email" do
    params = ActionController::Parameters.new(name: "No Email User", session: "active", roleId: "player")

    assert_no_difference 'User.count' do
      @user_repo.create(params)
    end
  end
end

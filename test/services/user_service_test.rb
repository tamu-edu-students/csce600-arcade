require "test_helper"

class UserServiceTest < ActiveSupport::TestCase
    def setup
        @user_repo = UserRepository.new
        @user_service = UserService.new(@user_repo)
    end

    test "should find or create user" do
        user_data = { name: "Test Service", email: "service@example.com", session: "active", roleId: "player" }

        user_params = ActionController::Parameters.new(user_data)

        user = @user_service.find_or_create_user(user_params)
        assert_not_nil user
        assert_equal "Test Service", user.name

        same_user = @user_service.find_or_create_user(user_params)
        assert_equal user.id, same_user.id
    end

    test "should update user" do
        user = User.create(name: "Old Service", email: "service_update@example.com", session: "active", roleId: "player")
        updated_user = @user_service.update_user(user.id, { name: "New Service", session: "inactive" })
        assert_equal "New Service", updated_user.name
        assert_equal "inactive", updated_user.session
    end

    test "should delete user" do
        user = User.create(name: "Service Delete", email: "service_delete@example.com", session: "active", roleId: "player")
        result = @user_service.delete_user(user.id)
        assert result
        assert_nil User.find_by(email: "service_delete@example.com")
    end

    # test "should find all connected oauths" do
    #     user = User.create(name: "Service OAuth", email: "google@gmail.com")
    #     connected_auths = @user_service.find_all_connected_oauths(user)
        
    #     # Verify that the connected auths contain the email as expected
    #     assert_equal({"email" => "google@gmail.com"}, connected_auths)
    # end
end

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
    test "should not update non-existing user" do
        put "/api/users/999", params: { user: { name: "Non Existent" } }
        assert_response :unprocessable_entity
        json_response = JSON.parse(response.body)
        assert_equal "User update failed", json_response["message"]
    end

    test "should handle logout for non-existing user" do
        post "/api/users/999/logout"
        assert_response :unprocessable_entity
        json_response = JSON.parse(response.body)
        assert_equal "Logout failed", json_response["message"]
    end
end

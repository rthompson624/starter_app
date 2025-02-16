require "test_helper"

module Api
  module V1
    class SessionsControllerTest < ActionDispatch::IntegrationTest
      def setup
        @user = users(:one) # This will use the fixture we'll create next
        @user.save
      end

      test "should get JWT token on valid login" do
        post api_v1_login_path, params: {
          user: {
            email: @user.email,
            password: "password123"
          }
        }, as: :json

        assert_response :success
        assert_not_nil json_response["token"]
        assert_equal "Logged in successfully.", json_response["status"]["message"]
      end

      test "should not get JWT token on invalid login" do
        post api_v1_login_path, params: {
          user: {
            email: @user.email,
            password: "wrongpassword"
          }
        }, as: :json

        assert_response :unauthorized
        assert_equal "Invalid email or password.", json_response["status"]["message"]
      end

      test "should logout successfully" do
        # First login to get the token
        post api_v1_login_path, params: {
          user: {
            email: @user.email,
            password: "password123"
          }
        }, as: :json

        token = json_response["token"]

        # Then try to logout
        delete api_v1_logout_path, headers: { 'Authorization': "Bearer #{token}" }
        assert_response :success
      end

      private

      def json_response
        JSON.parse(response.body)
      end
    end
  end
end

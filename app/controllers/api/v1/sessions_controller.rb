module Api
  module V1
    class SessionsController < Api::V1::ApplicationController
      skip_before_action :authenticate_user!, only: [ :create ]
      respond_to :json

      def create
        user = User.find_by(email: params[:user][:email])

        if user && user.valid_password?(params[:user][:password])
          token = JWT.encode(
            { sub: user.id, exp: 24.hours.from_now.to_i },
            Rails.application.secret_key_base
          )
          render json: {
            status: { code: 200, message: "Logged in successfully." },
            data: UserSerializer.new(user).serializable_hash[:data][:attributes],
            token: token
          }
        else
          render json: {
            status: { message: "Invalid email or password." }
          }, status: :unauthorized
        end
      end

      def destroy
        # Blacklist the token or handle logout as needed
        render json: {
          status: 200,
          message: "Logged out successfully."
        }
      end
    end
  end
end

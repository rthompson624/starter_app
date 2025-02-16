module Api
  module V1
    class SessionsController < Api::V1::ApplicationController
      skip_before_action :authenticate_user!, only: [ :create ]
      respond_to :json

      def create
        user = User.find_by(email: params[:user][:email])

        if user && user.valid_password?(params[:user][:password])
          payload = {
            sub: user.id,
            exp: 24.hours.from_now.to_i,
            jti: user.jti
          }

          token = JWT.encode(payload, Rails.application.secret_key_base)

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
        if current_user
          # Invalidate the user's JWT token by regenerating their jti
          current_user.update!(jti: SecureRandom.uuid)

          render json: {
            status: 200,
            message: "Logged out successfully."
          }
        else
          render json: {
            status: 401,
            message: "User not found."
          }, status: :unauthorized
        end
      end
    end
  end
end

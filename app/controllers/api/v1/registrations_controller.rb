module Api
  module V1
    class RegistrationsController < Api::V1::ApplicationController
      skip_before_action :authenticate_user!, only: [ :create ]
      respond_to :json

      def create
        user = User.new(sign_up_params)
        if user.save
          token = JWT.encode(
            { sub: user.id, exp: 24.hours.from_now.to_i },
            Rails.application.secret_key_base
          )
          render json: {
            status: { code: 200, message: "Signed up successfully." },
            data: UserSerializer.new(user).serializable_hash[:data][:attributes],
            token: token
          }
        else
          render json: {
            status: { message: "User couldn't be created successfully. #{user.errors.full_messages.to_sentence}" }
          }, status: :unprocessable_entity
        end
      end

      private

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

      def account_update_params
        params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
      end
    end
  end
end

module Api
  module V1
    class ApplicationController < ActionController::API
      include ActionController::MimeResponds
      respond_to :json
      before_action :authenticate_user!

      private

      def authenticate_user!
        if request.headers["Authorization"].present?
          begin
            token = request.headers["Authorization"].split(" ").last
            decoded = JWT.decode(token, Rails.application.secret_key_base).first

            # Verify the token hasn't been revoked (check jti)
            user = User.find(decoded["sub"])
            if user && user.jti == decoded["jti"]
              @current_user_id = user.id
            else
              render json: { error: "Token has been revoked" }, status: :unauthorized
            end
          rescue JWT::ExpiredSignature
            render json: { error: "Token has expired" }, status: :unauthorized
          rescue JWT::DecodeError
            render json: { error: "Invalid token" }, status: :unauthorized
          end
        else
          render json: { error: "Token missing" }, status: :unauthorized unless params[:controller] == "api/v1/sessions" && params[:action] == "create"
        end
      end

      def current_user
        @current_user ||= User.find(@current_user_id) if @current_user_id
      end
    end
  end
end

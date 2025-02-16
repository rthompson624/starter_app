module Api
  module V1
    class ApplicationController < ActionController::API
      include ActionController::MimeResponds
      respond_to :json
      before_action :authenticate_user!

      private

      def authenticate_user!
        if request.headers["Authorization"].present?
          jwt_payload = JWT.decode(request.headers["Authorization"].split(" ").last, Rails.application.secret_key_base).first
          @current_user_id = jwt_payload["sub"]
        end

        render json: { error: "Not Authorized" }, status: 401 unless current_user
      end

      def current_user
        @current_user ||= User.find(@current_user_id)
      rescue StandardError
        nil
      end
    end
  end
end

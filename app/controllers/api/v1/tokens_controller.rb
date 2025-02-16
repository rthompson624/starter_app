module Api
  module V1
    class TokensController < Api::V1::ApplicationController
      def validate
        if current_user
          render json: {
            user: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
          }
        else
          render json: { error: "Invalid token" }, status: :unauthorized
        end
      end
    end
  end
end

module Api
  class BaseController < ApplicationController
    # Disable CSRF for API endpoints since we'll use token authentication
    skip_before_action :verify_authenticity_token

    # Handle common API errors
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { error: e.message }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: { error: e.message }, status: :unprocessable_entity
    end

    private

    # Helper method to render a JSON response with a specific status
    def json_response(object, status = :ok)
      render json: object, status: status
    end
  end
end

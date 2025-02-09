module Api
  module V1
    class ExampleController < Api::BaseController
      def index
        json_response({
          message: "Hello from Rails API!",
          timestamp: Time.current
        })
      end
    end
  end
end

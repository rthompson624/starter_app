Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      post "/login", to: "sessions#create"
      delete "/logout", to: "sessions#destroy"
      post "/signup", to: "registrations#create"
      get "/validate_token", to: "tokens#validate"
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "application#index"

  # Catch all routes to support React Router
  get "*path", to: "application#index"
end

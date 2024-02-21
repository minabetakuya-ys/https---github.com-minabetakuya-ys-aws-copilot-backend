Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :test,only: %i[index]
      get "up" => "rails/health#show", as: :rails_health_check
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations'
      }
      namespace :auth do
        resources :sessions, only: %i[index]
      end
    end
  end
end

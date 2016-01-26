Rails.application.routes.draw do

  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username.eql?('admin') && password.eql?('123456')
  end if Rails.env.production?
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :jwt_auth_token do
        collection do
          post :send_reset_password_mail, :update_password
          get :validate_auth_token
        end
      end
    end
  end

end

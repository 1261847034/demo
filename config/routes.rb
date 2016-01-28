Rails.application.routes.draw do

  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username.eql?('admin') && password.eql?('123456')
  end if Rails.env.production?
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users

  resources :i18n do
    post :export, :update, on: :collection
  end

  resources :simditors do
    post :upload, on: :collection
  end

  resources :redis_caches

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

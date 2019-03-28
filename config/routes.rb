Rails.application.routes.draw do

  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'authentication/registrations'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: [:index, :show]

  resources :me, only: [] do
    collection do
      get :show
    end
  end

  resources :omniauth, only: [:create]
  get '/auth/:provider/callback', to: 'omniauth#create'
  get '/auth/failure', to: 'omniauth#failure'

  resources :projects, only: [:index, :show]

  resources :podcasts, only: [:index]

  namespace :api do
    namespace :v1 do

      resources :tags, only: [:index]
      resources :users, only: [:index]

      namespace :me do
        resources :projects, only: [:index, :show, :create, :edit, :update, :destroy]

        resources :chat_sessions, only: [:create]

        resources :messages, only: [:create]

        resources :conversations, only: [:index, :show, :create]

        resources :ghost_sessions, only: [:create]

        resources :avatars_uploads, only: [:create]


        resources :projects, only: [], module: :projects do
          member do
            resources :logo_upload, only: [:create]
            resources :pictures_uploads, only: [:create]
          end
        end

      end
    end
  end
end

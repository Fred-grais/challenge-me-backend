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

  resources :projects, only: [:index, :show]

  namespace :api do
    namespace :v1 do

      resources :tags, only: [:index]

      namespace :me do
        resources :projects, only: [:index, :show, :create, :edit, :update, :destroy]
      end
    end
  end
end

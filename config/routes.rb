Rails.application.routes.draw do
  get 'venmo_callback', to: 'users#create'
  get 'sign_out', to: 'sessions#destroy'

  root 'welcome#index'

  resources :users, only: [:show, :create, :destroy]
  resources :groups, only: [:create, :show, :destroy, :update]
  resources :transactions, only: [:create]

  resources :users do
    member do
      get 'settings'
    end
  end
end

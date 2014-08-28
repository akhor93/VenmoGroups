Rails.application.routes.draw do
  get 'venmo_callback', to: 'users#create'
  get 'sign_out', to: 'sessions#destroy'

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example resource route (maps HTTP verbs to controller actions automatically):
    resources :users, only: [:show, :create, :destroy]
    resources :groups, only: [:create, :show, :destroy, :update]
    resources :admins, only: [:index]
    resources :transactions, only: [:create]

    resources :users do
      member do
        get 'settings'
      end
    end
end

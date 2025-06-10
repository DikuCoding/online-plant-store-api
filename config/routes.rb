Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      
      #  Products (public access)
      resources :products, only: [:index, :show]
      
      namespace :admin do
        resources :products, only: [:create, :update, :destroy, :index, :show] # Admin CRUD with image upload
        # resources :users, only: [:index, :destroy]
      end

      resource :cart, only: [:show]
      resources :cart_items, only: [:create, :destroy, :index, :update]
      
      # Orders (authenticated users)
      # resources :orders, only: [:create, :index, :show]
      
      # Messages (authenticated users)
      # resources :messages, only: [:create, :index]
      
    end
  end
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
end

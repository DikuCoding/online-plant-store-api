Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      
      #  Products (public access)
      resources :products, only: [:index, :show]
      
      namespace :admin do
        resources :products, only: [:create, :update, :destroy, :index, :show] # Admin CRUD with image upload
        # resources :users, only: [:index, :destroy]

         # Admin can view all orders
        get 'orders', to: 'orders#admin_index'
        match 'orders/:id', to: 'orders#admin_update', via: [:put, :patch]
        delete 'orders/:id', to: 'orders#admin_destroy'
      end

      resource :cart, only: [:show]
      resources :cart_items, only: [:create, :destroy, :index, :update]
      resources :orders, only: [:create, :index, :show]
      
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

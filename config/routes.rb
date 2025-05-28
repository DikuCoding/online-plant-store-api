Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resources :products
  resources :carts, only: [:show]
  resources :cart_items, only: [:create, :update, :destroy]
  resources :orders, only: [:index, :show, :create, :update]
  resources :messages, only: [:index, :create]
  resources :payments, only: [:create, :show]

end

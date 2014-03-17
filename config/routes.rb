HotelAdvisor::Application.routes.draw do
  
  resources :users, only: [:new, :create, :edit, :update]
  resources :sessions, only: [:new, :create, :destroy]
  resources :hotels, only: [:index, :new, :create, :show]
  resources :rates, only: [:create]

  root 'pages#home'
  match '/home',    to: 'pages#home',    via: 'get'
  match '/rating',  to: 'hotels#index',  via: 'get'
  match '/signup',  to: 'users#new',     via: 'get'
  match '/signin',  to: 'sessions#new',  via: 'get'
  match '/signout', to: 'sessions#destroy',  via: 'delete'



end

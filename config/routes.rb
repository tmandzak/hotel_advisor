HotelAdvisor::Application.routes.draw do
  
  resources :users, only: [:new, :create, :edit, :update]
  resources :sessions, only: [:new, :create, :destroy]
  root 'pages#home'
  match '/home',    to: 'pages#home',    via: 'get'
  match '/rating',  to: 'pages#rating',  via: 'get'
  match '/signup',  to: 'users#new',     via: 'get'
  match '/signin',  to: 'sessions#new',  via: 'get'
  match '/signout', to: 'sessions#destroy',  via: 'delete'
  


end

Rails.application.routes.draw do

  resources :users

  get '/signup', to: 'users#new'

  post '/signup',to: 'users#create'

  get '/help', to: 'static_pages#help'

  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'

  root 'static_pages#home'
  get '/login', :to => 'sessions#new'
  post '/login', :to => 'sessions#create'
  delete '/logout', :to => 'sessions#destroy'
  resources :account_activations, only: [:edit]
  # Why did we choose name 'edit' for this route?
  # Because we are editing the activation status here

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do

  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  match '/profile/(:id)/finish_signup' => 'users#finish_signup', via: [:get, :patch], as: :finish_signup

  resources :streams
  resources :highlights

  get '/personal' => 'home#personal', as: :personal
  root to: 'home#index'

end

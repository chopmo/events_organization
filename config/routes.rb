Rails.application.routes.draw do
  root 'events#index'
  resources :users
  resources :events
end

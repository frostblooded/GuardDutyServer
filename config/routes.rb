Rails.application.routes.draw do
  # Add Grape routes, so that the API works
  mount Mobile::Data => '/api'
  mount Mobile::Login   => '/api'
  
  # Add Devise routes for Company
  devise_for :companies

  root                  'static_page#home'
  get  'help'        => 'static_page#help'
  get  'about'       => 'static_page#about'
  get  'contact'     => 'static_page#contact'
  get  'workers/new' => 'worker#new'
  post 'workers'     => 'worker#create'
  get  'workers'     => 'worker#show'
  get  'settings'    => 'company_settings#show'
  resources :devices
end

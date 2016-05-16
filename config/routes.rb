Rails.application.routes.draw do
  # Add Grape routes, so that the API works
  mount API::AttendanceCheck => '/api'
  
  # Add Devise routes for Company
  devise_for :companies

  root                  'static_page#home'
  get "test_exception" => "application#test_exception_notification"
  get  'help'        => 'static_page#help'
  get  'about'       => 'static_page#about'
  get  'contact'     => 'static_page#contact'
  get  'workers/new' => 'worker#new'
  post 'workers'     => 'worker#create'
  get  'workers'     => 'worker#index'
  get  'settings'    => 'settings#index'
  post 'settings'     => 'settings#update'
  get  'workers/:id' => 'worker#show'
  post 'workers/:id'  => 'worker#update'

  resources :worker
  resources :site
  post 'sites'     => 'site#create'
  get  'sites'     => 'site#index'
end

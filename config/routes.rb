Rails.application.routes.draw do
  # Add Grape routes, so that the API works
  mount Mobile::AttendanceCheck => '/api'
  
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
  get  'workers/:id' => 'worker#show'
  resources :worker
end

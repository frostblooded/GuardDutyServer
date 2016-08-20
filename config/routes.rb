Rails.application.routes.draw do
  # Add Grape routes, so that the API works
  mount API::AttendanceCheck => '/api'
  
  # Add Devise routes for Company
  devise_for :companies
  resources :workers
  resources :settings

  resources :sites do
    resources :routes
  end

  root              'static_pages#home'
  get  'contact' => 'static_pages#contact'
end

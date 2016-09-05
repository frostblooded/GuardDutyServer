Rails.application.routes.draw do
  # Add Grape routes, so that the API works
  mount API::AttendanceCheck => '/api'
  
  # Add Devise routes for Company
  devise_for :companies

  resources :workers do
    get :autocomplete_worker_name, on: :collection
  end

  resources :settings

  resources :sites do
    resources :routes
  end

  root              'static_pages#home'
  get  'contact' => 'static_pages#contact'

  # Makes settings work, because otherwise you
  # can't make PATCH request on the index path
  patch 'settings'     => 'settings#update'
end

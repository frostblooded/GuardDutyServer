Rails.application.routes.draw do
  # Add Grape routes, so that the API works
  mount API::V1::GuardDuty => '/api'
  
  # Use urls like '/:locale/workers' so that the locale is set in the url
  scope ':locale', locale: /#{I18n.available_locales.join("|")}/ do
      # Add Devise routes for Company
    devise_for :companies, controllers: {
      registrations: 'company/registrations'
    }

    resources :workers do
      get :autocomplete_worker_name, on: :collection
    end

    resources :settings
    resources :sites

    root              'static_pages#home'
    get  'contact' => 'static_pages#contact'

    # Makes settings work, because otherwise you
    # can't make PATCH request on the index path
    patch 'settings'     => 'settings#update'
  end

  # Redirect to correct path if locale is missing
  get '*path', to: redirect("/#{I18n.default_locale}/%{path}"),
               constraints: ->(req) do
                              !req.path.starts_with? "/#{I18n.default_locale}/"
                            end
  get '', to: redirect("/#{I18n.default_locale}")
end

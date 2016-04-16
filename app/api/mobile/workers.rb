module Mobile
  class Workers < Grape::API
    # Set API version and determine it from URL
    version 'v1', using: :path

    # Response is in JSON format
    format :json

    # Catch and return exceptions as response
    rescue_from :all
    
    resource :mobile do
      params do
        requires :token, type: String
      end

      get :workers do
        params
      end
    end
  end
end
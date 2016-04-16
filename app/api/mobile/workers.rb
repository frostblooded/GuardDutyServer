module Mobile
  class Workers < Grape::API
    # Set API version and determine it from URL
    version 'v1', using: :path

    # Response is in JSON format
    format :json

    # Catch and return exceptions as response
    rescue_from :all

    helpers do
      # Check if the access token is valid
      def restrict_access
        api_key = ApiKey.find_by(access_token: params[:access_token])
        error!("Invalid token", 401) unless api_key
      end

      def get_current_company
        api_key = ApiKey.find_by(access_token: params[:access_token])
        api_key.company
      end
    end
    
    resource :mobile do
      # Before every request
      before {restrict_access}

      # Set parameter requirements for workers GET request
      params do
        requires :access_token, type: String
      end

      # Get current company's workers
      get :workers do
        Worker.all
        get_current_company
      end
    end
  end
end
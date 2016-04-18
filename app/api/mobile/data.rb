module Mobile
  class Data < Grape::API
    # Set API version and determine it from URL
    version 'v1', using: :path

    # Response is in JSON format
    format :json

    # Catch and return exceptions as response
    rescue_from :all

    # Before every request
    before {restrict_access}

    helpers do
      # Get API key based on access token parameter
      def get_api_key
        ApiKey.find_by(access_token: params[:access_token])
      end

      # Check if the access token is valid
      def restrict_access
        api_key = get_api_key

        # Return error if the API key doesn't exist
        error!("invalid token", 401) unless api_key

        # Return error if the access token has expired
        error!("expired token", 401) if api_key.expired?
      end

      # Returns the current company based on the access_token parameter
      def get_current_company
        get_api_key.company
      end
    end

    # Set parameter requirements for data requests
    params do
      requires :access_token, type: String
    end
    
    resource :mobile do
      # Get current company's workers
      get :workers do
        # TODO: Implement functionality
      end
    end
  end
end
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
        # Return error if the API key doesn't exist
        error!("Invalid token", 401) unless get_api_key
      end

      # Returns the current company based on the access_token parameter
      def get_current_company
        get_api_key.company
      end
    end
    
    resource :mobile do
      # Set parameter requirements for workers GET request
      params do
        requires :access_token, type: String
      end

      # Get current company's workers
      get :workers do
        # TODO: Implement functionality
      end
    end
  end
end
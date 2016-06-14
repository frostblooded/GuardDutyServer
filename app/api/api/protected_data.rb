module API
  class ProtectedData < Grape::API
    # Before every request
    before_validation {restrict_access}

    helpers do
      # Get API key based on access token parameter
      def get_api_key
        ApiKey.find_by access_token: params[:access_token]
      end

      # Check if the access token is valid
      def restrict_access
        api_key = get_api_key

        # Return error if the API key doesn't exist
        error!("invalid token", 401) unless api_key
      end
    end

    mount API::Calls
    mount API::Workers
    mount API::Companies    
  end
end
module API
  # Has some common functions and filters for all data which is protected
  # and requires an API key to be accessed
  class ProtectedData < Grape::API
    # Before every request
    before_validation { restrict_access }

    helpers do
      # Get API key based on access token parameter
      def api_key
        ApiKey.find_by access_token: params[:access_token]
      end

      # Check if the access token is valid
      def restrict_access
        # Return error if the API key doesn't exist
        error!('invalid token', 401) unless api_key
      end
    end

    mount API::Sites
    mount API::Workers
    mount API::Companies
  end
end

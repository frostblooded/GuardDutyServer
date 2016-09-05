module API::V1
  # Has some common functions and filters for all data which is protected
  # and requires an API key to be accessed
  class ProtectedData < Grape::API
    # Before every request
    before { restrict_access }

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

      # Used by the grape-cancan gem
      def current_user
        current_company
      end

      def current_company
        api_key.company
      end
    end

    mount API::V1::Sites
  end
end

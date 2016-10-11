module API
  module V1
    # Contains some API-wide settings and other stuff
    class GuardDuty < Grape::API
      # Set API version and determine it from URL
      version 'v1', using: :path

      # Response is in JSON format
      format :json

      # Catch and return exceptions as response
      rescue_from :all

      rescue_from ::CanCan::AccessDenied do
        error!('Access forbidden', 403)
      end

      # Mount the other API files
      mount ProtectedData
      mount AccessTokens
    end
  end
end

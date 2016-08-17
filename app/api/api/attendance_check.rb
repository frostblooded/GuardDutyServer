module API
  # Contains some API-wide settings and other stuff
  class AttendanceCheck < Grape::API
    # Set API version and determine it from URL
    version 'v1', using: :path

    # Response is in JSON format
    format :json

    # Catch and return exceptions as response
    rescue_from :all

    # Mount the other API files
    mount API::ProtectedData
    mount API::AccessTokens
  end
end

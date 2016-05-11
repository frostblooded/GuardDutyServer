module API
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
    mount API::Devices
    mount API::Calls
  end
end
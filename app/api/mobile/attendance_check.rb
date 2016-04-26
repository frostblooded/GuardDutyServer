module Mobile
  class AttendanceCheck < Grape::API
    # Set API version and determine it from URL
    version 'v1', using: :path

    # Response is in JSON format
    format :json

    # Catch and return exceptions as response
    rescue_from :all

    # Mount the other API files
    mount Mobile::Data
    mount Mobile::LoginCompany
    mount Mobile::RegisterDevice
    mount Mobile::CheckDeviceLogin
  end
end
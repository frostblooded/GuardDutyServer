module API
  class AttendanceCheck < Grape::API
    # Set API version and determine it from URL
    version 'v1', using: :path

    # Response is in JSON format
    format :json

    # Catch and return exceptions as response
    rescue_from :all

    # Mount the other API files
    mount Resources
    mount Companies
    mount RegisterDevice
    mount CheckWorkerLogin
    mount CheckDeviceLoginStatus
    mount RespondToCall
    mount SignoutDevice
  end
end
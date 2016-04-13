module AttendanceCheck
  class Workers < Grape::API
    version 'v1', using: :path
    format :json
    rescue_from :all
    
    resource :attendance_check do
      params do
        requires :token, type: String
      end

      get :workers do
        params
      end
    end
  end
end
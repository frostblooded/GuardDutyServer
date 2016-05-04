module API
  class CheckDeviceLoginStatus < Grape::API
    resource :mobile do
      params do
        requires :gcm_token, type: String
      end 

      post :check_device_login_status do
        device_exists = !Device.find_by(gcm_token: params[:gcm_token]).nil?
        {device_exists: device_exists}
      end 
    end 
  end 
end
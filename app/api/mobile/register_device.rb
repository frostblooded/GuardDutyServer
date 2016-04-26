module Mobile
  class RegisterDevice < Grape::API
    resource :mobile do
      params do
        requires :gcm_token, type: String
      end

      post :register_device do
        Device.create!(gcm_token: params[:gcm_token])
        
        # Return an empty response
        {}
      end
    end 
  end
end
module API
  class SignoutDevice < Grape::API
    helpers do
      def params_device
        Device.find_by gcm_token: params[:gcm_token]
      end
    end

    resource :mobile do
      params do
        requires :gcm_token, type: String
      end

      post :signout_device do
        # Return error if device isn't found in database
        error!('no such device in database', 400) unless params_device

        params_device.destroy
        {success:true}
      end
    end 
  end
end
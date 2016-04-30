module Mobile
  class RegisterDevice < Grape::API
    helpers do
      # Uses the request parameters to return a worker
      def params_worker
        Worker.find_by(first_name: params[:first_name], last_name: params[:last_name])
      end

      # Uses the request parameters do determine if the password is valid
      def valid_password?
        Worker.find_by(first_name: params[:first_name],
                   last_name: params[:last_name]).authenticate(params[:password])
      end
    end

    resource :mobile do
      params do
        requires :first_name, type: String
        requires :last_name, type: String
        requires :password, type: String
        requires :gcm_token, type: String
      end

      post :register_device do
        # Return error if worker with such names doesn't exist
        error!('invalid names', 400) unless Worker.exists?(first_name: params[:first_name],
                                                           last_name: params[:last_name])

        # Return error if the names/password combination isn't valid
        error!('invalid names/password combination', 400) unless valid_password?

        params_worker.device = Device.create!(gcm_token: params[:gcm_token])
        {success: true}
      end
    end 
  end
end
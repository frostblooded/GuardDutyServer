module Mobile
  class CheckDeviceLogin < Grape::API
    resource :mobile do
      params do
        requires :first_name, type: String
        requires :last_name, type: String
        requires :password, type: String
      end

      # Uses the request parameters do determine if the password is valid
      def valid_password?
        Worker.find_by(first_name: params[:first_name], last_name: params[:last_name])
               .valid_password?(params[:password])
      end

      post :register_device do
        {
          success: valid_password? ? true : false
        }
      end
    end 
  end
end
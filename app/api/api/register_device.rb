module API
  class RegisterDevice < Grape::API
    helpers do
      # Uses the request parameters to return a worker
      def params_worker
        params_company.workers.find_by first_name: params[:first_name],
                                       last_name: params[:last_name]
      end

      # Uses the request parameters to return a company
      def params_company
        Company.find_by company_name: params[:company_name]
      end

      # Uses the request parameters do determine if the password is valid
      def valid_password?
        params_worker.authenticate(params[:password])
      end

      def downcase_params
        params[:first_name] = params[:first_name].downcase
        params[:last_name] = params[:last_name].downcase
      end
    end

    resource :mobile do
      params do
        requires :company_name, type: String
        requires :first_name, type: String
        requires :last_name, type: String
        requires :password, type: String
        requires :gcm_token, type: String
      end

      post :register_device do
        downcase_params

        # Return error if worker with such names doesn't exist
        error!('company doesn\'t exist', 400) unless params_company

        # Return error if worker with such names doesn't exist
        error!('company has no such worker', 400) unless params_worker

        # Return error if the names/password combination isn't valid
        error!('invalid names/password combination', 400) unless valid_password?

        params_worker.device = Device.create!(gcm_token: params[:gcm_token])
        {success: true}
      end
    end 
  end
end
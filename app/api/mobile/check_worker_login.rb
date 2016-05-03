module Mobile
  class CheckWorkerLogin < Grape::API
    helpers do
      # Uses the request parameters do determine if the password is valid
      def valid_password?
        params_worker.authenticate(params[:password])
      end

      def params_worker
        params_company.workers.find_by first_name: params[:first_name],
                                       last_name: params[:last_name]
      end

      def params_company
        Company.find_by company_name: params[:company_name]
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
      end 

      post :check_worker_login do
        downcase_params

        # Return error if company with such name doesn't exist
        return {error: 'company doesn\'t exist'} unless params_company

        # Return error if worker with such names doesn't exist
        return {error: 'company has no such worker'} unless params_worker

        # Return error if the names/password combination isn't valid
        return {error: 'invalid names/password combination'} unless valid_password?

        {success: true}
      end 
    end 
  end 
end
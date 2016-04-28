module Mobile
  class CheckWorkerLogin < Grape::API
    helpers do
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
      end 

      post :check_worker_login do
        # Return error if worker with such names doesn't exist
        return {error: 'invalid names'} unless Worker.exists?(first_name: params[:first_name],
                                                           last_name: params[:last_name])

        # Return error if the names/password combination isn't valid
        return {error: 'invalid names/password combination'} unless valid_password?

        {success: true}
      end 
    end 
  end 
end
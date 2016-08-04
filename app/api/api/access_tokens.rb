module API
  class AccessTokens < Grape::API
    helpers do
      # Uses the request parameters do determine if the password is valid
      def valid_password?
        params_company.valid_password?(params[:password])
      end

      def params_company
        Company.find_by name: params[:name]
      end

      def downcase_params
        params[:name] = params[:name].downcase
      end
    end
    
    resource :access_tokens do
      # Set parameter requirements for login POST request
      params do
        requires :name, type: String
        requires :password, type: String
      end

      # Login company
      post '/' do
        downcase_params
        
        # Return error if company with such name doesn't exist
        error!("invalid company name", 400) unless params_company

        # Return error if the name/password combination isn't valid
        error!("invalid company name/password combination", 401) unless valid_password?

        # Generate API key
        company = Company.find_by(name: params[:name])
        company.api_key = ApiKey.create
        
        # Return the generated token
        {access_token: company.api_key.access_token,
         company_id: company.id,
         name: company.name}
      end
    end
  end
end
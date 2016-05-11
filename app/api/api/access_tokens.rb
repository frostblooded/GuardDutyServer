module API
  class AccessTokens < Grape::API
    helpers do
      # Uses the request parameters do determine if the password is valid
      def valid_password?
        params_company.valid_password?(params[:password])
      end

      def params_company
        Company.find_by company_name: params[:company_name]
      end

      def downcase_params
        params[:company_name] = params[:company_name].downcase
      end
    end
    
    resource :access_tokens do
      # Set parameter requirements for login POST request
      params do
        requires :company_name, type: String
        requires :password, type: String
      end

      # Login company
      post '/' do
        downcase_params
        
        # Return error if company with such company_name doesn't exist
        error!("invalid company name", 400) unless params_company

        # Return error if the company_name/password combination isn't valid
        error!("invalid company name/password combination", 401) unless valid_password?

        # Generate API key
        company = Company.find_by(company_name: params[:company_name])
        company.api_key = ApiKey.create
        
        # Return the generated token
        {access_token: company.api_key.access_token,
         company_id: company.id,
         company_name: company.company_name}
      end
    end
  end
end
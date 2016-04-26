module Mobile
  class Login < Grape::API
    helpers do
      # Uses the request parameters do determine if the password is valid
      def valid_password?
        Company.find_by(company_name: params[:company_name])
               .valid_password?(params[:password])
      end
    end
    
    resource :mobile do
      # Set parameter requirements for login POST request
      params do
        requires :company_name, type: String
        requires :password, type: String
      end

      # Login the company
      post :login do
        # Return error if company with such company_name doesn't exist
        error!("invalid company name", 400) unless Company.exists?(company_name: params[:company_name])

        # Return error if the company_name/password combination isn't valid
        error!("invalid company name/password combination", 401) unless valid_password?

        # Generate API key
        company = Company.find_by(company_name: params[:company_name])
        company.api_key = ApiKey.create
        
        # Return the generated token
        {access_token: company.api_key.access_token}
      end
    end
  end
end
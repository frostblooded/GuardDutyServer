module Mobile
  class Login < Grape::API
    # Set API version and determine it from URL
    version 'v1', using: :path

    # Response is in JSON format
    format :json

    # Catch and return exceptions as response
    rescue_from :all

    helpers do
      # Uses the request parameters do determine if the password is valid
      def valid_password?
        company = Company.find_by(company_name: params[:company_name])

        if company
          company.encrypted_password == params[:password_digest]
        else
          error!("Invalid company name", 400)
        end
      end
    end
    
    resource :mobile do
      # Set parameter requirements for login POST request
      params do
        requires :company_name, type: String
        requires :password_digest, type: String
      end

      # Login the company
      post :login do
        # Validate company
        error!("Invalid company name/password combination", 401) unless valid_password?

        # Generate api key
        company = Company.find_by(company_name: params[:company_name])
        company.api_key = ApiKey.create
        
        {access_token: company.api_key.access_token}
      end
    end
  end
end
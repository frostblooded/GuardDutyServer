module API
  # Represents the access tokens' routes for the API
  class AccessTokens < Grape::API
    helpers do
      # Uses the request parameters do determine if the password is valid
      def valid_password?
        params_company.valid_password?(params[:password])
      end

      def params_company
        Company.find_by name: params[:name]
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
        # Return error if company with such name doesn't exist
        error!('invalid company name', 400) unless params_company

        # Return error if the name/password combination isn't valid
        unless valid_password?
          error!('invalid company name/password combination', 401)
        end

        # Generate API key
        company = params_company
        company.api_key = ApiKey.create

        # Return the generated token
        { access_token: company.api_key.access_token,
          company_id: company.id,
          name: company.name }
      end
    end
  end
end

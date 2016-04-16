module Mobile
  class Workers < Grape::API
    # Set API version and determine it from URL
    version 'v1', using: :path

    # Response is in JSON format
    format :json

    # Catch and return exceptions as response
    rescue_from :all

    helpers do
      # Uses the passed parameters do determine if the password is valid
      def valid_password?
        company = Company.find_by(company_name: params[:company_name])
        company.encrypted_password == params[:password_digest]
      end
    end
    
    resource :mobile do
      # Set params requirements for workers GET request
      params do
        requires :token, type: String
      end

      # Get current user's workers
      get :workers do
        params
      end

      # Set params requirements for login POST request
      params do
        requires :company_name, type: String
        requires :password_digest, type: String
      end

      # Login the company
      post :login do
        return error!("Invalid username/password combination!", 401) unless valid_password?
      end
    end
  end
end
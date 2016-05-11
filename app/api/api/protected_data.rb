module API
  class ProtectedData < Grape::API
    # Before every request
    before_validation {restrict_access}

    helpers do
      # Get API key based on access token parameter
      def get_api_key
        ApiKey.find_by(access_token: params[:access_token])
      end

      # Check if the access token is valid
      def restrict_access
        api_key = get_api_key

        # Return error if the API key doesn't exist
        error!("invalid token", 401) unless api_key

        # Return error if the access token has expired
        error!("expired token", 401) if api_key.expired?
      end

      # Returns the company based on the access_token parameter
      def token_company
        get_api_key.company
      end

      # Returns the site based on the access_token parameter
      def token_site
        token_company.sites.find_by name: params[:site_name]
      end
    end

    # Set parameter requirements for data requests
    params do
      requires :access_token, type: String
    end

    resource :companies do
      route_param :company_name do
        resource :sites do
          get '/' do
            token_company.sites
          end

          route_param :site_name do
            resource :workers do
              get '/' do
                token_site.workers
              end
            end
          end
        end
      end
    end
  end
end
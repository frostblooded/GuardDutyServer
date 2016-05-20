module API
  class ProtectedData < Grape::API
    # Before every request
    before_validation {restrict_access}

    helpers do
      # Get API key based on access token parameter
      def get_api_key
        ApiKey.find_by access_token: params[:access_token]
      end

      # Check if the access token is valid
      def restrict_access
        api_key = get_api_key

        # Return error if the API key doesn't exist
        error!("invalid token", 401) unless api_key
      end

      # Returns the company based on the access_token parameter
      def params_company
        Company.find params[:company_id].to_i
      end

      # Returns the site based on the access_token parameter
      def params_site
        Site.find params[:site_id].to_i
      end
    end

    mount API::Devices
    mount API::Calls

    resource :companies do
      # Return all companies
      get '/' do
        Company.all
      end

      route_param :company_id do
        before do
          error!("inexsitent company", 400) unless Company.exists? id: params["company_id"].to_i
        end

        resource :sites do
          # Return all of the company's sites
          get '/' do
            params_company.sites
          end

          route_param :site_id do
            before do
              error!("company has no such site", 400) unless Site.exists? id: params["site_id"].to_i
            end

            # Return all of the sites' workers
            get :workers do
              params_site.workers
            end

            params do
              requires :positions
            end

            # Create a new route
            post :routes do
              r = params_site.routes.create(name: 'test route')

              params['positions'].each_with_index do |p, index|
                r.positions.create(longitude: p['longitude'],
                                   latitude: p['latitude'],
                                   index: index)
              end
              
              {success: true}
            end
          end
        end
      end
    end
  end
end
module API
  class Sites < Grape::API    
    helpers do
      # Returns the company based on the access_token parameter
      def token_company
        get_api_key.company
      end
    end

    resource :companies do
      route_param :company_name do
        resource :sites do
          get '/' do
            token_company.sites
          end
        end
      end
    end
  end
end
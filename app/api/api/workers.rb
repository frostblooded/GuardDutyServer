module API
  class Workers < Grape::API    
    helpers do
      # Returns the company based on the access_token parameter
      def token_company
        get_api_key.company
      end
    end

    resource :workers do
      # Get current company's workers
      get '/' do
        {}
      end
    end
  end
end
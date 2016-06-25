module API
  class Companies < Grape::API
    helpers do
      # Returns the company based on the access_token parameter
      def params_company
        Company.find params[:company_id].to_i
      end

      # Returns the site based on the access_token parameter
      def params_site
        Site.find params[:site_id].to_i
      end
    end

    resource :companies do
      route_param :company_id do
        before do
          error!("inexsitent company", 400) unless Company.exists? id: params["company_id"].to_i
        end

        resource :sites do
          # Return all of the company's sites
          get '/' do
            params_company.sites.select(:id, :name)
          end

          route_param :site_id do
            before do
              error!("company has no such site", 400) unless Site.exists? id: params["site_id"].to_i
            end

            get :settings do
              {
                shift_start: params_site.settings(:shift).start,
                shift_end: params_site.settings(:shift).end,
                call_interval: params_site.settings(:call).interval
              }
            end

            # Return all of the sites' workers
            get :workers do
              params_site.workers.select(:id, :name)
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
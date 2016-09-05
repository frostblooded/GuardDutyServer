module API::V1
  # Represents the sites' routes for the API
  class Sites < Grape::API
    helpers do
      def params_site
        Site.find params[:site_id]
      end

      def params_worker
        Worker.find params[:worker_id]
      end
    end

    resource :sites do
      get '/' do
        current_company.sites.select(:id, :name)
      end

      route_param :site_id do
        before do
          unless Site.exists? id: params[:site_id].to_i
            error!('inexistent site', 400)
          end

          authorize! :manage, params_site
        end

        get :settings do
          { shift_start: params_site.settings(:shift).start,
            shift_end: params_site.settings(:shift).end,
            call_interval: params_site.settings(:call).interval }
        end

        mount API::V1::Routes
        mount API::V1::Workers
      end
    end
  end
end

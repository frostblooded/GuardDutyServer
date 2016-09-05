module API
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

        # Return all of the site's workers
        get :workers do
          params_site.workers.select(:id, :name)
        end

        params do
          requires :positions
        end

        # Create a new route
        post :routes do
          authorize! :manage, Route
          
          r = params_site.routes.create!(name: 'test route')

          params['positions'].each_with_index do |p, index|
            r.positions.create!(longitude: p['longitude'],
                               latitude: p['latitude'],
                               index: index)
          end

          { success: true }
        end

        resource :workers do
          route_param :worker_id do
            before do
              unless Worker.exists? params[:worker_id]
                error!('inexistent worker', 400)
              end

              authorize! :manage, params_worker
            end

            # Log call
            params do
              requires :time_left, type: Integer
            end

            post '/calls' do
              Activity.create!(category: :call,
                               time_left: params[:time_left],
                               site: params_site,
                               worker: params_worker)

              { success: true }
            end

            # Log login
            params do
              requires :password, type: String
            end

            post '/login' do
              unless params_worker.authenticate(params[:password])
                error!('Invalid worker/password combination', 400)
              end

              Activity.create!(category: :login, worker: params_worker, site: params_site)
              { success: true }
            end

            # Log logout
            post '/logout' do
              Activity.create!(category: :logout, worker: params_worker, site: params_site)
              { success: true }
            end
          end
        end
      end
    end
  end
end

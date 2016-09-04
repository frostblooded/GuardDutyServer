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
      route_param :site_id do
        before do
          error!('inexsitent site', 400) unless Site.exists? params[:site_id]
          authorize! :manage, params_site
        end

        resource :workers do
          route_param :worker_id do
            before do
              unless Worker.exists? params[:worker_id]
                error!('inexsitent worker', 400)
              end

              authorize! :manage, params_worker
            end

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

module API
  module V1
    # Represents the sites' routes for the API
    class Workers < Grape::API
      # Return all of the site's workers
      get :workers do
        params_site.workers.select(:id, :name)
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
            optional :created_at, type: String
          end
          post '/calls' do
            act = Activity.create!(category: :call,
                                   time_left: params[:time_left],
                                   site: params_site,
                                   worker: params_worker)

            if params[:created_at]
              created_at_datetime = Time.iso8601(params[:created_at])
              act.update!(created_at: created_at_datetime)
            end

            {}
          end

          # Log login
          params do
            requires :password, type: String
          end
          post '/login' do
            unless params_worker.authenticate(params[:password])
              error!('Invalid worker/password combination', 400)
            end

            Activity.create! category: :login,
                             worker: params_worker,
                             site: params_site

            {}
          end

          # Log logout
          post '/logout' do
            Activity.create! category: :logout,
                             worker: params_worker,
                             site: params_site

            {}
          end
        end
      end
    end
  end
end

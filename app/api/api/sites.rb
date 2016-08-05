module API
  class Sites < Grape::API
    resource :sites do
      route_param :site_id do
        before do
          error!("inexsitent site", 400) unless Site.exists? params[:site_id]
        end

        resource :workers do
          route_param :worker_id do
            before do
              error!("inexsitent worker", 400) unless Worker.exists? params[:worker_id]
            end

            params do
              requires :time_left, type: Integer
            end

            post '/calls' do
              Call.create(worker_id: params[:worker_id], time_left: params[:time_left])

              {success: true}
            end
          end
        end
      end
    end 
  end 
end
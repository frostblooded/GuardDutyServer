module API
  class Workers < Grape::API
    helpers do
      def params_worker
        Worker.find params[:id]
      end
    end

    resource :workers do
      route_param :id do
        before do
          error!("inexsitent worker", 400) unless Worker.exists? params[:id]
        end

        params do
          requires :password, type: String
        end

        post '/check_login' do
          error!('Invalid worker/password combination', 400) unless params_worker
                                                  .authenticate(params[:password])

          {success: true}
        end

        params do
          requires :time_left, type: Integer
        end

        post '/calls' do
          Call.create(worker_id: params[:id], time_left: params[:time_left])

          {success: true}
        end
      end
    end 
  end 
end
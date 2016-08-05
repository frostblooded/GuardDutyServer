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

        post '/login' do
          error!('Invalid worker/password combination', 400) unless params_worker
                                                  .authenticate(params[:password])

          Activity.create(category: :login, worker_id: params[:id])
          {success: true}
        end

        post '/logout' do
          Activity.create(category: :logout, worker_id: params[:id])
          {success: true}
        end
      end
    end 
  end 
end
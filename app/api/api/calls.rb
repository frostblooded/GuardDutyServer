module API
  class Calls < Grape::API
    helpers do
      def params_call
        Call.find params[:id]
      end
    end

    resource :calls do
      route_param :id do
        params do
          requires :time_left, type: Integer
          requires :call_token, type: String
        end

        put '/' do
          error!('call doesn\'t exist', 400) unless Call.exists? params[:id]

          call = params_call
          error!('invalid token', 401) unless params_call
                                              .valid_token?(params[:call_token])

          call.received_at = Time.now
          call.time_left = params[:time_left]
          call.save
          {success: true}
        end
      end
    end 
  end 
end
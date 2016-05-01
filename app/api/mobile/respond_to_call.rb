module Mobile
  class RespondToCall < Grape::API
    helpers do
      def params_call
        Call.find_by_id(params[:call_id])
      end
    end

    resource :mobile do
      params do
        requires :time_left, type: Integer
        requires :call_token, type: String
        requires :call_id, type: Integer
      end

      post :respond_to_call do
        call = params_call

        error!('call doesn\'t exist', 400) unless call
        error!('invalid token', 401) unless call
                                            .valid_token?(params[:call_token])

        call.received_at = Time.now
        call.time_left = params[:time_left]
        call.save
      end 
    end 
  end 
end
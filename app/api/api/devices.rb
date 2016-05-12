module API
  class Devices < Grape::API
    helpers do
      # Uses the request parameters to return a worker
      def params_worker
        Worker.find params[:worker_id]
      end

      # Uses the request parameters to return a company
      def params_company
        Company.find params[:company_id]
      end

      # Uses the request parameters to return a device
      def params_device
        Device.find_by gcm_token: params[:gcm_token]
      end

      # Uses the request parameters to return a site
      def params_site
        Site.find params[:site_id]
      end

      # Uses the request parameters do determine if the password is valid
      def valid_password?
        params_worker.authenticate(params[:password])
      end
    end

    resource :devices do
      params do
        requires :company_id, type: String
        requires :site_id, type: String
        requires :worker_id, type: String
        requires :password, type: String
        requires :gcm_token, type: String
      end

      post '/' do
        # Return error if company with such name doesn't exist
        error!('company doesn\'t exist', 400) unless Company.exists? params['company_id']

        # Return error if site with such name doesn't exist
        error!('company has no such site', 400) unless Site.exists? params['site_id']

        # Return error if worker with such names doesn't exist
        error!('company has no such worker', 400) unless Worker.exists? params['worker_id']

        # Return error if the names/password combination isn't valid
        error!('invalid names/password combination', 400) unless valid_password?

        params_worker.device = Device.create!(gcm_token: params[:gcm_token])
        {success: true}
      end

      route_param :gcm_token do
        get '/' do
          device_exists = !Device.find_by(gcm_token: params[:gcm_token]).nil?
          {device_exists: device_exists}
        end

        delete '/' do
          # Return error if device isn't found in database
          error!('no such device in database', 400) unless params_device

          params_device.destroy
          {success:true}
        end
      end
    end 
  end
end
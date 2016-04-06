class DevicesController < ApplicationController
  # Doesn't expect authenticity token, so that POST requests
  # can be received from sources other than forms
  skip_before_action :verify_authenticity_token
  

  def create
    @device = Device.new(token: params[:token])

    if @device.save
      # Return success
      head 200
    else
      # Return error
      head 400
    end
  end
end

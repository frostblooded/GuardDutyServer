module DeviceHelper
  GCM_URL = 'https://gcm-http.googleapis.com/gcm/send'

  module_function
    def send_all
      Device.all.each {|d| d.call}
    end
  end

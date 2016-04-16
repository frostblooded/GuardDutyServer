module DeviceHelper
  GCM_URL = 'https://gcm-http.googleapis.com/gcm/send'

  module_function
    def send_all
      devices = Device.all

      devices.each do |device|
        token = device.token

        # Set the sent parameters
        # As of now most of them are hardcoded for testing purposes
        params = {
          data:{
            token: token,
            time: Time.now,
            submission_interval: 60000,
            alarm_time: 60000,
            id: device.id
          },
          to: token
        }.to_json

        # Create https connction object
        uri = URI.parse(GCM_URL)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        
        req = Net::HTTP::Post.new(uri.path)

        # Set headers
        req['Content-Type'] = 'application/json'
        req['Authorization'] = "key=#{Figaro.env.push_notification_send_key}"

        # Make request
        req.body = params
        res = https.request(req)
        puts "Sent tokens: Response #{res.code} #{res.message}: #{res.body}"
      end
    end
  end

module CallSender
  def CallSender::send_all
    # Get all devices
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
        'to': token
      }.to_json

      puts params

      uri = URI.parse('https://gcm-http.googleapis.com/gcm/send')
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      req = Net::HTTP::Post.new(uri.path)

      # Set headers
      req['Content-Type'] = 'application/json'
      req['Authorization'] = "key=#{Rails.application.secrets.push_notification_send_key}"
      req.body = params
      puts req.body
      res = https.request(req)
      puts "Response #{res.code} #{res.message}: #{res.body}"
    end
  end
end
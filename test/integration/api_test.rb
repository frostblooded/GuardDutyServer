require 'test_helper'

class ApiTest < ActionDispatch::IntegrationTest
  def setup
    @company = Company.create(company_name: 'test', password: 'foobarrr')
    @site = @company.sites.create(name: 'test site')
    @worker = @site.workers.create(name: 'foo bar', password: 'foobarrr')

    @device = Device.create(gcm_token: 'b' * 152)
    @call = @worker.calls.create
  end

  def request_access_token
    post '/api/v1/access_tokens', {company_name: @company.company_name,
                                   password: @company.password}
    json = JSON.parse @response.body
    json['access_token']
  end

  # Access token acquiring
  test 'access token obtaining requires parameters' do
    post '/api/v1/access_tokens'
    assert_equal '500', @response.code
    json = JSON.parse @response.body
    assert_equal 'company_name is missing, password is missing', json['error']
  end

  test 'access token obtaining returns access token on company login success' do
    assert_difference 'ApiKey.count' do
      post '/api/v1/access_tokens', {company_name: @company.company_name,
                                     password: @company.password}
    end

    json_response = JSON.parse @response.body
    assert_equal '201', @response.code
    assert_not json_response['access_token'].nil?
    assert_not json_response['company_id'].nil?
    assert_not json_response['company_name'].nil?
  end

  test 'access token obtaining returns error on nonexistent company' do
    assert_no_difference 'ApiKey.count' do
      post '/api/v1/access_tokens', {company_name: @company.company_name + 'a',
                                     password: @company.password}
    end

    json_response = JSON.parse @response.body
    assert_equal '400', @response.code
    assert_equal 'invalid company name', json_response['error']
  end

  test 'access token obtaining returns error on invalid company/password combination' do
    assert_no_difference 'ApiKey.count' do
      post '/api/v1/access_tokens', {company_name: @company.company_name,
                                     password: @company.password + 'a'}
    end

    json_response = JSON.parse @response.body
    assert_equal '401', @response.code
    assert_equal 'invalid company name/password combination', json_response['error']
  end

  # Data
  test 'protected data forbids access when token is invalid' do
    get '/api/v1/companies/' + @company.id.to_s + '/sites/' + @site.id.to_s + '/workers', { access_token: request_access_token + 'a' }
    assert_equal '401', @response.code
  end

  test 'protected data returns error when company doesn\'t exist' do
    token = request_access_token
    get '/api/v1/companies/' + (@company.id + 1).to_s + '/sites', { access_token: token }
    assert_equal '400', @response.code
    json = JSON.parse @response.body
    assert_equal 'inexsitent company', json['error']
  end

  test 'protected data returns error when site doesn\'t exist' do
    token = request_access_token
    get '/api/v1/companies/' + @company.id.to_s + '/sites/' + (@site.id + 1).to_s + '/workers', { access_token: token }
    assert_equal '400', @response.code
    json = JSON.parse @response.body
    assert_equal 'company has no such site', json['error']
  end

  test 'returns companies' do
    token = request_access_token
    get '/api/v1/companies/', { access_token: token }
    assert_equal '200', @response.code
    json = JSON.parse @response.body
    assert_equal @company.id, json.first['id']
  end

  test 'returns sites' do
    token = request_access_token
    get '/api/v1/companies/' + @company.id.to_s + '/sites', { access_token: token }
    assert_equal '200', @response.code
    json = JSON.parse @response.body
    assert_equal @site.id, json.first['id']
  end

  test 'returns workers' do
    token = request_access_token
    get '/api/v1/companies/' + @company.id.to_s + '/sites/' + @site.id.to_s + '/workers', { access_token: token }
    assert_equal '200', @response.code
    json = JSON.parse @response.body
    assert_equal @worker.id, json.first['id']
  end

  # Device registration
  test 'device registration requires parameters' do
    post '/api/v1/devices', {access_token: request_access_token}
    assert_equal '500', @response.code
    json = JSON.parse @response.body
    assert_equal 'site_id is missing, worker_id is missing, password is missing, gcm_token is missing', json['error']
  end

  test 'registers device' do
    assert_difference 'Device.count', 1 do
      post '/api/v1/devices', {access_token: request_access_token,
                               site_id: @site.id,
                               worker_id: @worker.id,
                               password: @worker.password,
                               gcm_token: 'a' * 152}
    end

    assert_equal '201', @response.code
    json_response = JSON.parse @response.body
    assert_equal true, json_response['success']

    device = Device.find_by(gcm_token: 'a' * 152)
    assert_equal @worker, device.worker
    assert_equal @site, device.site
  end

  test 'device registration returns error on inexistent site' do
    assert_no_difference 'Device.count' do
      post '/api/v1/devices', {access_token: request_access_token,
                               site_id: @site.id + 1,
                               worker_id: @worker.id,
                               password: @worker.password,
                               gcm_token: 'a' * 152}
    end

    assert_equal '400', @response.code
    json_response = JSON.parse @response.body
    assert_equal 'company has no such site', json_response['error']
  end

  test 'device registration returns error on invalid names' do
    assert_no_difference 'Device.count' do
      post '/api/v1/devices', {access_token: request_access_token,
                               site_id: @site.id,
                               worker_id: @worker.id + 1,
                               password: @worker.password,
                               gcm_token: 'a' * 152}
    end

    assert_equal '400', @response.code
    json_response = JSON.parse @response.body
    assert_equal 'company has no such worker', json_response['error']
  end

  test 'device registration returns error on wrong names/password combination' do
    assert_no_difference 'Device.count' do
      post '/api/v1/devices', {access_token: request_access_token,
                               site_id: @site.id,
                               worker_id: @worker.id,
                               password: @worker.password + 'a',
                               gcm_token: 'a' * 152}
    end

    assert_equal '400', @response.code
    json_response = JSON.parse @response.body
    assert_equal 'invalid names/password combination', json_response['error']
  end

  # Device signout
  test 'device signs out' do
    assert_difference 'Device.count', -1 do
      delete '/api/v1/devices/' + @device.gcm_token, {access_token: request_access_token}
    end

    assert_equal '200', @response.code
    json = JSON.parse @response.body
    assert_equal true, json['success']
  end

  test 'device signout returns error on nonexistent device' do
    token = 'b' * 151 + 'a'

    assert_no_difference 'Device.count' do
      delete '/api/v1/devices/' + token, {access_token: request_access_token}
    end

    assert_equal '400', @response.code
    json = JSON.parse @response.body
    assert_equal 'no such device in database', json['error']
  end

  # Check device login status
  test 'checks device login status' do
    get '/api/v1/devices/' + @device.gcm_token, {access_token: request_access_token}
    assert_equal '200', @response.code
    json_response = JSON.parse @response.body
    assert_equal true, json_response['device_exists']

    get '/api/v1/devices/' + 'c' * 152, {access_token: request_access_token}
    assert_equal '200', @response.code
    json_response = JSON.parse @response.body
    assert_equal false, json_response['device_exists']
  end

  # Respond to call
  test 'responds to call' do
    put '/api/v1/calls/' + @call.id.to_s, {access_token: request_access_token, call_token: @call.token, time_left: 59}
    assert_equal '200', @response.code
    json_response = JSON.parse @response.body
    assert_equal true, json_response['success']
  end

  test 'responding to call with invalid id returns error' do
    random_id = 98019

    # Get new id if this already exists in database
    while Call.exists?(id: random_id)
      random_id = Random.rand(1..10000000)
    end

    put '/api/v1/calls/1', {access_token: request_access_token, call_token: '', time_left: 59}
    assert_equal '400', @response.code
    json_response = JSON.parse @response.body
    assert_equal "call doesn\'t exist", json_response['error']
  end

  test 'responding to call with invalid token returns error' do
    put '/api/v1/calls/' + @call.id.to_s, {call_token: '', time_left: 59}
    assert_equal '401', @response.code
    json_response = JSON.parse @response.body
    assert_equal "invalid token", json_response['error']
  end

  # Route creation
  test 'creating route requires parameters' do
    post "/api/v1/companies/#{@company.id.to_s}/sites/#{@site.id.to_s}/routes", {access_token: request_access_token}
    # assert_equal '500', @response.code
    json_response = JSON.parse @response.body
    assert_equal "positions is missing", json_response['error']
  end

  test 'creates route' do
    data = [{latitude: 42, longitude: 42}]
    post "/api/v1/companies/#{@company.id.to_s}/sites/#{@site.id.to_s}/routes",
      {positions: data, access_token: request_access_token}
    assert_equal '201', @response.code
    json_response = JSON.parse @response.body
    assert_equal true, json_response['success']
  end
end

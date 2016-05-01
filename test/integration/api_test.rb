require 'test_helper'

class ApiTest < ActionDispatch::IntegrationTest
  def setup
    @company = Company.create(company_name: 'test', password: 'foobarrr')
    @worker = Worker.create(first_name: 'foo', last_name: 'bar', password: 'foobarrr')
    @device = Device.create(gcm_token: 'b' * 152)
    @call = @worker.calls.create
  end

  def request_access_token
    post '/api/v1/mobile/login_company', {company_name: @company.company_name,
                                          password: @company.password}
    json = JSON.parse @response.body
    json['access_token']
  end

  # Company login
  test 'company login requires parameters' do
    post '/api/v1/mobile/login_company'
    assert_equal '500', @response.code

    json = JSON.parse @response.body
    assert_equal 'company_name is missing, password is missing', json['error']
  end

  test 'company login returns access token on company login success' do
    assert_not request_access_token.nil?
    assert_equal '201', @response.code
  end

  # Workers data
  test 'workers data requires parameters' do
    post '/api/v1/mobile/workers'
    assert_equal '401', @response.code

    json = JSON.parse @response.body
    assert_equal 'invalid token', json['error']
  end

  test 'data forbids access to data when token is invalid' do
    get '/api/v1/mobile/workers', { access_token: request_access_token + 'a' }
    assert_equal '401', @response.code
  end

  test 'GETs correct data with access token' do
    get '/api/v1/mobile/workers', { access_token: request_access_token }
    assert_equal '200', @response.code
    workers = JSON.parse @response.body
    puts workers
    assert_equal @company.workers.as_json, workers
  end

  # Worker login
  test 'worker login check requires parameters' do
    post '/api/v1/mobile/check_worker_login'
    assert_equal '500', @response.code

    json = JSON.parse @response.body
    assert_equal 'first_name is missing, last_name is missing, password is missing', json['error']
  end

  test 'worker login responds on valid credentials' do
    post '/api/v1/mobile/check_worker_login', {first_name: @worker.first_name,
                                               last_name: @worker.last_name,
                                               password: @worker.password}

    assert_equal '201', @response.code
    json_response = JSON.parse @response.body
    assert_equal true, json_response['success']
  end

  test 'worker login responds to invalid worker names' do
    post '/api/v1/mobile/check_worker_login', {first_name: @worker.first_name + 'a',
                                               last_name: @worker.last_name + 'i',
                                               password: @worker.password}

    assert_equal '201', @response.code
    json_response = JSON.parse @response.body
    assert_equal 'invalid names', json_response['error']
  end

  test 'worker login responds to invalid names/password combination' do
    post '/api/v1/mobile/check_worker_login', {first_name: @worker.first_name,
                                               last_name: @worker.last_name,
                                               password: @worker.password + 'a' }

    assert_equal '201', @response.code
    json_response = JSON.parse @response.body
    assert_equal 'invalid names/password combination', json_response['error']
  end

  # Device registration
  test 'device registration requires parameters' do
    post '/api/v1/mobile/check_worker_login'
    assert_equal '500', @response.code

    json = JSON.parse @response.body
    assert_equal 'first_name is missing, last_name is missing, password is missing', json['error']
  end

  test 'device registration creates device on valid credentials' do
    assert_difference 'Device.count', 1 do
      post '/api/v1/mobile/register_device', {first_name: @worker.first_name,
                                              last_name: @worker.last_name,
                                              password: @worker.password,
                                              gcm_token: 'a' * 152}
    end

    assert_equal '201', @response.code
    json_response = JSON.parse @response.body

    device = Device.find_by(gcm_token: 'a' * 152)
    assert_equal @worker, device.worker
  end

  test 'device registration returns error on invalid names' do
    assert_no_difference 'Device.count' do
      post '/api/v1/mobile/register_device', {first_name: @worker.first_name + 'a',
                                              last_name: @worker.last_name + 'b',
                                              password: @worker.password,
                                              gcm_token: 'a' * 152}
    end

    assert_equal '400', @response.code
    json_response = JSON.parse @response.body
    assert_equal 'invalid names', json_response['error']
  end

  test 'device registration returns error on wrong names/password combination' do
    assert_no_difference 'Device.count' do
      post '/api/v1/mobile/register_device', {first_name: @worker.first_name,
                                              last_name: @worker.last_name,
                                              password: @worker.password + 'a',
                                              gcm_token: 'a' * 152}
    end

    assert_equal '400', @response.code
    json_response = JSON.parse @response.body
    assert_equal 'invalid names/password combination', json_response['error']
  end

  # Check device login status
  test 'checking device login status requires parameters' do
    post '/api/v1/mobile/check_device_login_status', {}
    assert_equal '500', @response.code
    json_response = JSON.parse @response.body
    assert_equal 'gcm_token is missing', json_response['error']
  end

  test 'checking device login status returns correct result' do
    post '/api/v1/mobile/check_device_login_status', {gcm_token: 'b' * 152}
    assert_equal '201', @response.code
    json_response = JSON.parse @response.body
    assert_equal true, json_response['device_exists']


    post '/api/v1/mobile/check_device_login_status', {gcm_token: 'c' * 152}
    assert_equal '201', @response.code
    json_response = JSON.parse @response.body
    assert_equal false, json_response['device_exists']
  end

  # Respond to call
  test 'responding to call requires parameters' do
    post '/api/v1/mobile/respond_to_call', {}
    assert_equal '500', @response.code
    json_response = JSON.parse @response.body
    assert_equal "time_left is missing, call_token is missing, call_id is missing", json_response['error']
  end

  test 'responding to call with invalid id returns error' do
    random_id = 98019

    # Get new id if this already exists in database
    while Call.exists?(id: random_id)
      random_id = Random.rand(1..10000000)
    end

    post '/api/v1/mobile/respond_to_call', {call_id: 1, call_token: '', time_left: 59}
    assert_equal '400', @response.code
    json_response = JSON.parse @response.body
    assert_equal "call doesn\'t exist", json_response['error']
  end

  test 'responding to call with invalid token returns error' do
    post '/api/v1/mobile/respond_to_call', {call_id: @call.id, call_token: '', time_left: 59}
    assert_equal '401', @response.code
    json_response = JSON.parse @response.body
    assert_equal "invalid token", json_response['error']
  end
end

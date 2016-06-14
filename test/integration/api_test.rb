require 'test_helper'

class ApiTest < ActionDispatch::IntegrationTest
  def setup
    @company = Company.create(company_name: 'test', password: 'foobarrr')
    @site = @company.sites.create(name: 'test site')
    @worker = @site.workers.create(name: 'foo bar', password: 'foobarrr')

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

  # Check worker login
  test 'worker login check' do
    post "/api/v1/workers/#{@worker.id}/check_login", {password: @worker.password,
                                                       access_token: request_access_token}

    json_response = JSON.parse @response.body
    assert_equal '201', @response.code
    assert_equal true, json_response['success']
  end

  test 'worker login check return error on invalid worker' do
    post "/api/v1/workers/#{@worker.id + 1}/check_login", {password: @worker.password,
                                                           access_token: request_access_token}

    json_response = JSON.parse @response.body
    assert_equal '400', @response.code
    assert_equal 'inexsitent worker', json_response['error']
  end

  test 'worker login check return error on invalid combination' do
    post "/api/v1/workers/#{@worker.id}/check_login", {password: @worker.password + 'a',
                                                       access_token: request_access_token}

    json_response = JSON.parse @response.body
    assert_equal '400', @response.code
    assert_equal 'Invalid worker/password combination', json_response['error']
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

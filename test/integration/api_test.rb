require 'test_helper'

class ApiTest < ActionDispatch::IntegrationTest
  def setup
    @company = Company.create(company_name: 'test', password: 'foobarrr')
  end

  def request_access_token
    post '/api/v1/mobile/login', { company_name: @company.company_name,
                                   password: @company.password }
    json = JSON.parse @response.body
    json['access_token']
  end

  test 'login return access token on success' do
    assert_not request_access_token.nil?
    assert_equal "201", @response.code
  end

  test 'forbid access to invalid token' do
    access_token = request_access_token
    get '/api/v1/mobile/workers', { access_token: request_access_token + 'a' }
    assert_equal "401", @response.code
  end

  test 'GET correct workers with access token' do
    get '/api/v1/mobile/workers', { access_token: request_access_token }
    assert_equal "200", @response.code
    workers = JSON.parse @response.body
    assert_equal @company.workers.as_json, workers
  end
end

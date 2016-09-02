require 'test_helper'

class ApiWorkerTest < ActionDispatch::IntegrationTest
  def setup
    @company = create(:company)
    @worker = @company.workers.first

    @worker_password = 'foobarrr'
    @worker.update(password: @worker_password)
  end

  # Login worker
  test 'worker login' do
    assert_difference 'Activity.count', 1 do
      post "/api/v1/workers/#{@worker.id}/login",
           params: { password: @worker_password,
                     access_token: request_access_token }
    end

    assert_equal '201', @response.code
    assert_equal true, json_response['success']
  end

  test 'worker login return error on invalid worker' do
    assert_no_difference 'Activity.count' do
      post '/api/v1/workers/-1/login',
           params: { password: @worker_password,
                     access_token: request_access_token }
    end

    assert_equal '400', @response.code
    assert_equal 'inexsitent worker', json_response['error']
  end

  test 'worker login return error on invalid combination' do
    assert_no_difference 'Activity.count' do
      post "/api/v1/workers/#{@worker.id}/login",
           params: { password: @worker_password + 'a',
                     access_token: request_access_token }
    end

    assert_equal '400', @response.code
    assert_equal 'Invalid worker/password combination', json_response['error']
  end

  # Logout worker
  test 'worker logout' do
    assert_difference 'Activity.count', 1 do
      post "/api/v1/workers/#{@worker.id}/logout",
           params: { access_token: request_access_token }
    end

    assert_equal '201', @response.code
    assert_equal true, json_response['success']
  end

  test 'worker logout returns error on invalid worker' do
    assert_no_difference 'Activity.count' do
      post '/api/v1/workers/-1/logout',
           params: { access_token: request_access_token }
    end

    assert_equal '400', @response.code
    assert_equal 'inexsitent worker', json_response['error']
  end
end

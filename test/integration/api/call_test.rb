require 'test_helper'

class ApiCallTest < ActionDispatch::IntegrationTest
  def setup
    @company = Company.create(name: 'test', password: 'foobarrr')
    @site = @company.sites.create(name: 'test site')
    @worker = @site.workers.create(name: 'foo bar', password: 'foobarrr')
  end
  
  # Respond to call
  test 'responds to call' do
    assert_difference 'Activity.count', 1 do
      post "/api/v1/sites/#{@site.id}/workers/#{@worker.id}/calls", {access_token: request_access_token, time_left: 59}
    end

    assert_equal '201', @response.code
    json_response = JSON.parse @response.body
    assert_equal true, json_response['success']
  end

  test 'responding to call to unexisting worker throws error' do
    assert_no_difference 'Activity.count' do
      post "/api/v1/sites/#{@site.id}/workers/#{@worker.id + 1}/calls", {access_token: request_access_token, time_left: 59}
    end
    
    assert_equal '400', @response.code
    json_response = JSON.parse @response.body
    assert_equal "inexsitent worker", json_response['error']
  end

  test 'responding to call to unexisting site throws error' do
    assert_no_difference 'Activity.count' do
      post "/api/v1/sites/#{@site.id + 1}/workers/#{@worker.id}/calls", {access_token: request_access_token, time_left: 59}
    end
    
    assert_equal '400', @response.code
    json_response = JSON.parse @response.body
    assert_equal "inexsitent site", json_response['error']
  end
end
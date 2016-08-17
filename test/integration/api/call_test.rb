require 'test_helper'

class ApiCallTest < ActionDispatch::IntegrationTest
  def setup
    @company = create(:company)
    @site = @company.sites.first
    @worker = @site.workers.first
  end

  # Respond to call
  test 'responds to call' do
    assert_difference 'Activity.count', 1 do
      post "/api/v1/sites/#{@site.id}/workers/#{@worker.id}/calls",
           access_token: request_access_token,
           time_left: 59
    end

    assert_equal '201', @response.code
    assert_equal true, json_response['success']
  end

  test 'responding to call to unexisting worker throws error' do
    assert_no_difference 'Activity.count' do
      post "/api/v1/sites/#{@site.id}/workers/-1/calls",
           access_token: request_access_token,
           time_left: 59
    end

    assert_equal '400', @response.code
    assert_equal 'inexsitent worker', json_response['error']
  end

  test 'responding to call to unexisting site throws error' do
    assert_no_difference 'Activity.count' do
      post "/api/v1/sites/-1/workers/#{@worker.id}/calls",
           access_token: request_access_token,
           time_left: 59
    end

    assert_equal '400', @response.code
    assert_equal 'inexsitent site', json_response['error']
  end
end

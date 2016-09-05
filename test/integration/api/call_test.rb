require 'test_helper'

class ApiCallTest < ActionDispatch::IntegrationTest
  def setup
    @company = create(:company)
    @site = @company.sites.first
    @worker = @site.workers.first
  end

  # Creating call
  test 'create call' do
    assert_difference 'Activity.count', 1 do
      post "/api/v1/sites/#{@site.id}/workers/#{@worker.id}/calls",
           params: { access_token: request_access_token,
                     time_left: 59 }
    end

    assert_equal '201', @response.code
    assert_equal true, json_response['success']
  end

  test 'creatign call for unexisting worker throws error' do
    assert_no_difference 'Activity.count' do
      post "/api/v1/sites/#{@site.id}/workers/-1/calls",
           params: { access_token: request_access_token,
                     time_left: 59 }
    end

    assert_equal '400', @response.code
    assert_equal 'inexistent worker', json_response['error']
  end

  test 'creatign call for unexisting site throws error' do
    assert_no_difference 'Activity.count' do
      post "/api/v1/sites/-1/workers/#{@worker.id}/calls",
           params: { access_token: request_access_token,
                     time_left: 59 }
    end

    assert_equal '400', @response.code
    assert_equal 'inexistent site', json_response['error']
  end
end

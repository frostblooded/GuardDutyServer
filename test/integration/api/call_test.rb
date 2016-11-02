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
    assert_equal '{}', json_response.to_s
  end

  test 'creating call with delay' do
    call_time = Time.zone.now - 1.hour
    call_time_string = call_time.iso8601

    assert_difference 'Activity.count', 1 do
      post "/api/v1/sites/#{@site.id}/workers/#{@worker.id}/calls",
           params: { access_token: request_access_token,
                     time_left: 59,
                     created_at: call_time_string }
    end

    assert_equal '201', @response.code
    assert_equal '{}', json_response.to_s
    assert_in_delta call_time, Activity.last.created_at, 1.second
  end

  test 'creating call for unexisting worker throws error' do
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

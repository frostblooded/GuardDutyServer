require 'test_helper'

class ApiDataTest < ActionDispatch::IntegrationTest
  def setup
    @company = create(:company)
    @site = @company.sites.first
    @worker = @site.workers.first
  end

  # Data
  test 'forbids access when token is invalid' do
    get "/api/v1/sites/#{@site.id}/workers",
        params: { access_token: request_access_token + 'a' }

    assert_equal '401', @response.code
  end

  test 'returns error when site doesn\'t exist' do
    get "/api/v1/sites/-1/workers",
        params: { access_token: request_access_token }

    assert_equal '400', @response.code
    assert_equal 'inexistent site', json_response['error']
  end

  test 'returns sites' do
    get "/api/v1/sites/",
        params: { access_token: request_access_token }

    assert_equal '200', @response.code
    assert_equal @site.id, json_response.first['id']
  end

  test 'returns workers' do
    get "/api/v1/sites/#{@site.id}/workers",
        params: { access_token: request_access_token }

    assert_equal '200', @response.code
    assert_equal @worker.id, json_response.first['id']
  end

  test 'returns site settings' do
    get "/api/v1/sites/#{@site.id}/settings",
        params: { access_token: request_access_token }

    assert_equal '200', @response.code
    assert_equal @site.settings(:shift).start, json_response['shift_start']
    assert_equal @site.settings(:shift).end, json_response['shift_end']
    assert_equal @site.settings(:call).interval, json_response['call_interval']
  end
end

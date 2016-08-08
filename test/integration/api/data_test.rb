require 'test_helper'

class ApiDataTest < ActionDispatch::IntegrationTest
  def setup
    @company = create(:company)
    @site = @company.sites.first
    @worker = @site.workers.first
  end
  
  # Data
  test 'protected data forbids access when token is invalid' do
    get "/api/v1/companies/#{@company.id}/sites/#{@site.id}/workers", { access_token: request_access_token + 'a' }

    assert_equal '401', @response.code
  end

  test 'protected data returns error when company doesn\'t exist' do
    get "/api/v1/companies/-1/sites/", { access_token: request_access_token }

    assert_equal '400', @response.code
    assert_equal 'inexistent company', json_response['error']
  end

  test 'protected data returns error when site doesn\'t exist' do
    get "/api/v1/companies/#{@company.id}/sites/-1/workers", { access_token: request_access_token }

    assert_equal '400', @response.code
    assert_equal 'inexistent site', json_response['error']
  end

  test 'returns sites' do
    get "/api/v1/companies/#{@company.id}/sites/", { access_token: request_access_token }

    assert_equal '200', @response.code
    assert_equal @site.id, json_response.first['id']
  end

  test 'returns workers' do
    get "/api/v1/companies/#{@company.id}/sites/#{@site.id}/workers", { access_token: request_access_token }

    assert_equal '200', @response.code
    assert_equal @worker.id, json_response.first['id']
  end

  test 'returns site settings' do
    get "/api/v1/companies/#{@company.id}/sites/#{@site.id}/settings", { access_token: request_access_token }
    
    assert_equal '200', @response.code
    assert_equal @site.settings(:shift).start, json_response['shift_start']
    assert_equal @site.settings(:shift).end, json_response['shift_end']
    assert_equal @site.settings(:call).interval, json_response['call_interval']
  end
end
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
    token = request_access_token
    get "/api/v1/companies/-1/sites/", { access_token: token }
    assert_equal '400', @response.code
    json = JSON.parse @response.body
    assert_equal 'inexsitent company', json['error']
  end

  test 'protected data returns error when site doesn\'t exist' do
    token = request_access_token
    get "/api/v1/companies/#{@company.id}/sites/-1/workers", { access_token: token }
    assert_equal '400', @response.code
    json = JSON.parse @response.body
    assert_equal 'company has no such site', json['error']
  end

  test 'returns sites' do
    token = request_access_token
    get "/api/v1/companies/#{@company.id}/sites/", { access_token: token }
    assert_equal '200', @response.code
    json = JSON.parse @response.body
    assert_equal @site.id, json.first['id']
  end

  test 'returns workers' do
    token = request_access_token
    get "/api/v1/companies/#{@company.id}/sites/#{@site.id}/workers", { access_token: token }
    assert_equal '200', @response.code
    json = JSON.parse @response.body
    assert_equal @worker.id, json.first['id']
  end

  test 'returns site settings' do
    get "/api/v1/companies/#{@company.id}/sites/#{@site.id}/settings", { access_token: request_access_token }
    assert_equal '200', @response.code
    json = JSON.parse @response.body
    assert_equal @site.settings(:shift).start, json['shift_start']
    assert_equal @site.settings(:shift).end, json['shift_end']
    assert_equal @site.settings(:call).interval, json['call_interval']
  end
end
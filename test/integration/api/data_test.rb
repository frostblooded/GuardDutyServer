require 'test_helper'

class ApiDataTest < ActionDispatch::IntegrationTest
  def setup
    @company = Company.create(name: 'test', password: 'foobarrr')
    @site = @company.sites.create(name: 'test site')
    @worker = @site.workers.create(name: 'foo bar', password: 'foobarrr')
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

  test 'returns site settings' do
    get "/api/v1/companies/#{@company.id}/sites/#{@site.id}/settings", { access_token: request_access_token }
    assert_equal '200', @response.code
    json = JSON.parse @response.body
    assert_equal @site.settings(:shift).start, json['shift_start']
    assert_equal @site.settings(:shift).end, json['shift_end']
    assert_equal @site.settings(:call).interval, json['call_interval']
  end
end
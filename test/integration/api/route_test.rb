require 'test_helper'

class ApiRouteTest < ActionDispatch::IntegrationTest
  def setup
    @company = create(:company)
    @site = @company.sites.first
  end

  # Route creation
  test 'creating route requires parameters' do
    post "/api/v1/companies/#{@company.id.to_s}/sites/#{@site.id.to_s}/routes", {access_token: request_access_token}
    # assert_equal '500', @response.code
    json_response = JSON.parse @response.body
    assert_equal "positions is missing", json_response['error']
  end

  test 'creates route' do
    data = [{latitude: 42, longitude: 42}]
    post "/api/v1/companies/#{@company.id.to_s}/sites/#{@site.id.to_s}/routes",
      {positions: data, access_token: request_access_token}
    assert_equal '201', @response.code
    json_response = JSON.parse @response.body
    assert_equal true, json_response['success']
  end

  test 'route creation returns error if the company doesn\'t exist' do
    data = [{latitude: 42, longitude: 42}]
    post "/api/v1/companies/-1/sites/#{@site.id.to_s}/routes",
      {positions: data, access_token: request_access_token}
    assert_equal '400', @response.code
    json_response = JSON.parse @response.body
    assert_equal 'inexistent company', json_response['error']
  end

  test 'route creation returns error if the site doesn\'t exist' do
    data = [{latitude: 42, longitude: 42}]
    post "/api/v1/companies/#{@company.id.to_s}/sites/-1/routes",
      {positions: data, access_token: request_access_token}
    assert_equal '400', @response.code
    json_response = JSON.parse @response.body
    assert_equal 'inexistent site', json_response['error']
  end
end

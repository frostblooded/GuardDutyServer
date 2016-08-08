require 'test_helper'

class ApiRouteTest < ActionDispatch::IntegrationTest
  def setup
    @company = Company.create(name: 'test', password: 'foobarrr')
    @site = @company.sites.create(name: 'test site')
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
end

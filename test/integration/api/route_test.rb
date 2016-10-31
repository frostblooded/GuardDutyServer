require 'test_helper'

class ApiRouteTest < ActionDispatch::IntegrationTest
  def setup
    @company = create(:company)
    @site = @company.sites.first
  end

  # Route creation
  test 'creating route requires parameters' do
    post "/api/v1/sites/#{@site.id}/routes",
         params: { access_token: request_access_token }

    assert_equal '500', @response.code
    assert_equal 'positions is missing', json_response['error']
  end

  test 'creates route' do
    data = [{ latitude: 42, longitude: 42 }]
    post "/api/v1/sites/#{@site.id}/routes",
         params: { positions: data,
                   access_token: request_access_token }

    assert_equal '201', @response.code
    assert_equal '{}', json_response.to_s
  end

  test 'route creation returns error if the site doesn\'t exist' do
    data = [{ latitude: 42, longitude: 42 }]

    post '/api/v1/sites/-1/routes',
         params: { positions: data,
                   access_token: request_access_token }

    assert_equal '400', @response.code
    assert_equal 'inexistent site', json_response['error']
  end
end

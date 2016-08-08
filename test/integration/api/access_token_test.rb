require 'test_helper'

class ApiAccessTokenTest < ActionDispatch::IntegrationTest
  def setup
    @company = create(:company)
  end
  
  # Access token acquiring
  test 'access token obtaining requires parameters' do
    post '/api/v1/access_tokens'
    
    assert_equal '500', @response.code
    assert_equal 'name is missing, password is missing', json_response['error']
  end

  test 'access token obtaining returns access token on company login success' do
    assert_difference 'ApiKey.count' do
      post '/api/v1/access_tokens', {name: @company.name,
                                     password: @company.password}
    end

    assert_equal '201', @response.code
    assert_not json_response['access_token'].nil?
    assert_not json_response['company_id'].nil?
    assert_not json_response['name'].nil?
  end

  test 'access token obtaining returns error on nonexistent company' do
    assert_no_difference 'ApiKey.count' do
      post '/api/v1/access_tokens', {name: @company.name + 'a',
                                     password: @company.password}
    end

    assert_equal '400', @response.code
    assert_equal 'invalid company name', json_response['error']
  end

  test 'access token obtaining returns error on invalid company/password combination' do
    assert_no_difference 'ApiKey.count' do
      post '/api/v1/access_tokens', {name: @company.name,
                                     password: @company.password + 'a'}
    end

    assert_equal '401', @response.code
    assert_equal 'invalid company name/password combination', json_response['error']
  end
end
require 'test_helper'

class ApiAccessTokenTest < ActionDispatch::IntegrationTest
  def setup
    @company = create(:company)
    @other_company = create(:company)

    @site = @company.sites.first
    @other_site = @other_company.sites.first

    @worker = @site.workers.first
    @other_worker = @other_site.workers.first
  end

  test 'cannot create calls for other companies\' workers' do
    assert_no_difference 'Activity.count' do
      post "/api/v1/sites/#{@other_site.id}/workers/#{@other_worker.id}/calls",
           params: { access_token: request_access_token,
                     time_left: 59 }
    end

    assert_equal '403', @response.code
    assert_equal 'Access forbidden', json_response['error']
  end

  test 'cannot login other comapnies\' worker' do
    assert_no_difference 'Activity.count' do
      post "/api/v1/workers/#{@other_worker.id}/login",
           params: { password: @worker_password,
                     access_token: request_access_token }
    end

    assert_equal '403', @response.code
    assert_equal 'Access forbidden', json_response['error']
  end

  test 'cannot logout other comapnies\' worker' do
    assert_no_difference 'Activity.count' do
      post "/api/v1/workers/#{@other_worker.id}/logout",
           params: { access_token: request_access_token }
    end

    assert_equal '403', @response.code
    assert_equal 'Access forbidden', json_response['error']
  end

  test 'cannot get other companies\' site\'s settings' do
    get "/api/v1/companies/#{@other_company.id}/sites/#{@other_site.id}/settings",
         params: { access_token: request_access_token }

    assert_equal '403', @response.code
    assert_equal 'Access forbidden', json_response['error']
  end

  test 'cannot get other companies\' site\'s workers' do
    get "/api/v1/companies/#{@other_company.id}/sites/#{@other_site.id}/workers",
         params: { access_token: request_access_token }

    assert_equal '403', @response.code
    assert_equal 'Access forbidden', json_response['error']
  end

  test 'cannot create routes for other companies\' sites' do
    data = [{ latitude: 42, longitude: 42 }]
    post "/api/v1/companies/#{@other_company.id}/sites/#{@other_site.id}/routes",
         params: { positions: data,
                   access_token: request_access_token }

    assert_equal '403', @response.code
    assert_equal 'Access forbidden', json_response['error']
  end
end

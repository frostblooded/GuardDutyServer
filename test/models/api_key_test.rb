require 'test_helper'

class ApiKeyTest < ActiveSupport::TestCase
  def setup
    @company = create(:company)
    @company.api_key = ApiKey.create
  end

  test 'has token' do
    assert_not @company.api_key.access_token.nil?
  end

  test 'token has valid length' do
    assert_equal 32, @company.api_key.access_token.length
  end

  test 'setting company API key removes old one' do
    assert_no_difference('ApiKey.count') do
      @company.api_key = ApiKey.create
    end
  end
end

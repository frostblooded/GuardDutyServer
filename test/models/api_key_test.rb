require 'test_helper'

class ApiKeyTest < ActiveSupport::TestCase
  def setup
    @company = Company.new
    @company.api_key = ApiKey.create
  end

  test 'API key has token' do
    assert_not @company.api_key.access_token.nil?
  end

  test 'token has valid length' do
    assert_equal 32, @company.api_key.access_token.length
  end

  test 'Setting company API key removes old one' do
    assert_no_difference('ApiKey.count') do
      @company.api_key = ApiKey.create
    end
  end
end

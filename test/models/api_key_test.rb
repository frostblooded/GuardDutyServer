require 'test_helper'

class ApiKeyTest < ActiveSupport::TestCase
  def setup
    @company = Company.new
    @company.api_key = ApiKey.create
  end

  test 'API key has token' do
    assert_not @company.api_key.access_token.nil?
  end

  test 'API key is valid for 2 hours' do
    assert_not @company.api_key.expired?

    Timecop.freeze(Time.now + ApiKey::VALID_HOURS.hours - 1.minutes) do
      assert_not @company.api_key.expired?
    end

    Timecop.freeze(Time.now + ApiKey::VALID_HOURS.hours + 1.minutes) do
      assert @company.api_key.expired?
    end
  end

  test 'Setting company API key removes old one' do
    assert_no_difference('ApiKey.count') do
      @company.api_key = ApiKey.create
    end
  end
end

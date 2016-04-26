require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  def setup
    @device = Device.new(gcm_token: 'a' * 152)
  end

  test "should be valid" do
    assert @device.valid?
  end

  test "GCM token should be present" do
    @device.gcm_token = ''
    assert_not @device.valid?
  end

  test "GCM token should be of valid length" do
    @device.gcm_token = 'a' * 100
    assert_not @device.valid?
  end
end

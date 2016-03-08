require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  def setup
    @device = Device.new(token: 'a' * 152)
  end

  test "should be valid" do
    assert @device.valid?
  end

  test "token should be present" do
    @device.token = ''
    assert_not @device.valid?
  end

  test "token should be of valid length" do
    @device.token = 'a' * 100
    assert_not @device.valid?
  end
end

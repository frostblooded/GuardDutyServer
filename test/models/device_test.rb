require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  def setup
    @site = Site.create(name: 'test site')
    @worker = @site.workers.create(name: 'Ivan Testov', password: 'foobarrr')
    @worker.device = Device.new(gcm_token: 'a' * 152)
    @device = @worker.device
    @device.site = @site
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

  test "device belongs to correct site" do
    assert_equal @site, @device.site
  end

  test "device belongs to correct worker" do
    assert_equal @worker, @device.worker
  end
end

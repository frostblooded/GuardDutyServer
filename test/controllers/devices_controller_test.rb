require 'test_helper'

class DevicesControllerTest < ActionController::TestCase
  test "do not handle empty create params" do
    assert_no_difference 'Device.count' do
      post :create, {}
    end
  end

  test "do not create device with token that has wrong length" do
    assert_no_difference 'Device.count' do
      post :create, token: 'a' * 100
    end
  end

  test "create device with valid token length" do
    assert_difference 'Device.count', 1 do
      post :create, token: 'a' * 152
    end
  end
end

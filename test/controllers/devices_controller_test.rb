require 'test_helper'

class DevicesControllerTest < ActionController::TestCase
  test "do not handle empty create params" do
    assert_no_difference 'Device.count' do
      post :create, {}
    end
  end

  test "do not create devices with tokens that are below the length limit" do
    assert_no_difference 'Device.count' do
      post :create, token: "12321412"
    end
  end
end

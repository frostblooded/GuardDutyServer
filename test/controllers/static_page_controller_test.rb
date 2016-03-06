require 'test_helper'

class StaticPageControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "AttendanceCheck"
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "AttendanceCheck"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "AttendanceCheck"
  end
end
require "test_helper"

class CanAcessHomeTest < Capybara::Rails::TestCase
  test "sanity" do
    visit root_path
    assert_content page, "AttendanceCheck"
  end
end

require "test_helper"

class CanAcessHomeTest < Capybara::Rails::TestCase
  
  test "visitRoot" do
    visit root_path
    assert_content page, "AttendanceCheck"
  end

  test "testLinkAbout" do
  	visit root_path
  	click_link "About"
  	assert_content page, "test"
    page.wont_have_content "Sing in as"
  end

  test "testLinkContact" do
    visit root_path
    click_link "Contact"
    assert_content page, "should insert"
  end
end

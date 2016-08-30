require 'test_helper'

class CanClickHeaderLinksTest < Capybara::Rails::TestCase
  def setup
    visit root_path
  end

  test 'has correct links when logged out' do
    within '.navbar' do
      assert_text 'Sign in'
      assert_text 'Sign up'
      assert_no_text 'Sites'
      assert_no_text 'Workers'
      assert_no_text 'Settings'
      assert_no_text 'Sign out'
    end
  end

  test 'has correct links when logged in' do
    login_as create(:company)
    reload_page

    within '.navbar' do
      assert_no_text 'Sign in'
      assert_no_text 'Sign up'
      assert_text 'Sites'
      assert_text 'Workers'
      assert_text 'Settings'
      assert_text 'Sign out'
    end
  end

  test 'sign out signs the user out' do
    login_as create(:company)
    reload_page

    click_link 'Sign out'
    assert_text 'Signed out successfully'
  end
end

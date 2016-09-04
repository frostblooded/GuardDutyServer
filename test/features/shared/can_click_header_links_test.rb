require 'test_helper'

class CanClickHeaderLinksTest < Capybara::Rails::TestCase
  def setup
    visit root_path
  end

  test 'has correct links when logged out' do
    within '.navbar' do
      has_link? 'Sign in'
      has_link? 'Sign up'
      has_no_link? '#sites-nav'
      has_no_link? '#worker-nav'
      has_no_link? '#settings-nav'
      has_no_link? 'Sign out'
    end
  end

  test 'has correct links when logged in' do
    login_as create(:company)
    reload_page

    within '.navbar' do
      has_no_link? 'Sign in'
      has_no_link? 'Sign up'
      has_link? '#sites-nav'
      has_link? '#worker-nav'
      has_link? '#settings-nav'
      has_link? 'Sign out'
    end
  end

  test 'sign out signs the user out' do
    login_as create(:company)
    reload_page

    click_link 'Sign out'
    assert_text 'Signed out successfully'
  end
end

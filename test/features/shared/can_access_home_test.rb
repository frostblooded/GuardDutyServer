require 'test_helper'

class CanAcessHomeTest < Capybara::Rails::TestCase
  def setup
    visit root_path
  end

  test 'can visit root' do
    assert_content page, 'Guard Duty'
  end

  test 'has sign buttons when not logged in' do
    assert_link 'Sign in'
    assert_link 'Sign up'

    login_as create(:company)
    reload_page
    assert_no_link 'Sign in'
    assert_no_link 'Sign up'
  end
end

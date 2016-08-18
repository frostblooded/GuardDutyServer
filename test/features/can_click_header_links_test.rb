require 'test_helper'

class CanClickHeaderLinksTest < Capybara::Rails::TestCase
  test 'signin link opens signin' do
    visit root_path
    click_link 'Sign in'
    assert_equal new_company_session_path, current_path
  end

  test 'signup link opens signup' do
    visit root_path
    click_link 'Sign up'
    assert_equal new_company_registration_path, current_path
  end

  test 'sites link opens sites' do
    login_as create(:company)
    visit root_path
    click_link 'Sites'
    assert_equal sites_path, current_path
  end

  test 'workers link opens workers' do
    login_as create(:company)
    visit root_path
    click_link 'Workers'
    assert_equal workers_path, current_path
  end

  test 'settings link opens settings' do
    login_as create(:company)
    visit root_path
    click_link 'Settings'
    assert_equal settings_path, current_path
  end

  test 'signs out' do
    login_as create(:company)
    visit root_path
    click_link 'Sign out'
    assert_equal root_path, current_path
    assert page.has_content? 'Signed out successfully'
  end
end

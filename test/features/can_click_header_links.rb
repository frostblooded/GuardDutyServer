require 'test_helper'

class CanClickHeaderLinks < Capybara::Rails::TestCase
  test 'opens contact' do
    visit root_path
    click_link 'Contact'
    assert_equal current_path, '/contact'
  end

  # Need to make user log in before every test
  test 'opens sites' do
    login_as create(:company)
    visit root_path
    click_link 'Sites'
    assert_equal current_path, '/sites'
  end
end

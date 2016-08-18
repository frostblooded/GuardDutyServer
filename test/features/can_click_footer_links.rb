require 'test_helper'

class CanClickHeaderLinks < Capybara::Rails::TestCase
  test 'opens contact' do
    visit root_path
    click_link 'Contact'
    assert_equal contact_path, current_path
  end
end

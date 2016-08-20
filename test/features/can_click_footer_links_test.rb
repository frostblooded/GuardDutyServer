require 'test_helper'

class CanClickFooterLinks < Capybara::Rails::TestCase
  test 'contact opens contact' do
    visit root_path
    click_link 'Contact'
    assert_equal contact_path, current_path
  end
end

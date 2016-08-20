require 'test_helper'

class CanClickFooterLinks < Capybara::Rails::TestCase
  def setup
    visit root_path
  end

  test 'contact opens contact' do
    click_link 'Contact'
    assert_equal contact_path, current_path
  end
end

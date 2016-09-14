require 'test_helper'

class CanClickFooterLinks < Capybara::Rails::TestCase
  def setup
    visit root_path
  end

  test 'has correct links' do
    within '#footer-nav' do
      assert_text 'Contact'
    end
  end
end

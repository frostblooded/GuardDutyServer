require 'test_helper'

class CanAcessHomeTest < Capybara::Rails::TestCase
  test 'visit root' do
    visit root_path
    assert_content page, 'Attendance Check'
  end

  test 'link contact' do
    visit root_path
    click_link 'Contact'
    assert_content page, 'nikolay_danailov@yahoo.com'
  end
end

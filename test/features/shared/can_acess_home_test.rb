require 'test_helper'

class CanAcessHomeTest < Capybara::Rails::TestCase
  test 'can visit root' do
    visit root_path
    assert_content page, 'Attendance Check'
  end
end

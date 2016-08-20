require 'test_helper'

class CanAcessHomeTest < Capybara::Rails::TestCase
  def setup
    visit root_path
  end

  test 'can visit root' do
    assert_content page, 'Attendance Check'
  end
end

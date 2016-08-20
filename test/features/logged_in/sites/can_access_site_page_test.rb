require "test_helper"

class CanAccessSitePageTest < Capybara::Rails::TestCase
  def setup
    @company = create(:company)
    @site = @company.sites.first
    login_as @company

    visit site_path(@site)
  end

  test 'site shows correct default site settings' do
    assert_equal @site.settings(:call).interval, find('#call_interval').value
    assert_equal @site.settings(:shift).start, find('#shift_start').value
    assert_equal @site.settings(:shift).end, find('#shift_end').value
  end

  test 'site settings get updated correctly' do
    fill_in 'call_interval', with: '20'
    fill_in 'shift_start', with: '20:00'
    fill_in 'shift_end', with: '21:00'
    click_button 'Save changes'

    assert_equal site_path(@site), current_path
    assert_text 'Settings saved'
  end
end

require "test_helper"

class CanAccessSitePageTest < Capybara::Rails::TestCase
  def setup
    @company = create(:company)
    @site = @company.sites.first
    login_as @company

    @new_call_interval = '20'
    @new_shift_start = '20:00'
    @new_shift_end = '21:00'

    @new_invalid_shift_start = '13@4t:'
    @new_invalid_shift_end = '13@4t:'

    visit site_path(@site)
  end

  test 'shows correct site name' do
    assert_text @site.name
  end

  test 'site shows correct default site settings' do
    assert_equal @site.settings(:call).interval, find('#call_interval').value
    assert_equal @site.settings(:shift).start, find('#shift_start').value
    assert_equal @site.settings(:shift).end, find('#shift_end').value
  end

  test 'site settings get updated correctly' do
    fill_in 'call_interval', with: @new_call_interval
    fill_in 'shift_start', with: @new_shift_start
    fill_in 'shift_end', with: @new_shift_end
    click_button 'Save changes'

    assert_equal site_path(@site), current_path
    assert_text 'Settings saved'

    @site.reload
    assert_equal @new_call_interval, @site.settings(:call).interval
    assert_equal @new_shift_start, @site.settings(:shift).start
    assert_equal @new_shift_end, @site.settings(:shift).end
  end

  test 'site settings update returns error on invalid times' do
    fill_in 'call_interval', with: @new_call_interval
    fill_in 'shift_start', with: @new_invalid_shift_start
    fill_in 'shift_end', with: @new_invalid_shift_end
    click_button 'Save changes'

    assert_equal site_path(@site), current_path
    assert_text 'Invalid shift start format'
    assert_text 'Invalid shift end format'

    @site.reload
    assert_equal @new_call_interval, @site.settings(:call).interval
    assert_not_equal @new_shift_start, @site.settings(:shift).start
    assert_not_equal @new_shift_end, @site.settings(:shift).end
  end
end

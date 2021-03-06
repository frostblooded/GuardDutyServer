require 'test_helper'

class CanAccessSitePageTest < Capybara::Rails::TestCase
  def initialize_new_values
    @new_call_interval = '20'
    @new_shift_start = '20:00'
    @new_shift_end = '21:00'

    @new_invalid_shift_start = '13@4t:'
    @new_invalid_shift_end = '13@4t:'
  end

  def setup
    @company = create(:company)
    @other_company = create(:company)

    @site = @company.sites.first
    @site2 = @company.sites.last
    @other_site = @other_company.sites.first

    initialize_new_values

    login_as @company
    visit site_path(@site)
  end

  test 'shows correct site name' do
    assert_text @site.name
  end

  test 'shows correct default site settings' do
    assert_equal @site.call_interval, find('#call_interval').value
    assert_equal @site.shift_start, find('#shift_start').value
    assert_equal @site.shift_end, find('#shift_end').value

    within '#workers' do
      worker_inputs = page.all('.worker-input').map(&:value)
      @site.workers.each do |w|
        assert worker_inputs.include? w.name
      end
    end
  end

  test 'settings get updated correctly' do
    fill_in 'call_interval', with: @new_call_interval
    fill_in 'shift_start', with: @new_shift_start
    fill_in 'shift_end', with: @new_shift_end
    click_button 'Save changes'

    assert_equal site_path(@site), current_path
    assert_text 'Site settings updated'

    @site.reload
    assert_equal @new_call_interval, @site.call_interval
    assert_equal @new_shift_start, @site.shift_start
    assert_equal @new_shift_end, @site.shift_end
  end

  test 'adding workers works' do
    @site.workers.each do |w|
      within '.new-worker' do
        find('#new-worker-input').set w.name
        find('#new-worker-add').click
      end

      # Button is pressed like this, because, otherwise,
      # it shows an error because of the fixed footer
      find('input[type="submit"]').trigger('click')

      @site.reload
      assert @site.workers.include? w
    end
  end

  test 'removing workers' do
    @site.workers.each do |w|
      within '#workers' do
        first('.worker-remove').click
      end

      click_button 'Save changes'

      @site.reload
      assert_not @site.workers.include? w
    end
  end

  test 'settings update returns error when trying to add nonexistent worker' do
    worker = Worker.new name: 'wekgreogmeromeogm',
                        password: 'foobarrr'

    within '.new-worker' do
      find('#new-worker-input').set worker.name
      find('#new-worker-add').click
    end

    click_button 'Save changes'

    assert_not @site.workers.include? worker
    assert_text "Worker '#{worker.name}' doesn't exist in this company"
  end

  test 'settings update returns error when trying to add worker \
        of other company' do
    worker = @other_site.workers.first

    within '.new-worker' do
      find('#new-worker-input').set worker.name
      find('#new-worker-add').click
    end

    click_button 'Save changes'

    assert_not @site.workers.include? worker
    assert_text "Worker '#{worker.name}' doesn't exist in this company"
  end

  test 'settings update returns error when trying to add a worker twice' do
    worker = @site.workers.first

    within '.new-worker' do
      find('#new-worker-input').set worker.name
      find('#new-worker-add').click
    end

    click_button 'Save changes'

    @site.reload
    assert @site.workers.include? worker
    assert_text "Worker '#{worker.name}' was added several times", count: 1
  end
end

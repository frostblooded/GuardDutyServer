require 'test_helper'

class CanAccessWorkerPageTest < Capybara::Rails::TestCase
  def setup
    @company = create(:company)
    login_as @company
    @worker = @company.workers.first

    visit worker_path(@worker)
  end

  test 'displays correct data' do
    assert_text @worker.name

    within '#sites' do
      @worker.sites.each do |s|
        assert_text s.name
      end
    end

    within '.wtable' do
      @worker.activities.each do |a|
        assert_text a.created_at.localtime.strftime('%H:%M:%S %d/%m/%Y')
      end
    end
  end

  test 'sorts activities by created_at' do
    # Created_at time for new call. It should be before the last call,
    # so that the sorting is tested
    call_time = @worker.activities.last.created_at - 20.minutes
    create_activity :call, @worker, @worker.sites.first, call_time
    reload_page

    @worker.activities.each_with_index do |a, index|
      selector = ".activities tr:nth-child(#{index + 1})"

      within selector do
        wanted_time = a.created_at.localtime.strftime('%H:%M:%S %d/%m/%Y')
        page.has_content? wanted_time
      end
    end
  end
end

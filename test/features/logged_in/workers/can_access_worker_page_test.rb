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
        assert_text a.created_at.localtime
      end
    end
  end
end

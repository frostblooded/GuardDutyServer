require "test_helper"

class AccessIsRestrictedTest < Capybara::Rails::TestCase
  def setup
    @company = create(:company)
    @other_company = create(:company)

    @site = @company.sites.first
    @other_site = @other_company.sites.first

    @worker = @company.workers.first
    @other_worker = @other_company.workers.first

    login_as @company
  end

  test 'company can access only own workers' do
    visit site_path(@site)
    assert_equal site_path(@site), current_path
    assert_text @site.name

    visit site_path(@other_site)
    assert_equal root_path, current_path
    assert_text 'You are not authorized to access this page'
  end

  test 'company can access only own sites' do
    visit worker_path(@worker)
    assert_equal worker_path(@worker), current_path
    assert_text @worker.name

    visit worker_path(@other_worker)
    assert_equal root_path, current_path
    assert_text 'You are not authorized to access this page'
  end
end

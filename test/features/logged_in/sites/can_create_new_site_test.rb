require "test_helper"

class CanCreateNewSiteTest < Capybara::Rails::TestCase
  def setup
    @site = Site.new name: 'test site'
    login_as create(:company)
    visit new_site_path
  end

  test 'can create new site' do
    assert_difference 'Site.count' do
      fill_in 'site_name', with: @site.name
      click_button 'Create new site'
    end

    assert sites_path, current_path
    assert page, 'Site added!'
  end
end

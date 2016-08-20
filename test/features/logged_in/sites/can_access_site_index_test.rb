require 'test_helper'

class CanAccessSiteIndexTest < Capybara::Rails::TestCase
  def setup
    @company = create(:company)
    @site = @company.sites.first
    login_as @company
    
    visit sites_path
  end

  test 'shows correct sites' do
    @company.sites.each do |s|
      assert_content page, s.name
    end

    assert_content page, 'Create site'
  end

  test 'site page link opens site page' do
    click_link @site.name
    assert @site, current_path
  end

  test 'site delete link deletes site' do
    first(:link, 'delete').click
    assert_not Site.exists? @site.id
  end

  test 'new site link opens new site' do
    click_link 'Create site'
    assert new_site_path, current_path
  end
end

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
      assert_text s.name
    end

    assert_text 'Create site'
  end

  test 'site page link opens site page' do
    first(:link, @site.name).click
    assert_equal site_path(@site), current_path
  end

  test 'site delete link deletes site' do
    first(:link, 'delete').click
    assert_not Site.exists? @site.id
    assert_text 'Site deleted'
  end

  test 'new site link opens new site' do
    click_link 'Create site'
    assert_equal new_site_path, current_path
  end
end

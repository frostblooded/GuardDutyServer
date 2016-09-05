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

  test 'site delete link deletes site' do
    first('.site-delete').click
    assert_not Site.exists? @site.id
    assert_text 'Site deleted'
  end

  test 'has correct links' do
    assert_text @site.name
    assert_text 'Create site'
  end
end

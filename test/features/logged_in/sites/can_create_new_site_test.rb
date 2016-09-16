require 'test_helper'

class CanCreateNewSiteTest < Capybara::Rails::TestCase
  def setup
    @company = create(:company)
    @site = @company.sites.first

    @new_site_name = @site.name + 'a'

    login_as @company
    visit new_site_path
  end

  test 'can create new site' do
    assert_difference 'Site.count' do
      fill_in 'site_name', with: @new_site_name
      click_button 'Create site'
    end

    assert_equal sites_path, current_path
    assert_text 'Site created'
  end

  test 'shows error when name isn\'t unique in company' do
    @other_company = create(:company)

    # Not unique in company
    assert_no_difference 'Site.count' do
      fill_in 'site_name', with: @site.name
      click_button 'Create site'
    end

    assert_equal sites_path, current_path
    assert_text 'Name not unique in company'

    # Unique in company
    login_as @other_company

    assert_difference 'Site.count' do
      fill_in 'site_name', with: @site.name
      click_button 'Create site'
    end

    assert_equal sites_path, current_path
    assert_text 'Site created'
  end

  test 'shows error on empty form' do
    assert_no_difference 'Site.count' do
      click_button 'Create site'
    end

    assert_equal sites_path, current_path
    assert_text 'Name can\'t be blank'
  end
end

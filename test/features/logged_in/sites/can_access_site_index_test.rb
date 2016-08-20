require 'test_helper'

class CanAccessSiteIndexTest < Capybara::Rails::TestCase
  def setup
    @company = create(:company)
    login_as @company
  end

  test 'shows correct sites' do
    visit sites_path

    @company.sites.each do |s|
      assert_content page, s.name
    end

    assert_content page, 'Create site'
  end

  test 'site edit link opens site edit' do
    
  end
end

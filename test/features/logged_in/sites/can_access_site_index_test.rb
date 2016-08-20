require 'test_helper'

class CanAccessSiteIndexTest < Capybara::Rails::TestCase
  def setup
    @company = create(:company)
    login_as @company
    
    visit sites_path
  end

  test 'shows correct sites' do
    @company.sites.each do |s|
      assert_content page, s.name
    end

    assert_content page, 'Create site'
  end
end

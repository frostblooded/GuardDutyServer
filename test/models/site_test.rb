require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  def setup
    @company = create(:company)
    @site = @company.sites.first
  end

  test 'position belongs to correct company' do
    assert_equal @company, @site.company
  end
end

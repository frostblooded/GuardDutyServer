require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  def setup
    @company = Company.create(name: 'foobarrr', password: 'foobarrr')
    @site = @company.sites.create(name: 'test site')
  end

  test 'position belongs to correct company' do
    assert_equal @company, @site.company
  end
end

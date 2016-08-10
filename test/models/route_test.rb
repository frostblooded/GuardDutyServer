require 'test_helper'

class RouteTest < ActiveSupport::TestCase
  def setup
    @site = create(:site)
    @route = @site.routes.first
  end

  test 'route belongs to correct site' do
    assert_equal @site, @route.site
  end
end

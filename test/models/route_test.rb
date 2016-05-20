require 'test_helper'

class RouteTest < ActiveSupport::TestCase
  def setup
    @site = Site.create(name: 'test site')
    @route = @site.routes.create(name: 'test route')
  end

  test 'position belongs to correct site' do
    assert_equal @site, @route.site
  end
end

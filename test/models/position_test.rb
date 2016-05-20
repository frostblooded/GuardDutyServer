require 'test_helper'

class PositionTest < ActiveSupport::TestCase
  def setup
    @route = Route.create(name: 'test route')
    @position = @route.positions.create(latitude: 42, longitude: 42)
  end

  test 'position belongs to correct route' do
    assert_equal @route, @position.route
  end
end

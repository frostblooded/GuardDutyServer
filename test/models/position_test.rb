require 'test_helper'

class PositionTest < ActiveSupport::TestCase
  def setup
    @route = create(:route)
    @position = @route.positions.first
  end

  test 'position belongs to correct route' do
    assert_equal @route, @position.route
  end
end

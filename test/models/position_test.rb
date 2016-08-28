require 'test_helper'

class PositionTest < ActiveSupport::TestCase
  def setup
    @route = create(:route)
    @position = @route.positions.first
  end

  test 'belongs to correct route' do
    assert_equal @route, @position.route
  end

  test 'latitude is number' do
    @position.latitude = 13.34
    assert @position.valid?

    @position.latitude = 'asadasd'
    assert_not @position.valid?
  end

  test 'longitude is number' do
    @position.longitude = 14.43
    assert @position.valid?

    @position.longitude = 'asfewg'
    assert_not @position.valid?
  end
end

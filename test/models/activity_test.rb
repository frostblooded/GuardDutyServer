require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  test 'validates time_left' do
    activity = Activity.new time_left: 'ivan'
    assert_not activity.valid?
  end
end

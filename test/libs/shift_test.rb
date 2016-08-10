require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  def setup
    @shift = Shift.new
  end

  test 'shift has initialized properly' do
    assert 0, @shift.start
    assert 0, @shift.end
    assert [], @shift.activities
  end
end

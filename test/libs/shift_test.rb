require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  def setup
    @shift = Shift.new(Time.parse('11:00'), Time.parse('12:00'))
    @workers = []

    2.times do
      @workers << create(:worker)
    end

    @activities = []
    @activities << create_activity(:call, @workers[0], @shift.start - 5.minutes)

    @shift.activities = @activities
  end

  test 'shift has initialized properly' do
    @shift = Shift.new
    assert_not_nil @shift.start
    assert_not_nil @shift.end
    assert_not_nil @shift.activities
  end

  test 'returns correct workers' do

  end
end

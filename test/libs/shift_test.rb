require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  def setup
    @shift = Shift.new(Time.parse('11:00'), Time.parse('12:00'))
    @workers = []

    # Make 3 workers - the third one isn't in the shift
    3.times do
      @workers << create(:worker)
    end

    @activities = []

    # Worker 1 activities
    @activities << create_activity(:login, @workers[0], @shift.start - 5.minutes)
    @activities << create_activity(:call, @workers[0], @shift.start + 10.minutes)
    @activities << create_activity(:call, @workers[0], @shift.start + 25.minutes)
    # Missing call 40 minutes after shift has started
    @activities << create_activity(:call, @workers[0], @shift.start + 55.minutes)
    @activities << create_activity(:logout, @workers[0], @shift.end + 5.minutes)

    # Worker 2 activities
    @activities << create_activity(:login, @workers[1], @shift.start + 5.minutes)
    # Missing call 20 minutes after shift has started
    @activities << create_activity(:call, @workers[1], @shift.start + 35.minutes)
    # Missing call 50 minutes after shift has started
    @activities << create_activity(:logout, @workers[1], @shift.end - 5.minutes)

    @shift.activities = @activities
  end

  test 'shift has initialized properly' do
    @shift = Shift.new
    assert_not_nil @shift.start
    assert_not_nil @shift.end
    assert_not_nil @shift.activities
  end

  test 'returns correct workers' do
    workers = @shift.workers
    assert workers.include? @workers[0]
    assert workers.include? @workers[1]
    assert_not workers.include? @workers[2]
  end
end

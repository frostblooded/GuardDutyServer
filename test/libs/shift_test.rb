require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  def setup
    @shift = Shift.new(Time.parse('11:00'), Time.parse('12:00'))
    @shift.site = create(:site)

    @workers = []

    # Make 3 workers - the third one isn't in the shift
    4.times do
      @workers << create(:worker)
    end

    @activities = []

    # Worker 1(good worker - logged in before shift)
    @activities << create_activity(:login, @workers[0], @shift.start - 5.minutes)
    @activities << create_activity(:call, @workers[0], @shift.start + 10.minutes)
    @activities << create_activity(:call, @workers[0], @shift.start + 40.minutes)
    @activities << create_activity(:call, @workers[0], @shift.start + 25.minutes)
    @activities << create_activity(:call, @workers[0], @shift.start + 55.minutes)
    @activities << create_activity(:logout, @workers[0], @shift.end + 5.minutes)

    # Worker 2(okay worker - logged in a bit after shift started, but
    #  2 calls haven't been received from him)
    @activities << create_activity(:login, @workers[1], @shift.start + 5.minutes)
    # Missing call 20 minutes after shift has started
    @activities << create_activity(:call, @workers[1], @shift.start + 35.minutes)
    # Missing call 50 minutes after shift has started
    @activities << create_activity(:logout, @workers[1], @shift.end - 5.minutes)

    # Worker 3(bad worker - only logged out)
    @activities << create_activity(:logout, @workers[2], @shift.end - 5.minutes)

    # Worker 4(bad worker - logged out too late and didn't answer some calls)
    @activities << create_activity(:login, @workers[3], @shift.start + 17.minutes)
    @activities << create_activity(:call, @workers[3], @shift.start + 20.minutes, 0)
    @activities << create_activity(:call, @workers[3], @shift.start + 35.minutes)
    @activities << create_activity(:call, @workers[3], @shift.start + 50.minutes, 0)
    @activities << create_activity(:logout, @workers[3], @shift.end + 5.minutes)

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
    assert workers.include? @workers[3]
  end

  test 'makes correct report' do
    shift_report = @shift.report
    assert_equal @shift.site, shift_report.site
    assert_equal @shift.workers.size, shift_report.worker_reports.size

    shift_report.worker_reports.each_with_index do |wr, i|
      assert_equal @workers[i], shift_report.worker_reports[i].worker
      worker_messages = shift_report.worker_reports[i].messages

      # Check different things for the different workers
      case i
      when 0
        assert_equal worker_messages.size, 0
      when 1
        assert_equal worker_messages[0], ('unreceived call around ' + (@shift.start + 20.minutes).to_s)
        assert_equal worker_messages[1], ('unreceived call around ' + (@shift.start + 50.minutes).to_s)
      when 3
        assert_equal worker_messages[0], ('logged in 17 minutes too late')
        assert_equal worker_messages[1], ('didn\'t answer call at ' + (@shift.start + 20.minutes).to_s)
        assert_equal worker_messages[2], ('didn\'t answer call at ' + (@shift.start + 50.minutes).to_s)
      end
    end
  end
end

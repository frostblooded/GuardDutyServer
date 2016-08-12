require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  def make_activities
    activities = []

    # Worker 0 (good worker - logged in before shift)
    activities << create_activity(:login, @workers[0], @shift.start - 5.minutes)
    activities << create_activity(:call, @workers[0], @shift.start + 10.minutes)
    activities << create_activity(:call, @workers[0], @shift.start + 40.minutes)
    activities << create_activity(:call, @workers[0], @shift.start + 25.minutes)
    activities << create_activity(:call, @workers[0], @shift.start + 55.minutes)
    activities << create_activity(:logout, @workers[0], @shift.end + 5.minutes)

    # Worker 1 (okay worker - logged in a bit after shift started, but
    #  2 calls haven't been received from him)
    activities << create_activity(:login, @workers[1], @shift.start + 5.minutes)
    # Missing call 20 minutes after shift has started
    activities << create_activity(:call, @workers[1], @shift.start + 35.minutes)
    # Missing call 50 minutes after shift has started
    activities << create_activity(:logout, @workers[1], @shift.end - 5.minutes)

    # Worker 2 (bad worker - only logged out)
    activities << create_activity(:logout, @workers[2], @shift.end - 5.minutes)

    # Worker 3 (bad worker - logged out too late and didn't answer some calls)
    activities << create_activity(:login, @workers[3], @shift.start + 17.minutes)
    activities << create_activity(:call, @workers[3], @shift.start + 20.minutes, 0)
    activities << create_activity(:call, @workers[3], @shift.start + 35.minutes)
    activities << create_activity(:call, @workers[3], @shift.start + 50.minutes, 0)
    activities << create_activity(:logout, @workers[3], @shift.end + 5.minutes)

    activities
  end

  def make_workers
    workers = []

    4.times do
      workers << create(:worker)
    end

    workers
  end

  def get_worker_report(shift, worker)
    shift.report.worker_reports.select { |wr| wr.worker == worker }.first
  end

  def get_worker_messages(shift, worker)
    get_worker_report(shift, worker).messages
  end

  def setup
    @workers = make_workers

    @shift = Shift.new(Time.parse('11:00'), Time.parse('12:00'))
    @shift.site = create(:site)
    @shift.activities = make_activities
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

  test 'report has correct site' do
    assert_equal @shift.site, @shift.report.site
  end

  test 'report has correct number of workers' do
    assert_equal @shift.workers.size, @shift.report.worker_reports.size
  end

  test 'makes correct report for perfect worker' do
    worker_messages = get_worker_messages @shift, @workers[0]
    assert worker_messages.empty?
  end

  test 'makes correct report for worker with 2 unmade calls' do
    worker_messages = get_worker_messages @shift, @workers[1]
    assert_equal 'unreceived call around ' + (@shift.start + 20.minutes).to_s, worker_messages[0]
    assert_equal 'unreceived call around ' + (@shift.start + 50.minutes).to_s, worker_messages[1]
  end

  test 'makes correct report for worker who logged in late and didn\'t answer 2 calls' do
    worker_messages = get_worker_messages @shift, @workers[3]
    assert_equal 'logged in 17 minutes too late', worker_messages[0]
    assert_equal 'didn\'t answer call at ' + (@shift.start + 20.minutes).to_s, worker_messages[1]
    assert_equal 'didn\'t answer call at ' + (@shift.start + 50.minutes).to_s, worker_messages[2]
  end
end

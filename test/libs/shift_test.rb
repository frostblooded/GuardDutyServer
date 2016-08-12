require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  def make_activities
    activities = []

    # Worker 0 (good worker - logged in before shift)
    activities << create_activity(:login, @workers[0], @shift.start - 5.minutes)
    activities << create_activity(:logout, @workers[0], @shift.end + 5.minutes)

    # Worker 1 (okay worker - logged in a bit after shift started)
    activities << create_activity(:login, @workers[1], @shift.start + 5.minutes)
    activities << create_activity(:logout, @workers[1], @shift.end - 5.minutes)

    # Worker 2 (bad worker - only logged out)
    activities << create_activity(:logout, @workers[2], @shift.end - 5.minutes)

    # Worker 3 (bad worker - logged in too late)
    activities << create_activity(:login, @workers[3], @shift.start + 17.minutes)
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
end

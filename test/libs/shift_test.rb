require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  # Good worker - logged in before shift started
  def make_good_worker_activities
    [create_activity(:login, @workers[0], @site, @shift.start - 5.minutes),
     create_activity(:logout, @workers[0], @site, @shift.end + 5.minutes)]
  end

  # Okay worker - logged in after shift started
  def make_okay_worker_activities
    [create_activity(:login, @workers[1], @site, @shift.start + 5.minutes),
     create_activity(:logout, @workers[1], @site, @shift.end - 5.minutes)]
  end

  # Bad worker - only logged out
  def make_inactive_worker_activities
    create_activity(:logout, @workers[2], @site, @shift.end - 5.minutes)
  end

  def make_activities
    activities = []
    activities += make_good_worker_activities
    activities += make_okay_worker_activities
    activities << make_inactive_worker_activities
  end

  def make_workers
    @site.workers.to_a
  end

  def setup
    @site = create(:site)
    @workers = make_workers

    @shift = Shift.new(Time.parse('11:00'), Time.parse('12:00'))
    @shift.site = create(:site)
    @shift.activities = make_activities
  end

  test 'initializes properly' do
    shift = Shift.new
    assert_not_nil shift.start
    assert_not_nil shift.end
    assert_not_nil shift.activities
  end

  test 'returns correct call_interval' do
    site = Site.create(name: Faker::Name.name)
    site.call_interval = '20'
    shift = Shift.new
    shift.site = site

    assert_equal site.call_interval.to_i, shift.call_interval
  end

  test 'returns correct workers' do
    workers = @shift.workers

    assert workers.include? @workers[0]
    assert workers.include? @workers[1]
    assert_not workers.include? @workers[2]
  end

  test 'generated report has correct site' do
    assert_equal @shift.site, @shift.report.site
  end

  test 'generated report has correct number of workers' do
    assert_equal @shift.workers.size, @shift.report.worker_reports.size
  end
end

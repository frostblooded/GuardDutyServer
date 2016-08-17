require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  # rubocop:disable AbcSize
  def make_activities
    activities = []

    # Worker 0 (good worker - logged in before shift started)
    activities << create_activity(:login, @workers[0], @shift.start - 5.minutes)
    activities << create_activity(:logout, @workers[0], @shift.end + 5.minutes)

    # Worker 1 (okay worker - logged in after shift started)
    activities << create_activity(:login, @workers[1], @shift.start + 5.minutes)
    activities << create_activity(:logout, @workers[1], @shift.end - 5.minutes)

    # Worker 2 (bad worker - only logged out)
    activities << create_activity(:logout, @workers[2], @shift.end - 5.minutes)

    activities
  end

  def make_workers
    workers = []

    3.times do
      workers << create(:worker)
    end

    workers
  end

  def setup
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
    site.settings(:call).interval = '20'
    shift = Shift.new
    shift.site = site

    assert_equal site.settings(:call).interval.to_i, shift.call_interval
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

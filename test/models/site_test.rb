require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  def make_worker_activities
    base_time = Time.zone.parse(@site.shift_start)
    call_interval = 15
    @activities = []

    6.times do |i|
      creation_time = base_time - 5.minutes + call_interval.minutes * i
      @activities << create_activity(:call, @worker, @site, creation_time)
    end
  end

  # The point of this is to make sure that, although the other worker
  # can work on this site, the shift report doesn\'t return
  # the other worker's activities, if they weren't made for this site,
  # but were made for another site, to which the other worker also belongs
  def make_other_worker_activities
    base_time = Time.zone.parse(@site.shift_start)
    call_interval = 15
    @other_activities = []

    6.times do |i|
      creation_time = base_time - 5.minutes + call_interval.minutes * i
      @other_activities << create_activity(:call, @other_worker,
                                           @other_site, creation_time)
    end
  end

  def setup
    @company = create(:company)
    @site = @company.sites.first
    @other_site = @company.sites.second

    @worker = @site.workers.first
    @other_worker = @site.workers.second

    @site.shift_start = '11:00'
    @site.shift_end = '12:00'
  end

  test 'position belongs to correct company' do
    assert_equal @company, @site.company
  end

  test 'returns last shift times when shift has just ended' do
    time = Time.zone.parse(@site.shift_end) + 30.minutes

    Timecop.freeze(time) do
      shift_times = @site.instance_eval { last_shift_times }
      assert_equal shift_times[:start],
                   Time.zone.parse(@site.shift_start)
      assert_equal shift_times[:end],
                   Time.zone.parse(@site.shift_end)
    end
  end

  test 'returns last shift times when a new shift has started and not ended' do
    time = Time.zone.parse(@site.shift_start) + 30.minutes

    Timecop.freeze(time) do
      shift_times = @site.instance_eval { last_shift_times }
      assert_equal shift_times[:start],
                   (Time.zone.parse(@site.shift_start) - 1.day)
      assert_equal shift_times[:end],
                   (Time.zone.parse(@site.shift_end) - 1.day)
    end
  end

  test 'returns last shift times when a new shift is about to start' do
    time = Time.zone.parse(@site.shift_start) - 30.minutes

    Timecop.freeze(time) do
      shift_times = @site.instance_eval { last_shift_times }
      assert_equal shift_times[:start],
                   (Time.zone.parse(@site.shift_start) - 1.day)
      assert_equal shift_times[:end],
                   (Time.zone.parse(@site.shift_end) - 1.day)
    end
  end

  test 'correctly returns last shift' do
    make_worker_activities
    make_other_worker_activities

    time = Time.zone.parse(@site.shift_end) + 30.minutes

    Timecop.freeze(time) do
      shift = @site.last_shift

      # Make sure it returns only the activities which are part of the shift
      assert_not shift.activities.include?(@activities[0])
      assert shift.activities.include?(@activities[1])
      assert shift.activities.include?(@activities[2])
      assert shift.activities.include?(@activities[3])
      assert shift.activities.include?(@activities[4])
      assert_not shift.activities.include?(@activities[5])

      # Make sure the other worker's activities are not present here
      @other_activities.each { |a| assert_not shift.activities.include? a }

      assert_equal Time.zone.parse(@site.shift_start), shift.start
      assert_equal Time.zone.parse(@site.shift_end), shift.end
      assert_equal @site, shift.site
    end
  end

  test 'last shift only has workers from this site' do
    @other_site = create(:site)
    @other_worker = @other_site.workers.first
    @other_activity = create_activity(:call,
                                      @other_worker,
                                      @site,
                                      Time.zone.parse('11:10'))

    time = Time.zone.parse(@site.shift_end) + 30.minutes

    Timecop.freeze(time) do
      shift = @site.last_shift
      assert_not shift.activities.include? @other_activity
    end
  end

  test 'name is unique in company' do
    @other_company = create(:company)
    @site1 = @company.sites.new name: @site.name
    assert_not @site1.valid?

    @site2 = @other_company.sites.new name: @site.name
    assert @site2.valid?
  end
end

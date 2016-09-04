require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  # rubocop:disable AbcSize
  def make_activities
    base_time = Time.zone.parse(@site.settings(:shift).start)
    call_interval = 15
    @activities = []

    6.times do |i|
      creation_time = base_time - 5.minutes + call_interval.minutes * i
      @activities << create_activity(:call, @worker, @site, creation_time)
    end
  end

  def setup
    @company = create(:company)
    @site = @company.sites.first
    @worker = @site.workers.first

    @site.settings(:shift).start = '11:00'
    @site.settings(:shift).end = '12:00'
    make_activities
  end

  test 'position belongs to correct company' do
    assert_equal @company, @site.company
  end

  test 'returns last shift times when shift has just ended' do
    time = Time.zone.parse(@site.settings(:shift).end) + 30.minutes

    Timecop.freeze(time) do
      shift_times = @site.instance_eval { last_shift_times }
      assert_equal shift_times[:start],
                   Time.zone.parse(@site.settings(:shift).start)
      assert_equal shift_times[:end],
                   Time.zone.parse(@site.settings(:shift).end)
    end
  end

  test 'returns last shift times when a new shift has started and not ended' do
    time = Time.zone.parse(@site.settings(:shift).start) + 30.minutes

    Timecop.freeze(time) do
      shift_times = @site.instance_eval { last_shift_times }
      assert_equal shift_times[:start],
                   (Time.zone.parse(@site.settings(:shift).start) - 1.day)
      assert_equal shift_times[:end],
                   (Time.zone.parse(@site.settings(:shift).end) - 1.day)
    end
  end

  test 'returns last shift times when a new shift is about to start' do
    time = Time.zone.parse(@site.settings(:shift).start) - 30.minutes

    Timecop.freeze(time) do
      shift_times = @site.instance_eval { last_shift_times }
      assert_equal shift_times[:start],
                   (Time.zone.parse(@site.settings(:shift).start) - 1.day)
      assert_equal shift_times[:end],
                   (Time.zone.parse(@site.settings(:shift).end) - 1.day)
    end
  end

  test 'correctly returns last shift' do
    time = Time.zone.parse(@site.settings(:shift).end) + 30.minutes

    Timecop.freeze(time) do
      shift = @site.last_shift

      # Make sure it returns only the activities which are part of the shift
      assert_not shift.activities.include?(@activities[0])
      assert shift.activities.include?(@activities[1])
      assert shift.activities.include?(@activities[2])
      assert shift.activities.include?(@activities[3])
      assert shift.activities.include?(@activities[4])
      assert_not shift.activities.include?(@activities[5])

      assert_equal Time.zone.parse(@site.settings(:shift).start), shift.start
      assert_equal Time.zone.parse(@site.settings(:shift).end), shift.end
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

    time = Time.zone.parse(@site.settings(:shift).end) + 30.minutes

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

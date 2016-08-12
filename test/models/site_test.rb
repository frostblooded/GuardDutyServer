require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  def setup
    @company = create(:company)
    @site = @company.sites.first
    @worker = @site.workers.first

    @site.settings(:shift).start = '11:00'
    @site.settings(:shift).end = '12:00'

    base_time = Time.parse(@site.settings(:shift).start)
    call_interval = 15
    @activities = []

    6.times do |i|
      activity = @worker.activities.create(category: :call)

      # Adds minutes to the time so that the first and the last
      # activities are not in the shift's time
      activity.created_at = base_time - 5.minutes + call_interval.minutes*i
      activity.updated_at = activity.created_at
      activity.save!

      @activities << activity
    end
  end

  test 'position belongs to correct company' do
    assert_equal @company, @site.company
  end

  test 'correctly returns last completed shift times when shift has just ended' do
    time = Time.parse(@site.settings(:shift).end) + 30.minutes

    Timecop.freeze(time) do
      shift_times = @site.instance_eval{ get_last_shift_times }
      assert_equal shift_times[:start], Time.parse(@site.settings(:shift).start)
      assert_equal shift_times[:end], Time.parse(@site.settings(:shift).end)
    end
  end

  test 'correctly returns last completed shift times when a new shift has started and not ended' do
    time = Time.parse(@site.settings(:shift).start) + 30.minutes

    Timecop.freeze(time) do
      shift_times = @site.instance_eval{ get_last_shift_times }
      assert_equal shift_times[:start], (Time.parse(@site.settings(:shift).start) - 1.day)
      assert_equal shift_times[:end], (Time.parse(@site.settings(:shift).end) - 1.day)
    end
  end

  test 'correctly returns last completed shift times when a new shift is about to start' do
    time = Time.parse(@site.settings(:shift).start) - 30.minutes

    Timecop.freeze(time) do
      shift_times = @site.instance_eval{ get_last_shift_times }
      assert_equal shift_times[:start], (Time.parse(@site.settings(:shift).start) - 1.day)
      assert_equal shift_times[:end], (Time.parse(@site.settings(:shift).end) - 1.day)
    end
  end

  test 'correctly returns last shift' do
    time = Time.parse(@site.settings(:shift).end) + 30.minutes

    Timecop.freeze(time) do
      shift = @site.get_last_shift

      # Make sure it returns only the activities which are part of the shift
      assert_not shift.activities.include?(@activities[0])
      assert shift.activities.include?(@activities[1])
      assert shift.activities.include?(@activities[2])
      assert shift.activities.include?(@activities[3])
      assert shift.activities.include?(@activities[4])
      assert_not shift.activities.include?(@activities[5])

      assert_equal Time.parse(@site.settings(:shift).start), shift.start
      assert_equal Time.parse(@site.settings(:shift).end), shift.end
      assert_equal @site, shift.site
    end
  end
end

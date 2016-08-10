require 'test_helper'

class ShiftReportTest < ActiveSupport::TestCase
  def setup
    @site = create(:site)
    @worker = @site.workers.first

    base_time = Time.zone.parse('11:00')
    @activities = []

    6.times do |i|
      activity = @worker.activities.create(category: :call)

      # Adds minutes to the time so that the first and the last
      # activities are not in the shift's time
      activity.created_at = base_time - 5.minutes + 15.minutes*i
      activity.updated_at = activity.created_at
      activity.save!

      @activities << activity
    end

    @site.settings(:shift).start = '11:00'
    @site.settings(:shift).end = '12:00'
  end

  test 'site correctly returns last shift' do
    shift = @site.get_last_shift

    # Make sure it returns only the activities which are part of the shift
    assert_not shift.activities.include?(@activities[0])
    assert shift.activities.include?(@activities[1])
    assert shift.activities.include?(@activities[2])
    assert shift.activities.include?(@activities[3])
    assert shift.activities.include?(@activities[4])
    assertnot shift.activities.include?(@activities[5])

    assert_equal @site.settings(:shift).start, shift.start
    assert_equal @site.settings(:shift).end, shift.end
    assert_equal @site, shift.site
  end
end

require 'test_helper'

class ShiftReportTest < ActiveSupport::TestCase
  def setup
    @site = create(:site)
    @shift_report = ShiftReport.new(@site, Shift.new)
  end

  test 'initializes correctly' do
    assert_equal @site, @shift_report.site
    assert @shift_report.worker_reports.empty?
    assert_not @shift_report.shift.nil?
  end

  test 'returns correctly if is empty' do
    5.times do
      @shift_report.worker_reports << WorkerReport.new
    end

    assert_not @shift_report.messages?
  end

  test 'returns correctly if is not empty' do
    5.times do
      @shift_report.worker_reports << WorkerReport.new
    end

    non_empty_worker_report = WorkerReport.new
    non_empty_worker_report.add_late_login(20, Time.now)
    @shift_report.worker_reports << non_empty_worker_report

    assert @shift_report.messages?
  end
end

require 'test_helper'

class ShiftReportTest < ActiveSupport::TestCase
  def setup
    @site = create(:site)
    @shift_report = ShiftReport.new(@site, Shift.new)
  end

  test 'worker report initializes correctly' do
    assert_equal @site, @shift_report.site
    assert @shift_report.worker_reports.empty?
    assert_not @shift_report.shift.nil?
  end
end

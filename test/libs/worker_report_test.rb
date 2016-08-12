require 'test_helper'

class WorkerReportTest < ActiveSupport::TestCase
  def setup
    @worker = create(:worker)
    @shift = Shift.new
    @worker_report = WorkerReport.new(@worker, [], @shift)
  end

  test 'worker report initializes correctly' do
    assert_equal @worker, @worker_report.worker
    assert @worker_report.activities.empty?
    assert_equal @shift, @worker_report.shift
    assert @worker_report.messages.empty?
  end
end

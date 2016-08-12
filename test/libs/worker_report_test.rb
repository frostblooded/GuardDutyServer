require 'test_helper'

class WorkerReportTest < ActiveSupport::TestCase
  def setup
    @worker = create(:worker)
    @worker_report = WorkerReport.new(@worker)
  end

  test 'worker report initializes correctly' do
    assert_equal @worker, @worker_report.worker
    assert @worker_report.activities.empty?
    assert @worker_report.messages.empty?
  end
end

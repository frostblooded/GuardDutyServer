require 'test_helper'

class WorkerReportTest < ActiveSupport::TestCase
  def setup
    @worker = create(:worker)

    site = create(:site)
    site.settings(:call).interval = "15"

    @shift = Shift.new(Time.parse('11:00'), Time.parse('12:00'))
    @shift.site = site

    @worker_report = WorkerReport.new(@worker, [], @shift)
  end

  test 'initializes correctly' do
    assert_equal @worker, @worker_report.worker
    assert @worker_report.activities.empty?
    assert_equal @shift, @worker_report.shift
    assert @worker_report.messages.empty?
  end

  test 'has set proper partial path' do
    assert_equal 'shared/worker_report', @worker_report.to_partial_path
  end

  test 'returns correct login time for already logged in worker' do
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 10.minutes)

    assert_equal @shift.start, @worker_report.login_time.localtime
  end

  test 'returns correct login time for worker that logs in during shift' do
    login_time = @shift.start + 5.minutes
    @worker_report.activities << create_activity(:login, @worker, login_time)

    assert_equal login_time, @worker_report.login_time.localtime
  end

  test 'returns correct login delay for already logged in worker' do
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 10.minutes)

    assert_equal 0, @worker_report.login_delay
  end

  test 'returns correct login delay for worker that logs in during shift' do
    login_delay = 20
    @worker_report.activities << create_activity(:login, @worker, @shift.start + login_delay.minutes)

    assert_equal login_delay, @worker_report.login_delay
  end

  test 'generates correct messages for perfect worker' do
    @worker_report.activities << create_activity(:login, @worker, @shift.start - 5.minutes)
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 10.minutes)
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 40.minutes)
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 25.minutes)
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 55.minutes)
    @worker_report.generate_messages

    assert @worker_report.messages.empty?
  end

  # Unsynced calls are calls which start sooner than the call interval, which is expected
  test 'generates correct messages for perfect worker with unsynced calls' do
    @worker_report.activities << create_activity(:login, @worker, @shift.start + 5.minutes)
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 11.minutes)
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 26.minutes)
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 41.minutes)
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 56.minutes)
    @worker_report.generate_messages

    assert @worker_report.messages.empty?
  end

  test 'generates correct messages for worker with 2 missing calls' do
    @worker_report.activities << create_activity(:login, @worker, @shift.start + 5.minutes)
    # Missing call 20 minutes after shift has started
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 35.minutes)
    # Missing call 50 minutes after shift has started
    @worker_report.activities << create_activity(:logout, @worker, @shift.end - 5.minutes)
    @worker_report.generate_messages

    assert_equal WorkerReport.format_unreceived_call(@shift.start + 20.minutes), @worker_report.messages[0]
    assert_equal WorkerReport.format_unreceived_call(@shift.start + 50.minutes), @worker_report.messages[1]
  end

  test 'generates correct messages for worker with late login and 2 unanswered calls' do
    @worker_report.activities << create_activity(:login, @worker, @shift.start + 20.minutes)
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 35.minutes, 0)
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 50.minutes, 0)
    @worker_report.generate_messages

    assert_equal WorkerReport.format_late_login(20, @shift.start + 20.minutes), @worker_report.messages[0]
    assert_equal WorkerReport.format_unanswered_call(@shift.start + 35.minutes), @worker_report.messages[1]
    assert_equal WorkerReport.format_unanswered_call(@shift.start + 50.minutes), @worker_report.messages[2]
  end
end

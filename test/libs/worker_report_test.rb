require 'test_helper'

class WorkerReportTest < ActiveSupport::TestCase
  def setup
    @worker = create(:worker)

    @shift = Shift.new(Time.parse('11:00'), Time.parse('12:00'))
    @shift.site = create(:site)

    @worker_report = WorkerReport.new(@worker, [], @shift)
  end

  test 'worker report initializes correctly' do
    assert_equal @worker, @worker_report.worker
    assert @worker_report.activities.empty?
    assert_equal @shift, @worker_report.shift
    assert @worker_report.messages.empty?
  end

  test 'worker report returns correct login time for already logged in worker' do
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 10.minutes)

    assert_equal @shift.start, @worker_report.login_time.localtime
  end

  test 'worker report returns correct login time for worker that logs in during shift' do
    login_time = @shift.start + 5.minutes
    @worker_report.activities << create_activity(:login, @worker, login_time)

    assert_equal login_time, @worker_report.login_time.localtime
  end

  test 'worker report generates correct messages for perfect worker' do
    @worker_report.activities << create_activity(:login, @worker, @shift.start - 5.minutes)
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 10.minutes)
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 40.minutes)
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 25.minutes)
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 55.minutes)
    @worker_report.activities << create_activity(:logout, @worker, @shift.end + 5.minutes)
    @worker_report.generate_messages

    assert @worker_report.messages.empty?
  end

  test 'worker report generates correct messages for worker with 2 missing calls' do
    @worker_report.activities << create_activity(:login, @worker, @shift.start + 5.minutes)
    # Missing call 20 minutes after shift has started
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 35.minutes)
    # Missing call 50 minutes after shift has started
    @worker_report.activities << create_activity(:logout, @worker, @shift.end - 5.minutes)
    @worker_report.generate_messages

    assert_equal 'unreceived call around ' + (@shift.start + 20.minutes).to_s, @worker_report.messages[0]
    assert_equal 'unreceived call around ' + (@shift.start + 50.minutes).to_s, @worker_report.messages[1]
  end

  test 'worker report generates correct messages for worker with late login and 2 unanswered calls' do
    @worker_report.activities << create_activity(:login, @worker, @shift.start + 17.minutes)
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 20.minutes, 0)
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 35.minutes)
    @worker_report.activities << create_activity(:call, @worker, @shift.start + 50.minutes, 0)
    @worker_report.activities << create_activity(:logout, @worker, @shift.end + 5.minutes)
    @worker_report.generate_messages

    assert_equal 'logged in 17 minutes too late', @worker_report.messages[0]
    assert_equal 'didn\'t answer call at ' + (@shift.start + 20.minutes).to_s, @worker_report.messages[1]
    assert_equal 'didn\'t answer call at ' + (@shift.start + 50.minutes).to_s, @worker_report.messages[2]
  end
end

# Represents the report for a single worker
class WorkerReport
  attr_accessor :worker
  attr_accessor :activities
  attr_accessor :shift
  attr_accessor :messages

  # In minutes
  ALLOWED_LOGIN_DELAY = 10

  # In minutes
  ALLOWED_CALL_DELAY = 3

  def initialize(worker = nil, activities = [], shift = nil, messages = [])
    @worker = worker
    @activities = activities
    @shift = shift
    @messages = messages
  end

  # Used for finding the partial
  def to_partial_path
    'shared/worker_report'
  end

  def add_late_login(minutes, time)
    @messages << WorkerReport.format_late_login(minutes, time)
  end

  def add_unreceived_call(time)
    @messages << WorkerReport.format_unreceived_call(time)
  end

  def add_unanswered_call(time)
    @messages << WorkerReport.format_unanswered_call(time)
  end

  # Returns when the worker logged in based on the worker's
  #  activities in the shift. If the first activity isn't a login activity
  #  the method returns the start of the shift. If the first acitvity
  #  is a login activity, it returns its time.
  def login_time
    @activities.first.login? ? @activities.first.created_at : @shift.start
  end

  # Returns the login delay in minutes
  def login_delay
    ((login_time - @shift.start) / 60).floor
  end

  def next_call(last_call_time)
    next_call_upper_range = last_call_time + @shift.call_interval.minutes
    next_call_upper_range += ALLOWED_CALL_DELAY.minutes

    @activities.select do |a|
      a.created_at > last_call_time \
      && a.created_at < next_call_upper_range \
      && a.call?
    end.first
  end

  def handle_call(call, last_call_time)
    if call.nil?
      add_unreceived_call(last_call_time + @shift.call_interval.minutes)
      last_call_time += @shift.call_interval.minutes
    else
      add_unanswered_call(call.created_at) if call.time_left <= 0
      last_call_time = call.created_at
    end

    last_call_time
  end

  def generate_messages
    last_call_time = login_time
    add_late_login(login_delay, login_time) if login_delay > ALLOWED_LOGIN_DELAY

    while last_call_time + @shift.call_interval.minutes < @shift.end
      call = next_call(last_call_time)
      last_call_time = handle_call(call, last_call_time)
    end
  end

  def self.format_time(time)
    time.localtime.strftime '%H:%M'
  end

  def self.format_late_login(minutes, time)
    format_time(time) + ': ' + I18n.t('worker_report.late_login',
                                      minutes: minutes.to_s)
  end

  def self.format_unreceived_call(time)
    format_time(time) + ': ' + I18n.t('worker_report.unreceived_call')
  end

  def self.format_unanswered_call(time)
    format_time(time) + ': ' + I18n.t('worker_report.unanswered_call')
  end
end

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

  def add_late_login(minutes)
    @messages << 'logged in ' + minutes.to_s + ' minutes too late'
  end

  def add_unreceived_call(time)
    @messages << 'unreceived call around ' + time.localtime.to_s
  end

  def add_unanswered_call(time)
    @messages << 'didn\'t answer call at ' + time.localtime.to_s
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
    @activities.select do |a|
      a.created_at > last_call_time \
      && a.created_at < last_call_time + 15.minutes + ALLOWED_CALL_DELAY
    end.first 
  end

  def generate_messages
    last_call_time = login_time
    add_late_login(login_delay) if login_delay > ALLOWED_LOGIN_DELAY

    while last_call_time + 15.minutes < @shift.end
      call = next_call(last_call_time)

      if call.nil?
        add_unreceived_call(last_call_time + 15.minutes)
        last_call_time += 15.minutes
      else
        add_unanswered_call(call.created_at) if call.time_left <= 0
        last_call_time = call.created_at
      end
    end
  end
end
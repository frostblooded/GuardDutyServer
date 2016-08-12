class WorkerReport
  attr_accessor :worker
  attr_accessor :activities
  attr_accessor :shift
  attr_accessor :messages

  def initialize(worker = nil, activities = [], shift = nil, messages = [])
    @worker = worker
    @activities = activities
    @shift = shift
    @messages = messages
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
    ((self.login_time - @shift.start) / 60).floor
  end

  def generate_messages
    next_expected_call = Time.new

    # If first activity isn't a login, then user must be logged in
    # If that is the case, start expecting calls from the beginning of the shift
    # Else start expecting from when the user logs in
    if @activities.first.login?
      # Get login delay in minutes
      login_delay = (@activities.first.created_at - @shift.start).floor / 60

      if login_delay > 10
        @messages << 'logged in ' + login_delay.to_s + ' minutes too late'
      end

      # TO DO: Actually call may appear exactly after login. Fix it.
      next_expected_call = @activities.first.created_at + 15.minutes
    else
      next_expected_call = @shift.start + 15.minutes
    end

    while next_expected_call < @shift.end
      # Give several minutes window for expected call
      expected_call = @activities.select do |a|
        a.created_at > next_expected_call - 5.minutes \
         && a.created_at < next_expected_call + 5.minutes
      end.first

      if expected_call.nil?
        @messages << 'unreceived call around ' + next_expected_call.localtime.to_s
      elsif expected_call.time_left <= 0
        @messages << 'didn\'t answer call at ' + next_expected_call.localtime.to_s
      end

      next_expected_call += 15.minutes
    end
  end
end
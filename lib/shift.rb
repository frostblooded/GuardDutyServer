class Shift
  attr_accessor :start
  attr_accessor :end
  attr_accessor :activities
  attr_accessor :site

  def initialize(shift_start = 0, shift_end = 0, activities = [], site = nil)
    @start = shift_start
    @end = shift_end
    @activities = activities
    @site = site
  end

  # Returns the workers, which participated in the shift
  #
  # NOTE: Only calls and logins (without logouts) are
  #  counted towards participation
  def workers
    relevant_ativities = @activities.select do |a|
      a.call? || a.login?
    end

    relevant_ativities.map(&:worker).uniq
  end

  def report
    shift_report = ShiftReport.new(@site)
    shift_report.site = @site

    self.workers.each do |w|
      worker_report = WorkerReport.new(w)
      worker_activities = @activities.select { |a| a.worker == w }
      next_expected_call = Time.new

      # If first activity isn't a login, then user must be logged in
      # If that is the case, start expecting calls from the beginning of the shift
      # Else start expecting from when the user logs in
      if worker_activities.first.login?
        # Get login delay in minutes
        login_delay = (worker_activities.first.created_at - @start).floor / 60

        if login_delay > 10
          worker_report.messages << 'logged in ' + login_delay.to_s + ' minutes too late'
        end

        # TO DO: Actually call may appear exactly after login. Fix it.
        next_expected_call = worker_activities.first.created_at + 15.minutes
      else
        next_expected_call = @start + 15.minutes
      end

      while next_expected_call < @end
        # Give several minutes window for expected call
        expected_call = worker_activities.select do |a|
          a.created_at > next_expected_call - 5.minutes \
           && a.created_at < next_expected_call + 5.minutes
        end.first

        if expected_call.nil?
          worker_report.messages << 'unreceived call around ' + next_expected_call.localtime.to_s
        elsif expected_call.time_left <= 0
          worker_report.messages << 'didn\'t answer call at ' + next_expected_call.localtime.to_s
        end

        next_expected_call += 15.minutes
      end

      shift_report.worker_reports << worker_report
    end

    shift_report
  end
end

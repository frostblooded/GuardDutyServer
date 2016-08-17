# Used when generating a report for a site's last shift
class Shift
  attr_accessor :start
  attr_accessor :end
  attr_accessor :call_interval
  attr_accessor :activities
  attr_accessor :site

  def initialize(shift_start = 0, shift_end = 0, site = nil, activities = [])
    @start = shift_start
    @end = shift_end
    @activities = activities
    @site = site
  end

  def call_interval
    @site.settings(:call).interval.to_i
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
    report = ShiftReport.new(@site, self)

    workers.each do |w|
      worker_activities = @activities.select { |a| a.worker == w }
      worker_report = WorkerReport.new(w, worker_activities, self)
      worker_report.generate_messages
      report.worker_reports << worker_report
    end

    report
  end
end

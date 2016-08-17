# Represents the report for a single shift
class ShiftReport
  attr_accessor :site
  attr_accessor :shift
  attr_accessor :worker_reports

  def initialize(site = nil, shift = nil, worker_reports = [])
    @site = site
    @shift = shift
    @worker_reports = worker_reports
  end

  # Used for finding the partial
  def to_partial_path
    'shared/shift_report'
  end

  def messages?
    worker_reports.each do |wr|
      return true unless wr.messages.empty?
    end

    false
  end
end

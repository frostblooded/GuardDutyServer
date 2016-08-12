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

  def has_messages?
    worker_reports.each do |wr|
      return true if !wr.messages.empty?
    end

    false
  end
end
class ShiftReport
  attr_accessor :site
  attr_accessor :shift
  attr_accessor :worker_reports

  def initialize(site = nil, shift = nil, worker_reports = [])
    @site = site
    @shift = shift
    @worker_reports = worker_reports
  end
end
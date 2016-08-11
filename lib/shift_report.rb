class ShiftReport
  attr_accessor :site
  attr_accessor :worker_reports

  def initialize(site = nil, worker_reports = [])
    @site = site
    @worker_reports = worker_reports
  end
end
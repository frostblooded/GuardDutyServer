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
end
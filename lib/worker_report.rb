class WorkerReport
  attr_accessor :worker
  attr_accessor :messages

  def initialize(worker = nil, messages = [])
    @worker = worker
    @messages = messages
  end
end
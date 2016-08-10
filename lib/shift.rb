class Shift
  attr_accessor :start
  attr_accessor :end
  attr_accessor :activities
  attr_accessor :site

  def initialize
    @start = 0
    @end = 0
    @activities = []
  end
end
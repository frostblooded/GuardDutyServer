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
end
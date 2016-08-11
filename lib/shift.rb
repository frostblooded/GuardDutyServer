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

    relevant_ativities.map { |a| a.worker }.uniq
  end
end
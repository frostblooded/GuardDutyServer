class Site < ActiveRecord::Base
  # has_and_belongs_to_many doesn't support dependent: :destroy,
  # so this is used
  before_destroy {workers.each {|w| w.destroy}}

  has_and_belongs_to_many :workers
  has_many :routes, dependent: :destroy
  belongs_to :company

  has_settings do |s|
    s.key :attached_worker, :defaults => { :name => ''}
    s.key :call, :defaults => { :interval => '15' }
    s.key :shift, :defaults => { :start => '12:00', :end => '13:00'}
  end

  validates :name, presence: true, length: { maximum: 40 }

  # Returns data about the last COMPLETED shift
  def last_shift
    shift_times = last_shift_times

    shift = Shift.new(shift_times[:start], shift_times[:end], self)
    shift.activities = Activity.where('created_at >= :shift_start AND created_at <= :shift_end',
      {shift_start: shift.start, shift_end: shift.end}).to_a

    shift
  end

  private
    # Return start and end of last COMPLETED shift in a hash
    # NOTE: This method assumes that there is only one shift per day
    def last_shift_times
      shift_times = Hash.new
      shift_end = Time.parse settings(:shift).end

      while shift_end > Time.now
        shift_end -= 1.day
      end

      shift_start = Time.parse settings(:shift).start

      while shift_start > shift_end
        shift_start -= 1.day
      end

      {start: shift_start, end: shift_end}
    end
end

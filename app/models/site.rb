# Represents a site
class Site < ActiveRecord::Base
  # has_and_belongs_to_many doesn't support dependent: :destroy,
  # so this is used
  before_destroy { workers.each(&:destroy) }

  # Apparently it is better to do this rather than making
  # has_and_belongs_to_many relationships like this as stated here
  has_many :site_worker_relations, dependent: :destroy
  has_many :workers, through: :site_worker_relations, dependent: :destroy

  has_many :routes, dependent: :destroy
  belongs_to :company

  has_settings do |s|
    s.key :attached_worker, defaults: { name: '' }
    s.key :call, defaults: { interval: '15' }
    s.key :shift, defaults: { start: '12:00', end: '13:00' }
  end

  validates :name, presence: true, length: { maximum: 40 }

  # Returns data about the last COMPLETED shift
  def last_shift
    shift_times = last_shift_times
    shift = Shift.new(shift_times[:start], shift_times[:end], self)

    workers.each do |w|
      shift.activities += w.activities.where 'created_at >= :shift_start
        AND created_at <= :shift_end', shift_start: shift.start,
                                       shift_end: shift.end
    end

    shift
  end

  private

  # Return start and end of last COMPLETED shift in a hash
  # NOTE: This method assumes that there is only one shift per day
  def last_shift_times
    shift_end = last_shift_end
    { start: last_shift_start(shift_end), end: shift_end }
  end

  def last_shift_start(shift_end)
    shift_start = Time.zone.parse settings(:shift).start
    shift_start -= 1.day while shift_start > shift_end
    shift_start
  end

  def last_shift_end
    shift_end = Time.zone.parse settings(:shift).end
    shift_end -= 1.day while shift_end > Time.zone.now
    shift_end
  end
end

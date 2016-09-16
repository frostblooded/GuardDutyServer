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

  store :settings, accessors: [ :call_interval, :shift_start, :shift_end ], coder: JSON

  validates :name, presence: true, length: { maximum: 40 },
                   # Name should be unique in this company
                   uniqueness: { scope: :company_id,
                                 message: I18n.t('name.not_unique') }

  before_create :initialize_site

  def initialize_site
    self.call_interval = '15'
    self.shift_start = '12:00'
    self.shift_end = '13:00'
  end

  # Returns data about the last COMPLETED shift
  def last_shift
    shift_times = last_shift_times
    shift = Shift.new(shift_times[:start], shift_times[:end], self)

    workers.each do |w|
      shift.activities += w.activities.where 'created_at >= :shift_start
        AND created_at <= :shift_end AND site_id = :site_id',
                                             shift_start: shift.start,
                                             shift_end: shift.end,
                                             site_id: id
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
    shift_start = Time.zone.parse self.shift_start
    shift_start -= 1.day while shift_start > shift_end
    shift_start
  end

  def last_shift_end
    shift_end = Time.zone.parse self.shift_end
    shift_end -= 1.day while shift_end > Time.zone.now
    shift_end
  end
end

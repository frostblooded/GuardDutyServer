class Site < ActiveRecord::Base
  # has_and_belongs_to_many doesn't support dependent: :destroy,
  # so this is used
  before_destroy {workers.each {|w| w.destroy}}

  has_and_belongs_to_many :workers
  has_many :routes, dependent: :destroy
  belongs_to :company

  has_settings :shift_start, :shift_end

  validates :name, presence: true, length: { maximum: 40 }
end

class Site < ActiveRecord::Base
  # has_and_belongs_to_many doesn't support dependent: :destroy,
  # so this is used
  before_destroy {workers.each {|w| w.destroy}}

  has_and_belongs_to_many :workers
  has_many :routes, dependent: :destroy
  has_many :devices, dependent: :destroy
  belongs_to :company

  validates :name, presence: true, length: { maximum: 40 }
end

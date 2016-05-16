class Site < ActiveRecord::Base
  has_and_belongs_to_many :workers
  has_many :routes
  has_many :devices
  belongs_to :company

  validates :name, presence: true, length: { maximum: 40 }
end

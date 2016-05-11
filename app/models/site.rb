class Site < ActiveRecord::Base
  has_many :workers
  belongs_to :company

  validates :name, presence: true, length: { maximum: 40 }
end

class Route < ActiveRecord::Base
  belongs_to :site
  has_many :positions

  validates :name, presence: true, length: { maximum: 40 }
end

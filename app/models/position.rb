class Position < ActiveRecord::Base
  belongs_to :route

  validates :index, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
end

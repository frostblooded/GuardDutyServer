# Represents a position
class Position < ActiveRecord::Base
  belongs_to :route

  validates :index, presence: true, numericality: true
  validates :latitude, presence: true, numericality: true
  validates :longitude, presence: true, numericality: true
end

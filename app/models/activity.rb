# Represents an activity, which is used to make a history feed
# for a worker
class Activity < ActiveRecord::Base
  belongs_to :worker

  enum category: [:call, :login, :logout]

  # Used for showing the activity in the worker page
  attr_accessor :row_class

  validates :time_left, numericality: true, allow_nil: true
  validates :site, presence: true
end

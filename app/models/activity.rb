# Represents an activity, which is used to make a history feed
# for a worker
class Activity < ActiveRecord::Base
  belongs_to :worker
  belongs_to :site

  enum category: [:call, :login, :logout]

  # Used for showing the activity in the worker page
  attr_accessor :row_class

  validates :time_left, numericality: true, presence: true, if: :call?
  validates :site, presence: true
  validates :worker, presence: true
  validate :worker_belongs_to_site

  def worker_belongs_to_site
    if site and !site.workers.include? worker
      errors.add(:worker, 'doesn\'t belong to site')
    end
  end
end

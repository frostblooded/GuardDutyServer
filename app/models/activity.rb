class Activity < ActiveRecord::Base
  belongs_to :worker

  enum category: [:call, :login, :logout]

  # Used for showing the activity in the worker page
  attr_accessor :row_class
end

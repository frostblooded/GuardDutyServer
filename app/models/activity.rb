class Activity < ActiveRecord::Base
  belongs_to :worker

  enum category: [:call, :login, :logout]
end

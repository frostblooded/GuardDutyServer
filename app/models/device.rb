class Device < ActiveRecord::Base
  # Validation for length automatically
  # validates for presence too
  validates :token, length: { is: 30 }
end

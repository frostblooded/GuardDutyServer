class Device < ActiveRecord::Base
  validates :token, length: { is: 30 }, presence: true
end

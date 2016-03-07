class Device < ActiveRecord::Base
  validates :token, length: { is: 152 }, presence: true
end

class Worker < ActiveRecord::Base
  validates :first_name, presence: true,	length: { maximum: 40 }
  validates :last_name,	presence: true,	length: { maximum: 40 }
  belongs_to :company
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }
end
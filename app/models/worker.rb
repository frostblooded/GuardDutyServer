class Worker < ActiveRecord::Base
<<<<<<< HEAD
  validates :first_name, presence: true,	length: { maximum: 40 }
	validates :last_name,	presence: true,	length: { maximum: 40 }
	has_secure_password
	validates :password, presence: true, length: { minimum: 8 }
=======
  validates :first_name,	presence: true,	length: { maximum: 40}
  validates :last_name,		presence: true,	length: { maximum: 40}
>>>>>>> 2529521d4bf1adf870d89163a681011579475cf6
end

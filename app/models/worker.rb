class Worker < ActiveRecord::Base
  belongs_to :site
  has_one :device
  has_many :calls

  validates :first_name, presence: true,	length: { maximum: 40 }
  validates :last_name,	presence: true,	length: { maximum: 40 }
  validates :password, presence: true, length: { minimum: 8 }
  has_secure_password

  before_save :lowercase_names

  def lowercase_names
    self.first_name = self.first_name.downcase
    self.last_name = self.last_name.downcase
  end
end
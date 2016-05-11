class Worker < ActiveRecord::Base
  belongs_to :site
  has_one :device
  has_many :calls

  validates :name, presence: true,	length: { maximum: 40 }
  validates :password, presence: true, length: { minimum: 8 }
  has_secure_password

  before_save :lowercase_names

  def lowercase_names
    self.name = self.name.downcase
  end
end
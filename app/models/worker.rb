class Worker < ActiveRecord::Base
  has_and_belongs_to_many :sites
  belongs_to :company
  has_many :activities, dependent: :destroy

  validates :name, presence: true,	length: { maximum: 40 }
  validates :password, presence: true, length: { minimum: 8 }
  has_secure_password

  before_save :lowercase_names

  def lowercase_names
    self.name = self.name.downcase
  end
end
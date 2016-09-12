# Represents a worker
class Worker < ActiveRecord::Base
  # Apparently it is better to do this rather than making
  # has_and_belongs_to_many relationships like this as stated here
  has_many :site_worker_relations, dependent: :destroy
  has_many :sites, through: :site_worker_relations, dependent: :destroy

  has_many :activities, dependent: :destroy
  belongs_to :company

  validates :name, presence: true,	length: { maximum: 40 },
                   # Name should be unique in this company
                   uniqueness: { scope: :company_id,
                                 message: t 'name.not_unique' }
  validates :password, presence: true, length: { minimum: 8 },
                       if: :password_changed?
  has_secure_password

  private

  def password_changed?
    !@password.blank? || password_digest.blank?
  end
end

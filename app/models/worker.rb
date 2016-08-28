# Represents a worker
class Worker < ActiveRecord::Base
  # Apparently it is better to do this rather than making
  # has_and_belongs_to_many relationships like this as stated here
  has_many :site_worker_relations, dependent: :destroy
  has_many :sites, through: :site_worker_relations, dependent: :destroy

  has_many :activities, dependent: :destroy
  belongs_to :company

  validates :name, presence: true,	length: { maximum: 40 }
  validate :name_unique_in_company
  validates :password, presence: true, length: { minimum: 8 }
  has_secure_password

  before_save :lowercase_names

  def lowercase_names
    self.name = name.downcase
  end

  def name_unique_in_company
    if company
      # Yes, indeed, I am making another variable
      # which on first sight looks identical to the
      # company reference, which the worker has, but
      # for some god damn reason, you can not get all
      # of the company's workers if you use
      # the normal reference(company) so I had to get
      # it by finding the company by using the reference's id...........
      # Atleast I finally fucking got it to work...
      # Fuck this
      com = Company.find company.id
      names = []

      com.workers.each do |w|
        names << w.name if w.id != self.id
      end

      if names.include? self.name
        errors.add(:name, 'not unique in company')
      end
    end
  end
end

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
                                 message: I18n.t('name.not_unique') }
  validates :password, presence: true, length: { minimum: 8 },
                       if: :password_changed?
  validates_numericality_of :trust_score, greater_than_or_equal_to: 0.0,
                                          less_than_or_equal_to: 100.0
  has_secure_password

  def calculate_trust_score
    calls = self.activities.select { |a| a.call? }
    good_calls = calls.count { |c| c.time_left > 0 }

    if calls.count == 0
      100.0
    else
      100 * good_calls / calls.count
    end
  end

  private

  def password_changed?
    !@password.blank? || password_digest.blank?
  end
end

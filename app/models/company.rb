# Represents a company
class Company < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  has_many :sites, dependent: :destroy
  has_many :workers, dependent: :destroy
  has_one :api_key, dependent: :destroy

  has_settings do |s|
    s.key :email, defaults: { wanted: false, time: '12:00' }
  end

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :name, presence: true, length: { maximum: 50 },
                   uniqueness: true
  validates :email, presence: true, uniqueness: true,
                    format: { with: VALID_EMAIL_REGEX }

  before_save :lowercase_name
  before_create :initialize_company

  def lowercase_name
    @name = name.downcase
  end

  def initialize_company
    @last_mail_sent_at = Time.zone.now
  end

  # Documentation says email_required? and email_changed?
  # should be implemented as follows:
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def send_report_email
    CompanyNotifier.report_email(self).deliver_now
  end
end

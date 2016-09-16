# Represents a company
class Company < ActiveRecord::Base
  has_many :sites, dependent: :destroy
  has_many :workers, dependent: :destroy
  has_one :api_key, dependent: :destroy

  store :settings, accessors: [ :recipients, :email_wanted, :email_time ], coder: JSON

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :name, presence: true, length: { maximum: 50 },
                   uniqueness: true
  validates :email, presence: true, uniqueness: true,
                    format: { with: Rails.application.config.email_regex }

  before_create :initialize_company

  def initialize_company
    @last_mail_sent_at = Time.zone.now
    self.recipients = [email]
    self.email_wanted = false
    self.email_time = '12:00'
  end

  # Devise documentation says email_required? and email_changed?
  # should be implemented as follows:
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def send_report_email
    self.recipients.each do |r|
      CompanyNotifier.report_email(self, r).deliver_now
    end
  end
end

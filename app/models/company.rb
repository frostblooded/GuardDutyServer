# Represents a company
class Company < ActiveRecord::Base
  has_many :sites, dependent: :destroy
  has_many :workers, dependent: :destroy
  has_one :api_key, dependent: :destroy

  # Use JSON for storing recipients, because  I couldn't get the database
  # to store an array otherwise
  store :settings, accessors: [:recipients], coder: JSON

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :name, presence: true, length: { maximum: 50 },
                   uniqueness: true
  validates :email, presence: true, uniqueness: true,
                    format: { with: Rails.application.config.email_regex }
  validate :recipients_is_not_nil
  # Validate email_wanted is boolean
  validates :email_wanted, inclusion: { in: [true, false] }
  validates :email_time, presence: true,
                         format: { with: Rails.application.config.time_regex }

  before_validation :initialize_company, on: :create

  def initialize_company
    self.last_mail_sent_at = Time.zone.now
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
    recipients.each do |r|
      CompanyNotifier.report_email(self, r).deliver_now
    end
  end

  private

  def recipients_is_not_nil
    errors.add :recipients, 'can not be nil' if recipients.nil?
  end
end

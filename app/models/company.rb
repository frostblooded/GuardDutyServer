class Company < ActiveRecord::Base
  has_many :sites, dependent: :destroy
  has_many :workers, dependent: :destroy
  has_one :api_key, dependent: :destroy

  has_settings do |s|
    s.key :mail, defaults: { daily: false, additional: '' , time: '12:00'}
  end
  
  enum role: [ :logged_in, :logged_out ]  

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  validates :name, presence: true, length: { maximum: 50},
                           uniqueness: true

  validates_confirmation_of :password
  before_save :lowercase_name
  before_create :initialize_company

  def lowercase_name
    self.name = self.name.downcase
  end

  def initialize_company
    self.last_mail_sent_at = Time.now
  end

  # Documentation says email_required? and email_changed? should be implemented as follows:
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def send_report_mail
    CompanyNotifier.sample_email(self).deliver_now
  end

  def send_report_mail_additional_email
    CompanyNotifier.additional_email(self).deliver_now
  end

  # Tasks executed by cron job

  # Returns if the time has come to send a mail
  # This is determined based on if the time at which the company has said that it should receive a mail
  # has come and by checking if the last time a mail was sent was today
  def should_send_mail
    Time.parse(settings(:mail).time) < Time.now && Time.now.day != last_mail_sent_at.day
  end

  def check_mail_status
    if settings(:mail).daily && should_send_mail
      send_report_mail
      update(last_mail_sent_at: Time.now)

      puts 'Sending mail to ' + self.inspect
    else
      puts 'Not sending mail...'
    end
  end
end

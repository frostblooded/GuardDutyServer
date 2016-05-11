class Company < ActiveRecord::Base
  has_many :sites
  has_many :workers
  has_one :api_key, dependent: :destroy
  has_settings :daily_mail
  
  enum role: [ :logged_in, :logged_out ]  

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  validates :company_name, presence: true, length: { maximum: 50},
                           uniqueness: true

  validates_confirmation_of :password
  before_save :lowercase_name

  def lowercase_name
    self.company_name = self.company_name.downcase
  end

  # Documentation says email_required? and email_changed? should be implemented as follows:
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def send_report_mail
    CompanyNotifier.sample_email(self).deliver
  end
end

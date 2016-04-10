class Company < ActiveRecord::Base
  has_many :workers
  enum role: [ :logged_in, :logged_out ]  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :company_name, presence: true, length: { maximum: 50},
                           uniqueness: true
  after_create :send_admin_mail
  # Documentation says email_required? and email_changed? should be implemented as follows:
  def email_required?
    false
  end

  def send_admin_mail
  end

  def email_changed?
    false
  end
end

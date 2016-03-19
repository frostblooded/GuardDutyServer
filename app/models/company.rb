class Company < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :companies
  # Documentation says email_required? and email_changed? should be implemented as follows:
  def email_required?
    false
  end

  def email_changed?
    false
  end
end

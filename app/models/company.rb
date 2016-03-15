class Company < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :company_name

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:company_name)
    where(conditions).where(["lower(company_name) = :value", { :value => login.downcase }]).first
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end
end

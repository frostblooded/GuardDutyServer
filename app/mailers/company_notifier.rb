class CompanyNotifier < ApplicationMailer
  default :from => 'ihzahariev@gmail.com'

  def send_signup_email(company) #Just trying to see how sending an email works 
    @company = company 
    mail( :to => @company.email,
      :subject => 'Thanks for signing up for our amazing app' )
  end
end

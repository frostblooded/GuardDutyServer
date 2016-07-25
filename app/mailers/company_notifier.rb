class CompanyNotifier < ApplicationMailer
  default :from => 'attendancecheck1337@gmail.com'

  def sample_email(company)
    @company = company
    mail(to: @company.email, subject: "Worker's report")
  end

  def second_email(email)
  	@email = email
  	mail(to: @email, subject: "Worker's report")
   end 
end

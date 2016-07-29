class CompanyNotifier < ApplicationMailer
  default :from => 'attendancecheck1337@gmail.com'

  def sample_email(company)
    @company = company
    mail(to: @company.email, subject: "Worker's report")
  end

  def additional_email(company)
  	@company = company
  	@reciever = @company.settings(:mail).additional
  	mail(to: @reciever, subject: "Worker's report")
   end 
end

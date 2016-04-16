class CompanyNotifier < ApplicationMailer
  default :from => 'attendancecheck1337@gmail.com'

  def sample_email(company)
    hash_yes = {"YesOrNoButton"=>"Yes"}  #Somewhere here is the problem ......
    hash_no = {"YesOrNoButton"=>"No"}   #Somewhere here is the problem ......
    if @company_daily_mail == hash_yes    #Somewhere here is the problem ......
      @company = company
      mail(to: @company.email, subject: "Worker's report")
    elsif @company_daily_mail == hash_no
      @company = company
      mail(to: @company.email, subject: "Something")
    end
  end  
end

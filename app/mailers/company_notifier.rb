class CompanyNotifier < ApplicationMailer
  default :from => 'ihzahariev@gmail.com'


  def sample_email(company)
    @company = company
    mail(to: @company.email, subject: 'Sample Email')
  end
end

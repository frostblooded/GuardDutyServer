class CompanyNotifier < ApplicationMailer
  default :from => 'attendancecheck1337@gmail.com'

  def report_email(company)
    @company = company

    # The reports are stored in a variable, so that a new report
    #  isn't made every time the report needs to be accessed
    #  (through the last_shift methods of Site)
    @shift_reports = @company.sites.map { |site| site.last_shift.report }

    mail(to: @company.email, subject: "Worker's report")
  end
end

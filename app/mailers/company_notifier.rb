# Manages the company notifier emails' actions
class CompanyNotifier < ApplicationMailer
  def report_email(company, email = company.email)
    I18n.with_locale(company.report_locale) do
      @company = company

      # The reports are stored in a variable, so that a new report
      #  isn't made every time the report needs to be accessed
      #  (through the last_shift methods of Site)
      @shift_reports = @company.sites.map { |site| site.last_shift.report }

      mail to: email, subject: t('report.subject')
    end
  end
end

# Preview all emails at http://localhost:3000/rails/mailers/company_notifier
class CompanyNotifierPreview < ActionMailer::Preview
  def company_notice
    CompanyNotifier.report_email(Company.first)
  end
end

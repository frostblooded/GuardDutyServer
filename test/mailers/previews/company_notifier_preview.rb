# Preview all emails at http://localhost:3000/rails/mailers/company_notifier
class CompanyNotifierPreview < ActionMailer::Preview
  def company_notifier_preview
    CompanyNotifier.sample_email(Company.first)
  end
end

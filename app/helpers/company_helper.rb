module CompanyHelper
  module_function
    def send_report_mail
      Company.all.each do |c|
        CompanyNotifier.sample_email(c).deliver
      end
    end
end

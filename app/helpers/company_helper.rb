module CompanyHelper
  module_function
    def send_report_mail
      Company.all.each { |c| c.send_report_mail }
    end

    def send_report_mail_additional_email
      Company.all.each { |c| c.send_report_mail_additional_email }
    end
end

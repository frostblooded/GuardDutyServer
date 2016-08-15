module CompanyHelper
  module_function
    def send_report_mail
      Company.all.each { |c| c.send_report_mail }
    end

    def send_report_mail_additional_email
      Company.all.each { |c| c.send_report_mail_additional_email }
    end

    def check_mails_status
      Company.all.each { |c| c.check_mail_status }
    end
end

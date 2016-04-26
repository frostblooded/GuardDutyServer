module CompanyHelper
  module_function
    def send_report_mail
      Company.all.each { |c| c.send_report_mail }
    end
end

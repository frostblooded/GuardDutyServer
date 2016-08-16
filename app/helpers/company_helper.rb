module CompanyHelper
  module_function
    def check_mails_status
      Company.all.each { |c| CompanyHelper.check_report_status(c) }
    end

    # Returns if the time has come to send a mail
    # This is determined based on if the time at which the company has said that it should receive a mail
    # has come and by checking if the last time a mail was sent was today
    def should_send_report(company)
      Time.parse(company.settings(:email).time) < Time.now && Time.now.day != company.last_mail_sent_at.day
    end

    def check_report_status(company)
      if company.settings(:email).daily && CompanyHelper.should_send_report(company)
        company.send_report_email
        company.update(last_mail_sent_at: Time.now)

        puts 'Sending mail to ' + company.email
      else
        puts 'Not sending mail...'
      end
    end
end

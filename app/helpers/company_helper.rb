module CompanyHelper
  module_function
    def send_report_mail
      Company.all.each { |c| c.send_report_mail }
    end

    def send_report_mail_additional_email
      Company.all.each { |c| c.send_report_mail_additional_email }
    end

    def check_mails_status
      Company.all.each { |c| CompanyHelper.check_mail_status(c) }
    end

    # Returns if the time has come to send a mail
    # This is determined based on if the time at which the company has said that it should receive a mail
    # has come and by checking if the last time a mail was sent was today
    def should_send_mail(company)
      Time.parse(company.settings(:mail).time) < Time.now && Time.now.day != company.last_mail_sent_at.day
    end

    def check_mail_status(company)
      if company.settings(:mail).daily && CompanyHelper.should_send_mail(company)
        company.send_report_mail
        company.update(last_mail_sent_at: Time.now)

        puts 'Sending mail to ' + company.email
      else
        puts 'Not sending mail...'
      end
    end
end

# Contains helpers for companies
module CompanyHelper
  module_function

  def check_mails_status
    Company.all.each { |c| CompanyHelper.check_report_status(c) }
  end

  # Returns if the time has come to send a mail
  # This is determined based on if the time at which the company
  # has said that it should receive a mail has come and by checking
  # if the last time a mail was sent was today
  def should_send_report(company)
    Time.zone.parse(company.settings(:email).time) < Time.zone.now \
    && Time.zone.now.day != company.last_mail_sent_at.day
  end

  def check_report_status(company)
    if company.settings(:email).daily \
      && CompanyHelper.should_send_report(company)
      company.send_report_email
      company.update(last_mail_sent_at: Time.zone.now)

      Rails.logger.info 'Sending mail to ' + company.email
    end
  end
end

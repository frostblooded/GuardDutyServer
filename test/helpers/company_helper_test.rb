require 'test_helper'

class CompanyHelperTest < ActiveSupport::TestCase
  def setup
    @company = create(:company)
    @company.email_time = '12:00'
    @company.email_wanted = true
    @company.recipients = ['frostblooded@example.org',
                           'ivan@example.org']
    @company.save!
  end

  test 'mail is sent when it should be' do
    Timecop.freeze(Time.parse('13:00')) do
      @company.update(last_mail_sent_at: Time.zone.now - 1.day)
      CompanyHelper.check_mails_status
      assert mail_is_sent?(@company.recipients.first)
    end
  end

  test 'mail isn\'t sent when it shouldn\'t be' do
    Timecop.freeze(Time.parse('13:00')) do
      @company.update(last_mail_sent_at: Time.zone.now)
      CompanyHelper.check_mails_status
      assert_not mail_is_sent?(@company.recipients.first)
    end
  end

  test 'mails are sent to all recipients' do
    Timecop.freeze(Time.parse('13:00')) do
      @company.update(last_mail_sent_at: Time.zone.now - 1.day)
      CompanyHelper.check_mails_status
      assert mails_are_sent?(@company.recipients)
    end
  end
end

require 'test_helper'

class CompanyHelperTest < ActiveSupport::TestCase
  def setup
    @company = create(:company)
    @company.settings(:email).time = '12:00'
    @company.settings(:email).daily = true
    @company.settings(:email).recipients = ['frostblooded@example.org', 'ivan@example.org']
  end

  test 'mail is sent when it should be' do
    Timecop.freeze(Time.zone.parse('13:00')) do
      @company.update(last_mail_sent_at: Time.zone.now - 1.day)
      CompanyHelper.check_mails_status
      assert mail_is_sent?(@company.settings(:email).recipients.first)
    end
  end

  test 'mail isn\'t sent when it shouldn\'t be' do
    Timecop.freeze(Time.zone.parse('13:00')) do
      @company.update(last_mail_sent_at: Time.zone.now)
      CompanyHelper.check_mails_status
      assert_not mail_is_sent?(@company.settings(:email).recipients.first)
    end
  end

  test 'mails are sent to all recipients' do
    Timecop.freeze(Time.zone.parse('13:00')) do
      @company.update(last_mail_sent_at: Time.zone.now - 1.day)
      CompanyHelper.check_mails_status
      assert mails_are_sent?(@company.settings(:email).recipients)
    end
  end
end

require 'test_helper'

class CompanyHelperTest < ActiveSupport::TestCase
  def setup
    @company = create(:company)
    @company.settings(:mail).time = '12:00'
    @company.settings(:mail).daily = true
  end

  def mail_is_sent(company)
    mail = ActionMailer::Base.deliveries.last
    !mail.nil? && company.email == mail['to'].to_s
  end

  test 'mail is sent when it should be' do
    Timecop.freeze(Time.parse('13:00')) do
      @company.update(last_mail_sent_at: Time.now - 1.day)
      CompanyHelper.check_mails_status
      assert mail_is_sent(@company)
    end
  end

  test 'mail isn\'t sent when it shouldn\'t be' do
    Timecop.freeze(Time.parse('13:00')) do
      @company.update(last_mail_sent_at: Time.now)
      CompanyHelper.check_mails_status
      assert_not mail_is_sent(@company)
    end
  end
end

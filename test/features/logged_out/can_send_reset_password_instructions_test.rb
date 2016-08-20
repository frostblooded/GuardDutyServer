require 'test_helper'

class CanSendResetPasswordInstructionsTest < Capybara::Rails::TestCase
  def setup
    @company = create(:company)
    visit new_company_password_path
  end

  test 'sends successfully' do
    fill_in 'company_email', with: @company.email
    click_button 'Send me reset password instructions'

    assert_content page, 'You will receive an email with instructions' \
    ' on how to reset your password in a few minutes.'
    assert mail_is_sent?(@company)
  end

  test 'returns error on nonexistent email' do
    fill_in 'company_email', with: @company.email + 'a'
    click_button 'Send me reset password instructions'

    assert_content page, 'Email not found'
    assert_not mail_is_sent?(@company)
  end
end

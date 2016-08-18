require 'test_helper'

class CanResendConfirmationInstructionsTest < Capybara::Rails::TestCase
  def setup
    @company = create(:company)

    # Make company not confirmed
    @company.update(confirmed_at: nil)
  end

  test 'send confirmation instuctions' do
    visit new_company_confirmation_path
    fill_in 'company_email', with: @company.email
    click_button 'Resend confirmation instructions'

    assert mail_is_sent?(@company)
    assert_content page, 'You will receive an email with instructions for' \
                         ' how to confirm your email address in a few minutes'
  end

  test 'send confirmation instuctions to confirmed company' do
    @company.update(confirmed_at: Time.zone.now)

    visit new_company_confirmation_path
    fill_in 'company_email', with: @company.email
    click_button 'Resend confirmation instructions'

    assert_not mail_is_sent?(@company)
    assert_content page, 'Email was already confirmed, please try signing in'
  end

  test 'login link opens login' do
    visit new_company_confirmation_path
    click_link 'Log in'
    assert_equal new_company_session_path, current_path
  end

  test 'sign up link opens sign up' do
    visit new_company_confirmation_path
    click_link 'Log in'
    assert_equal new_company_session_path, current_path
  end

  test 'password reset link opens password reset' do
    visit new_company_confirmation_path
    click_link 'Forgot your password?'
    assert_equal new_company_password_path, current_path
  end
end

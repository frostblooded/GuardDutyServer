require 'test_helper'

class CanResendConfirmationInstructionsTest < Capybara::Rails::TestCase
  def setup
    # Get not confirmed company
    @company = create(:company)
    @company.update(confirmed_at: nil)

    visit new_company_confirmation_path
  end

  test 'sends successfully' do
    fill_in 'company_email', with: @company.email
    click_button 'Resend'

    assert mail_is_sent?(@company.email)
    assert_text 'You will receive an email with instructions for' \
                         ' how to confirm your email address in a few minutes'
    assert_equal new_company_session_path, current_path
  end

  test 'shows error on confirmed email' do
    @company.update(confirmed_at: Time.zone.now)

    fill_in 'company_email', with: @company.email
    click_button 'Resend'

    assert_not mail_is_sent?(@company.email)
    assert_text 'Company email was already confirmed, please try signing in'
    assert_equal company_confirmation_path, current_path
  end

  test 'shows error on nonexistent email' do
    fill_in 'company_email', with: @company.email + 'a'
    click_button 'Resend'

    assert_not mail_is_sent?(@company.email)
    assert_text 'Company email not found'
    assert_equal company_confirmation_path, current_path
  end

  test 'shows error in empty form' do
    click_button 'Resend'

    assert_equal company_confirmation_path, current_path
    assert_text 'Company email can\'t be blank'
  end
end

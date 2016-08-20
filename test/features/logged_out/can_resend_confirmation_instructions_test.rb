require 'test_helper'

class CanResendConfirmationInstructionsTest < Capybara::Rails::TestCase
  def setup
    @company = create(:company)

    # Make company not confirmed
    @company.update(confirmed_at: nil)
  end

  test 'sends successfully' do
    visit new_company_confirmation_path
    fill_in 'company_email', with: @company.email
    click_button 'Resend confirmation instructions'

    assert mail_is_sent?(@company)
    assert_content page, 'You will receive an email with instructions for' \
                         ' how to confirm your email address in a few minutes'
  end

  test 'returns error on confirmed email' do
    @company.update(confirmed_at: Time.zone.now)

    visit new_company_confirmation_path
    fill_in 'company_email', with: @company.email
    click_button 'Resend confirmation instructions'

    assert_not mail_is_sent?(@company)
    assert_content page, 'Email was already confirmed, please try signing in'
  end

  test 'returns error on nonexistent email' do
    visit new_company_confirmation_path
    fill_in 'company_email', with: @company.email + 'a'
    click_button 'Resend confirmation instructions'

    assert_not mail_is_sent?(@company)
    assert_content page, 'Email not found'
  end
end

require 'test_helper'

class CanSendResetPasswordInstructionsTest < Capybara::Rails::TestCase
  def setup
    @company = create(:company)
    visit new_company_password_path
  end

  test 'sends successfully' do
    fill_in 'company_email', with: @company.email
    click_button 'Reset'

    assert_text 'You will receive an email with instructions' \
    ' on how to reset your password in a few minutes.'
    assert mail_is_sent?(@company.email)
    assert_equal new_company_session_path, current_path
  end

  test 'shows error on nonexistent email' do
    fill_in 'company_email', with: @company.email + 'a'
    click_button 'Reset'

    assert_text 'Email not found'
    assert_not mail_is_sent?(@company.email)
    assert_equal company_password_path, current_path
  end

  test 'shows error in empty form' do
    click_button 'Reset'

    assert_equal company_password_path, current_path
    assert_text 'Email can\'t be blank'
  end
end

require 'test_helper'

class CanSignInTest < Capybara::Rails::TestCase
  def setup
    @company_password = 'foobarrr'

    @company = create(:company)
    @company.update(password: @company_password)

    visit new_company_session_path
  end

  test 'can sign in' do
    fill_in 'company_name', with: @company.name
    fill_in 'company_password', with: @company_password
    click_button 'Sign in'

    assert_content page, 'Signed in successfully'
  end

  test 'shows error on non-matching name and password' do
    fill_in 'company_name', with: @company.name
    fill_in 'company_password', with: @company_password * 3
    click_button 'Sign in'

    assert_content page, 'Invalid Name or password'
  end

  test 'reset password instruction link opens reset password instructions' do
    click_link 'Forgot your password?'
    assert_equal new_company_password_path, current_path
  end

  test 'resend mail confirmation link opens resend mail confirmation' do
    click_link 'Didn\'t receive confirmation instructions?'
    assert_equal new_company_confirmation_path, current_path
  end
end

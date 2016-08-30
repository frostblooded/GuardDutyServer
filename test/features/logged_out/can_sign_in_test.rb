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

    assert_text 'Signed in successfully'
    assert_equal root_path, current_path
  end

  test 'shows error on non-matching name and password' do
    fill_in 'company_name', with: @company.name
    fill_in 'company_password', with: @company_password * 3
    click_button 'Sign in'

    assert_text 'Invalid Name or password'
    assert_equal new_company_session_path, current_path
  end

  test 'has correct links' do
    assert_text 'Forgot your password?'
    assert_text 'Didn\'t receive confirmation instructions?'
  end
end

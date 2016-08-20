require 'test_helper'

class CanSignInTest < Capybara::Rails::TestCase
  def setup
    @company_password = 'foobarrr'

    @company = create(:company)
    @company.update(password: @company_password)
  end

  test 'can sign in' do
    visit new_company_session_path

    fill_in 'company_name', with: @company.name
    fill_in 'company_password', with: @company_password
    click_button 'Log in'

    assert_content page, 'Signed in successfully'
  end

  test 'shows error on non-matching name and password' do
    visit new_company_session_path

    fill_in 'company_name', with: @company.name
    fill_in 'company_password', with: @company_password * 3
    click_button 'Log in'

    assert_content page, 'Invalid Name or password'
  end
end

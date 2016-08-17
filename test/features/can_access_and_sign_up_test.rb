require 'test_helper'

class CanAccessAndSignUpTest < Capybara::Rails::TestCase
  test 'can access sign up' do
    visit new_company_registration_path
    assert_content page, 'Password confirmation (8 characters minimum)'
  end

  test 'can sign up' do
    visit new_company_registration_path

    fill_in 'company_name', with: 'SomeRandomNameKappa'
    fill_in 'company_email', with: 'somerandommail@example.org'
    fill_in 'company_password', with: 'foobarrr'
    fill_in 'company_password_confirmation', with: 'foobarrr'
    click_button 'Sign up'

    assert_content page, 'A message with a confirmation link has been sent'
  end
end

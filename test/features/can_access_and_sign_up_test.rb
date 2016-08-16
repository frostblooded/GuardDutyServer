require "test_helper"

class CanAccessAndSignUpTest < Capybara::Rails::TestCase
  test "canAccessSignUp" do
    visit new_company_registration_path
    assert_content page, 'Password confirmation (8 characters minimum)'
  end

 # test "canActuallyLogin" do
 #    visit new_company_session_path

 #    fill_in 'Name', with: 'SomeRandomNameKappa'
 #    fill_in 'Email', with: 'somerandommail@example.org'
 #    fill_in 'Password', with: 'foobarbarbar'
 #    fill_in 'Password confirmation', with: 'foobarbarbar'
 #    click_button 'Sign up'

 #    assert_content page,  'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
 #  end
end

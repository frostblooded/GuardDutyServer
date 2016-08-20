require 'test_helper'

class CanSignUpTest < Capybara::Rails::TestCase
  def setup
    @company = create(:company)
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

  test 'shows error on empty fields' do
    visit new_company_registration_path
    click_button 'Sign up'

    assert_content page, 'Password can\'t be blank'
    assert_content page, 'Name can\'t be blank'
    assert_content page, 'Email can\'t be blank'
  end

  test 'shows error on non-matching password fields' do
    visit new_company_registration_path

    fill_in 'company_name', with: 'SomeRandomNameKappa'
    fill_in 'company_email', with: 'somerandommail@example.org'
    fill_in 'company_password', with: 'foobarrr'
    fill_in 'company_password_confirmation', with: 'foobarrrr'
    click_button 'Sign up'

    assert_content page, 'Password confirmation doesn\'t match Password'
  end

  test 'shows error on non-unique name and email' do
    visit new_company_registration_path

    fill_in 'company_name', with: @company.name
    fill_in 'company_email', with: @company.email
    fill_in 'company_password', with: 'foobarrr'
    fill_in 'company_password_confirmation', with: 'foobarrrr'
    click_button 'Sign up'

    assert_content page, 'Name has already been taken'
    assert_content page, 'Email has already been taken'
  end
end

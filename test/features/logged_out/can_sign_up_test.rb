require 'test_helper'

class CanSignUpTest < Capybara::Rails::TestCase
  def setup
    @company = create(:company)

    visit new_company_registration_path
  end

  test 'can sign up' do
    fill_in 'company_name', with: 'SomeRandomNameKappa'
    fill_in 'company_email', with: 'somerandommail@example.org'
    fill_in 'company_password', with: 'foobarrr'
    fill_in 'company_password_confirmation', with: 'foobarrr'
    click_button 'Sign up'

    assert_content page, 'A message with a confirmation link has been sent'
    assert_equal root_path, current_path
  end

  test 'shows error on empty fields' do
    click_button 'Sign up'

    assert_content page, 'Password can\'t be blank'
    assert_content page, 'Name can\'t be blank'
    assert_content page, 'Email can\'t be blank'
    assert_equal company_registration_path, current_path
  end

  test 'shows error on non-matching password fields' do
    fill_in 'company_name', with: 'SomeRandomNameKappa'
    fill_in 'company_email', with: 'somerandommail@example.org'
    fill_in 'company_password', with: 'foobarrr'
    fill_in 'company_password_confirmation', with: 'foobarrrr'
    click_button 'Sign up'

    assert_content page, 'Password confirmation doesn\'t match Password'
    assert_equal company_registration_path, current_path
  end

  test 'shows error on non-unique name and email' do
    fill_in 'company_name', with: @company.name
    fill_in 'company_email', with: @company.email
    fill_in 'company_password', with: 'foobarrr'
    fill_in 'company_password_confirmation', with: 'foobarrrr'
    click_button 'Sign up'

    assert_content page, 'Name has already been taken'
    assert_content page, 'Email has already been taken'
    assert_equal company_registration_path, current_path
  end
end

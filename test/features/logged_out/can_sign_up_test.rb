require 'test_helper'

class CanSignUpTest < Capybara::Rails::TestCase
  def setup
    @existing_company = create(:company)
    @new_company = Company.new name: 'frostblooded',
                               email: 'frostblooded@example.com'
    @password = 'foobarrr'
    @non_matching_password = @password + 'r'
    @invalid_mail = 'efwefew@aefdf.'

    visit new_company_registration_path
  end

  test 'can sign up' do
    fill_in 'company_name', with: @new_company.name
    fill_in 'company_email', with: @new_company.email
    fill_in 'company_password', with: @password
    fill_in 'company_password_confirmation', with: @password

    assert_difference 'Company.count' do
      click_button 'Sign up'
    end

    assert_text 'A message with a confirmation link has been sent'
    assert_equal root_path, current_path
  end

  test 'shows error on empty fields' do
    assert_no_difference 'Company.count' do
      click_button 'Sign up'
    end

    assert_text 'password can\'t be blank'
    assert_text 'name can\'t be blank'
    assert_text 'email can\'t be blank'
    assert_text 'email is invalid'
    assert_equal company_registration_path, current_path
  end

  test 'shows error on non-matching password fields' do
    fill_in 'company_name', with: @new_company.name
    fill_in 'company_email', with: @new_company.email
    fill_in 'company_password', with: @password
    fill_in 'company_password_confirmation', with: @non_matching_password

    assert_no_difference 'Company.count' do
      click_button 'Sign up'
    end

    assert_text 'password confirmation doesn\'t match password'
    assert_equal company_registration_path, current_path
  end

  test 'shows error on non-unique name and email' do
    fill_in 'company_name', with: @existing_company.name
    fill_in 'company_email', with: @existing_company.email
    fill_in 'company_password', with: @password
    fill_in 'company_password_confirmation', with: @password

    assert_no_difference 'Company.count' do
      click_button 'Sign up'
    end

    assert_text 'name has already been taken'
    assert_text 'email has already been taken'
    assert_equal company_registration_path, current_path
  end

  test 'shows error on nonvalid email' do
    fill_in 'company_name', with: @new_company.name
    fill_in 'company_email', with: @invalid_mail
    fill_in 'company_password', with: @password
    fill_in 'company_password_confirmation', with: @password

    assert_no_difference 'Company.count' do
      click_button 'Sign up'
    end

    assert_text 'email is invalid'
    assert_equal company_registration_path, current_path
  end
end

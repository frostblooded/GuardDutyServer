require 'test_helper'

class CanAccessAccountEditTest < Capybara::Rails::TestCase
  def setup
    @current_password = 'foobarrr'

    @company = create(:company)
    @company.update password: @current_password

    @new_email = @company.email + 'a'
    @new_password = 'barrrfoo'

    login_as @company
    visit edit_company_registration_path
  end

  test 'shows correct default email' do
    assert_equal @company.email, find('#company_email').value
  end

  test 'correctly updates settings' do
    fill_in 'company_email', with: @new_email
    fill_in 'company_password', with: @new_password
    fill_in 'company_password_confirmation', with: @new_password
    fill_in 'company_current_password', with: @current_password
    click_button 'Update'

    assert_equal root_path, current_path
    assert_text 'Your account has been updated successfully'

    @company.reload
    assert_equal @new_email, @company.email
    assert @company.valid_password?(@new_password)
  end

  test 'returns error on nonmatching passwords' do
    fill_in 'company_email', with: @new_email
    fill_in 'company_password', with: @new_password
    fill_in 'company_password_confirmation', with: @new_password + 'a'
    fill_in 'company_current_password', with: @current_password
    click_button 'Update'

    assert_equal company_registration_path, current_path
    assert_text 'password confirmation doesn\'t match password'
  end

  test 'shows error on invalid current password' do
    fill_in 'company_email', with: @new_email
    fill_in 'company_password', with: @new_password
    fill_in 'company_password_confirmation', with: @new_password
    fill_in 'company_current_password', with: @current_password + 'a'
    click_button 'Update'

    assert_equal company_registration_path, current_path
    assert_text 'current password is invalid'
  end

  test 'shows error on empty form' do
    click_button 'Update'

    assert_equal company_registration_path, current_path
    assert_text 'current password can\'t be blank'
  end
end

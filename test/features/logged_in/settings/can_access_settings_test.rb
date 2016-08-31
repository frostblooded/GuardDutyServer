require 'test_helper'

class CanAccessSettingsTest < Capybara::Rails::TestCase
  def setup
    @company = create(:company)
    @company.settings(:email).time = '12:00'
    @company.settings(:email).wanted = false

    @new_email_wanted = true
    @new_email_time = '13:00'
    @new_invalid_email_time = '13?23REtre'

    @company.settings(:email).recipients = ['ivan@example.com', 'petkan@example.com']
    @added_email = 'frostblooded@example.com'

    login_as @company
    
    visit settings_path
  end

  test 'shows correct default values' do
    assert_equal @company.settings(:email).wanted, find('#email_wanted').checked?
    assert_equal @company.settings(:email).time, find('#email_time').value
  end

  test 'correctly updates settings' do
    find('#email_wanted').set @new_email_wanted
    fill_in 'email_time', with: @new_email_time
    click_button 'Save changes'

    assert_equal settings_path, current_path
    assert_text 'Settings saved'

    @company.reload
    assert_equal @new_email_time, @company.settings(:email).time
    assert_equal @new_email_wanted, @company.settings(:email).wanted
  end

  test 'returns error on invalid email time format' do
    fill_in 'email_time', with: @new_invalid_email_time
    click_button 'Save changes'

    assert_equal settings_path, current_path
    assert_text 'Invalid email time format'

    @company.reload
    assert_not_equal @new_email_time, @company.settings(:email).time
  end

  test 'adding emails works' do
    within '.new-email' do
      find('.new-email-input').set @added_email
      find('.new-email-add').click
    end

    click_button 'Save changes'

    @company.reload
    assert @company.settings(:email).recipients.include? @added_email
  end

  test 'removing emails works' do
    email = @company.settings(:email).recipients.first

    within '.emails' do
      first('.email-remove').click
    end

    click_button 'Save changes'

    @company.reload
    assert_not @company.settings(:email).recipients.include? @email
  end
end

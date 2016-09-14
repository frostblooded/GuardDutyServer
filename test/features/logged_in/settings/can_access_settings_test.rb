require 'test_helper'

class CanAccessSettingsTest < Capybara::Rails::TestCase
  def initialize_email_variables
    @new_email_wanted = false
    @new_email_time = '13:00'
    @new_invalid_email_time = '13?23REtre'

    @company.settings(:email).recipients = ['ivan@example.com',
                                            'petkan@example.com']
    @added_email = 'frostblooded@example.com'
    @invalid_email = 'rgergreg@wefwef.'
  end

  def setup
    @company = create(:company)
    @company.settings(:email).time = '12:00'
    @company.settings(:email).wanted = true
    initialize_email_variables

    login_as @company
    visit settings_path
  end

  test 'shows correct default values' do
    assert_equal @company.settings(:email).wanted,
                 find('#email_wanted').checked?

    assert_equal @company.settings(:email).time, find('#email_time').value
  end

  test 'correctly updates email time' do
    fill_in 'email_time', with: @new_email_time
    click_button 'Save changes'

    assert_equal settings_path, current_path
    assert_text 'Settings updated'

    @company.reload
    assert_equal @new_email_time, @company.settings(:email).time
  end

  test 'correctly updates email wanted' do
    find('#email_wanted').set @new_email_wanted
    click_button 'Save changes'

    assert_equal settings_path, current_path
    assert_text 'Settings updated'

    @company.reload
    assert_equal @new_email_wanted, @company.settings(:email).wanted
  end

  test 'adding emails works' do
    within '#new-email' do
      find('#new-email-input').set @added_email
      find('#new-email-add').click
    end

    click_button 'Save changes'

    @company.reload
    assert @company.settings(:email).recipients.include? @added_email
  end

  test 'removing emails works' do
    within '#emails' do
      first('.email-remove').click
    end

    click_button 'Save changes'

    @company.reload
    assert_not @company.settings(:email).recipients.include? @email
  end

  test 'adding invalid email shows error but saves valid ones' do
    within '#new-email' do
      find('#new-email-input').set @invalid_email
      find('#new-email-add').click
      find('#new-email-input').set @added_email
      find('#new-email-add').click
    end

    click_button 'Save changes'
    assert_text "The email '#{@invalid_email}' is invalid"

    @company.reload
    assert_not @company.settings(:email).recipients.include? @invalid_email
    assert @company.settings(:email).recipients.include? @added_email
  end
end

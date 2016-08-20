require 'test_helper'

class CanAccessSettingsTest < Capybara::Rails::TestCase
  def setup
    @company = create(:company)
    @company.settings(:email).time = '12:00'
    @company.settings(:email).wanted = false

    @new_email_wanted = true
    @new_email_time = '13:00'

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
end

require "test_helper"

class CanEditWorkerTest < Capybara::Rails::TestCase
  def setup
    @company = create(:company)
    login_as @company

    @worker = @company.workers.first
    @new_name = @worker.name + 'a'

    visit edit_worker_path(@worker)
  end

  test 'editting worker works' do
    new_password = 'foobarrra'

    fill_in 'worker_name', with: @new_name
    fill_in 'worker_password', with: new_password
    fill_in 'worker_password_confirmation', with: new_password

    click_button 'Save Changes'
    assert_equal workers_path, current_path
    assert_text 'Worker updated'

    @worker.reload
    assert_equal @new_name, @worker.name
    assert @worker.authenticate(new_password)
  end

  test 'shows error on nonmatching passwords' do
    new_password = 'foobarrr'

    fill_in 'worker_name', with: @new_name
    fill_in 'worker_password', with: new_password
    fill_in 'worker_password_confirmation', with: new_password + 'a'

    click_button 'Save Changes'
    assert_equal worker_path(@worker), current_path
    assert_text 'Password confirmation doesn\'t match Password'
  end

  test 'shows error on too short password' do
    fill_in 'worker_password', with: 'a' * 7
    fill_in 'worker_password_confirmation', with: 'a' * 7

    click_button 'Save Changes'
    assert_equal worker_path(@worker), current_path
    assert_text 'Password is too short (minimum is 8 characters)'
  end
end

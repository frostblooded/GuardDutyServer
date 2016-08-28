require "test_helper"

class CanCreateNewWorkerTest < Capybara::Rails::TestCase
  def setup
    @worker = Worker.new name: 'test worker',
                         password: 'foobarrr'

    login_as create(:company)
    visit new_worker_path
  end

  test 'can create new worker' do
    assert_difference 'Worker.count' do
      fill_in 'worker_name', with: @worker.name
      fill_in 'worker_password', with: @worker.password
      fill_in 'worker_password_confirmation', with: @worker.password
      click_button 'Create new worker'
    end

    assert_equal workers_path, current_path
    assert_text 'Worker created'
  end

  test 'creating new worker returns error on nonmatching passwords' do
    assert_no_difference 'Worker.count' do
      fill_in 'worker_name', with: @worker.name
      fill_in 'worker_password', with: @worker.password
      fill_in 'worker_password_confirmation', with: @worker.password + 'a'
      click_button 'Create new worker'
    end

    assert_equal workers_path, current_path
    assert_text 'Password confirmation doesn\'t match Password'
  end
end

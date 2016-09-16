require 'test_helper'

class CanCreateNewWorkerTest < Capybara::Rails::TestCase
  def setup
    @worker = Worker.new name: 'test worker',
                         password: 'foobarrr'
    @company = create(:company)

    login_as @company
    visit new_worker_path
  end

  test 'can create new worker' do
    assert_difference 'Worker.count' do
      fill_in 'worker_name', with: @worker.name
      fill_in 'worker_password', with: @worker.password
      fill_in 'worker_password_confirmation', with: @worker.password
      click_button 'Create Worker'
    end

    assert_equal workers_path, current_path
    assert_text 'Worker created'
  end

  test 'shows error on nonmatching passwords' do
    assert_no_difference 'Worker.count' do
      fill_in 'worker_name', with: @worker.name
      fill_in 'worker_password', with: @worker.password
      fill_in 'worker_password_confirmation', with: @worker.password + 'a'
      click_button 'Create Worker'
    end

    assert_equal workers_path, current_path
    assert_text 'Password confirmation doesn\'t match Password'
  end

  test 'shows error when name isn\'t unique in company' do
    @other_company = create(:company)

    # Not unique in company
    @worker.update(company: @company)

    assert_no_difference 'Worker.count' do
      fill_in 'worker_name', with: @worker.name
      fill_in 'worker_password', with: @worker.password
      fill_in 'worker_password_confirmation', with: @worker.password
      click_button 'Create Worker'
    end

    assert_equal workers_path, current_path
    assert_text 'Name not unique in company'

    # Unique in company
    @worker.update(company: @other_company)

    assert_difference 'Worker.count' do
      fill_in 'worker_name', with: @worker.name
      fill_in 'worker_password', with: @worker.password
      fill_in 'worker_password_confirmation', with: @worker.password
      click_button 'Create Worker'
    end

    assert_equal workers_path, current_path
    assert_text 'Worker created'
  end

  test 'shows error on empty form' do
    assert_no_difference 'Worker.count' do
      click_button 'Create Worker'
    end

    assert_equal workers_path, current_path
    assert_text 'Name can\'t be blank'
    assert_text 'Password can\'t be blank'
    assert_text 'Password is too short (minimum is 8 characters)'
  end
end
